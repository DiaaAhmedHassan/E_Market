import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/HomePageTemps/category_icon.dart';
import 'package:e_market/HomePageTemps/item_card.dart';
import 'package:e_market/HomePageTemps/offer_banner.dart';
import 'package:e_market/details_page.dart';
import 'package:e_market/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List products = [
    {"image": "images/1.png", "title": "Watch", "price": 25.0, "rating": 3, "available amount": 300, "description": "Watch description"},
    {
      "image": "images/2.png",
      "title": "head phone",
      "price": 30.0,
      "rating": 4,
      "available amount": 4000, "description": "Headphone description"
    },
    {"image": "images/3.png", "title": "Sneakers", "price": 15.0, "rating": 2, "available amount": 1000, "description": "sneakers description"},
    {"image": "images/4.png", "title": "Hoodie", "price": 24.0, "rating": 5, "available amount": 2000, "description": "Hoodie description"},
    {"image": "images/5.png", "title": "perfume", "price": 300.0, "rating": 3, "available amount": 6000, "description": "perfume description"},
  ];

  List categories = [
    {
      "title": "All",
      "icon": Icons.all_inclusive,
      "color": Colors.blue,
      "iconColor": Colors.white
    },
    {
      "title": "Electronics",
      "icon": Icons.computer,
      "color": Colors.white,
      "iconColor": Colors.black
    },
    {
      "title": "Kitchen",
      "icon": Icons.kitchen_outlined,
      "color": Colors.white,
      "iconColor": Colors.black
    },
  

  ];

  List offers = [
    {"image": "images/offer1.png"},
    {"image": "images/offer2.png"},
    {"image": "images/offer3.png"},
   
  ];

  var user;
  
 Future<MarketUser?> getUserData()async{
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    DocumentSnapshot snapshot = await users.doc(FirebaseAuth.instance.currentUser!.uid).get();
    if(snapshot.exists){
    user = MarketUser(name: snapshot.get('username'), imageUrl: snapshot.get('imageUrl'));
    setState(() {
      
    });
    return user;
    }else{
      print("No data found");
    }
  }



  signOutUser()async{
    var user = MarketUser();
    user.signOut();
  }



  final _scrollControl = ScrollController();
  Timer? _scrollTimer;

  scrollOffersAutomatically(){
   _scrollTimer = Timer.periodic(const Duration(seconds: 2), (timer){
      final newPosition = _scrollControl.position.pixels +100;
      if(newPosition >= _scrollControl.position.maxScrollExtent){
        _scrollControl.animateTo(0, duration: const Duration(seconds: 2), curve: Curves.decelerate);
      }else{
        _scrollControl.animateTo(newPosition, duration:const Duration(seconds: 2), curve: Curves.linear);
      }
    });
  }
  @override
  void initState() {
    scrollOffersAutomatically();
    getUserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(5),
              suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                  )),
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
              return const Text('No user data available');
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
                      user.getImage(),
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
                          user.getName(),
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
                  // Navigate to Profile
                },
                title: const Text("Profile"),
                leading: const Icon(Icons.person),
              ),
              ListTile(
                onTap: () {
                  // Navigate to Cart
                },
                title: const Text("Cart"),
                leading: const Icon(Icons.shopping_cart),
              ),
              ListTile(
                onTap: () {
                  // Navigate to Customer Support
                },
                title: const Text("Customer support"),
                leading: const Icon(Icons.chat),
              ),
              ListTile(
                onTap: () async {
                  _scrollTimer?.cancel();
                  await signOutUser();
                  Navigator.of(context).pushNamedAndRemoveUntil("login_page", (route) => false);
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
                    itemBuilder: (context, i){
                      return OfferBanner(offerImage: offers[i]['image']);
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
                child: ListView.builder(
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CategoryIcon(
                        title: categories[i]['title'],
                        icon: categories[i]['icon'],
                        color: categories[i]['color'],
                        iconColor: categories[i]['iconColor'],
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 20, 
                  mainAxisSpacing: 20),
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetails(data: products[i],)));
                      },
                      child: ItemCard(
                          itemName: products[i]['title'],
                          price: products[i]['price'],
                          rating: products[i]['rating'],
                          imagePath: products[i]['image']),
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
