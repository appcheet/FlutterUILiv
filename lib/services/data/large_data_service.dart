import 'dart:math';
import 'dart:math' as math;
import '../../architecture/domain/entities/user_entity.dart';

/// Service to generate large datasets for performance testing
class LargeDataService {
  static final Random _random = Random();
  
  // Lists for generating random data
  static const List<String> _firstNames = [
    'James', 'John', 'Robert', 'Michael', 'William', 'David', 'Richard', 'Charles',
    'Joseph', 'Thomas', 'Christopher', 'Daniel', 'Paul', 'Mark', 'Donald', 'Steven',
    'Andrew', 'Joshua', 'Kenneth', 'Kevin', 'Brian', 'George', 'Timothy', 'Ronald',
    'Jason', 'Edward', 'Jeffrey', 'Ryan', 'Jacob', 'Gary', 'Nicholas', 'Eric',
    'Mary', 'Patricia', 'Jennifer', 'Linda', 'Elizabeth', 'Barbara', 'Susan', 'Jessica',
    'Sarah', 'Karen', 'Nancy', 'Lisa', 'Betty', 'Helen', 'Sandra', 'Donna',
    'Carol', 'Ruth', 'Sharon', 'Michelle', 'Laura', 'Sarah', 'Kimberly', 'Deborah',
    'Dorothy', 'Lisa', 'Nancy', 'Karen', 'Betty', 'Helen', 'Sandra', 'Donna'
  ];
  
  static const List<String> _lastNames = [
    'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
    'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas',
    'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson', 'White',
    'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson', 'Walker', 'Young',
    'Allen', 'King', 'Wright', 'Scott', 'Torres', 'Nguyen', 'Hill', 'Flores',
    'Green', 'Adams', 'Nelson', 'Baker', 'Hall', 'Rivera', 'Campbell', 'Mitchell'
  ];
  
  static const List<String> _companies = [
    'Tech Innovations Inc', 'Digital Solutions Corp', 'Global Systems Ltd', 'Future Technologies',
    'Advanced Computing Co', 'Smart Data Systems', 'Cloud Nine Technologies', 'Quantum Computing Inc',
    'Cyber Security Solutions', 'AI Research Labs', 'Machine Learning Corp', 'Data Analytics Pro',
    'Software Development Hub', 'Mobile Apps Studio', 'Web Services Inc', 'Enterprise Solutions',
    'Creative Design Agency', 'Marketing Dynamics', 'Business Intelligence Co', 'Strategic Consulting',
    'Financial Services Group', 'Healthcare Technology', 'Education Platform Inc', 'E-commerce Solutions',
    'Media Production House', 'Gaming Studio Pro', 'VR/AR Innovations', 'Blockchain Technologies',
    'Green Energy Solutions', 'Sustainable Tech Corp', 'Environmental Systems', 'Clean Tech Innovations'
  ];
  
  static const List<String> _domains = [
    'email.com', 'gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com', 'company.com',
    'tech.io', 'business.net', 'professional.org', 'corporate.biz', 'startup.co', 'innovation.tech'
  ];
  
  static const List<String> _cities = [
    'New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia',
    'San Antonio', 'San Diego', 'Dallas', 'San Jose', 'Austin', 'Jacksonville',
    'Fort Worth', 'Columbus', 'Charlotte', 'San Francisco', 'Indianapolis', 'Seattle',
    'Denver', 'Washington', 'Boston', 'Las Vegas', 'Nashville', 'Miami', 'Atlanta'
  ];

  /// Generate a large list of users
  static List<UserEntity> generateLargeUserList(int count) {
    final users = <UserEntity>[];
    
    for (int i = 1; i <= count; i++) {
      users.add(_generateRandomUser(i));
    }
    
    return users;
  }

  /// Generate users with pagination simulation
  static Future<List<UserEntity>> generateUsersPage({
    required int page,
    required int pageSize,
    int? totalUsers,
    Duration delay = const Duration(milliseconds: 300),
  }) async {
    // Simulate network delay
    await Future.delayed(delay);
    
    final total = totalUsers ?? 1000;
    final startIndex = (page - 1) * pageSize;
    final endIndex = math.min(startIndex + pageSize, total);
    
    if (startIndex >= total) {
      return [];
    }
    
    final users = <UserEntity>[];
    for (int i = startIndex; i < endIndex; i++) {
      users.add(_generateRandomUser(i + 1));
    }
    
    return users;
  }

