import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/HomePageTemps/category_icon.dart';
import 'package:e_market/HomePageTemps/item_card.dart';
import 'package:e_market/HomePageTemps/offer_banner.dart';
import 'package:e_market/details_page.dart';
import 'package:e_market/product.dart';
import 'package:e_market/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];

  String selectedCategory = "all";

  bool isSearching = true;

  TextEditingController searchBarController = TextEditingController();

  QuerySnapshot? productSnapshot;
  getProductData() async {
     productSnapshot == null ? print("snapshot is currently null"): print("Snapshot is no longer null");
     productSnapshot ??= await FirebaseFirestore.instance.collection("products").get();

     products.clear();
    for (var i in productSnapshot!.docs) {
      products.add(Product(
          title: i.get('title'),
          price: (i.get('price') as int).toDouble(),
          description: i.get('description'),
          rating: i.get('rating'),
          availableAmount: i.get('availableAmount'),
          imageUrl: i.get("imageUrl"),
          category: i.get('category')));
    }
  }

  List categories = [];

  getCategoriesData() async{
    QuerySnapshot categorySnapshot = await FirebaseFirestore.instance.collection("categories").get();
    categories.addAll(categorySnapshot.docs);    
  }


   Future<void> filterCategory(int i) async {
    print("on tap pressed =========");
    print("${categories[i]['title']} selected =============");
    setState(() {
      
      selectedCategory = categories[i]['title'];
    });
    
      print(categories[i]['title']);
    //Todo filter the categories with firebase 
      productSnapshot =await FirebaseFirestore.instance.collection("products").where("category", arrayContains: categories[i]['title']).get();
      
      await getProductData();
      print(productSnapshot!.docs);
    setState(() {});
  }

  List offers = [];

  getOffersData() async{
    QuerySnapshot offerSnapshot = await FirebaseFirestore.instance.collection("offers").get();
    offers.addAll(offerSnapshot.docs);
  }

  var user;

  Future<MarketUser?> getUserData() async {
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    DocumentSnapshot snapshot =
        await users.doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (snapshot.exists) {
      user = MarketUser(
          name: snapshot.get('username'), imageUrl: snapshot.get('imageUrl'));
      setState(() {});
      return user;
    } else {
      print("No data found");
    }
    return null;
  }

  signOutUser() async {
    var user = MarketUser();
    user.signOut();
  }

  final _scrollControl = ScrollController();
  Timer? _scrollTimer;
  scrollOffersAutomatically() {
    _scrollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final newPosition = _scrollControl.position.pixels + 100;
      if (newPosition >= _scrollControl.position.maxScrollExtent) {
        _scrollControl.animateTo(0,
            duration: const Duration(seconds: 2), curve: Curves.decelerate);
      } else {
        _scrollControl.animateTo(newPosition,
            duration: const Duration(seconds: 2), curve: Curves.linear);
      }
    });
  }

  void fuzzySearch(String val){
    print("icon clicked");
    print(val);
    
    if(val.isEmpty){
    List productsTitle = [for(var product in products ) product.title];

    final fuse = Fuzzy(productsTitle, options: FuzzyOptions(
      threshold: 0.3,
      findAllMatches: true,
      tokenize: true 
    ));

    final result = fuse.search(val);
    List results = [];
    result.forEach((r)async{
      print("n score: ${r.score}::n title ${r.item}");
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("products").where("title", isEqualTo: r.item).get(); 
      
      for (var doc in snapshot.docs) {
        results.add(doc['title']);
      }

      productSnapshot = await FirebaseFirestore.instance.collection("products").where("title", whereIn: results).get();
      getProductData();
    });
  
    setState(() {  });}else{isSearching = false;}
  }

  Future<void> searchProduct() async {
    if(isSearching){
      fuzzySearch(searchBarController.text);
      isSearching = false;
      setState(() {});
    }else {
    isSearching = true;
    productSnapshot =await FirebaseFirestore.instance.collection('products').get();
    searchBarController.text = "";
    getProductData();
    setState(() {});
    }
  }
  

  @override
  void initState() {
    getOffersData();
    print("i'm in initState");
    getCategoriesData();
    getProductData();
    scrollOffersAutomatically();
    getUserData();
    super.initState();
  }

//app GUI starts here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (val){
            if(val.isEmpty){
              setState(() {
                isSearching = true;
              });
            }
          },
          controller: searchBarController,
          textInputAction: TextInputAction.search,
          onSubmitted: (value){
            searchProduct();
          },

          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(5),
              suffixIcon: IconButton(
                  onPressed: () async{
                    await searchProduct();
                  },
                  icon:isSearching? const Icon(
                    Icons.search,
                    size: 30,
                  ): const Icon(Icons.close)),
              hintText: "Search",
              hintStyle: const TextStyle(fontSize: 18, color: Colors.black38)),
        ),
      ),
      
      drawer: Drawer(

        child: SafeArea(
          child: Column(
            children: [
              FutureBuilder<MarketUser?>(
                future: getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const LinearProgressIndicator(color: Colors.blue,);
                  } else {
                    MarketUser user = snapshot.data!;
                    return Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.network(
                            user.imageUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                maxLines: 1,
                                softWrap: false,
                                user.name!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              Text(
                                FirebaseAuth.instance.currentUser!.email ?? '',
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed("user_profile");
                      },
                      title: const Text("Profile"),
                      leading: const Icon(Icons.person),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed("cart_page");
                      },
                      title: const Text("Cart"),
                      leading: const Icon(Icons.shopping_cart),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed("customer_support");
                      },
                      title: const Text("Customer support"),
                      leading: const Icon(Icons.chat),
                    ),
                    ListTile(
                      onTap: () async {
                        _scrollTimer?.cancel();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "login_page", (route) => false);
                        await signOutUser();
                      },
                      title: const Text("Logout"),
                      leading: const Icon(Icons.logout),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Offers",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(10),
              child: Center(
                child: ListView.builder(
                  controller: _scrollControl,
                  itemCount: offers.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return OfferBanner(offerImage: offers[i]['imageUrl']);
                  },
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Categories",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
          ),
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              height: 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CategoryIcon(
                      title: "All",
                       icon: Image.asset("images/all.png"), 
                       isSelected: selectedCategory == "all", 
                       onTap: ()async{
                        selectedCategory = "all";
                        productSnapshot = await FirebaseFirestore.instance.collection("products").get();

                        getProductData();
                       }),
                       const SizedBox(width: 20),
                    ...List.generate(
                      categories.length, (i){
                      return Row(
                        children: [
                          CategoryIcon(
                            title: categories[i]['title'], 
                            icon: Image.network(categories[i]['iconUrl']),  
                            isSelected: selectedCategory == categories[i]['title'],
                            onTap: ()async{
                              await filterCategory(i);
                            },
                            ),
                           const SizedBox(width: 20,),
                        ],
                      );
                    })
                  ],
                  ),
                ),
              ),
            ),
          
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverGrid(
              
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ItemDetails(
                                    data: products[i],
                                    isComingFromCart: false,
                                  )));
                    },
                    child: ItemCard(
                        itemName: products[i].title,
                        price: products[i].price,
                        rating: products[i].rating,
                        imagePath: products[i].imageUrl),
                  );
                },
                childCount: products.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  

  
  
}
