import 'package:clean_arch/features/user/data/models/sub%20models/address_model.dart';
import 'package:clean_arch/features/user/data/models/sub%20models/company_model.dart';
import 'package:clean_arch/features/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final int id;
  final String username;
  final String website;
  final CompanyModel company;
  UserModel({
    required this.username,
    required this.website,
    required this.company,
    required super.name,
    required super.phone,
    required super.email,
    required super.address,
    required this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      website: json['website'],
      company: CompanyModel.fromJson(json['company']),
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: AddressModel.fromJson(json['address']),
      id: json['id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'website': website,
      'company': company.toJson(),
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'id': id,
    };
  }
}
