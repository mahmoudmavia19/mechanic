
class CarService {
  String uid;
  String name;
  bool isSelected;
  double price;
  bool hidden;
  String type ;
  CarService(this.uid,this.name, this.isSelected, this.price, {this.hidden = false , this.type='all'});

  // Factory method to create a CarService object from JSON
  factory CarService.fromJson(Map<String, dynamic> json) {
    return CarService(
      json['uid'] as String,
      json['name'] as String,
      json['isSelected'] as bool,
      (json['price'] as num).toDouble(),
      type:json['type'] ??'all',
      hidden: json['hidden'], );
  }

  // Method to convert a CarService object to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'isSelected': isSelected,
      'price': price,
      'type': type??'all',
      'hidden': hidden,
    };
  }
}
