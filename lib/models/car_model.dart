class CarModel {
  String? uid;
  String? modelName;
  String? modelMakeId;
  bool hidden ;

  CarModel({
    this.uid,
    this.modelName,
    this.modelMakeId,
    this.hidden = false
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      uid: json['uid'],
      hidden: json['hidden']??false,
      modelName: json['model_name'],
      modelMakeId: json['model_make_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'hidden': hidden,
      'model_name': modelName,
      'model_make_id': modelMakeId,
    };
  }
}
