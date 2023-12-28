
class CarDetails {
  String? make;
  List<String>? models;

  CarDetails(this.make, this.models);

  // Factory constructor to create CarDetails from a JSON map
  factory CarDetails.fromJson(Map<String, dynamic> json) {
    return CarDetails(
      json['make'],
      List<String>.from(json['models']),
    );
  }
}