import 'package:mechanic/models/car_services.dart';
import 'package:mechanic/models/driver_model.dart';
import 'package:mechanic/models/service_provider.dart';
import 'package:mechanic/models/vehicle.dart';
import 'package:mechanic/utils/constants.dart' as constant;


class Order {
   final String id;
  final String user;
    Driver? driver;
  final ServiceProvider serviceProvider;
  final List<CarService> services;
  final DateTime orderDateTime; // Add a DateTime field
  final String type ;
  Car? car ;
  String status;
  String paymentType;
  String paymentStatus;
  double rate;


  Order({
    required this.id,
    required this.user,
    required this.serviceProvider,
    required this.services,
    required this.car,
    required this.orderDateTime,
    required this.type,
    required this.status,
    required this.paymentStatus,
    required this.paymentType,
      this.driver,
      this.rate = 0.0,
  });

  factory Order.fromJson(Map<String, dynamic>? json) {
    return Order(
      id:  json!['id']??'',
      user: json['user'] as String,
      serviceProvider: ServiceProvider.fromJson(json['serviceProvider']),
      car: json['car']==null? null : Car.fromJson(json['car']),
      driver:json['driver']!=null ?  Driver.fromJson(json['driver']) : null,
      services: List<CarService>.from(
        json['services'].map((service) => CarService.fromJson(service)),
      ),
      orderDateTime: DateTime.parse(json['orderDateTime']), // Parse the DateTime from JSON
      status: json['status'] as String  ,
      type: json['type'] as String  ,
      paymentStatus: json['paymentStatus']??constant.paymentStatus[0]  ,
      paymentType:  json['paymentType']??constant.paymentType[0]  ,
      rate:  json['rate']??0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id ,
      'user': user,
      'serviceProvider': serviceProvider.toJson(),
      'car': car!.toJson(),
      'driver': driver?.toJson(),
      'services': services.map((service) => service.toJson()).toList(),
      'orderDateTime': orderDateTime.toIso8601String(), // Convert DateTime to ISO 8601 format
      'type' : type ,
      'status' : status,
      'paymentStatus' : paymentStatus,
      'rate' : rate
    };
  }

}
