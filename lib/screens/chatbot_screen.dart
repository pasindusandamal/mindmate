import 'package:flutter/material.dart';

import '../model/chat_message.dart';
import '../services/ollama_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_field.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final OllamaService _ollamaService = OllamaService();

  List<ChatMessage> _messages = [];
  bool _isTyping = false;
  String _displayResponse = '';

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String message) async {
    // Add user message
    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _isTyping = true;
      _displayResponse = '';
    });
    _scrollToBottom();

    try {
      final responseStream = await _ollamaService.sendMessage(message);
      
      final aiMessage = ChatMessage(text: '', isUser: false);
      _messages.add(aiMessage);

      responseStream.listen(
        (chunk) {
          setState(() {
            _displayResponse += chunk;
          });
          _scrollToBottom();
        },
        onDone: () {
          setState(() {
            _isTyping = false;
          });
        },
        onError: (error) {
          setState(() {
            _isTyping = false;
            _messages.add(ChatMessage(
              text: 'Error: Unable to get response. Check Ollama server.',
              isUser: false
            ));
          });
        }
      );
    } catch (e) {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: 'Error: Unable to send message.',
          isUser: false
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chatbot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              setState(() {
                _messages.clear();
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final isLastMessage = index == _messages.length - 1 && !_messages[index].isUser;
                return MessageBubble(
                  message: _messages[index],
                  isLastMessage: isLastMessage,
                  displayResponse: isLastMessage ? _displayResponse : null,
                );
              },
            ),
          ),
          ChatInputField(
            controller: _messageController,
            onSend: () {
              if (_messageController.text.isNotEmpty) {
                _sendMessage(_messageController.text);
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}