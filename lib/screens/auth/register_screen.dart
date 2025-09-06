import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';
import '../home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  UserType _selectedUserType = UserType.student;
  String _selectedCountry = 'Jordan';
  String _selectedProvince = 'Amman';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _countries = [
    'Jordan',
    'Saudi Arabia',
    'UAE',
    'Kuwait',
    'Qatar',
    'Bahrain',
    'Oman',
    'Lebanon',
    'Syria',
    'Iraq',
    'Egypt',
    'Palestine',
  ];

  final Map<String, List<String>> _provinces = {
    'Jordan': ['Amman', 'Zarqa', 'Irbid', 'Aqaba', 'Karak', 'Mafraq', 'Tafilah', 'Madaba', 'Jerash', 'Ajloun', 'Balqa', 'Ma\'an'],
    'Saudi Arabia': ['Riyadh', 'Makkah', 'Madinah', 'Eastern Province', 'Asir', 'Jazan', 'Najran', 'Al Baha', 'Northern Borders', 'Al Jouf', 'Tabuk', 'Hail', 'Qassim'],
    'UAE': ['Abu Dhabi', 'Dubai', 'Sharjah', 'Ajman', 'Umm Al Quwain', 'Ras Al Khaimah', 'Fujairah'],
    'Kuwait': ['Al Ahmadi', 'Al Farwaniyah', 'Al Jahra', 'Hawalli', 'Kuwait City', 'Mubarak Al-Kabeer'],
    'Qatar': ['Doha', 'Al Rayyan', 'Al Wakrah', 'Al Khor', 'Al Shamal', 'Al Daayen', 'Umm Salal'],
    'Bahrain': ['Capital', 'Muharraq', 'Northern', 'Southern'],
    'Oman': ['Muscat', 'Dhofar', 'Musandam', 'Al Buraimi', 'Al Dakhiliyah', 'Al Dhahirah', 'Al Sharqiyah North', 'Al Sharqiyah South', 'Al Wusta', 'Dhofar'],
    'Lebanon': ['Beirut', 'Mount Lebanon', 'North Lebanon', 'South Lebanon', 'Bekaa', 'Nabatieh', 'Akkar', 'Baalbek-Hermel'],
    'Syria': ['Damascus', 'Aleppo', 'Homs', 'Hama', 'Latakia', 'Tartus', 'Idlib', 'Raqqa', 'Deir ez-Zor', 'Hasaka', 'Quneitra', 'Daraa', 'As-Suwayda'],
    'Iraq': ['Baghdad', 'Basra', 'Nineveh', 'Erbil', 'Kirkuk', 'Najaf', 'Karbala', 'Anbar', 'Babylon', 'Wasit', 'Maysan', 'Dhi Qar', 'Muthanna', 'Diyala', 'Sulaymaniyah', 'Dohuk'],
    'Egypt': ['Cairo', 'Alexandria', 'Giza', 'Shubra El Kheima', 'Port Said', 'Suez', 'Luxor', 'Aswan', 'Asyut', 'Ismailia', 'Faiyum', 'Zagazig', 'Damietta', 'Minya', 'Beni Suef', 'Hurghada', 'Qena', 'Sohag', 'Mansoura', 'Tanta', 'Kafr El Sheikh', 'Damanhur', 'Marsa Matruh', 'Qalyubia', 'Monufia', 'Beheira', 'Sharqia', 'Dakahlia', 'Gharbia', 'Red Sea', 'New Valley', 'North Sinai', 'South Sinai'],
    'Palestine': ['West Bank', 'Gaza Strip'],
  };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        userType: _selectedUserType,
        country: _selectedCountry,
        province: _selectedProvince,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Text(
                  'Join Watad Marketplace',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Create your account to start buying and selling',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Phone Field
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // User Type Dropdown
                DropdownButtonFormField2<UserType>(
                  value: _selectedUserType,
                  decoration: const InputDecoration(
                    labelText: 'I am a',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  items: UserType.values.map((UserType type) {
                    return DropdownMenuItem<UserType>(
                      value: type,
                      child: Text(type == UserType.student ? 'Student' : 'Parent'),
                    );
                  }).toList(),
                  onChanged: (UserType? value) {
                    setState(() {
                      _selectedUserType = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select user type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Country Dropdown
                DropdownButtonFormField2<String>(
                  value: _selectedCountry,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    prefixIcon: Icon(Icons.public),
                  ),
                  items: _countries.map((String country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCountry = value!;
                      _selectedProvince = _provinces[value]!.first;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select country';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Province Dropdown
                DropdownButtonFormField2<String>(
                  value: _selectedProvince,
                  decoration: const InputDecoration(
                    labelText: 'Province/State',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  items: _provinces[_selectedCountry]!.map((String province) {
                    return DropdownMenuItem<String>(
                      value: province,
                      child: Text(province),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedProvince = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select province';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                // Sign Up Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _signUp,
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Create Account'),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Error Message
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    if (authProvider.errorMessage != null) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Text(
                          authProvider.errorMessage!,
                          style: TextStyle(color: Colors.red[700]),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 20),
                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
