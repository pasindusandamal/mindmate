import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';

class OllamaService {
  final Dio _dio = Dio();

  Future<Stream<String>> sendMessage(String message) async {
    final streamController = StreamController<String>();

    try {
      final url = 'http://localhost:11434/api/generate';

      final response = await _dio.post(
        url,
        data: {
          'model': 'qwen2.5:7b',
          'prompt': message,
          'stream': true
        },
        options: Options(responseType: ResponseType.stream),
      );

      await (response.data as ResponseBody).stream.forEach((chunk) {
        String responseChunk = utf8.decode(chunk);

        LineSplitter.split(responseChunk).forEach((line) {
          if (line.trim().isNotEmpty) {
            try {
              var jsonResponse = json.decode(line);

              if (jsonResponse['response'] != null) {
                // Stream each character individually
                final String partialResponse = jsonResponse['response'];
                for (int i = 0; i < partialResponse.length; i++) {
                  streamController.add(partialResponse[i]);
                }
              }

              if (jsonResponse['done'] == true) {
                streamController.close();
              }
            } catch (e) {
              print('JSON parsing error: $e');
            }
          }
        });
      });
    } catch (e) {
      streamController.addError(e);
      streamController.close();
    }

    return streamController.stream;
  }
}