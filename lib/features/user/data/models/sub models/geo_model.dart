import 'package:clean_arch/core/databases/api/end_points.dart';
import 'package:clean_arch/features/user/domain/entities/sub_entities/geo_entity.dart';

class GeoModel extends GeoEntity {
  GeoModel({required super.lat, required super.lng});

  factory GeoModel.fromJson(Map<String, dynamic> json) {
    return GeoModel(lat: json[Apikeys.userLat], lng: json[Apikeys.userLng]);
  }
  // to json
  Map<String, String> toJson() {
    return {'lat': lat, 'lng': lng};
  }
}
