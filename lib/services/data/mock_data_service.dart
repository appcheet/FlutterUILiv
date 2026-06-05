import '../../architecture/domain/entities/user_entity.dart';

/// Mock data service to provide sample users for demo purposes
class MockDataService {
  static List<UserEntity> getMockUsers() {
    return [
      UserEntity(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        email: 'john.doe@email.com',
        phone: '+1-555-0123',
        website: 'johndoe.com',
        address: AddressEntity(
          street: '123 Main St',
          suite: 'Apt 1',
          city: 'New York',
          zipcode: '10001',
          geo: GeoEntity(lat: '40.7128', lng: '-74.0060'),
        ),
        company: CompanyEntity(
          name: 'Tech Corp',
          catchPhrase: 'Innovation at its finest',
          bs: 'tech solutions',
        ),
      ),
      UserEntity(
        id: 2,
        name: 'Jane Smith',
        username: 'janesmith',
        email: 'jane.smith@email.com',
        phone: '+1-555-0456',
        website: 'janesmith.dev',
        address: AddressEntity(
          street: '456 Oak Ave',
          suite: 'Suite 2B',
          city: 'Los Angeles',
          zipcode: '90210',
          geo: GeoEntity(lat: '34.0522', lng: '-118.2437'),
        ),
        company: CompanyEntity(
          name: 'Creative Studios',
          catchPhrase: 'Design with purpose',
          bs: 'creative solutions',
        ),
      ),
      UserEntity(
        id: 3,
        name: 'Mike Johnson',
        username: 'mikejohnson',
        email: 'mike.johnson@email.com',
        phone: '+1-555-0789',
        website: null,
        address: AddressEntity(
          street: '789 Pine St',
          suite: 'Unit 3C',
          city: 'Chicago',
          zipcode: '60601',
          geo: GeoEntity(lat: '41.8781', lng: '-87.6298'),
        ),
        company: CompanyEntity(
          name: 'Data Systems',
          catchPhrase: 'Managing data efficiently',
          bs: 'data management',
        ),
      ),
      UserEntity(
        id: 4,
        name: 'Sarah Wilson',
        username: 'sarahw',
        email: 'sarah.wilson@email.com',
        phone: '+1-555-0321',
        website: 'sarahwilson.io',
        address: AddressEntity(
          street: '321 Elm Dr',
          suite: 'Floor 4',
          city: 'Seattle',
          zipcode: '98101',
          geo: GeoEntity(lat: '47.6062', lng: '-122.3321'),
        ),
        company: null,
      ),
      UserEntity(
        id: 5,
        name: 'David Brown',
        username: 'davidbrown',
        email: 'david.brown@email.com',
        phone: '+1-555-0654',
        website: null,
        address: AddressEntity(
          street: '654 Maple Ln',
          suite: 'Apt 5A',
          city: 'Boston',
          zipcode: '02101',
          geo: GeoEntity(lat: '42.3601', lng: '-71.0589'),
        ),
        company: CompanyEntity(
          name: 'Finance Plus',
          catchPhrase: 'Your financial future',
          bs: 'financial services',
        ),
      ),
      UserEntity(
        id: 6,
        name: 'Emily Davis',
        username: 'emilydavis',
        email: 'emily.davis@email.com',
        phone: '+1-555-0987',
        website: 'emilydavis.net',
        address: AddressEntity(
          street: '987 Cedar Ave',
          suite: 'Studio 6',
          city: 'Austin',
          zipcode: '73301',
          geo: GeoEntity(lat: '30.2672', lng: '-97.7431'),
        ),
        company: CompanyEntity(
          name: 'Marketing Hub',
          catchPhrase: 'Reaching new heights',
          bs: 'marketing solutions',
        ),
      ),
      UserEntity(
        id: 7,
        name: 'Chris Taylor',
        username: 'christaylor',
        email: 'chris.taylor@email.com',
        phone: '+1-555-0147',
        website: null,
        address: AddressEntity(
          street: '147 Birch St',
          suite: 'Room 7B',
          city: 'Denver',
          zipcode: '80201',
          geo: GeoEntity(lat: '39.7392', lng: '-104.9903'),
        ),
        company: CompanyEntity(
          name: 'Healthcare Solutions',
          catchPhrase: 'Caring for your health',
          bs: 'healthcare technology',
        ),
      ),
      UserEntity(
        id: 8,
        name: 'Lisa Anderson',
        username: 'lisaanderson',
        email: 'lisa.anderson@email.com',
        phone: '+1-555-0258',
        website: 'lisaanderson.com',
        address: AddressEntity(
          street: '258 Spruce Rd',
          suite: 'Loft 8',
          city: 'Miami',
          zipcode: '33101',
          geo: GeoEntity(lat: '25.7617', lng: '-80.1918'),
        ),
        company: CompanyEntity(
          name: 'Travel Adventures',
          catchPhrase: 'Explore the world',
          bs: 'travel services',
        ),
      ),
      UserEntity(
        id: 9,
        name: 'Tom Martinez',
        username: 'tommartinez',
        email: 'tom.martinez@email.com',
        phone: '+1-555-0369',
        website: null,
        address: AddressEntity(
          street: '369 Willow Way',
          suite: 'Unit 9',
          city: 'Phoenix',
          zipcode: '85001',
          geo: GeoEntity(lat: '33.4484', lng: '-112.0740'),
        ),
        company: CompanyEntity(
          name: 'Education First',
          catchPhrase: 'Learning for life',
          bs: 'educational services',
        ),
      ),
      UserEntity(
        id: 10,
        name: 'Amy Garcia',
        username: 'amygarcia',
        email: 'amy.garcia@email.com',
        phone: '+1-555-0741',
        website: 'amygarcia.dev',
        address: AddressEntity(
          street: '741 Aspen Ct',
          suite: 'Penthouse',
          city: 'San Francisco',
          zipcode: '94101',
          geo: GeoEntity(lat: '37.7749', lng: '-122.4194'),
        ),
        company: CompanyEntity(
          name: 'Green Energy',
          catchPhrase: 'Powering the future',
          bs: 'renewable energy',
        ),
      ),
    ];
  }

  static Future<List<UserEntity>> fetchUsersAsync() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockUsers();
  }

  static List<UserEntity> searchUsers(List<UserEntity> users, String query) {
    if (query.isEmpty) return users;
    
    final lowerQuery = query.toLowerCase();
    return users.where((user) =>
      user.name.toLowerCase().contains(lowerQuery) ||
      user.username.toLowerCase().contains(lowerQuery) ||
      user.email.toLowerCase().contains(lowerQuery) ||
      (user.company?.name.toLowerCase().contains(lowerQuery) ?? false)
    ).toList();
  }

  static UserEntity? getUserById(List<UserEntity> users, int id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
}