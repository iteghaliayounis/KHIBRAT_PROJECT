class CompanyModel {
  final dynamic id;
  final String? name;
  final Map<String, dynamic> raw;

  CompanyModel({this.id, this.name, this.raw = const {}});

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      name: json['name'],
      raw: json,
    );
  }

  Map<String, dynamic> toJson() => raw;
}
