class Driver {
  String? uid;
  String? spId;
  String name;
/*
  String address;
*/
  String email;
  String phoneNumber;
  String password;
  bool block;
  Map<String,double>? rate;

  Driver({
    this.uid,
    this.spId,
    required this.name,
/*
    required this.address,
*/
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.block = false,
    this.rate
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      uid: json['uid']??'',
      spId: json['spId']??'',
      name: json['name']??'',
/*
      address: json['address']??'',
*/
      email: json['email']??'',
      phoneNumber: json['phoneNumber']??'',
      password: json['password']??'',
      block: json['block'] ?? false,
        rate:json['rate'] !=null ? (json['rate'] as Map<String,dynamic>).cast(): {}
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'spId': spId,
      'name': name,
/*
      'address': address,
*/
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'block': block,
      'rate' : rate

    };
  }
}
