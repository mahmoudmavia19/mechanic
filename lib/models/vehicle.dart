class Car {
  final String brand;
  final String yearOfMake;
  final String model;
  final String make;
  final String engineType;
    String? serialNumber;

  Car({
    required this.brand,

    required this.yearOfMake,
    required this.model,
    required this.make,
    required this.engineType,
      this.serialNumber ,
  });

  // Factory method to create a Car object from JSON
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      brand: (json['brand']??json['make'] )as String,
      yearOfMake: json['yearOfMake'] ,
      model: json['model'] as String,
      make:( json['make']??json['brand'] )as String,
      engineType: json['engineType'] as String,
      serialNumber: json['serialNumber'] as String,
    );
  }

  // Method to convert a Car object to JSON
  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'yearOfMake': yearOfMake,
      'model': model,
      'make': make,
      'engineType': engineType,
      'serialNumber': serialNumber,
    };
  }
}
