import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';

class AIService {
  late GenerativeModel _model;

  AIService() {
    final apiKey = 'AIzaSyADvS5vgFziFBdNAFxAmU5xhuXG_PJNF8c'; // Replace with your actual API key
    _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

  Future<Map<String, String>> enhanceListingDescription(String initialDescription) async {
    try {
      final prompt = '''
        Based on the following initial description of an item for sale, generate an enhanced listing with the following format:
        - A catchy title (max 50 characters)
        - A detailed description (max 200 words)
        - A suggested price (if not explicitly mentioned, make a reasonable guess)

        Initial description: $initialDescription

        Please return the result in the following JSON format:
        {
          "title": "Catchy Title Here",
          "description": "Detailed description here...",
          "price": "Suggested price here"
        }
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final jsonResponse = response.text;

      // Parse the JSON response
      try {
        Map<String, dynamic> parsedResponse = json.decode(jsonResponse!);
        return {
          'title': parsedResponse['title'] ?? '',
          'description': parsedResponse['description'] ?? '',
          'price': parsedResponse['price'] ?? '',
        };
      } catch (e) {
        print('Error parsing JSON: $e');
        return {
          'title': '',
          'description': initialDescription,
          'price': '',
        };
      }
    } catch (e) {
      print('Error enhancing listing description: $e');
      return {
        'title': '',
        'description': initialDescription,
        'price': '',
      };
    }
  }
}