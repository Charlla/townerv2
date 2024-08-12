import 'package:flutter/material.dart';
import 'package:towner/screens/home_screen.dart';
import 'package:towner/screens/auth/login_screen.dart';
import 'package:towner/screens/auth/register_screen.dart';
import 'package:towner/screens/marketplace/marketplace_screen.dart';
import 'package:towner/screens/marketplace/create_listing_screen.dart';
import 'package:towner/screens/community/community_screen.dart';
import 'package:towner/screens/insights/insights_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String marketplace = '/marketplace';
  static const String createListing = '/create_listing';
  static const String community = '/community';
  static const String insights = '/insights';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => HomeScreen(),
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    marketplace: (context) => MarketplaceScreen(),
    createListing: (context) => CreateListingScreen(),
    community: (context) => CommunityScreen(),
    insights: (context) => InsightsScreen(),
  };
}