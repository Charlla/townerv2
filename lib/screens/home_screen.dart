import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towner/providers/auth_provider.dart';
import 'package:towner/widgets/chat_interface.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Towner'),
        actions: [
          if (authProvider.user != null)
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => authProvider.signOut(),
            ),
        ],
      ),
      body: authProvider.user == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('Login'),
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('Register'),
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      _buildFeatureCard(
                        context,
                        'Marketplace',
                        Icons.store,
                        'Buy and sell locally',
                        () => Navigator.pushNamed(context, '/marketplace'),
                      ),
                      _buildFeatureCard(
                        context,
                        'Community',
                        Icons.people,
                        'Engage in community projects',
                        () => Navigator.pushNamed(context, '/community'),
                      ),
                      _buildFeatureCard(
                        context,
                        'Insights',
                        Icons.insights,
                        'Discover community trends',
                        () => Navigator.pushNamed(context, '/insights'),
                      ),
                    ],
                  ),
                ),
                ChatInterface(),
              ],
            ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon,
      String description, VoidCallback onTap) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 4),
                    Text(description),
                  ],
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}