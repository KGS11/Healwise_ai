import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healwise_ai/features/chatbot/data/gemini_chat_service.dart';
import 'package:healwise_ai/features/chatbot/presentation/chatbot_screen.dart';
import 'package:healwise_ai/features/chatbot/presentation/widgets/chat_welcome_card.dart';
import 'package:healwise_ai/features/chatbot/presentation/widgets/suggestion_chip_row.dart';
import 'package:healwise_ai/features/chatbot/presentation/widgets/typing_indicator.dart';
import 'package:healwise_ai/features/chatbot/presentation/widgets/user_message_bubble.dart';
import 'package:healwise_ai/features/chatbot/presentation/widgets/ai_message_bubble.dart';

void main() {
  testWidgets('ChatbotScreen initial state shows welcome card and suggestion chips', (WidgetTester tester) async {
    final fakeService = GeminiChatService(
      onSendMessage: (msg) async => 'Mock response',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChatbotScreen(
          languageName: 'English',
          geminiChatService: fakeService,
        ),
      ),
    );

    // Verify AppBar is present with titles
    expect(find.text('HealWise AI Assistant'), findsOneWidget);
    expect(find.text('Your naturopathy wellness guide'), findsOneWidget);

    // Verify Welcome Card is present
    expect(find.byType(ChatWelcomeCard), findsOneWidget);
    expect(find.text('Hello! I am HealWise AI'), findsOneWidget);

    // Verify Suggestion Chips are present
    expect(find.byType(SuggestionChipRow), findsOneWidget);
    expect(find.text('😴 Better Sleep'), findsOneWidget);

    // Verify input field and send button are present
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.send), findsOneWidget);
  });

  testWidgets('Tapping a suggestion chip sends query and shows response after delay', (WidgetTester tester) async {
    final fakeService = GeminiChatService(
      onSendMessage: (msg) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return 'Mock response for $msg';
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChatbotScreen(
          languageName: 'English',
          geminiChatService: fakeService,
        ),
      ),
    );

    // Tap the '😴 Better Sleep' suggestion chip
    await tester.tap(find.text('😴 Better Sleep'));
    await tester.pump(); // Start action, layout updates

    // User message bubble should appear immediately
    expect(find.byType(UserMessageBubble), findsOneWidget);
    expect(find.text('improve sleep'), findsOneWidget);

    // Typing indicator should be visible
    expect(find.byType(TypingIndicator), findsOneWidget);

    // Advance clock to finish the async call
    await tester.pump(const Duration(milliseconds: 100));

    // Typing indicator should be removed
    expect(find.byType(TypingIndicator), findsNothing);

    // AI message bubble should appear with response
    expect(find.byType(AiMessageBubble), findsOneWidget);
    expect(find.text('Mock response for improve sleep'), findsOneWidget);
  });

  testWidgets('Typing and sending text manually works correctly', (WidgetTester tester) async {
    final fakeService = GeminiChatService(
      onSendMessage: (msg) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return 'Mock response for $msg';
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChatbotScreen(
          languageName: 'English',
          geminiChatService: fakeService,
        ),
      ),
    );

    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    // Enter custom query
    await tester.enterText(textFieldFinder, 'yoga');
    await tester.pump();

    // Tap send button
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    // Verify user bubble
    expect(find.byType(UserMessageBubble), findsOneWidget);
    expect(find.text('yoga'), findsOneWidget);
    expect(find.byType(TypingIndicator), findsOneWidget);

    // Wait for delay
    await tester.pump(const Duration(milliseconds: 100));

    // Verify AI response
    expect(find.byType(TypingIndicator), findsNothing);
    expect(find.byType(AiMessageBubble), findsOneWidget);
    expect(find.text('Mock response for yoga'), findsOneWidget);
  });

  testWidgets('Tapping the refresh button resets the chat and clears messages', (WidgetTester tester) async {
    final fakeService = GeminiChatService(
      onSendMessage: (msg) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return 'Mock response for $msg';
      },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChatbotScreen(
          languageName: 'English',
          geminiChatService: fakeService,
        ),
      ),
    );

    // Send a message first
    await tester.tap(find.text('😴 Better Sleep'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify chat bubbles exist and welcome card is hidden
    expect(find.byType(UserMessageBubble), findsOneWidget);
    expect(find.byType(AiMessageBubble), findsOneWidget);
    expect(find.byType(ChatWelcomeCard), findsNothing);

    // Tap the refresh/new conversation button in AppBar
    await tester.tap(find.byTooltip('New conversation'));
    await tester.pump();

    // Verify chat bubbles are cleared
    expect(find.byType(UserMessageBubble), findsNothing);
    expect(find.byType(AiMessageBubble), findsNothing);

    // Verify welcome card is visible again
    expect(find.byType(ChatWelcomeCard), findsOneWidget);
  });
}
