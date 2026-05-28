import 'package:flutter/material.dart';

import '../domain/chat_message.dart';
import 'widgets/chat_message_bubble.dart';

class AiChatbotScreen extends StatefulWidget {
  const AiChatbotScreen({
    super.key,
    required this.languageName,
    this.showAppBar = false,
  });

  final String languageName;
  final bool showAppBar;

  @override
  State<AiChatbotScreen> createState() => _AiChatbotScreenState();
}

class _AiChatbotScreenState extends State<AiChatbotScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  late final _ChatbotCopy _copy;

  @override
  void initState() {
    super.initState();
    _copy = _ChatbotCopy(widget.languageName);
    _messages.add(
      ChatMessage(
        id: 'welcome',
        text: _copy.welcomeMessage,
        isUser: false,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? quickMessage]) {
    final text = (quickMessage ?? _messageController.text).trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          text: text,
          isUser: true,
          createdAt: DateTime.now(),
        ),
      );
      _messages.add(
        ChatMessage(
          id: '${DateTime.now().microsecondsSinceEpoch}-ai',
          text: _copy.placeholderResponse(text),
          isUser: false,
          createdAt: DateTime.now(),
        ),
      );
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        _ChatbotHeader(copy: _copy),
        _QuickSymptomChips(symptoms: _copy.symptoms, onSelected: _sendMessage),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];

              return ChatMessageBubble(
                message: message.text,
                isUser: message.isUser,
              );
            },
          ),
        ),
        _MessageInputBar(
          controller: _messageController,
          hintText: _copy.inputHint,
          onSend: () => _sendMessage(),
        ),
      ],
    );

    if (!widget.showAppBar) {
      return SafeArea(child: content);
    }

    return Scaffold(
      appBar: AppBar(title: Text(_copy.title)),
      body: SafeArea(child: content),
    );
  }
}

class _ChatbotHeader extends StatelessWidget {
  const _ChatbotHeader({required this.copy});

  final _ChatbotCopy copy;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.health_and_safety_outlined,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    copy.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    copy.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.84),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickSymptomChips extends StatelessWidget {
  const _QuickSymptomChips({required this.symptoms, required this.onSelected});

  final List<String> symptoms;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: symptoms.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final symptom = symptoms[index];

          return ActionChip(
            avatar: const Icon(Icons.add_circle_outline, size: 18),
            label: Text(symptom),
            onPressed: () => onSelected(symptom),
          );
        },
      ),
    );
  }
}

class _MessageInputBar extends StatelessWidget {
  const _MessageInputBar({
    required this.controller,
    required this.hintText,
    required this.onSend,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8E5))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: const Icon(Icons.spa_outlined),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 52,
            height: 52,
            child: FilledButton(
              onPressed: onSend,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: colorScheme.primary,
              ),
              child: const Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatbotCopy {
  const _ChatbotCopy(this.languageName);

  final String languageName;

  bool get isKannada => languageName.toLowerCase() == 'kannada';

  String get title => 'AI Chatbot';
  String get subtitle => isKannada
      ? 'Kannada wellness guidance structure is ready.'
      : 'Ask about common symptoms and get safe wellness suggestions.';
  String get inputHint => isKannada
      ? 'Type your health question...'
      : 'Type your health question...';
  String get welcomeMessage => isKannada
      ? 'Hello. I can help with simple wellness guidance in a Kannada-ready flow. For serious symptoms, contact a doctor.'
      : 'Hi. I can help with simple wellness guidance. For serious or persistent symptoms, please contact a doctor.';

  List<String> get symptoms => const [
    'Headache',
    'Stress',
    'Anxiety',
    'Poor Sleep',
    'Cold',
    'Digestion',
  ];

  String placeholderResponse(String message) {
    final symptom = message.toLowerCase();

    if (symptom.contains('headache')) {
      return 'For headache: drink water, rest your eyes, try slow breathing, and avoid screen strain. Seek medical help if pain is severe, sudden, or repeated.';
    }
    if (symptom.contains('stress') || symptom.contains('anxiety')) {
      return 'For stress or anxiety: try 4-4-6 breathing, a short walk, and 5 minutes of meditation. Talk to a trusted person or doctor if it feels intense.';
    }
    if (symptom.contains('sleep')) {
      return 'For poor sleep: keep a fixed sleep time, reduce phone use before bed, try light stretching, and avoid caffeine late in the day.';
    }
    if (symptom.contains('cold')) {
      return 'For cold: rest, drink warm fluids, use steam carefully, and monitor fever. Consult a doctor if breathing is difficult or fever is high.';
    }
    if (symptom.contains('digestion')) {
      return 'For digestion: eat light food, drink warm water, walk gently after meals, and avoid oily foods. Get medical advice for severe pain or vomiting.';
    }

    return 'This is a temporary HealWise AI response. I can suggest safe lifestyle ideas like hydration, rest, breathing, yoga, and doctor consultation when symptoms are serious.';
  }
}
