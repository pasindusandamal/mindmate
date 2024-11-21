import 'package:flutter/material.dart';

import '../model/chat_message.dart';


class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isLastMessage;
  final String? displayResponse;

  const MessageBubble({
    Key? key,
    required this.message,
    this.isLastMessage = false,
    this.displayResponse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;
    final String text = isLastMessage && displayResponse != null 
        ? displayResponse! 
        : message.text;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.deepPurple[50] : Colors.purple[100],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isUser ? const Radius.circular(15) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isUser ? Icons.person : Icons.android,
              color: isUser ? Colors.deepPurple : Colors.purple,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.deepPurple[900] : Colors.purple[900],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}