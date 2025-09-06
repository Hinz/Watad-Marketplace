import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/listing.dart';
import '../models/user.dart';

class ListingProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  List<Listing> _listings = [];
  List<Listing> _filteredListings = [];
  ListingFilter _currentFilter = ListingFilter();
  bool _isLoading = false;
  String? _errorMessage;

  List<Listing> get listings => _filteredListings;
  List<Listing> get allListings => _listings;
  ListingFilter get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all listings
  Future<void> loadListings() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final querySnapshot = await _firestore
          .collection('listings')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      _listings = querySnapshot.docs
          .map((doc) => Listing.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load listings: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new listing
  Future<bool> createListing({
    required String title,
    required String description,
    required double price,
    required ListingCategory category,
    required ListingCondition condition,
    required List<XFile> images,
    required User seller,
    String? schoolId,
    String? schoolName,
    required String country,
    required String province,
    required String city,
    List<String>? tags,
    String? size,
    String? brand,
    String? color,
    String? material,
    String? grade,
    String? subject,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Upload images
      List<String> imageUrls = [];
      for (XFile image in images) {
        final imageUrl = await _uploadImage(image);
        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        }
      }

      if (imageUrls.isEmpty) {
        _errorMessage = 'At least one image is required';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final listing = Listing(
        id: '', // Will be set by Firestore
        title: title,
        description: description,
        price: price,
        category: category,
        condition: condition,
        imageUrls: imageUrls,
        sellerId: seller.id,
        sellerName: seller.name,
        sellerPhone: seller.phone,
        schoolId: schoolId,
        schoolName: schoolName,
        country: country,
        province: province,
        city: city,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: tags ?? [],
        size: size,
        brand: brand,
        color: color,
        material: material,
        grade: grade,
        subject: subject,
      );

      final docRef = await _firestore.collection('listings').add(listing.toMap());
      
      // Update the listing with the generated ID
      await _firestore.collection('listings').doc(docRef.id).update({'id': docRef.id});

      // Reload listings
      await loadListings();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create listing: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update a listing
  Future<bool> updateListing(String listingId, Map<String, dynamic> updates) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      updates['updatedAt'] = DateTime.now().millisecondsSinceEpoch;
      
      await _firestore.collection('listings').doc(listingId).update(updates);
      
      // Reload listings
      await loadListings();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update listing: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete a listing
  Future<bool> deleteListing(String listingId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firestore.collection('listings').doc(listingId).delete();
      
      // Reload listings
      await loadListings();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete listing: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Mark listing as sold
  Future<bool> markAsSold(String listingId, String buyerId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firestore.collection('listings').doc(listingId).update({
        'isSold': true,
        'buyerId': buyerId,
        'soldAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
      
      // Reload listings
      await loadListings();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to mark listing as sold: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Apply filters
  void applyFilters(ListingFilter filter) {
    _currentFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredListings = _listings.where((listing) {
      // Search query filter
      if (_currentFilter.searchQuery != null && 
          _currentFilter.searchQuery!.isNotEmpty) {
        final query = _currentFilter.searchQuery!.toLowerCase();
        if (!listing.title.toLowerCase().contains(query) &&
            !listing.description.toLowerCase().contains(query) &&
            !listing.tags.any((tag) => tag.toLowerCase().contains(query))) {
          return false;
        }
      }

      // Category filter
      if (_currentFilter.category != null && 
          listing.category != _currentFilter.category) {
        return false;
      }

      // Country filter
      if (_currentFilter.country != null && 
          listing.country != _currentFilter.country) {
        return false;
      }

      // Province filter
      if (_currentFilter.province != null && 
          listing.province != _currentFilter.province) {
        return false;
      }

      // School filter
      if (_currentFilter.schoolId != null && 
          listing.schoolId != _currentFilter.schoolId) {
        return false;
      }

      // Price range filter
      if (_currentFilter.minPrice != null && 
          listing.price < _currentFilter.minPrice!) {
        return false;
      }
      if (_currentFilter.maxPrice != null && 
          listing.price > _currentFilter.maxPrice!) {
        return false;
      }

      // Condition filter
      if (_currentFilter.condition != null && 
          listing.condition != _currentFilter.condition) {
        return false;
      }

      // Grade filter
      if (_currentFilter.grade != null && 
          listing.grade != _currentFilter.grade) {
        return false;
      }

      // Subject filter
      if (_currentFilter.subject != null && 
          listing.subject != _currentFilter.subject) {
        return false;
      }

      // Active filter
      if (_currentFilter.isActive != null && 
          listing.isActive != _currentFilter.isActive) {
        return false;
      }

      // Sold filter
      if (_currentFilter.isSold != null && 
          listing.isSold != _currentFilter.isSold) {
        return false;
      }

      return true;
    }).toList();
  }

  // Clear filters
  void clearFilters() {
    _currentFilter = ListingFilter();
    _applyFilters();
    notifyListeners();
  }

  // Get user's listings
  Future<List<Listing>> getUserListings(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('listings')
          .where('sellerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Listing.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      _errorMessage = 'Failed to load user listings: $e';
      notifyListeners();
      return [];
    }
  }

  // Get listing by ID
  Future<Listing?> getListingById(String listingId) async {
    try {
      final doc = await _firestore.collection('listings').doc(listingId).get();
      if (doc.exists) {
        return Listing.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      _errorMessage = 'Failed to load listing: $e';
      notifyListeners();
      return null;
    }
  }

  // Increment view count
  Future<void> incrementViewCount(String listingId) async {
    try {
      await _firestore.collection('listings').doc(listingId).update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      // Silently fail for view count
    }
  }

  // Upload image to Firebase Storage
  Future<String?> _uploadImage(XFile image) async {
    try {
      final file = File(image.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
      final ref = _storage.ref().child('listings/$fileName');
      
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      _errorMessage = 'Failed to upload image: $e';
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
