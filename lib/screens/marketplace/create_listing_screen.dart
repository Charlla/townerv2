import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towner/providers/marketplace_provider.dart';
import 'package:towner/models/listing_model.dart';
import 'package:towner/services/ai_service.dart';

class CreateListingScreen extends StatefulWidget {
  @override
  _CreateListingScreenState createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  late AIService _aiService;

  @override
  void initState() {
    super.initState();
    _aiService = AIService();
    _processInitialDescription();
  }

  void _processInitialDescription() async {
    final marketplaceProvider = Provider.of<MarketplaceProvider>(context, listen: false);
    final initialDescription = marketplaceProvider.currentListingDescription;
    if (initialDescription != null) {
      final enhancedListing = await _aiService.enhanceListingDescription(initialDescription);
      setState(() {
        _titleController.text = enhancedListing['title'] ?? '';
        _descriptionController.text = enhancedListing['description'] ?? '';
        _priceController.text = enhancedListing['price'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Listing'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Create Listing'),
                onPressed: _submitListing,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitListing() async {
    if (_formKey.currentState!.validate()) {
      final marketplaceProvider = Provider.of<MarketplaceProvider>(context, listen: false);
      final newListing = ListingModel(
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        sellerId: 'current_user_id', // Replace with actual user ID
        createdAt: DateTime.now(),
      );

      try {
        await marketplaceProvider.createListing(newListing);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Listing created successfully')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create listing: $e')));
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}