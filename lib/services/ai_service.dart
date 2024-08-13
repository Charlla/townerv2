import 'package:towner/models/project_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:towner/models/listing_model.dart';

class AIService {
  late GenerativeModel _model;

  AIService() {
    final apiKey = 'AIzaSyADvS5vgFziFBdNAFxAmU5xhuXG_PJNF8c'; // Replace with your actual API key
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
      ],
    );
  }
  Future<String> generateResponse(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'No response generated.';
    } catch (e) {
      print('Error generating response: $e');
      return 'An error occurred while generating a response.';
    }
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

  Future<List<ListingModel>> rankListings(String query, List<ListingModel> listings) async {
    try {
      final listingsJson = listings.map((l) => {
        'id': l.id,
        'title': l.title,
        'description': l.description,
        'price': l.price,
      }).toList();

      final prompt = '''
        Given the following user query and list of products, rank the products based on their relevance to the query.
        Return a JSON array of product IDs in order of relevance.

        User query: $query

        Products:
        ${json.encode(listingsJson)}

        Ranked product IDs:
      ''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final rankedIds = json.decode(response.text!) as List<dynamic>;

      // Sort the listings based on the AI-generated ranking
      final rankedListings = listings.where((l) => rankedIds.contains(l.id)).toList()
        ..sort((a, b) => rankedIds.indexOf(a.id!).compareTo(rankedIds.indexOf(b.id!)));

      // Add any listings that weren't ranked by the AI to the end of the list
      rankedListings.addAll(listings.where((l) => !rankedIds.contains(l.id)));

      return rankedListings;
    } catch (e) {
      print('Error ranking listings: $e');
      return listings; // Return original list if ranking fails
    }
  }

  Future<Map<String, dynamic>> enhanceProjectDescription(String initialDescription) async {
  try {
    final prompt = '''
      Based on the following initial description of a community project, generate an enhanced project proposal with the following format:
      - A catchy title (max 50 characters)
      - A detailed description (max 200 words)
      - A list of 3-5 skills needed for the project
      - A suggested deadline (2-4 weeks from now)
      - Number of volunteers needed (1-10)

      Initial description: $initialDescription

      Please return the result in the following JSON format:
      {
        "title": "Catchy Title Here",
        "description": "Detailed description here...",
        "skillsNeeded": ["Skill 1", "Skill 2", "Skill 3"],
        "deadline": "YYYY-MM-DD",
        "volunteersNeeded": 5
      }
    ''';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    final jsonResponse = response.text;

    try {
      // Remove any markdown formatting that might be present
      final cleanJson = jsonResponse!.replaceAll(RegExp(r'```json|```'), '').trim();
      Map<String, dynamic> parsedResponse = json.decode(cleanJson);
      return parsedResponse;
    } catch (e) {
      print('Error parsing JSON: $e');
      return {
        'title': '',
        'description': initialDescription,
        'skillsNeeded': [],
        'deadline': DateTime.now().add(Duration(days: 14)).toIso8601String().split('T')[0],
        'volunteersNeeded': 1,
      };
    }
  } catch (e) {
    print('Error enhancing project description: $e');
    return {
      'title': '',
      'description': initialDescription,
      'skillsNeeded': [],
      'deadline': DateTime.now().add(Duration(days: 14)).toIso8601String().split('T')[0],
      'volunteersNeeded': 1,
    };
  }
}

Future<String> generateCommunityInsights(List<ProjectModel> projects) async {
  try {
    final projectsJson = projects.map((p) => {
      'title': p.title,
      'description': p.description,
      'skillsNeeded': p.skillsNeeded,
      'volunteersNeeded': p.volunteersNeeded,
      'volunteerIds': p.volunteerIds,
      'status': p.status,
    }).toList();

    final prompt = '''
      Given the following list of community projects, generate insights about the community's engagement and needs.
      Provide a summary of the most needed skills, the most popular types of projects, and suggestions for new projects that might benefit the community.

      Community Projects:
      ${json.encode(projectsJson)}

      Please provide your insights in a concise, bullet-point format.
    ''';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text ?? 'Unable to generate community insights.';
  } catch (e) {
    print('Error generating community insights: $e');
    return 'An error occurred while generating community insights.';
  }
}
}