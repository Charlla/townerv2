import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towner/providers/marketplace_provider.dart';
import 'package:towner/models/listing_model.dart';
import 'package:towner/services/ai_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarketplaceScreen extends StatefulWidget {
  @override
  _MarketplaceScreenState createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AIService _aiService = AIService();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MarketplaceProvider>().fetchListings());
  }

  void _performSearch() async {
    final marketplaceProvider = context.read<MarketplaceProvider>();
    final query = _searchController.text;
    if (query.isNotEmpty) {
      final rankedListings = await _aiService.rankListings(
        query,
        marketplaceProvider.listings,
      );
      marketplaceProvider.setRankedListings(rankedListings);
    } else {
      marketplaceProvider.setRankedListings([]);
    }
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search listings...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _performSearch,
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<MarketplaceProvider>(
              builder: (context, marketplaceProvider, child) {
                final listings = marketplaceProvider.filteredListings.isEmpty
                    ? marketplaceProvider.listings
                    : marketplaceProvider.filteredListings;

                if (listings.isEmpty) {
                  return Center(child: Text('No listings available'));
                }
                return ListView.builder(
                  itemCount: listings.length,
                  itemBuilder: (context, index) {
                    final listing = listings[index];
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
          ),
        ],
      ),
    );
  }

  void _showListingDetails(ListingModel listing) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(listing.title),
      content: Container(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarkdownBody(
                data: '''
### Description
${listing.description}

### Price
\$${listing.price.toStringAsFixed(2)}

### Created
${listing.createdAt.toString()}

### Status
${listing.isSold ? 'Sold' : 'Available'}
''',
              ),
            ],
          ),
        ),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}