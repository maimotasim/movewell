import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movewell/core/theme/colors.dart';
import 'package:movewell/core/widgets/header_background.dart';
import 'package:movewell/core/models/mock_data.dart';

class DoctorChatScreen extends StatefulWidget {
  const DoctorChatScreen({super.key});

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      MockData.doctorChatMessages.add(ChatMessageModel(text: text, isMe: true));
      _messageController.clear();
    });

    _scrollToBottom();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      setState(() {
        MockData.doctorChatMessages.add(
          ChatMessageModel(
            text: "${MockData.primaryDoctor.name} is currently with a patient, but we have received your message and will review it shortly. Thank you!",
            isMe: false,
          ),
        );
      });
      _scrollToBottom();
    });
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
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const HeaderBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeaderTopArea(context),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chat directly with',
                                style: GoogleFonts.leagueSpartan(
                                  fontSize: 14,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                MockData.primaryDoctor.name,
                                style: GoogleFonts.leagueSpartan(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            itemCount: MockData.doctorChatMessages.length,
                            itemBuilder: (context, index) {
                              final msg = MockData.doctorChatMessages[index];
                              return _buildMessageBubble(msg.text, isMe: msg.isMe);
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16) +
                              EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, -4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: AppColors.inputBg,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: TextField(
                                    controller: _messageController,
                                    decoration: InputDecoration(
                                      hintText: 'Message ${MockData.primaryDoctor.name}...',
                                      hintStyle: GoogleFonts.leagueSpartan(
                                        color: AppColors.textHint,
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: GoogleFonts.leagueSpartan(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                    ),
                                    onSubmitted: (_) => _sendMessage(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: _sendMessage,
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, {required bool isMe}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.leagueSpartan(
            color: isMe ? Colors.white : AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderTopArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
