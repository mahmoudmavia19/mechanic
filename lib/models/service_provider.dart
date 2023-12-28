import 'package:mechanic/models/workshop.dart';

class ServiceProvider {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final bool blocked ;
  final Workshop workshop ;
  Map<String,double>? rate;


  ServiceProvider({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.workshop,
      this.blocked = false,
    this.rate

  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['uid'].toString(),
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      blocked:json['blocked']!=null?json['blocked'] as bool : false,
      workshop: Workshop.fromJson(json['automativeRepair']),
      rate:json['rate'] !=null ? (json['rate'] as Map<String,dynamic>).cast(): {}
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'blocked': blocked,
      'automativeRepair': workshop.toJson(),
      'rate' : rate

    };
  }
}
