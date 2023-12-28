class CarMake {
  String? makeId;
  String? makeDisplay;
  String? makeIsCommon;
  String? makeCountry;

  CarMake({
    this.makeId,
    this.makeDisplay,
    this.makeIsCommon,
    this.makeCountry,
  });

  factory CarMake.fromJson(Map<String, dynamic> json) {
    return CarMake(
      makeId: json['make_id'],
      makeDisplay: json['make_display'],
      makeIsCommon: json['make_is_common'],
      makeCountry: json['make_country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'make_id': makeId,
      'make_display': makeDisplay,
      'make_is_common': makeIsCommon,
      'make_country': makeCountry,
    };
  }
}
