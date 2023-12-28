import 'package:mechanic/models/order.dart';
class User {
  String uid;
  String name;
  String address;
  String email;
  int phoneNumber;
  String cardInfo;
  List<String>? currentOrder;
  User({
    required this.uid,
    required this.name,
    required this.address,
    required this.email,
    required this.phoneNumber,
    required this.cardInfo,
    this.currentOrder
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as int,
      cardInfo: json['cardInfo'] as String,
      currentOrder: json['currentOrder'] ==null || json['currentOrder'] ==[]? []: json['currentOrder'] is Map  ?
      [ Order.fromJson((json['currentOrder'] as Map<String, dynamic>)).id ]: json['currentOrder'].cast<String>());
  }
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'cardInfo': cardInfo,};
  }
}

 