import 'package:cloud_firestore/cloud_firestore.dart';

class ListingModel {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String sellerId;
  final DateTime createdAt;
  final bool isSold;

  ListingModel({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.sellerId,
    required this.createdAt,
    this.isSold = false,
  });

  factory ListingModel.fromMap(Map<String, dynamic> data, String id) {
    return ListingModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      sellerId: data['sellerId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isSold: data['isSold'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'sellerId': sellerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'isSold': isSold,
    };
  }
}