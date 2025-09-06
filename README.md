# Watad Marketplace

A comprehensive marketplace application for parents and students to buy and sell educational items including uniforms, books, presentations, stationery, and more.

## Features

### 🛍️ **Marketplace Features**
- **Browse Listings**: View all available items with high-quality images
- **Advanced Filtering**: Filter by school, country, province, category, price range, condition, grade, and subject
- **Search Functionality**: Search for specific items using keywords
- **Detailed Item Views**: Comprehensive item details with multiple images, descriptions, and seller information

### 👥 **User Management**
- **Dual User Types**: Separate registration for students and parents
- **User Profiles**: Complete profiles with ratings, listing history, and contact information
- **Authentication**: Secure login/signup with email verification and password reset

### 📱 **Listing Management**
- **Create Listings**: Easy-to-use form for creating new listings with multiple images
- **Categories**: Support for uniforms, books, presentations, stationery, electronics, sports, art, music, and more
- **Condition Tracking**: Items categorized by condition (New, Excellent, Good, Fair, Poor)
- **Location-Based**: Listings organized by country, province, and city

### 💰 **Payment System**
- **Listing Fee**: 2 JDs per listing (configurable)
- **Shopping Cart**: Add multiple items to cart before checkout
- **Payment Integration**: Ready for integration with payment gateways

### 🎨 **User Experience**
- **Modern UI**: Clean, intuitive interface with Material Design 3
- **Responsive Design**: Works seamlessly on mobile and web
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Image Optimization**: Cached network images for better performance

## Technology Stack

- **Framework**: Flutter 3.0+
- **State Management**: Provider
- **Backend**: Firebase (Firestore, Authentication, Storage)
- **Image Handling**: Cached Network Image, Image Picker
- **UI Components**: Material Design 3
- **Internationalization**: Intl package for currency formatting

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user.dart            # User and School models
│   └── listing.dart         # Listing and Filter models
├── providers/               # State management
│   ├── auth_provider.dart   # Authentication logic
│   ├── listing_provider.dart # Listing management
│   └── cart_provider.dart   # Shopping cart logic
├── screens/                 # UI screens
│   ├── splash_screen.dart   # App loading screen
│   ├── home_screen.dart     # Main navigation
│   ├── auth/               # Authentication screens
│   ├── listings/           # Listing-related screens
│   ├── cart_screen.dart    # Shopping cart
│   └── profile_screen.dart # User profile
├── widgets/                # Reusable UI components
│   ├── listing_card.dart   # Item display card
│   ├── search_bar.dart     # Search input
│   ├── filter_drawer.dart  # Filtering interface
│   └── cart_item_widget.dart # Cart item display
└── theme/                  # App theming
    └── app_theme.dart      # Color scheme and styling
```

## Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Firebase project setup
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Watad-Marketplace
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication, Firestore Database, and Storage
   - Download configuration files:
     - For Android: `google-services.json` → `android/app/`
     - For iOS: `GoogleService-Info.plist` → `ios/Runner/`
     - For Web: Update `lib/firebase_options.dart` with your config

4. **Update Firebase Configuration**
   - Replace placeholder values in `lib/firebase_options.dart` with your actual Firebase config
   - Configure Firestore security rules
   - Set up Storage security rules

5. **Run the application**
   ```bash
   flutter run
   ```

### Firebase Configuration

#### Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Listings are readable by all authenticated users
    match /listings/{listingId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
        request.auth.uid == resource.data.sellerId;
      allow update, delete: if request.auth != null && 
        request.auth.uid == resource.data.sellerId;
    }
  }
}
```

#### Storage Security Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /listings/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

## Key Features Explained

### Filtering System
The app includes a comprehensive filtering system that allows users to narrow down listings by:
- **Geographic**: Country, Province, City
- **Educational**: School, Grade, Subject
- **Item Properties**: Category, Condition, Price Range
- **Search**: Text-based search across titles, descriptions, and tags

### Payment Integration
The app is designed to integrate with payment gateways:
- **Stripe**: For international payments
- **Local Gateways**: For regional payment methods
- **Listing Fees**: Configurable fee structure (currently 2 JDs per listing)

### User Experience
- **Responsive Design**: Optimized for mobile and desktop
- **Image Optimization**: Lazy loading and caching for better performance
- **Offline Support**: Basic offline functionality with cached data
- **Accessibility**: Screen reader support and keyboard navigation

## Customization

### Adding New Categories
1. Update `ListingCategory` enum in `lib/models/listing.dart`
2. Add category text mapping in relevant widgets
3. Update filter options in `lib/widgets/filter_drawer.dart`

### Modifying Listing Fee
1. Update `_listingFee` in `lib/providers/cart_provider.dart`
2. Update fee display text throughout the app

### Adding New Countries/Provinces
1. Update `_countries` and `_provinces` maps in:
   - `lib/screens/auth/register_screen.dart`
   - `lib/widgets/filter_drawer.dart`

## Deployment

### Web Deployment
```bash
flutter build web
# Deploy the build/web folder to your hosting service
```

### Android Deployment
```bash
flutter build apk --release
# Or for app bundle:
flutter build appbundle --release
```

### iOS Deployment
```bash
flutter build ios --release
# Open ios/Runner.xcworkspace in Xcode for further configuration
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Email: support@watadmarketplace.com
- Documentation: [Link to documentation]
- Issues: [GitHub Issues](https://github.com/your-repo/issues)

## Roadmap

- [ ] Push notifications for new listings
- [ ] Advanced search with filters
- [ ] User ratings and reviews
- [ ] Messaging system between buyers and sellers
- [ ] Wishlist functionality
- [ ] Social media integration
- [ ] Multi-language support
- [ ] Advanced analytics dashboard
- [ ] Mobile app for iOS and Android stores

---

**Watad Marketplace** - Connecting students and parents through educational commerce.
