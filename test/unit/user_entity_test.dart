import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/architecture/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    test('should create UserEntity with required parameters', () {
      // Arrange
      final now = DateTime.now();
      
      // Act
      final user = UserEntity(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(user.id, equals(1));
      expect(user.name, equals('John Doe'));
      expect(user.username, equals('johndoe'));
      expect(user.email, equals('john@example.com'));
      expect(user.createdAt, equals(now));
      expect(user.updatedAt, equals(now));
    });

    test('should create UserEntity with all parameters', () {
      // Arrange
      final createdAt = DateTime(2023, 1, 1);
      final updatedAt = DateTime(2023, 6, 1);
      
      // Act
      final user = UserEntity(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
        phone: '+1234567890',
        website: 'https://johndoe.com',
        createdAt: createdAt,
        updatedAt: updatedAt,
        company: const CompanyEntity(
          name: 'Tech Corp',
          catchPhrase: 'Innovation at its best',
          bs: 'revolutionize synergistic e-markets',
        ),
        address: const AddressEntity(
          street: '123 Tech Street',
          suite: 'Apt 4B',
          city: 'Tech City',
          zipcode: '12345',
          geo: GeoEntity(lat: '40.7128', lng: '-74.0060'),
        ),
      );

      // Assert
      expect(user.id, equals(1));
      expect(user.name, equals('John Doe'));
      expect(user.username, equals('johndoe'));
      expect(user.email, equals('john@example.com'));
      expect(user.phone, equals('+1234567890'));
      expect(user.website, equals('https://johndoe.com'));
      expect(user.createdAt, equals(createdAt));
      expect(user.updatedAt, equals(updatedAt));
      expect(user.company?.name, equals('Tech Corp'));
      expect(user.address?.city, equals('Tech City'));
    });

    test('should support copyWith method', () {
      // Arrange
      final now = DateTime.now();
      final originalUser = UserEntity(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final updatedUser = originalUser.copyWith(
        name: 'John Smith',
        email: 'johnsmith@example.com',
      );

      // Assert
      expect(updatedUser.id, equals(originalUser.id));
      expect(updatedUser.name, equals('John Smith'));
      expect(updatedUser.username, equals(originalUser.username));
      expect(updatedUser.email, equals('johnsmith@example.com'));
    });

    test('should be equal when properties are the same', () {
      // Arrange
      final now = DateTime.now();
      final user1 = UserEntity(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
        createdAt: now,
        updatedAt: now,
      );

      final user2 = UserEntity(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(user1, equals(user2));
      expect(user1.hashCode, equals(user2.hashCode));
    });

    test('should not be equal when properties are different', () {
      // Arrange
      final now = DateTime.now();
      final user1 = UserEntity(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
        createdAt: now,
        updatedAt: now,
      );

      final user2 = UserEntity(
        id: 2,
        name: 'Jane Smith',
        username: 'janesmith',
        email: 'jane@example.com',
        createdAt: now,
        updatedAt: now,
      );

      // Assert
      expect(user1, isNot(equals(user2)));
      expect(user1.hashCode, isNot(equals(user2.hashCode)));
    });

    test('should return correct string representation', () {
      // Arrange
      final now = DateTime.now();
      final user = UserEntity(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final stringRepresentation = user.toString();

      // Assert
      expect(stringRepresentation, contains('UserEntity'));
      expect(stringRepresentation, contains('id: 1'));
      expect(stringRepresentation, contains('name: John Doe'));
      expect(stringRepresentation, contains('username: johndoe'));
      expect(stringRepresentation, contains('email: john@example.com'));
    });
  });
}