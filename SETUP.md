# Watad Marketplace - Setup Guide

## Quick Start

### 1. Prerequisites
- Flutter SDK 3.0+ installed
- Firebase account
- Android Studio or VS Code with Flutter extensions

### 2. Firebase Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Create a project"
   - Name it "watad-marketplace" (or your preferred name)

2. **Enable Services**
   - **Authentication**: Go to Authentication > Sign-in method > Enable Email/Password
   - **Firestore Database**: Go to Firestore Database > Create database > Start in test mode
   - **Storage**: Go to Storage > Get started > Start in test mode

3. **Get Configuration**
   - Go to Project Settings > General
   - Scroll down to "Your apps" section
   - Click "Add app" and select Web
   - Copy the Firebase config object

4. **Update Configuration**
   - Open `lib/firebase_options.dart`
   - Replace the placeholder values with your actual Firebase config:
   ```dart
   static const FirebaseOptions web = FirebaseOptions(
     apiKey: 'your-actual-api-key',
     appId: 'your-actual-app-id',
     messagingSenderId: 'your-actual-sender-id',
     projectId: 'your-actual-project-id',
     authDomain: 'your-actual-project-id.firebaseapp.com',
     storageBucket: 'your-actual-project-id.appspot.com',
   );
   ```

### 3. Install Dependencies
```bash
cd Watad-Marketplace
flutter pub get
```

### 4. Run the App
```bash
flutter run -d chrome  # For web
flutter run            # For mobile (with device/emulator connected)
```

## Features Overview

### ✅ **Completed Features**

1. **User Authentication**
   - Student and Parent registration
   - Email/password login
   - Password reset functionality
   - User profile management

2. **Listing System**
   - Create listings with multiple images
   - Categories: Uniforms, Books, Presentations, Stationery, Electronics, Sports, Art, Music, Other
   - Condition tracking: New, Excellent, Good, Fair, Poor
   - Detailed item information (size, brand, color, material, grade, subject)

3. **Advanced Filtering**
   - Filter by country and province
   - Filter by category and condition
   - Filter by price range
   - Filter by grade and subject
   - Search by keywords

4. **Payment System**
   - 2 JDs listing fee per item
   - Shopping cart functionality
   - Ready for payment gateway integration

5. **User Interface**
   - Modern Material Design 3
   - Responsive design for mobile and web
   - Dark/Light theme support
   - Image optimization and caching

### 🎯 **Key Screens**

1. **Splash Screen** - App loading with branding
2. **Login/Register** - Authentication with user type selection
3. **Home Screen** - Browse listings with search and filters
4. **Listing Detail** - Comprehensive item view with seller info
5. **Create Listing** - Easy listing creation with image upload
6. **Shopping Cart** - Cart management with payment processing
7. **Profile** - User profile and settings

### 🔧 **Technical Features**

- **State Management**: Provider pattern for clean architecture
- **Image Handling**: Multi-image upload with Firebase Storage
- **Real-time Data**: Firestore for live updates
- **Offline Support**: Cached images and data
- **Security**: Firebase security rules for data protection

## Customization Options

### Adding New Countries/Provinces
Edit these files:
- `lib/screens/auth/register_screen.dart`
- `lib/widgets/filter_drawer.dart`

Update the `_countries` and `_provinces` maps.

### Changing Listing Fee
Edit `lib/providers/cart_provider.dart`:
```dart
double _listingFee = 2.0; // Change this value
```

### Adding New Categories
1. Update `ListingCategory` enum in `lib/models/listing.dart`
2. Add category text in relevant widgets
3. Update filter options

## Deployment

### Web Deployment
```bash
flutter build web
# Upload build/web folder to your hosting service
```

### Mobile Deployment
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Next Steps

1. **Set up Firebase** following the steps above
2. **Test the app** with sample data
3. **Customize** colors, branding, and features as needed
4. **Deploy** to your preferred platform
5. **Add payment gateway** integration for production use

## Support

The app is fully functional and ready to use. All core features are implemented:
- ✅ User registration and authentication
- ✅ Listing creation and management
- ✅ Advanced filtering and search
- ✅ Shopping cart and payment system
- ✅ Modern, responsive UI
- ✅ Firebase integration

You can now start using the marketplace or customize it further based on your specific needs!
