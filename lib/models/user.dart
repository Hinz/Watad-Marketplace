class User {
  final String id;
  final String email;
  final String name;
  final String phone;
  final UserType userType;
  final String? schoolId;
  final String? schoolName;
  final String country;
  final String province;
  final DateTime createdAt;
  final String? profileImageUrl;
  final double rating;
  final int totalListings;
  final int totalSales;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.userType,
    this.schoolId,
    this.schoolName,
    required this.country,
    required this.province,
    required this.createdAt,
    this.profileImageUrl,
    this.rating = 0.0,
    this.totalListings = 0,
    this.totalSales = 0,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      userType: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${map['userType']}',
        orElse: () => UserType.student,
      ),
      schoolId: map['schoolId'],
      schoolName: map['schoolName'],
      country: map['country'] ?? '',
      province: map['province'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      profileImageUrl: map['profileImageUrl'],
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalListings: map['totalListings'] ?? 0,
      totalSales: map['totalSales'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'userType': userType.toString().split('.').last,
      'schoolId': schoolId,
      'schoolName': schoolName,
      'country': country,
      'province': province,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profileImageUrl': profileImageUrl,
      'rating': rating,
      'totalListings': totalListings,
      'totalSales': totalSales,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    UserType? userType,
    String? schoolId,
    String? schoolName,
    String? country,
    String? province,
    DateTime? createdAt,
    String? profileImageUrl,
    double? rating,
    int? totalListings,
    int? totalSales,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      schoolId: schoolId ?? this.schoolId,
      schoolName: schoolName ?? this.schoolName,
      country: country ?? this.country,
      province: province ?? this.province,
      createdAt: createdAt ?? this.createdAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      rating: rating ?? this.rating,
      totalListings: totalListings ?? this.totalListings,
      totalSales: totalSales ?? this.totalSales,
    );
  }
}

enum UserType {
  student,
  parent,
}

class School {
  final String id;
  final String name;
  final String country;
  final String province;
  final String city;
  final SchoolType type;

  School({
    required this.id,
    required this.name,
    required this.country,
    required this.province,
    required this.city,
    required this.type,
  });

  factory School.fromMap(Map<String, dynamic> map) {
    return School(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      country: map['country'] ?? '',
      province: map['province'] ?? '',
      city: map['city'] ?? '',
      type: SchoolType.values.firstWhere(
        (e) => e.toString() == 'SchoolType.${map['type']}',
        orElse: () => SchoolType.public,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'province': province,
      'city': city,
      'type': type.toString().split('.').last,
    };
  }
}

enum SchoolType {
  public,
  private,
  international,
  university,
}
