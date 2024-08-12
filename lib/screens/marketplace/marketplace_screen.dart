import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towner/providers/marketplace_provider.dart';
import 'package:towner/models/listing_model.dart';

class MarketplaceScreen extends StatefulWidget {
  @override
  _MarketplaceScreenState createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MarketplaceProvider>().fetchListings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketplace'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/create_listing'),
          ),
        ],
      ),
      body: Consumer<MarketplaceProvider>(
        builder: (context, marketplaceProvider, child) {
          if (marketplaceProvider.listings.isEmpty) {
            return Center(child: Text('No listings available'));
          }
          return ListView.builder(
            itemCount: marketplaceProvider.listings.length,
            itemBuilder: (context, index) {
              final listing = marketplaceProvider.listings[index];
              return ListTile(
                title: Text(listing.title),
                subtitle: Text('${listing.description}\nPrice: \$${listing.price.toStringAsFixed(2)}'),
                trailing: listing.isSold ? Icon(Icons.check_circle, color: Colors.green) : null,
                onTap: () => _showListingDetails(listing),
              );
            },
          );
        },
      ),
    );
  }

  void _showListingDetails(ListingModel listing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(listing.title),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Description: ${listing.description}'),
            Text('Price: \$${listing.price.toStringAsFixed(2)}'),
            Text('Created: ${listing.createdAt.toString()}'),
            Text('Status: ${listing.isSold ? 'Sold' : 'Available'}'),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}