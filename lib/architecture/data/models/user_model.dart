import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

/// Data model for User - handles serialization and conversion to/from entity
@JsonSerializable(explicitToJson: true)
class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? phone;
  final String? website;
  final CompanyModel? company;
  final AddressModel? address;

  const UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.phone,
    this.website,
    this.company,
    this.address,
  });

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Convert to domain entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      username: username,
      email: email,
      phone: phone,
      website: website,
      company: company?.toEntity(),
      address: address?.toEntity(),
      createdAt: DateTime.now(), // Default values for data layer
      updatedAt: DateTime.now(),
    );
  }

  /// Create from domain entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      username: entity.username,
      email: entity.email,
      phone: entity.phone,
      website: entity.website,
      company: entity.company != null ? CompanyModel.fromEntity(entity.company!) : null,
      address: entity.address != null ? AddressModel.fromEntity(entity.address!) : null,
    );
  }

  /// Create from database map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      name: map['name'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String?,
      website: map['website'] as String?,
      company: map['company'] != null 
          ? CompanyModel.fromJson(Map<String, dynamic>.from(map['company']))
          : null,
      address: map['address'] != null 
          ? AddressModel.fromJson(Map<String, dynamic>.from(map['address']))
          : null,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'website': website,
      'company': company?.toJson(),
      'address': address?.toJson(),
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}

@JsonSerializable(explicitToJson: true)
class CompanyModel {
  final String name;
  @JsonKey(name: 'catchPhrase')
  final String catchPhrase;
  final String bs;

  const CompanyModel({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => _$CompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);

  CompanyEntity toEntity() {
    return CompanyEntity(
      name: name,
      catchPhrase: catchPhrase,
      bs: bs,
    );
  }

  factory CompanyModel.fromEntity(CompanyEntity entity) {
    return CompanyModel(
      name: entity.name,
      catchPhrase: entity.catchPhrase,
      bs: entity.bs,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class AddressModel {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final GeoModel geo;

  const AddressModel({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  AddressEntity toEntity() {
    return AddressEntity(
      street: street,
      suite: suite,
      city: city,
      zipcode: zipcode,
      geo: geo.toEntity(),
    );
  }

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      street: entity.street,
      suite: entity.suite,
      city: entity.city,
      zipcode: entity.zipcode,
      geo: GeoModel.fromEntity(entity.geo),
    );
  }
}

@JsonSerializable()
class GeoModel {
  final String lat;
  final String lng;

  const GeoModel({
    required this.lat,
    required this.lng,
  });

  factory GeoModel.fromJson(Map<String, dynamic> json) => _$GeoModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeoModelToJson(this);

  GeoEntity toEntity() {
    return GeoEntity(lat: lat, lng: lng);
  }

  factory GeoModel.fromEntity(GeoEntity entity) {
    return GeoModel(lat: entity.lat, lng: entity.lng);
  }
}