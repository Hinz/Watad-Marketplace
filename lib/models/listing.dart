import 'user.dart';

class Listing {
  final String id;
  final String title;
  final String description;
  final double price;
  final ListingCategory category;
  final ListingCondition condition;
  final List<String> imageUrls;
  final String sellerId;
  final String sellerName;
  final String sellerPhone;
  final String? schoolId;
  final String? schoolName;
  final String country;
  final String province;
  final String city;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final bool isSold;
  final String? buyerId;
  final DateTime? soldAt;
  final int views;
  final int favorites;
  final List<String> tags;
  final String? size;
  final String? brand;
  final String? color;
  final String? material;
  final String? grade;
  final String? subject;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.condition,
    required this.imageUrls,
    required this.sellerId,
    required this.sellerName,
    required this.sellerPhone,
    this.schoolId,
    this.schoolName,
    required this.country,
    required this.province,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.isSold = false,
    this.buyerId,
    this.soldAt,
    this.views = 0,
    this.favorites = 0,
    this.tags = const [],
    this.size,
    this.brand,
    this.color,
    this.material,
    this.grade,
    this.subject,
  });

  factory Listing.fromMap(Map<String, dynamic> map) {
    return Listing(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      category: ListingCategory.values.firstWhere(
        (e) => e.toString() == 'ListingCategory.${map['category']}',
        orElse: () => ListingCategory.books,
      ),
      condition: ListingCondition.values.firstWhere(
        (e) => e.toString() == 'ListingCondition.${map['condition']}',
        orElse: () => ListingCondition.good,
      ),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      sellerPhone: map['sellerPhone'] ?? '',
      schoolId: map['schoolId'],
      schoolName: map['schoolName'],
      country: map['country'] ?? '',
      province: map['province'] ?? '',
      city: map['city'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
      isActive: map['isActive'] ?? true,
      isSold: map['isSold'] ?? false,
      buyerId: map['buyerId'],
      soldAt: map['soldAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['soldAt'])
          : null,
      views: map['views'] ?? 0,
      favorites: map['favorites'] ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
      size: map['size'],
      brand: map['brand'],
      color: map['color'],
      material: map['material'],
      grade: map['grade'],
      subject: map['subject'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category.toString().split('.').last,
      'condition': condition.toString().split('.').last,
      'imageUrls': imageUrls,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerPhone': sellerPhone,
      'schoolId': schoolId,
      'schoolName': schoolName,
      'country': country,
      'province': province,
      'city': city,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isActive': isActive,
      'isSold': isSold,
      'buyerId': buyerId,
      'soldAt': soldAt?.millisecondsSinceEpoch,
      'views': views,
      'favorites': favorites,
      'tags': tags,
      'size': size,
      'brand': brand,
      'color': color,
      'material': material,
      'grade': grade,
      'subject': subject,
    };
  }

  Listing copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    ListingCategory? category,
    ListingCondition? condition,
    List<String>? imageUrls,
    String? sellerId,
    String? sellerName,
    String? sellerPhone,
    String? schoolId,
    String? schoolName,
    String? country,
    String? province,
    String? city,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isSold,
    String? buyerId,
    DateTime? soldAt,
    int? views,
    int? favorites,
    List<String>? tags,
    String? size,
    String? brand,
    String? color,
    String? material,
    String? grade,
    String? subject,
  }) {
    return Listing(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      imageUrls: imageUrls ?? this.imageUrls,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerPhone: sellerPhone ?? this.sellerPhone,
      schoolId: schoolId ?? this.schoolId,
      schoolName: schoolName ?? this.schoolName,
      country: country ?? this.country,
      province: province ?? this.province,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      isSold: isSold ?? this.isSold,
      buyerId: buyerId ?? this.buyerId,
      soldAt: soldAt ?? this.soldAt,
      views: views ?? this.views,
      favorites: favorites ?? this.favorites,
      tags: tags ?? this.tags,
      size: size ?? this.size,
      brand: brand ?? this.brand,
      color: color ?? this.color,
      material: material ?? this.material,
      grade: grade ?? this.grade,
      subject: subject ?? this.subject,
    );
  }
}

enum ListingCategory {
  uniforms,
  books,
  presentations,
  stationery,
  electronics,
  sports,
  art,
  music,
  other,
}

enum ListingCondition {
  new_,
  excellent,
  good,
  fair,
  poor,
}

class ListingFilter {
  final String? searchQuery;
  final ListingCategory? category;
  final String? country;
  final String? province;
  final String? schoolId;
  final double? minPrice;
  final double? maxPrice;
  final ListingCondition? condition;
  final String? grade;
  final String? subject;
  final bool? isActive;
  final bool? isSold;

  ListingFilter({
    this.searchQuery,
    this.category,
    this.country,
    this.province,
    this.schoolId,
    this.minPrice,
    this.maxPrice,
    this.condition,
    this.grade,
    this.subject,
    this.isActive,
    this.isSold,
  });

  ListingFilter copyWith({
    String? searchQuery,
    ListingCategory? category,
    String? country,
    String? province,
    String? schoolId,
    double? minPrice,
    double? maxPrice,
    ListingCondition? condition,
    String? grade,
    String? subject,
    bool? isActive,
    bool? isSold,
  }) {
    return ListingFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      category: category ?? this.category,
      country: country ?? this.country,
      province: province ?? this.province,
      schoolId: schoolId ?? this.schoolId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      condition: condition ?? this.condition,
      grade: grade ?? this.grade,
      subject: subject ?? this.subject,
      isActive: isActive ?? this.isActive,
      isSold: isSold ?? this.isSold,
    );
  }
}
