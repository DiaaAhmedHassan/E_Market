
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewsView extends StatefulWidget {
   ReviewsView({super.key, required this.productId});

  String productId;
  @override
  State<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends State<ReviewsView> {

   TextEditingController reviewController = TextEditingController();
   int rate = 0;
   int generalRate = 0;

   List reviews = [];
   bool isUserAlreadyReviewed = false;

  getReviews() async{
    QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance.collection("products").doc(widget.productId).collection("reviews").get();
    reviews.addAll(reviewSnapshot.docs);
    setState(() {});
  }

 Future<void> checkIfUserReviewed()async{
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot =await FirebaseFirestore.instance.collection("products").doc(widget.productId).collection("reviews").doc(userId).get();
    isUserAlreadyReviewed = snapshot.exists;
    setState(() {
      
    });
  }

   calculateRating() async{
    
    DocumentReference documentReference = FirebaseFirestore.instance.collection("products").doc(widget.productId);
    QuerySnapshot snapshot =await documentReference.collection("reviews").get();

    if(snapshot.docs.isNotEmpty){
      int totalRating = snapshot.docs.length;
      double sumRating = snapshot.docs.map((doc) => (doc['user_rate'] as num).toDouble()).reduce((a, b) => a+b);

      double averageRating = sumRating/totalRating;
      generalRate = averageRating.round();
    }

    documentReference.update({"rating": generalRate});
  }

  @override
  void initState() {
    super.initState();
    checkIfUserReviewed();
    getReviews();
  }

  GlobalKey<FormState> updateKey = GlobalKey();
  TextEditingController updateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 500,
      child:

       Column(
        children: [
         isUserAlreadyReviewed? 
         const Text("Thanks for your review!", style: TextStyle(fontSize: 20),)
         :Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ...List.generate(5, (i){
                    
                    return IconButton(
                      onPressed: (){
                        setState(() {
                        rate = i+1;
                        print(rate);
              
                        });
                      },
                       icon: i<rate?
                      const Icon(Icons.star, color: Colors.amber, size: 35,)
                       :
                       const Icon(Icons.star_outline, color: Colors.amber, size: 35,));
                  }),
                  const SizedBox(width: 20,),
                  Text('$rate ', style:const TextStyle(fontSize: 24),),
                ],
              ),
                       TextField(
              controller: reviewController,
              decoration: InputDecoration(
                focusColor: Colors.blue,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:const BorderSide(color: Colors.blue)),
                
              
                filled: true,
                fillColor: Colors.grey[200], 
                contentPadding:const EdgeInsets.all(5),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), 
                hintText: "Type a review",
                suffixIcon: IconButton(onPressed: ()async{
                  // Add review to database
                  String userId = FirebaseAuth.instance.currentUser!.uid;
                  DocumentSnapshot userSnapshot =await FirebaseFirestore.instance.collection("users").doc(userId).get();
                  var userData = userSnapshot.data() as Map<String, dynamic>;
                  FirebaseFirestore
                  .instance
                  .collection("products")
                  .doc(widget.productId)
                  .collection("reviews")
                  .doc(userId).set(
                    {"user_rate": rate,
                    "user_id": userId,
                    "user_name": userData['username'],
                    "review": reviewController.text,
                    "date": FieldValue.serverTimestamp(),
                    "user_image": userData['imageUrl']});
                  reviewController.clear();
                  calculateRating();
                  rate = 0;
                  setState(() {               
                  });
                }, icon: const Icon(Icons.send, color: Colors.blue,))
              ),
                       ),
            ],
          ),

         Expanded(          
           child: Padding(
             padding: const EdgeInsets.all(10),
             child:reviews.isNotEmpty? ListView.builder(
              itemCount: reviews.length,
              shrinkWrap: true,
              itemBuilder: (context, i){
                String userId = FirebaseAuth.instance.currentUser!.uid;
                DocumentSnapshot review = reviews[i];
                Timestamp timestamp = review['date'];
                DateTime date = timestamp.toDate();
                String formattedDate = DateFormat("dd/MM/yyyy").format(date);
                return
                  InkWell(
                    onLongPress:userId == review['user_id']?(){
                      updateController.text = review['review'];
                      int userRating = review['user_rate'];
                      showDialog(
                        context: context, 
                        builder: (context){
                          return StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text("My review"),
                                content: SizedBox(
                                  height: 150,
                                  child: Form(
                                    key: updateKey,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            ...List.generate(5, (i){
                              
                                              return IconButton(onPressed: (){
                                                setState(() {
                                                  userRating = i+1;
                                                  print(i);
                                                  print(userRating);
                                                });
                                              }, icon:i<userRating? const Icon(Icons.star, color: Colors.amber,size: 30,):const Icon(Icons.star_outline, color: Colors.amber,size: 30,));
                                               
                                            })
                                          ],
                                        ),
                                        TextFormField(
                                          controller: updateController,
                                          maxLines: null,
                                          keyboardType: TextInputType.multiline,
                                          decoration: InputDecoration(
                                            filled: true, 
                                            fillColor: Colors.grey[200], 
                                            contentPadding: const EdgeInsets.all(5),
                                            border: const OutlineInputBorder(borderSide: BorderSide.none),
                                            hintText: 'update your review',
                                          ),
                                          validator: (val){
                                            if(val!.isEmpty) return "can't be empty";
                                            return "";
                                          },
                                          onSaved: (val){
                                            updateController.text = val!;
                                          },
                                          
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  MaterialButton(
                                    onPressed: (){
                                      FirebaseFirestore.instance.collection("products").
                                      doc(widget.productId).
                                      collection("reviews").
                                      doc(userId).delete();
                                    }, 
                                    color: Colors.red,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    child:const Text("Delete"),),
                                  MaterialButton(
                                    onPressed: (){
                                      if(updateKey.currentState!.validate()){
                                        updateKey.currentState!.save();
                                        FirebaseFirestore.
                                        instance.collection("products").
                                        doc(widget.productId).
                                        collection("reviews").
                                        doc(userId).
                                        update({
                                          "user_rate": userRating,
                                          "review": updateController.text,
                                          "date": FieldValue.serverTimestamp()
                                        });               
                                        calculateRating();          
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                       
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your review updated successfully"),behavior: SnackBarBehavior.floating,));
                                        
                                      }
                                    }, 
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    child:const Text("Update"),),
                                ],
                              );
                            }
                          );
                        });
                        
                    }: null,
                    child: CommentView(
                    userName: review['user_name'], 
                    userImageUrl: review['user_image'], 
                    commentText: review['review'],
                    userRating: review['user_rate'],
                    date: formattedDate,),
                  );
              },
              
             ):const Center(child: Column(children: [
              Icon(Icons.reviews, size: 40, color: Colors.blue,),
              Text("No reviews yet", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
             ],),),
           ),
         )
        ],
      ),
    );
  }
}

class CommentView extends StatelessWidget{
 CommentView({super.key,required this.userName,required this.userImageUrl,required this.commentText,required this.userRating, required this.date});

  String userName;
  String userImageUrl;
  String commentText;
  int userRating;
  String date;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.only(top: 20),
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Container(
          clipBehavior: Clip.hardEdge,
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blue,
          ),
          child: Image.network(userImageUrl, fit: BoxFit.cover,),),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(userName, style: const TextStyle(fontSize: 15, color: Colors.black),),
                   Text(date),
                ],
              ),
              Row(children: [...List.generate(5, (i){
                if(userRating<=i){
                  return const Icon(Icons.star_outline, color: Colors.amber, size: 20,);
                }else{
                  return const Icon(Icons.star, color: Colors.amber, size: 20,);
                }
                
              }),
              
              ],
              
              ),
              Text(commentText,softWrap: true,overflow: TextOverflow.visible, style:const TextStyle(fontSize: 18),)
            ],),
          )
      ],),
    );
  }

}