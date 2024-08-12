import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:towner/models/listing_model.dart';

class MarketplaceService {
  final CollectionReference _listingsCollection = FirebaseFirestore.instance.collection('listings');

  Future<void> createListing(ListingModel listing) async {
    await _listingsCollection.add(listing.toMap());
  }

  Future<List<ListingModel>> getListings() async {
    QuerySnapshot querySnapshot = await _listingsCollection.get();
    return querySnapshot.docs.map((doc) => ListingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> updateListing(ListingModel listing) async {
    await _listingsCollection.doc(listing.id).update(listing.toMap());
  }

  Future<void> deleteListing(String id) async {
    await _listingsCollection.doc(id).delete();
  }
}