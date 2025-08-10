import 'package:equatable/equatable.dart';

/// User entity representing the core business logic model
class UserEntity extends Equatable {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? phone;
  final String? website;
  final CompanyEntity? company;
  final AddressEntity? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.phone,
    this.website,
    this.company,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  /// Create a copy with updated fields
  UserEntity copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    String? phone,
    String? website,
    CompanyEntity? company,
    AddressEntity? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      company: company ?? this.company,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        email,
        phone,
        website,
        company,
        address,
        createdAt,
        updatedAt,
      ];
}

/// Company entity
class CompanyEntity extends Equatable {
  final String name;
  final String catchPhrase;
  final String bs;

  const CompanyEntity({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  CompanyEntity copyWith({
    String? name,
    String? catchPhrase,
    String? bs,
  }) {
    return CompanyEntity(
      name: name ?? this.name,
      catchPhrase: catchPhrase ?? this.catchPhrase,
      bs: bs ?? this.bs,
    );
  }

  @override
  List<Object?> get props => [name, catchPhrase, bs];
}

/// Address entity
class AddressEntity extends Equatable {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final GeoEntity geo;

  const AddressEntity({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  AddressEntity copyWith({
    String? street,
    String? suite,
    String? city,
    String? zipcode,
    GeoEntity? geo,
  }) {
    return AddressEntity(
      street: street ?? this.street,
      suite: suite ?? this.suite,
      city: city ?? this.city,
      zipcode: zipcode ?? this.zipcode,
      geo: geo ?? this.geo,
    );
  }

  @override
  List<Object?> get props => [street, suite, city, zipcode, geo];
}

/// Geo entity
class GeoEntity extends Equatable {
  final String lat;
  final String lng;

  const GeoEntity({
    required this.lat,
    required this.lng,
  });

  GeoEntity copyWith({
    String? lat,
    String? lng,
  }) {
    return GeoEntity(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  @override
  List<Object?> get props => [lat, lng];
}