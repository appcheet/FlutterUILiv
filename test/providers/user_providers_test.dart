import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:test_app/architecture/domain/entities/user_entity.dart';
import 'package:test_app/architecture/domain/usecases/get_users_usecase.dart';
import 'package:test_app/architecture/presentation/riverpod/providers/user_providers.dart';

import 'user_providers_test.mocks.dart';

// Generate mocks for testing
@GenerateMocks([GetUsersUseCase])
void main() {
  group('User Providers Tests', () {
    late MockGetUsersUseCase mockGetUsersUseCase;
    late ProviderContainer container;

    setUp(() {
      mockGetUsersUseCase = MockGetUsersUseCase();
      container = ProviderContainer(
        overrides: [
          getUsersUseCaseProvider.overrideWithValue(mockGetUsersUseCase),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('UsersNotifier', () {
      test('should load users successfully', () async {
        // Arrange
        final testUsers = [
          const UserEntity(
            id: 1,
            name: 'John Doe',
            username: 'johndoe',
            email: 'john@example.com',
          ),
          const UserEntity(
            id: 2,
            name: 'Jane Smith',
            username: 'janesmith',
            email: 'jane@example.com',
          ),
        ];

        when(mockGetUsersUseCase.execute(forceRefresh: false))
            .thenAnswer((_) async => Right(testUsers));

        // Act
        final result = await container.read(usersNotifierProvider.future);

        // Assert
        expect(result, equals(testUsers));
        verify(mockGetUsersUseCase.execute(forceRefresh: false)).called(1);
      });

      test('should handle error when loading users fails', () async {
        // Arrange
        const errorMessage = 'Network error';
        when(mockGetUsersUseCase.execute(forceRefresh: false))
            .thenAnswer((_) async => const Left(errorMessage));

        // Act & Assert
        expect(
          () async => await container.read(usersNotifierProvider.future),
          throwsA(equals(errorMessage)),
        );
        verify(mockGetUsersUseCase.execute(forceRefresh: false)).called(1);
      });

      test('should search users successfully', () async {
        // Arrange
        const query = 'John';
        final filteredUsers = [
          const UserEntity(
            id: 1,
            name: 'John Doe',
            username: 'johndoe',
            email: 'john@example.com',
          ),
        ];

        when(mockGetUsersUseCase.searchUsers(query))
            .thenAnswer((_) async => Right(filteredUsers));

        // Act
        final notifier = container.read(usersNotifierProvider.notifier);
        await notifier.searchUsers(query);
        final result = container.read(usersNotifierProvider).value;

        // Assert
        expect(result, equals(filteredUsers));
        verify(mockGetUsersUseCase.searchUsers(query)).called(1);
      });

      test('should refresh users successfully', () async {
        // Arrange
        final refreshedUsers = [
          const UserEntity(
            id: 3,
            name: 'Bob Johnson',
            username: 'bobjohnson',
            email: 'bob@example.com',
          ),
        ];

        when(mockGetUsersUseCase.execute(forceRefresh: true))
            .thenAnswer((_) async => Right(refreshedUsers));

        // Act
        final notifier = container.read(usersNotifierProvider.notifier);
        await notifier.refresh();
        final result = container.read(usersNotifierProvider).value;

        // Assert
        expect(result, equals(refreshedUsers));
        verify(mockGetUsersUseCase.execute(forceRefresh: true)).called(1);
      });

      test('should get user by ID successfully', () async {
        // Arrange
        const userId = 1;
        const expectedUser = UserEntity(
          id: 1,
          name: 'John Doe',
          username: 'johndoe',
          email: 'john@example.com',
        );

        when(mockGetUsersUseCase.getUserById(userId))
            .thenAnswer((_) async => const Right(expectedUser));

        // Act
        final notifier = container.read(usersNotifierProvider.notifier);
        final result = await notifier.getUserById(userId);

        // Assert
        expect(result, equals(expectedUser));
        verify(mockGetUsersUseCase.getUserById(userId)).called(1);
      });

      test('should return null when get user by ID fails', () async {
        // Arrange
        const userId = 999;
        const errorMessage = 'User not found';

        when(mockGetUsersUseCase.getUserById(userId))
            .thenAnswer((_) async => const Left(errorMessage));

        // Act
        final notifier = container.read(usersNotifierProvider.notifier);
        final result = await notifier.getUserById(userId);

        // Assert
        expect(result, isNull);
        verify(mockGetUsersUseCase.getUserById(userId)).called(1);
      });

      test('should clear cache successfully', () async {
        // Arrange
        when(mockGetUsersUseCase.clearCache())
            .thenAnswer((_) async => const Right(true));
        when(mockGetUsersUseCase.execute(forceRefresh: true))
            .thenAnswer((_) async => const Right([]));

        // Act
        final notifier = container.read(usersNotifierProvider.notifier);
        await notifier.clearCache();

        // Assert
        verify(mockGetUsersUseCase.clearCache()).called(1);
        verify(mockGetUsersUseCase.execute(forceRefresh: true)).called(1);
      });
    });

    group('UserSearchQuery Provider', () {
      test('should update search query', () {
        // Arrange
        const query = 'John';

        // Act
        container.read(userSearchQueryProvider.notifier).updateQuery(query);
        final result = container.read(userSearchQueryProvider);

        // Assert
        expect(result, equals(query));
      });

      test('should clear search query', () {
        // Arrange
        container.read(userSearchQueryProvider.notifier).updateQuery('test');
        
        // Act
        container.read(userSearchQueryProvider.notifier).clearQuery();
        final result = container.read(userSearchQueryProvider);

        // Assert
        expect(result, isEmpty);
      });
    });

    group('SelectedUser Provider', () {
      test('should select user', () {
        // Arrange
        const user = UserEntity(
          id: 1,
          name: 'John Doe',
          username: 'johndoe',
          email: 'john@example.com',
        );

        // Act
        container.read(selectedUserProvider.notifier).selectUser(user);
        final result = container.read(selectedUserProvider);

        // Assert
        expect(result, equals(user));
      });

      test('should clear user selection', () {
        // Arrange
        const user = UserEntity(
          id: 1,
          name: 'John Doe',
          username: 'johndoe',
          email: 'john@example.com',
        );
        container.read(selectedUserProvider.notifier).selectUser(user);

        // Act
        container.read(selectedUserProvider.notifier).clearSelection();
        final result = container.read(selectedUserProvider);

        // Assert
        expect(result, isNull);
      });
    });
  });
}