import 'package:flutter/material.dart';

import '../data/chat_repository.dart';
import '../data/gemini_chat_service.dart';
import '../domain/chat_message.dart';
import 'chat_history_screen.dart';
import 'widgets/ai_message_bubble.dart';
import 'widgets/chat_welcome_card.dart';
import 'widgets/suggestion_chip_row.dart';
import 'widgets/typing_indicator.dart';
import 'widgets/user_message_bubble.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({
    super.key,
    required this.languageName,
    this.geminiChatService,
    this.chatRepository,
    this.initialMessages,
    this.initialSessionId,
    this.readOnly = false,
  });

  final String languageName;
  final GeminiChatService? geminiChatService;
  final ChatRepository? chatRepository;
  final List<ChatMessage>? initialMessages;
  final String? initialSessionId;
  final bool readOnly;

  // Localization structure (Task Requirements)
  static const String appBarTitle = 'HealWise AI Assistant';
  // ಹಲೋ! ನಾನು HealWise AI (Kannada translation reference)

  static const String appBarSubtitle = 'Your naturopathy wellness guide';
  // ನೈಸರ್ಗಿಕ ಆರೋಗ್ಯದ ಬಗ್ಗೆ ಕೇಳಿ (Kannada translation reference)

  static const String inputHint = 'Ask about your wellness...';

  static const String welcomeTitle = 'Hello! I am HealWise AI';

  static const String welcomeSubtitle =
      'Ask me anything about natural wellness and naturopathy';

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = [];
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late final GeminiChatService _geminiChatService;
  late final ChatRepository _chatRepository;

  bool _isAiTyping = false;
  bool _isTextEmpty = true;
  bool _readOnly = false;
  bool _isNewSession = true;
  String? _currentSessionId;

  @override
  void initState() {
    super.initState();
    _geminiChatService = widget.geminiChatService ?? GeminiChatService();
    _chatRepository = widget.chatRepository ?? ChatRepository();
    _messages.addAll(widget.initialMessages ?? const <ChatMessage>[]);
    _currentSessionId = widget.initialSessionId;
    _readOnly = widget.readOnly;
    _isNewSession = _currentSessionId == null;
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isTextEmpty = _messageController.text.trim().isEmpty;
    });
  }

  void _sendMessage(String text) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty || _readOnly) return;

    final userMsg = ChatMessage(
      id: 'user-${DateTime.now().microsecondsSinceEpoch}',
      text: trimmedText,
      isUser: true,
      timestamp: DateTime.now(),
      isTyping: false,
    );

    setState(() {
      _messages.add(userMsg);
      _isAiTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    await _saveMessageToHistory(userMsg, firstMessage: trimmedText);

    String responseText;
    try {
      debugPrint('[ChatbotScreen] Sending message to GeminiChatService...');
      responseText = await _geminiChatService.sendMessage(trimmedText);
      debugPrint('[ChatbotScreen] Response received: ${responseText.length} chars');
    } catch (e) {
      debugPrint('[ChatbotScreen] Error during sendMessage: $e');
      responseText = "⚠️ Error communicating with AI: ${e.toString()}";
    } finally {
      if (mounted) {
        setState(() {
          _isAiTyping = false;
        });
      }
    }

    if (!mounted) return;

    final aiMsg = ChatMessage(
      id: 'ai-${DateTime.now().microsecondsSinceEpoch}',
      text: responseText,
      isUser: false,
      timestamp: DateTime.now(),
      isTyping: false,
    );

    setState(() {
      _messages.add(aiMsg);
    });

    await _saveMessageToHistory(aiMsg);
    _scrollToBottom();
  }

  Future<void> _saveMessageToHistory(
    ChatMessage message, {
    String? firstMessage,
  }) async {
    try {
      if (_isNewSession) {
        _currentSessionId = await _chatRepository.createSession(
          firstMessage ?? message.text,
        ).timeout(const Duration(seconds: 1));
        _isNewSession = false;
      }

      final sessionId = _currentSessionId;
      if (sessionId == null) {
        return;
      }

      await _chatRepository.saveMessage(
        sessionId: sessionId,
        message: message,
      ).timeout(const Duration(seconds: 1));
      
      await _chatRepository.updateSession(sessionId).timeout(const Duration(seconds: 1));
    } on ChatRepositoryException catch (e) {
      debugPrint('[ChatbotScreen] Chat history save failed: ${e.message}');
      _showStorageSnackBar(e.message);
    } catch (e) {
      debugPrint('[ChatbotScreen] Chat history save failed: $e');
      _showStorageSnackBar('Chat is working, but history was not saved.');
    }
  }

  void _startNewConversation() {
    _geminiChatService.resetChat();
    setState(() {
      _messages.clear();
      _isAiTyping = false;
      _readOnly = false;
      _currentSessionId = null;
      _isNewSession = true;
    });
  }

  void _continuePastConversation() {
    setState(() {
      _readOnly = false;
      _isNewSession = _currentSessionId == null;
    });
  }

  void _showStorageSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              ChatbotScreen.appBarTitle,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              ChatbotScreen.appBarSubtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.85),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Chat History',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatHistoryScreen(
                    languageName: widget.languageName,
                    chatRepository: _chatRepository,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'New conversation',
            onPressed: _startNewConversation,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_readOnly) _ReadOnlyBanner(onContinue: _continuePastConversation),
          Expanded(
            child: Container(
              color: const Color(
                0xFFF1F5F9,
              ), // Light slate grey background for chat area
              child: _messages.isEmpty
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 32),
                          const ChatWelcomeCard(
                            title: ChatbotScreen.welcomeTitle,
                            subtitle: ChatbotScreen.welcomeSubtitle,
                          ),
                          const SizedBox(height: 24),
                          SuggestionChipRow(onTapSuggestion: _sendMessage),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: _messages.length + (_isAiTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length && _isAiTyping) {
                          return const TypingIndicator();
                        }

                        final message = _messages[index];
                        final timeString =
                            "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}";

                        if (message.isUser) {
                          return UserMessageBubble(
                            message: message.text,
                            timeString: timeString,
                          );
                        } else {
                          // Pass showIcon: true if it is the first AI message in a potential block or globally
                          final showIcon =
                              index == 0 || _messages[index - 1].isUser;
                          return AiMessageBubble(
                            message: message.text,
                            timeString: timeString,
                            showIcon: showIcon,
                          );
                        }
                      },
                    ),
            ),
          ),
          if (!_readOnly)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          maxLines: 4,
                          minLines: 1,
                          textInputAction: TextInputAction.send,
                          onSubmitted: _sendMessage,
                          decoration: const InputDecoration(
                            hintText: ChatbotScreen.inputHint,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            fillColor: Colors.transparent,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _isTextEmpty
                            ? null
                            : () => _sendMessage(_messageController.text),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: _isTextEmpty
                              ? Colors.grey.shade300
                              : primaryColor,
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReadOnlyBanner extends StatelessWidget {
  const _ReadOnlyBanner({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      color: primaryColor.withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Icon(Icons.menu_book_rounded, color: primaryColor),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Viewing past conversation',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF12342F),
                ),
              ),
            ),
            TextButton(
              onPressed: onContinue,
              child: const Text('Continue Chat'),
            ),
          ],
        ),
      ),
    );
  }
}
