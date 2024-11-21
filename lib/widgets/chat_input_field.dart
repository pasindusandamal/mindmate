import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputField({
    Key? key,
    required this.controller,
    required this.onSend,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_checkButtonStatus);
  }

  void _checkButtonStatus() {
    setState(() {
      _isButtonEnabled = widget.controller.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: 'Type a message',
                hintStyle: TextStyle(color: Colors.deepPurple.shade300),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send, 
              color: _isButtonEnabled 
                ? Colors.deepPurple 
                : Colors.grey
            ),
            onPressed: _isButtonEnabled ? widget.onSend : null,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkButtonStatus);
    super.dispose();
  }
}