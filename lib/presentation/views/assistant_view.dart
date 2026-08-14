import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/assistant_controller.dart';
import '../widgets/assistant/assistant_effects.dart';
import '../widgets/assistant/assistant_palette.dart';
import '../widgets/assistant/assistant_sessions_drawer.dart';
import '../widgets/assistant/cyber_dust_canvas.dart';
import '../widgets/assistant/neural_orb.dart';

class AssistantView extends GetView<AssistantController> {
  const AssistantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dark = controller.isDarkMode.value;
      return Scaffold(
        backgroundColor: AssistantPalette.background(dark),
        resizeToAvoidBottomInset: true,
        body: PopScope(
          canPop: !controller.isDrawerOpen.value,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) controller.closeDrawer();
          },
          child: Stack(
            children: [
              CyberDustCanvas(isDark: dark),
              SafeArea(
                child: Column(
                  children: [
                    _AssistantHeader(controller: controller, isDark: dark),
                    Expanded(child: _buildBody(dark)),
                    if (controller.showWelcome &&
                        !controller.isLoadingSession.value)
                      _SuggestionChips(controller: controller, isDark: dark),
                    _ChatInputBar(controller: controller, isDark: dark),
                  ],
                ),
              ),
              AssistantSessionsDrawer(controller: controller, isDark: dark),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBody(bool dark) {
    controller.messages.length;
    controller.isSending.value;
    if (controller.isLoadingSession.value) {
      return const Center(
        child: CircularProgressIndicator(color: AssistantPalette.navy),
      );
    }
    if (controller.showWelcome) {
      return _WelcomeBody(controller: controller, isDark: dark);
    }
    return _ChatBody(controller: controller, isDark: dark);
  }
}

class _AssistantHeader extends StatelessWidget {
  final AssistantController controller;
  final bool isDark;

  const _AssistantHeader({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
      child: Row(
        children: [
          _roundIcon(
            icon: Icons.menu_rounded,
            onTap: controller.openDrawer,
            isDark: isDark,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.ltr,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        'ai_buddy'.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                          color: AssistantPalette.text(isDark),
                          height: 1.2,
                        ),
                      ),
                      Text(
                        'ai_connected'.tr,
                        style: GoogleFonts.cairo(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AssistantPalette.connected,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                NeuralOrb(
                  size: 38,
                  mini: true,
                  isThinking: controller.isThinking,
                ),
              ],
            ),
          ),
          _roundIcon(
            icon: isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
            onTap: controller.toggleDarkMode,
            isDark: isDark,
            color: const Color(0xFFB8860B),
          ),
        ],
      ),
    );
  }

  Widget _roundIcon({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    Color? color,
  }) {
    return Material(
      color: AssistantPalette.headerButton(isDark),
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black26,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            size: 20,
            color: color ??
                (isDark ? Colors.white : AssistantPalette.navyDeep),
          ),
        ),
      ),
    );
  }
}

class _WelcomeBody extends StatelessWidget {
  final AssistantController controller;
  final bool isDark;

  const _WelcomeBody({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final name = controller.greetingName;
    final chip = name.isEmpty
        ? 'ai_welcome_chip_generic'.tr
        : 'ai_welcome_chip'.trParams({'name': name});

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        children: [
          const SizedBox(height: 8),
          NeuralOrb(
            size: 230,
            isThinking: controller.isThinking,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E3A5F)
                  : AssistantPalette.chipBlue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('👋', style: GoogleFonts.cairo(fontSize: 14)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    chip,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AssistantPalette.text(isDark),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AssistantPalette.connected,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'ai_help_now'.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AssistantPalette.text(isDark),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ai_ready_subtitle'.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AssistantPalette.muted(isDark),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChips extends StatelessWidget {
  final AssistantController controller;
  final bool isDark;

  const _SuggestionChips({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('ai_suggestion_leave'.tr, Icons.bar_chart_rounded, const Color(0xFF42A5F5)),
      ('ai_suggestion_exit'.tr, Icons.badge_outlined, const Color(0xFF8D6E63)),
      ('ai_suggestion_salary'.tr, Icons.payments_rounded, const Color(0xFF43A047)),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: Material(
                color: AssistantPalette.surface(isDark),
                elevation: 3,
                shadowColor: Colors.black12,
                borderRadius: BorderRadius.circular(22),
                child: InkWell(
                  onTap: controller.isSending.value
                      ? null
                      : () => controller.sendSuggestion(item.$1),
                  borderRadius: BorderRadius.circular(22),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(item.$2, size: 16, color: item.$3),
                        const SizedBox(width: 6),
                        Text(
                          item.$1,
                          style: GoogleFonts.cairo(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AssistantPalette.text(isDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ChatBody extends StatelessWidget {
  final AssistantController controller;
  final bool isDark;

  const _ChatBody({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = controller.messages;
    return ListView.builder(
      controller: controller.chatScrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
      itemCount: items.length + (controller.isSending.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          return const MessageBubbleIn(
            key: ValueKey('typing-indicator'),
            child: _TypingRow(),
          );
        }
        final message = items[index];
        final prevIsUser = index > 0 && items[index - 1].isUser;
        return Padding(
          key: ValueKey(message.id),
          padding: const EdgeInsets.only(bottom: 12),
          child: MessageBubbleIn(
            child: message.isUser
                ? _UserBubble(text: message.message)
                : _AssistantBubble(
                    text: message.message,
                    isDark: isDark,
                    showHeader: prevIsUser,
                  ),
          ),
        );
      },
    );
  }
}

class _UserBubble extends StatelessWidget {
  final String text;

  const _UserBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AssistantPalette.navy,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AssistantPalette.navy.withOpacity(0.22),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.cairo(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}

class _AssistantBubble extends StatelessWidget {
  final String text;
  final bool isDark;
  final bool showHeader;

  const _AssistantBubble({
    required this.text,
    required this.isDark,
    required this.showHeader,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: LuxuryGradientBorder(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.78,
                ),
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                decoration: BoxDecoration(
                  color: AssistantPalette.bubbleAssistant(isDark),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader) ...[
                      Text(
                        'ai_analyzed_header'.tr,
                        style: GoogleFonts.cairo(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: AssistantPalette.text(isDark),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    Text(
                      text,
                      style: GoogleFonts.cairo(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: AssistantPalette.text(isDark),
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AssistantPalette.navy,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingRow extends StatelessWidget {
  const _TypingRow();

  @override
  Widget build(BuildContext context) {
    final dark = Get.find<AssistantController>().isDarkMode.value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            LuxuryGradientBorder(
              radius: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AssistantPalette.bubbleAssistant(dark),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SoundWavesIndicator(isDark: dark),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AssistantPalette.navy,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final AssistantController controller;
  final bool isDark;

  const _ChatInputBar({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final canSend = !controller.isSending.value;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 6, 12, 6),
        decoration: BoxDecoration(
          color: AssistantPalette.inputFill(isDark),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.inputController,
                focusNode: controller.inputFocusNode,
                enabled: canSend,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) {
                  if (canSend) controller.sendMessage();
                },
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: AssistantPalette.text(isDark),
                ),
                decoration: InputDecoration(
                  hintText: 'ai_input_hint'.tr,
                  hintStyle: GoogleFonts.cairo(
                    fontSize: 13.5,
                    color: AssistantPalette.muted(isDark),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            SendPulseButton(
              enabled: canSend,
              loading: controller.isSending.value,
              onPressed: controller.sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
