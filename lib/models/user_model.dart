

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String passwordH;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  // Add empty constructor
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.passwordH,
    required this.phoneNumber,
    this.dateOfBirth,
    this.profileImage,
    required this.createdAt,
    required this.lastLoginAt,
  });

  // Add empty factory constructor for unauthenticated state
  factory UserModel.empty() {
    return UserModel(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      passwordH: '',
      phoneNumber: null,
      dateOfBirth: null,
      profileImage: null,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  // Rest of your existing methods (copyWith, fromJson, toJson)...

  // Add copyWith method for immutability
  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? passwordH,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? profileImage,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      passwordH: passwordH ?? this.passwordH,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      passwordH: json['passwordHash'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      profileImage: json['profileImage'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: DateTime.parse(json['lastLoginAt']),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'passwordHash': passwordH,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
    };
  }
}