  /// Search through large dataset with pagination
  static Future<List<UserEntity>> searchUsersPage({
    required String query,
    required int page,
    required int pageSize,
    Duration delay = const Duration(milliseconds: 200),
  }) async {
    await Future.delayed(delay);
    
    if (query.isEmpty) {
      return generateUsersPage(page: page, pageSize: pageSize);
    }
    
    // Generate a subset of users that match the search
    final allUsers = generateLargeUserList(200); // Smaller set for search
    final filteredUsers = allUsers.where((user) =>
      user.name.toLowerCase().contains(query.toLowerCase()) ||
      user.email.toLowerCase().contains(query.toLowerCase()) ||
      user.username.toLowerCase().contains(query.toLowerCase())
    ).toList();
    
    final startIndex = (page - 1) * pageSize;
    final endIndex = math.min(startIndex + pageSize, filteredUsers.length);
    
    if (startIndex >= filteredUsers.length) {
      return [];
    }
    
    return filteredUsers.sublist(startIndex, endIndex);
  }

  /// Generate infinite scroll data
  static Future<List<UserEntity>> generateInfiniteScrollData({
    required int offset,
    required int limit,
    Duration delay = const Duration(milliseconds: 400),
  }) async {
    await Future.delayed(delay);
    
    final users = <UserEntity>[];
    for (int i = offset; i < offset + limit; i++) {
      users.add(_generateRandomUser(i + 1));
    }
    
    return users;
  }

  /// Get total count for pagination calculations
  static int getTotalUserCount() => 1000;

  /// Calculate total pages
  static int getTotalPages(int pageSize) => (getTotalUserCount() / pageSize).ceil();

  /// Generate a single random user
  static UserEntity _generateRandomUser(int id) {
    final firstName = _firstNames[_random.nextInt(_firstNames.length)];
    final lastName = _lastNames[_random.nextInt(_lastNames.length)];
    final username = '${firstName.toLowerCase()}${lastName.toLowerCase()}$id';
    final domain = _domains[_random.nextInt(_domains.length)];
    final city = _cities[_random.nextInt(_cities.length)];
    
    return UserEntity(
      id: id,
      name: '$firstName $lastName',
      username: username,
      email: '$username@$domain',
      phone: _generatePhoneNumber(),
      website: _random.nextBool() ? '$username.com' : null,
      address: AddressEntity(
        street: '${_random.nextInt(9999) + 1} ${_generateStreetName()}',
        suite: _random.nextBool() ? 'Apt ${_random.nextInt(999) + 1}' : 'Suite ${_random.nextInt(99) + 1}',
        city: city,
        zipcode: _generateZipCode(),
        geo: GeoEntity(
          lat: (_random.nextDouble() * 180 - 90).toStringAsFixed(4),
          lng: (_random.nextDouble() * 360 - 180).toStringAsFixed(4),
        ),
      ),
      company: _random.nextBool() ? CompanyEntity(
        name: _companies[_random.nextInt(_companies.length)],
        catchPhrase: _generateCatchPhrase(),
        bs: _generateBusinessService(),
      ) : null,
    );
  }

  static String _generatePhoneNumber() {
    return '+1-${_random.nextInt(900) + 100}-${_random.nextInt(900) + 100}-${_random.nextInt(9000) + 1000}';
  }

  static String _generateStreetName() {
    const streetTypes = ['St', 'Ave', 'Rd', 'Blvd', 'Dr', 'Ln', 'Ct', 'Way'];
    const streetNames = ['Main', 'Oak', 'Pine', 'Maple', 'Cedar', 'Elm', 'Park', 'First', 'Second', 'Third'];
    return '${streetNames[_random.nextInt(streetNames.length)]} ${streetTypes[_random.nextInt(streetTypes.length)]}';
  }

  static String _generateZipCode() {
    return '${_random.nextInt(90000) + 10000}';
  }

  static String _generateCatchPhrase() {
    const phrases = [
      'Innovation at its finest',
      'Leading the future',
      'Excellence in service',
      'Your trusted partner',
      'Driving success forward',
      'Quality you can count on',
      'Solutions that work',
      'Building tomorrow today'
    ];
    return phrases[_random.nextInt(phrases.length)];
  }

  static String _generateBusinessService() {
    const services = [
      'technology solutions', 'consulting services', 'digital transformation',
      'data analytics', 'software development', 'cloud computing',
      'cybersecurity solutions', 'mobile applications', 'web development',
      'business intelligence', 'artificial intelligence', 'machine learning'
    ];
    return services[_random.nextInt(services.length)];
  }
}