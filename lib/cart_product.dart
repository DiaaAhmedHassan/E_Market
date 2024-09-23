import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market/product.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartProduct extends Product {

  final int _requiredAmount;
  CartProduct(
      {required super.title,
      required super.price,
      required super.description,
      required super.rating,
      required super.availableAmount,
      required super.imageUrl,
      required super.category, 
      required int requiredAmount,
       required super.id}): _requiredAmount = requiredAmount;

  int get requiredAmount => _requiredAmount;

  toMap() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "description": description,
      "rating": rating,
      "availableAmount": availableAmount,
      "imageUrl": imageUrl,
      "category": category,
      "requiredAmount": _requiredAmount
    };
  }

  factory CartProduct.fromMap(Map<String, dynamic> data){
    return CartProduct(
      id: data['id'],
      title: data['title'],
      price: data['price'],
      description: data['description'],
      rating: data['rating'], 
      availableAmount: data['availableAmount'],
      imageUrl: data['imageUrl'],
      category: data['category'], 
      requiredAmount: data['requiredAmount']);
  }


 
 
}
