
class Product {
  final String _id;
  final String _title;
  double _price;
  final String _description;
  int _rating;
  final int _availableAmount;
  final String _imageUrl;
  final List _category;

  Product({
    required String id, 
    required String title,
    required double price,
    required String description,
    required int rating,
    required  int availableAmount, 
    required String imageUrl,
    required List category,

  }):

  _id = id,
  _title = title, 
  _price = price, 
  _description = description,
  _rating = rating,
  _availableAmount = availableAmount,
  _imageUrl = imageUrl,
  _category = category;

  String get id => _id;
  String get title => _title;
  double get price => _price;
  String get description => _description;
  int get rating => _rating;
  int get availableAmount => _availableAmount;
  String get imageUrl => _imageUrl;
  List get category => _category;

  set price(double price){
    if(price < 0){
      throw ArgumentError("Price should be more than 0");
    }else{
    _price = price;
    }
  } 

  set rating(int rating){
    if(rating<0 || rating>5){
      throw ArgumentError("Rating should be between 0 and 5");
    }else{
      _rating = rating;
    }
  }

  productToMap(){
    return {
      "id": id,
      "title": _title, 
      "price": _price,
      "description": _description,
      "rating": _rating,
      "availableAmount": _availableAmount,
      "imageUrl": _imageUrl,
      "category":_category
    };
  }


}