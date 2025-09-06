import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../providers/listing_provider.dart';
import '../models/listing.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({super.key});

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
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

  final List<String> _grades = [
    'Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 'Grade 6',
    'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12',
    'University', 'Other'
  ];

  final List<String> _subjects = [
    'Mathematics', 'Science', 'English', 'Arabic', 'History', 'Geography',
    'Physics', 'Chemistry', 'Biology', 'Computer Science', 'Art', 'Music',
    'Physical Education', 'Religion', 'Other'
  ];

  late ListingFilter _currentFilter;
  String? _selectedCountry;
  String? _selectedProvince;
  double _minPrice = 0;
  double _maxPrice = 1000;
  RangeValues _priceRange = const RangeValues(0, 1000);

  @override
  void initState() {
    super.initState();
    _currentFilter = ListingFilter();
  }

  void _applyFilters() {
    final listingProvider = Provider.of<ListingProvider>(context, listen: false);
    listingProvider.applyFilters(_currentFilter);
    Navigator.of(context).pop();
  }

  void _clearFilters() {
    setState(() {
      _currentFilter = ListingFilter();
      _selectedCountry = null;
      _selectedProvince = null;
      _priceRange = const RangeValues(0, 1000);
      _minPrice = 0;
      _maxPrice = 1000;
    });
    final listingProvider = Provider.of<ListingProvider>(context, listen: false);
    listingProvider.clearFilters();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Filter Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Filter
                    _buildSectionTitle('Category'),
                    Wrap(
                      spacing: 8,
                      children: ListingCategory.values.map((category) {
                        final isSelected = _currentFilter.category == category;
                        return FilterChip(
                          label: Text(_getCategoryText(category)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _currentFilter = _currentFilter.copyWith(
                                category: selected ? category : null,
                              );
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    // Country Filter
                    _buildSectionTitle('Country'),
                    DropdownButtonFormField2<String>(
                      value: _selectedCountry,
                      decoration: const InputDecoration(
                        hintText: 'Select Country',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _countries.map((String country) {
                        return DropdownMenuItem<String>(
                          value: country,
                          child: Text(country),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCountry = value;
                          _selectedProvince = null;
                          _currentFilter = _currentFilter.copyWith(
                            country: value,
                            province: null,
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Province Filter
                    if (_selectedCountry != null) ...[
                      _buildSectionTitle('Province/State'),
                      DropdownButtonFormField2<String>(
                        value: _selectedProvince,
                        decoration: const InputDecoration(
                          hintText: 'Select Province',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _provinces[_selectedCountry]!.map((String province) {
                          return DropdownMenuItem<String>(
                            value: province,
                            child: Text(province),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedProvince = value;
                            _currentFilter = _currentFilter.copyWith(
                              province: value,
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                    // Price Range Filter
                    _buildSectionTitle('Price Range (JD)'),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 1000,
                      divisions: 50,
                      labels: RangeLabels(
                        '${_priceRange.start.round()}',
                        '${_priceRange.end.round()}',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _priceRange = values;
                          _minPrice = values.start;
                          _maxPrice = values.end;
                          _currentFilter = _currentFilter.copyWith(
                            minPrice: values.start,
                            maxPrice: values.end,
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    // Condition Filter
                    _buildSectionTitle('Condition'),
                    Wrap(
                      spacing: 8,
                      children: ListingCondition.values.map((condition) {
                        final isSelected = _currentFilter.condition == condition;
                        return FilterChip(
                          label: Text(_getConditionText(condition)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _currentFilter = _currentFilter.copyWith(
                                condition: selected ? condition : null,
                              );
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    // Grade Filter
                    _buildSectionTitle('Grade'),
                    DropdownButtonFormField2<String>(
                      value: _currentFilter.grade,
                      decoration: const InputDecoration(
                        hintText: 'Select Grade',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _grades.map((String grade) {
                        return DropdownMenuItem<String>(
                          value: grade,
                          child: Text(grade),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _currentFilter = _currentFilter.copyWith(
                            grade: value,
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Subject Filter
                    _buildSectionTitle('Subject'),
                    DropdownButtonFormField2<String>(
                      value: _currentFilter.subject,
                      decoration: const InputDecoration(
                        hintText: 'Select Subject',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _subjects.map((String subject) {
                        return DropdownMenuItem<String>(
                          value: subject,
                          child: Text(subject),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _currentFilter = _currentFilter.copyWith(
                            subject: value,
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearFilters,
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getCategoryText(ListingCategory category) {
    switch (category) {
      case ListingCategory.uniforms:
        return 'Uniforms';
      case ListingCategory.books:
        return 'Books';
      case ListingCategory.presentations:
        return 'Presentations';
      case ListingCategory.stationery:
        return 'Stationery';
      case ListingCategory.electronics:
        return 'Electronics';
      case ListingCategory.sports:
        return 'Sports';
      case ListingCategory.art:
        return 'Art';
      case ListingCategory.music:
        return 'Music';
      case ListingCategory.other:
        return 'Other';
    }
  }

  String _getConditionText(ListingCondition condition) {
    switch (condition) {
      case ListingCondition.new_:
        return 'New';
      case ListingCondition.excellent:
        return 'Excellent';
      case ListingCondition.good:
        return 'Good';
      case ListingCondition.fair:
        return 'Fair';
      case ListingCondition.poor:
        return 'Poor';
    }
  }
}
