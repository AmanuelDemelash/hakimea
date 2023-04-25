import 'dart:convert';
import 'package:get/get.dart';

class MyServices extends GetConnect {
  Future<Response> getchatmessage(String prompt) async {
    const openaiApikey = "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";
    var url = Uri.http("api.openai.com", "/v1/completion");

    final response = await httpClient.post("api.openai.com/v1/completion",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openaiApikey',
        },
        body: jsonEncode({
          'model': 'text-davinci-003',
          'prompt': prompt,
          'temperature': 0,
          'max_token': 2000,
          'top_p': 1,
          'frequency_penalty': 0.0,
          'presence_penalty': 0.0
        }));

    return response;
  }
}
