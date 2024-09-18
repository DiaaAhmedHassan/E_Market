
class Product {
  String _title;
  double _price;
  String _description;
  int _rating;
  int _availableAmount;
  String _imageUrl;
  List _category;

  Product({
    required String title,
    required double price,
    required String description,
    required int rating,
    required  int availableAmount, 
    required String imageUrl,
    required List category,

  }):
    _title = title,
    _price = price,
    _description = description,
    _rating = rating,
    _availableAmount = availableAmount,
    _imageUrl = imageUrl,
    _category = category;
  

  String get title => _title;
  double get price => _price;
  String get description => _description;
  int get rating => _rating;
  int get availableAmount => _availableAmount;
  String get imageUrl => _imageUrl;
  List get category => _category;

  set title(String title){
    _title = title;
  }

  set price(double price){
    if(price < 0){
      throw ArgumentError("Price can't be less than 0");
    }
    _price = price;
  }   

  set description(String description){
    _description = description;
  }

  set rating(int rating){
    if(rating < 0 || rating > 5){
      throw ArgumentError("Invalid rating value");
    }
    _rating = rating;
  }

  set availableAmount(int availableAmount){
    if(availableAmount<0){
      throw ArgumentError("Available amount should be more than zero");
    }
    _availableAmount = availableAmount;
  }

  set imageUrl(String imageUrl){
    _imageUrl = imageUrl;
  }

  set category(List category){
    _category = category;
  }

  productToMap(int requiredAmount){
    return {
      "title": _title, 
      "price": _price,
      "description": _description,
      "rating": _rating,
      "availableAmount": _availableAmount - requiredAmount,
      "imageUrl": _imageUrl,
      "requiredAmount": requiredAmount,
      "category": category
    };
  }

}