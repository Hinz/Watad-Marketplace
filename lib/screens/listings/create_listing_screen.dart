import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../providers/listing_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/listing.dart';
import '../../models/user.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _sizeController = TextEditingController();
  final _brandController = TextEditingController();
  final _colorController = TextEditingController();
  final _materialController = TextEditingController();

  ListingCategory _selectedCategory = ListingCategory.books;
  ListingCondition _selectedCondition = ListingCondition.good;
  String? _selectedGrade;
  String? _selectedSubject;
  List<XFile> _selectedImages = [];

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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _sizeController.dispose();
    _brandController.dispose();
    _colorController.dispose();
    _materialController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
        // Limit to 5 images
        if (_selectedImages.length > 5) {
          _selectedImages = _selectedImages.take(5).toList();
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _createListing() async {
    if (_formKey.currentState!.validate() && _selectedImages.isNotEmpty) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final listingProvider = Provider.of<ListingProvider>(context, listen: false);
      
      if (authProvider.user == null) return;

      final success = await listingProvider.createListing(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        category: _selectedCategory,
        condition: _selectedCondition,
        images: _selectedImages,
        seller: authProvider.user!,
        country: authProvider.user!.country,
        province: authProvider.user!.province,
        city: authProvider.user!.province, // Using province as city for now
        size: _sizeController.text.trim().isEmpty ? null : _sizeController.text.trim(),
        brand: _brandController.text.trim().isEmpty ? null : _brandController.text.trim(),
        color: _colorController.text.trim().isEmpty ? null : _colorController.text.trim(),
        material: _materialController.text.trim().isEmpty ? null : _materialController.text.trim(),
        grade: _selectedGrade,
        subject: _selectedSubject,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } else if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Listing'),
        actions: [
          Consumer<ListingProvider>(
            builder: (context, listingProvider, child) {
              return TextButton(
                onPressed: listingProvider.isLoading ? null : _createListing,
                child: listingProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Post',
                        style: TextStyle(color: Colors.white),
                      ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Images Section
              _buildSectionTitle('Photos (Required)'),
              const SizedBox(height: 8),
              Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _selectedImages.length) {
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: _pickImages,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 40),
                              SizedBox(height: 4),
                              Text('Add Photo', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _selectedImages[index].path,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // Basic Information
              _buildSectionTitle('Basic Information'),
              const SizedBox(height: 16),
              
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  hintText: 'Enter a descriptive title',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  hintText: 'Describe your item in detail',
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Price
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price (JD) *',
                  hintText: '0.00',
                  prefixText: 'JD ',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Category
              DropdownButtonFormField2<ListingCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category *',
                ),
                items: ListingCategory.values.map((ListingCategory category) {
                  return DropdownMenuItem<ListingCategory>(
                    value: category,
                    child: Text(_getCategoryText(category)),
                  );
                }).toList(),
                onChanged: (ListingCategory? value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Condition
              DropdownButtonFormField2<ListingCondition>(
                value: _selectedCondition,
                decoration: const InputDecoration(
                  labelText: 'Condition *',
                ),
                items: ListingCondition.values.map((ListingCondition condition) {
                  return DropdownMenuItem<ListingCondition>(
                    value: condition,
                    child: Text(_getConditionText(condition)),
                  );
                }).toList(),
                onChanged: (ListingCondition? value) {
                  setState(() {
                    _selectedCondition = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              // Additional Details
              _buildSectionTitle('Additional Details (Optional)'),
              const SizedBox(height: 16),
              
              // Size
              TextFormField(
                controller: _sizeController,
                decoration: const InputDecoration(
                  labelText: 'Size',
                  hintText: 'e.g., Small, Medium, Large',
                ),
              ),
              const SizedBox(height: 16),
              
              // Brand
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Brand',
                  hintText: 'e.g., Nike, Adidas',
                ),
              ),
              const SizedBox(height: 16),
              
              // Color
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Color',
                  hintText: 'e.g., Blue, Red, Black',
                ),
              ),
              const SizedBox(height: 16),
              
              // Material
              TextFormField(
                controller: _materialController,
                decoration: const InputDecoration(
                  labelText: 'Material',
                  hintText: 'e.g., Cotton, Polyester',
                ),
              ),
              const SizedBox(height: 16),
              
              // Grade
              DropdownButtonFormField2<String>(
                value: _selectedGrade,
                decoration: const InputDecoration(
                  labelText: 'Grade',
                ),
                items: _grades.map((String grade) {
                  return DropdownMenuItem<String>(
                    value: grade,
                    child: Text(grade),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedGrade = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Subject
              DropdownButtonFormField2<String>(
                value: _selectedSubject,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                ),
                items: _subjects.map((String subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              
              // Listing Fee Notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'A listing fee of 2 JDs will be charged when you post this item.',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
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
