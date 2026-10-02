import 'package:clean_arch/core/databases/api/end_points.dart';
import 'package:clean_arch/features/user/data/models/sub%20models/geo_model.dart';
import 'package:clean_arch/features/user/domain/entities/sub_entities/address_entity.dart';

class AddressModel extends AddressEntity {
  AddressModel({
    required super.street,
    required super.suite,
    required super.city,
    required super.zipcode,
    required super.geo,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json[Apikeys.userStreet],
      suite: json[Apikeys.userSuite],
      city: json[Apikeys.userCity],
      zipcode: json[Apikeys.userZipCode],
      geo: GeoModel.fromJson(json[Apikeys.userGeo]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'suite': suite,
      'city': city,
      'zipcode': zipcode,
      'geo': geo,
    };
  }
}
