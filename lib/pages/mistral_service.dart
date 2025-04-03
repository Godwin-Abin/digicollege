import 'package:http/http.dart' as http;
import 'dart:convert';

class MistralService {
  final String apiKey = 'tYQ5jujU5B1dePBJcCK6Dk5wJ7AwahFB';
  final String apiUrl = 'https://api.mistral.ai/v1/chat/completions';

  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'mistral-tiny',
        'messages': [
          {'role': 'user', 'content': message}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to send message to Mistral.ai: ${response.body}');
    }
  }
}