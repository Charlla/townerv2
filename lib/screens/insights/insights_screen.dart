import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towner/providers/community_provider.dart';
import 'package:towner/services/ai_service.dart';

class InsightsScreen extends StatefulWidget {
  @override
  _InsightsScreenState createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final AIService _aiService = AIService();
  String _insights = 'Loading insights...';

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    final communityProvider = context.read<CommunityProvider>();
    await communityProvider.fetchProjects();
    final insights = await _aiService.generateCommunityInsights(communityProvider.projects);
    setState(() {
      _insights = insights;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Insights'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI-Generated Insights',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            Text(_insights),
            SizedBox(height: 24),
            ElevatedButton(
              child: Text('Refresh Insights'),
              onPressed: _loadInsights,
            ),
          ],
        ),
      ),
    );
  }
}