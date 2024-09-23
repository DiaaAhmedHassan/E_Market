import 'package:flutter/material.dart';

class ReviewsView extends StatefulWidget {
  const ReviewsView({super.key});

  @override
  State<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends State<ReviewsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 500,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...List.generate(5, (i){
                return IconButton(onPressed: (){}, icon:const Icon(Icons.star_outline, color: Colors.amber, size: 35,));
              }),
            ],
          ),
         TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200], 
            contentPadding:const EdgeInsets.all(5),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), 
            hintText: "Type a review",
            suffixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.send))
          ),
         ),
         Expanded(          
           child: Padding(
             padding: const EdgeInsets.all(10),
             child: ListView(
              shrinkWrap: true,
              
              children: [
                CommentView(
                  userImageUrl: "https://firebasestorage.googleapis.com/v0/b/e-market-cdf14.appspot.com/o/2b588418-4c24-483e-8026-7833f714c11b1420925970284525935.jpg?alt=media&token=91d804ce-ceb3-49df-8900-a70ac0ccc98c", 
                  userName: "Diaa Ahmed",
                  commentText: "Good work",
                  userRating: 4,),
                CommentView(
                  userImageUrl: "https://firebasestorage.googleapis.com/v0/b/e-market-cdf14.appspot.com/o/2b588418-4c24-483e-8026-7833f714c11b1420925970284525935.jpg?alt=media&token=91d804ce-ceb3-49df-8900-a70ac0ccc98c", 
                  userName: "Diaa Ahmed",
                  commentText: "Good work",
                  userRating: 3,),
                CommentView(
                  userImageUrl: "https://firebasestorage.googleapis.com/v0/b/e-market-cdf14.appspot.com/o/2b588418-4c24-483e-8026-7833f714c11b1420925970284525935.jpg?alt=media&token=91d804ce-ceb3-49df-8900-a70ac0ccc98c", 
                  userName: "Diaa Ahmed",
                  commentText: "Good work",
                  userRating: 1,),
              ],
             ),
           ),
         )
        ],
      ),
    );
  }
}

class CommentView extends StatelessWidget{
 CommentView({super.key,required this.userName,required this.userImageUrl,required this.commentText,required this.userRating});

  String userName;
  String userImageUrl;
  String commentText;
  int userRating;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Container(
          clipBehavior: Clip.hardEdge,
          width: 60,
          height: 60,
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
              Text(userName, style: const TextStyle(fontSize: 15, color: Colors.black),),
              Row(children: [...List.generate(5, (i){
                if(userRating<=i){
                  return const Icon(Icons.star_outline, color: Colors.amber,);
                }else{
                  return const Icon(Icons.star, color: Colors.amber,);
                }
                
              })],),
              Text(commentText,softWrap: true,overflow: TextOverflow.visible,)
            ],),
          )
      ],),
    );
  }

}