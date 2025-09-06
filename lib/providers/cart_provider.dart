import 'package:flutter/material.dart';
import '../models/listing.dart';

class CartProvider with ChangeNotifier {
  List<Listing> _cartItems = [];
  double _totalAmount = 0.0;
  double _listingFee = 2.0; // 2 JDs per listing

  List<Listing> get cartItems => _cartItems;
  double get totalAmount => _totalAmount;
  double get listingFee => _listingFee;
  int get itemCount => _cartItems.length;

  void addToCart(Listing listing) {
    if (!_cartItems.any((item) => item.id == listing.id)) {
      _cartItems.add(listing);
      _calculateTotal();
      notifyListeners();
    }
  }

  void removeFromCart(String listingId) {
    _cartItems.removeWhere((item) => item.id == listingId);
    _calculateTotal();
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _totalAmount = 0.0;
    notifyListeners();
  }

  bool isInCart(String listingId) {
    return _cartItems.any((item) => item.id == listingId);
  }

  void _calculateTotal() {
    _totalAmount = _cartItems.length * _listingFee;
  }

  // Get total with listing fees
  double getTotalWithFees() {
    return _totalAmount;
  }

  // Process payment (simplified - in real app, integrate with payment gateway)
  Future<bool> processPayment() async {
    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));
      
      // Clear cart after successful payment
      clearCart();
      return true;
    } catch (e) {
      return false;
    }
  }
}
