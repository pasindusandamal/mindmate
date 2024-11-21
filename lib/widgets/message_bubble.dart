import 'package:flutter/material.dart';
import '../model/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          gradient: isUser
              ? LinearGradient(
                  colors: [Colors.deepPurple[100]!, Colors.deepPurple[50]!],
                )
              : LinearGradient(
                  colors: [Colors.purple[100]!, Colors.purple[50]!],
                ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: isUser ? Colors.deepPurple : Colors.purple,
              radius: 20,
              child: Icon(
                isUser ? Icons.person_outline : Icons.android,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.deepPurple[900] : Colors.purple[900],
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}