import 'package:flutter/foundation.dart';
import 'package:towner/services/marketplace_service.dart';
import 'package:towner/models/listing_model.dart';

class MarketplaceProvider with ChangeNotifier {
  final MarketplaceService _marketplaceService = MarketplaceService();
  List<ListingModel> _listings = [];
  List<ListingModel> _filteredListings = [];
  String? _currentListingDescription;

  List<ListingModel> get listings => _listings;
  List<ListingModel> get filteredListings => _filteredListings.isEmpty ? _listings : _filteredListings;
  String? get currentListingDescription => _currentListingDescription;

  void setCurrentListing(String description) {
    _currentListingDescription = description;
    notifyListeners();
  }

  Future<void> createListing(ListingModel listing) async {
    try {
      await _marketplaceService.createListing(listing);
      _listings.add(listing);
      notifyListeners();
    } catch (e) {
      print('Error creating listing: $e');
      rethrow;
    }
  }

  Future<void> fetchListings() async {
    try {
      _listings = await _marketplaceService.getListings();
      notifyListeners();
    } catch (e) {
      print('Error fetching listings: $e');
      rethrow;
    }
  }

  void setRankedListings(List<ListingModel> rankedListings) {
    _filteredListings = rankedListings;
    notifyListeners();
  }

  void searchListings(String query) {
    if (query.isEmpty) {
      _filteredListings = [];
    } else {
      _filteredListings = _listings.where((listing) =>
        listing.title.toLowerCase().contains(query.toLowerCase()) ||
        listing.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    notifyListeners();
  }

  Future<void> updateListing(ListingModel listing) async {
    try {
      await _marketplaceService.updateListing(listing);
      int index = _listings.indexWhere((element) => element.id == listing.id);
      if (index != -1) {
        _listings[index] = listing;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating listing: $e');
      rethrow;
    }
  }

  Future<void> deleteListing(String id) async {
    try {
      await _marketplaceService.deleteListing(id);
      _listings.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting listing: $e');
      rethrow;
    }
  }
}