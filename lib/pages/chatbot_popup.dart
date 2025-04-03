import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:digicollege/pages/mistral_service.dart';

class ChatbotPopup extends StatefulWidget {
  const ChatbotPopup({Key? key}) : super(key: key);

  @override
  _ChatbotPopupState createState() => _ChatbotPopupState();
}

class _ChatbotPopupState extends State<ChatbotPopup> {
  final List<types.Message> _messages = [];
  final MistralService _mistralService = MistralService();

  // Callback for handling sent messages.
  void _handleSendPressed(types.PartialText message) async {
    // Create a new text message from the current user.
    final textMessage = types.TextMessage(
      author: const types.User(id: 'currentUser'),
      id: UniqueKey().toString(),
      text: message.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    setState(() {
      _messages.add(textMessage);
    });
    try {
      final replyText = await _mistralService.sendMessage(message.text);
      // Create a reply message from the bot.
      final replyMessage = types.TextMessage(
        author: const types.User(id: 'bot'),
        id: UniqueKey().toString(),
        text: replyText,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      setState(() {
        _messages.add(replyMessage);
      });
    } catch (e) {
      // Add an error message if sending fails.
      final errorMessage = types.TextMessage(
        author: const types.User(id: 'bot'),
        id: UniqueKey().toString(),
        text: 'Error: Could not send message.',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      setState(() {
        _messages.add(errorMessage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(16.0),
        child: Chat(
          messages: _messages,
          onPreviewDataFetched: (message, previewData) {},
          onSendPressed: _handleSendPressed,
          user: const types.User(id: 'currentUser'),
        ),
      ),
    );
  }
}
