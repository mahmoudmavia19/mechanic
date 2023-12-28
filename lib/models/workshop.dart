class Workshop {
  final String district;
  final String streetName;
  final String city;
    String status;

  Workshop({
    required this.district,
    required this.streetName,
     required this.city,
     this.status = 'Available',
  });

  // Factory method to create a Workshop object from JSON
  factory Workshop.fromJson(Map<String, dynamic> json) {
    return Workshop(
      district: json['district'] as String,
      streetName: json['streetName'] as String,
      city: json['city'] as String,
      status: json['status']!=null?json['status'] as String:'Available',
    );
  }

  // Method to convert a Workshop object to JSON
  Map<String, dynamic> toJson() {
    return {
      'district': district,
      'streetName': streetName,
      'city': city,
      'status': status
    };
  }
}
