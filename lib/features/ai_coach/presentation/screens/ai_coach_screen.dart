import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/ai_coach/data/ai_chat_message.dart';
import 'package:fiteo_myapp/features/ai_coach/data/ai_chat_repository.dart';
import 'package:fiteo_myapp/features/ai_coach/data/ai_chat_service.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/ai_chat/ai_message_input.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/ai_chat/ai_welcome_view.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/ai_chat/ai_bot_bubble.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/ai_chat/ai_user_bubble.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/ai_chat/ai_typing_bubble.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/widgets/shared/ai_mode_switch.dart';
import 'package:fiteo_myapp/features/ai_coach/presentation/screens/cook_ai_screen.dart';

class AiCoachScreen extends StatefulWidget {
  const AiCoachScreen({super.key});

  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Set<String> hiddenMessageIds = {};
  final AiChatRepository _chatRepository = AiChatRepository();
  final AiChatService _chatService = AiChatService();

  bool isSending = false;
  bool showWelcomeInsteadOfChat = true;
  bool isCookMode = false;
  String? temporaryErrorMessage;
  int messageCount = 0;

  static const int dailyLimit = 3;

  @override
  void initState() {
    super.initState();
    _loadMessageCount();
  }

  Future<void> _loadMessageCount() async {
    final count = await _chatRepository.getTodayMessageCount();

    if (!mounted) return;

    setState(() {
      messageCount = count;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_scrollController.hasClients) return;

      await Future.delayed(const Duration(milliseconds: 100));

      if (!_scrollController.hasClients) return;

      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    });
  }

  Future<void> _showMessageOptions(AiChatMessage message) async {
    if (message.id == null) return;

    final shouldDelete = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: ListTile(
            leading: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
            ),
            title: const Text(
              'Delete message',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => Navigator.pop(context, true),
          ),
        );
      },
    );

    if (shouldDelete == true) {
      setState(() {
        hiddenMessageIds.add(message.id!);
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();

    if (text.isEmpty || isSending) return;

    if (messageCount >= dailyLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Daily AI message limit reached.'),
        ),
      );
      return;
    }

    _messageController.clear();

    setState(() {
      isSending = true;
      temporaryErrorMessage = null;
      showWelcomeInsteadOfChat = false;
    });

    await _chatRepository.saveMessage(
      role: 'user',
      message: text,
    );

    final userPreferences = await _chatRepository.getUserPreferences();
    final dailySummary = await _chatRepository.getTodaySummary();
    final last7Summaries = await _chatRepository.getLast7DailySummaries();
    final recentMessages = await _chatRepository.getRecentMessages(limit: 6);

    final reply = await _chatService.sendMessage(
      message: text,
      userPreferences: userPreferences,
      dailySummary: dailySummary,
      last7Summaries: last7Summaries,
      recentMessages: recentMessages
          .map((message) => message.toJson())
          .toList(),
    );

    if (reply != null) {
      await _chatRepository.saveMessage(
        role: 'assistant',
        message: reply,
      );

      await _chatRepository.incrementTodayMessageCount();
    } else {
      temporaryErrorMessage =
      'Sorry, I could not respond right now. Please try again later.';
    }

    if (!mounted) return;

    setState(() {
      if (reply != null) {
        messageCount++;
      }

      isSending = false;
    });
  }

  void _backToWelcome() {
    setState(() {
      showWelcomeInsteadOfChat = true;
      temporaryErrorMessage = null;
      isSending = false;
      _messageController.clear();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AiChatMessage>>(
      stream: _chatRepository.watchMessages(),
      builder: (context, snapshot) {
        final allMessages = snapshot.data ?? [];

        final messages = allMessages
            .where(
              (message) =>
          message.id == null || !hiddenMessageIds.contains(message.id),
        )
            .toList();

        final hasMessages =
            messages.isNotEmpty && !showWelcomeInsteadOfChat;

        if (hasMessages) {
          _scrollToBottom();
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: isCookMode
                ? CookAiScreen(
              onSwitchToCoach: () {
                setState(() {
                  isCookMode = false;
                });
              },
            )
                : hasMessages
                ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.homeBrown,
                        size: 24,
                      ),
                      onPressed: _backToWelcome,
                    ),
                  ),
                ),

                Expanded(
                  child: _buildChatView(messages),
                ),

                _buildLimitText(),

                AiMessageInput(
                  controller: _messageController,
                  onSend: _sendMessage,
                ),
              ],
            )
                : Stack(
              children: [
                AiWelcomeView(
                  controller: _messageController,
                  onSend: _sendMessage,
                ),

                Positioned(
                  top: 24,
                  right: 28,
                  child: AiModeSwitch(
                    isCookMode: false,
                    onChanged: (_) {
                      setState(() {
                        isCookMode = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLimitText() {
    final remaining = dailyLimit - messageCount;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        remaining > 0
            ? '$remaining AI messages left today'
            : 'Daily AI message limit reached',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildChatView(List<AiChatMessage> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      itemCount: messages.length +
          1 +
          (isSending ? 1 : 0) +
          (temporaryErrorMessage != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AiBotBubble(
                text: 'Hi, I’m Fiteo. Tell me your goal and I’ll guide you.',
              ),
            ),
          );
        }

        final messageIndex = index - 1;

        if (messageIndex >= messages.length) {
          if (isSending) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AiTypingBubble(),
              ),
            );
          }

          if (temporaryErrorMessage != null) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AiBotBubble(text: temporaryErrorMessage!),
              ),
            );
          }
        }

        final message = messages[messageIndex];
        final isUser = message.role == 'user';

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: GestureDetector(
              onLongPress: () => _showMessageOptions(message),
              child: isUser
                  ? AiUserBubble(text: message.text)
                  : AiBotBubble(text: message.text),
            ),
          ),
        );
      },
    );
  }
}