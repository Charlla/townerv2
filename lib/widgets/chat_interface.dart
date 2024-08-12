import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:towner/providers/marketplace_provider.dart';

class ChatInterface extends StatefulWidget {
  @override
  _ChatInterfaceState createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late GenerativeModel _model;
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initializeAI();
    _initializeSpeech();
    _initializeTts();
  }

  void _initializeAI() {
    final apiKey = 'YOUR_GEMINI_API_KEY'; // Replace with your actual API key
    _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

  void _initializeSpeech() {
    _speech = stt.SpeechToText();
  }

  void _initializeTts() {
    _flutterTts = FlutterTts();
  }

  void _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _messages.add({'role': 'user', 'content': text});
    });
    _scrollToBottom();

    if (_isMarketplaceCommand(text)) {
      _handleMarketplaceCommand(text);
    } else {
      try {
        final content = [Content.text(text)];
        final response = await _model.generateContent(content);
        setState(() {
          _messages.add({'role': 'bot', 'content': response.text ?? 'No response'});
        });
        _scrollToBottom();
        _speakResponse(response.text ?? 'No response');
      } catch (e) {
        print('Error: $e');
        setState(() {
          _messages.add({'role': 'bot', 'content': 'Sorry, I encountered an error.'});
        });
      }
    }
  }

  bool _isMarketplaceCommand(String text) {
    final lowercaseText = text.toLowerCase();
    return lowercaseText.contains('sell') ||
        lowercaseText.contains('buy') ||
        lowercaseText.contains('marketplace') ||
        lowercaseText.contains('listing') ||
        lowercaseText.contains('product');
  }

  void _handleMarketplaceCommand(String text) {
    final marketplaceProvider = Provider.of<MarketplaceProvider>(context, listen: false);
    if (text.toLowerCase().contains('sell') || text.toLowerCase().contains('create listing')) {
      marketplaceProvider.setCurrentListing(text);
      Navigator.pushNamed(context, '/create_listing');
    } else if (text.toLowerCase().contains('buy') || text.toLowerCase().contains('search')) {
      Navigator.pushNamed(context, '/marketplace');
    } else {
      _speakResponse("I'm not sure what you want to do in the marketplace. You can say 'sell' to create a listing or 'buy' to browse listings.");
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _textController.text = result.recognizedWords;
          });
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _speakResponse(String text) async {
    await _flutterTts.speak(text);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Align(
                    alignment: message['role'] == 'user'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: message['role'] == 'user'
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        message['content'] ?? '',
                        style: TextStyle(
                          color: message['role'] == 'user'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                    onSubmitted: _handleSubmitted,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}