import 'package:clean_arch/core/databases/api/end_points.dart';

class CompanyModel {
  final String name;
  final String catchPhrase;
  final String bs;

  CompanyModel({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      name: json[Apikeys.userCompany],
      catchPhrase: json[Apikeys.userCatchPhrase],
      bs: json[Apikeys.userBs],
    );
  }
  Map<String, String> toJson() {
    return {'name': name, 'catchPhrase': catchPhrase, 'bs': bs};
  }
}

