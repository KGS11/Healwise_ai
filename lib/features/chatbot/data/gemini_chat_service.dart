import 'dart:async';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:healwise_ai/core/constants/app_secrets.dart';
import 'package:http/http.dart' as http;

class LoggingClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // ignore: avoid_print
    print('Gemini API Endpoint: ${request.url}');
    final response = await _inner.send(request);
    // ignore: avoid_print
    print('Gemini API Response Status: ${response.statusCode}');
    return response;
  }
}

class GeminiChatService {
  late final GenerativeModel _model;
  late ChatSession _chat;
  final Future<String> Function(String)? onSendMessage;

  GeminiChatService({this.onSendMessage}) {
    if (onSendMessage == null) {
      // ignore: avoid_print
      print('Initializing GeminiChatService with model: gemini-2.5-flash');
      _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: AppSecrets.geminiApiKey,
        systemInstruction: Content.system(
          "You are HealWise AI, a naturopathy and preventive "
          "healthcare wellness assistant built for Indian users.\n\n"
          "Your role:\n"
          "- Suggest natural, naturopathy-based remedies\n"
          "- Recommend yoga, meditation, breathing exercises\n"
          "- Suggest herbal remedies common in India\n"
          "- Provide diet and lifestyle improvement guidance\n"
          "- Support both English and Kannada speakers\n\n"
          "Your boundaries:\n"
          "- Never diagnose medical conditions\n"
          "- Never prescribe pharmaceutical medicines\n"
          "- Always recommend consulting a doctor for serious symptoms\n"
          "- Never replace professional medical advice\n\n"
          "Your tone:\n"
          "- Warm, caring, and encouraging\n"
          "- Use simple language (user may be rural or elderly)\n"
          "- Keep responses concise — maximum 150 words\n"
          "- Use bullet points for readability\n"
          "- Add relevant emojis for friendliness\n"
          "- End each response with one follow-up question\n\n"
          "If user writes in Kannada:\n"
          "- Respond in Kannada using proper Unicode\n"
          "- Maintain the same wellness guidance scope\n\n"
          "Always end responses with:\n"
          "\"🙏 Remember: For serious health concerns, "
          "please consult a qualified doctor.\""
        ),
        generationConfig: GenerationConfig(
          maxOutputTokens: 300,
          temperature: 0.7,
        ),
        httpClient: LoggingClient(),
      );
      _chat = _model.startChat();
    }
  }

  // Send message and get response
  Future<String> sendMessage(String userMessage) async {
    if (onSendMessage != null) {
      // ignore: avoid_print
      print('[GeminiChatService] sendMessage using mock onSendMessage delegate');
      return onSendMessage!(userMessage);
    }
    
    // ignore: avoid_print
    print('[GeminiChatService] sendMessage initiated. Payload size: ${userMessage.length} chars');
    // ignore: avoid_print
    print('[GeminiChatService] Target Gemini Model: gemini-2.5-flash');
    // ignore: avoid_print
    print('[GeminiChatService] API Key Present: ${AppSecrets.geminiApiKey.isNotEmpty}');
    
    try {
      // ignore: avoid_print
      print('[GeminiChatService] Contacting API endpoint...');
      final response = await _chat.sendMessage(
        Content.text(userMessage),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          // ignore: avoid_print
          print('[GeminiChatService] API Request timed out (limit: 10s)');
          throw TimeoutException('Response timed out');
        },
      );
      
      // ignore: avoid_print
      print('[GeminiChatService] API Response status: 200 (Success)');
      final text = response.text;
      
      if (text == null || text.trim().isEmpty) {
        // ignore: avoid_print
        print('[GeminiChatService] Empty response parsing.');
        return "🤔 I didn't get a response. Please rephrase your question.";
      }
      
      // ignore: avoid_print
      print('[GeminiChatService] Response successfully parsed. Size: ${text.length} chars');
      return text;
    } on TimeoutException catch (e) {
      // ignore: avoid_print
      print('[GeminiChatService] TimeoutException caught: $e');
      return "⏱️ Response is taking too long. Please try again.";
    } on SocketException catch (e) {
      // ignore: avoid_print
      print('[GeminiChatService] SocketException caught: $e');
      return "🌐 No internet connection. Please check your network and try again.";
    } on GenerativeAIException catch (e) {
      // ignore: avoid_print
      print('[GeminiChatService] GenerativeAIException caught: ${e.message}');
      final message = e.message.toLowerCase();
      if (message.contains('api_key_invalid') ||
          message.contains('api key') ||
          message.contains('invalid') ||
          message.contains('key not found') ||
          message.contains('not valid')) {
        return "⚙️ Configuration error. Please contact app support.";
      } else if (message.contains('quota') ||
                 message.contains('429') ||
                 message.contains('resource_exhausted') ||
                 message.contains('exhausted')) {
        return "⏳ Too many requests. Please wait a moment and try again.";
      } else if (message.contains('not found') || message.contains('404')) {
        return "⚙️ Model config error: models/gemini-1.5-flash was not found. Please contact app support.";
      }
      return 'API error: ${e.message}. Please try again.';
    } catch (e, stackTrace) {
      // ignore: avoid_print
      print('[GeminiChatService] General Exception caught: $e');
      // ignore: avoid_print
      print(stackTrace);
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('socket') ||
          errStr.contains('handshake') ||
          errStr.contains('failed host lookup') ||
          errStr.contains('network') ||
          errStr.contains('connection')) {
        return "🌐 No internet connection. Please check your network and try again.";
      }
      if (errStr.contains('api_key_invalid') ||
          errStr.contains('api key') ||
          errStr.contains('invalid') ||
          errStr.contains('key not found') ||
          errStr.contains('not valid') ||
          errStr.contains('400') ||
          errStr.contains('403')) {
        return "⚙️ Configuration error. Please contact app support.";
      }
      if (errStr.contains('quota') ||
          errStr.contains('429') ||
          errStr.contains('resource_exhausted') ||
          errStr.contains('exhausted')) {
        return "⏳ Too many requests. Please wait a moment and try again.";
      }
      if (errStr.contains('not found') || errStr.contains('404')) {
        return "⚙️ Model configuration error. Please contact support.";
      }
      return 'Something went wrong. Check your connection.';
    }
  }

  // Reset conversation history
  void resetChat() {
    if (onSendMessage == null) {
      _chat = _model.startChat();
    }
  }
}
