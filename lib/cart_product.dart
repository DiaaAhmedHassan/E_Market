import 'package:e_market/product.dart';

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
      required int requiredAmount}): _requiredAmount = requiredAmount;

  int get requiredAmount => _requiredAmount;

  toMap() {
    return {
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
}
