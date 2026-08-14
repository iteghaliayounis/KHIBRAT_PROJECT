import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../data/models/assistant_models.dart';
import '../../controllers/assistant_controller.dart';
import 'assistant_palette.dart';

class AssistantSessionsDrawer extends StatelessWidget {
  final AssistantController controller;
  final bool isDark;

  const AssistantSessionsDrawer({
    super.key,
    required this.controller,
    required this.isDark,
  });

  static const _slideCurve = Cubic(0.16, 1, 0.3, 1);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.86;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Obx(() {
      final open = controller.isDrawerOpen.value;
      return IgnorePointer(
        ignoring: !open,
        child: Stack(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 320),
              opacity: open ? 1 : 0,
              child: GestureDetector(
                onTap: controller.closeDrawer,
                child: Container(color: AssistantPalette.drawerScrim),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 420),
              curve: _slideCurve,
              top: 0,
              bottom: 0,
              width: width,
              right: isRtl ? (open ? 0 : -width) : null,
              left: isRtl ? null : (open ? 0 : -width),
              child: Material(
                color: AssistantPalette.surface(isDark),
                elevation: 16,
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: const Radius.circular(28),
                  bottomEnd: const Radius.circular(28),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: _iconButton(
                            icon: Icons.close_rounded,
                            onTap: controller.closeDrawer,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ai_history_title'.tr,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AssistantPalette.text(isDark),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: controller.isCreatingSession.value
                                ? null
                                : controller.createNewSession,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AssistantPalette.navy,
                              disabledBackgroundColor:
                                  AssistantPalette.navy.withOpacity(0.6),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: controller.isCreatingSession.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    '+ ${'ai_new_conversation'.tr}',
                                    style: GoogleFonts.cairo(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'ai_previous_chats'.tr,
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AssistantPalette.muted(isDark),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(child: _buildSessionsList()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSessionsList() {
    if (controller.isLoadingSessions.value && controller.sessions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AssistantPalette.navy),
      );
    }

    if (controller.sessions.isEmpty) {
      return Center(
        child: Text(
          'ai_no_sessions'.tr,
          style: GoogleFonts.cairo(
            fontSize: 13,
            color: AssistantPalette.muted(isDark),
          ),
        ),
      );
    }

    return ListView.separated(
      controller: controller.sessionsScrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: controller.sessions.length +
          (controller.isLoadingMoreSessions.value ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index >= controller.sessions.length) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        final session = controller.sessions[index];
        return _SessionTile(
          session: session,
          isDark: isDark,
          selected: controller.currentSession.value?.id == session.id,
          removing: controller.isSessionRemoving(session.id),
          onOpen: () => controller.openSession(session.id),
          onDelete: () => _confirmDelete(context, session.id),
        );
      },
    );
  }

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF24344F) : const Color(0xFFF1F3F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: AssistantPalette.iconMuted(isDark)),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String sessionId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AssistantPalette.surface(isDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'ai_delete_title'.tr,
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.w800,
            color: AssistantPalette.text(isDark),
          ),
        ),
        content: Text(
          'ai_delete_confirm'.tr,
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: AssistantPalette.muted(isDark),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'ai_cancel'.tr,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.w700,
                color: AssistantPalette.muted(isDark),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'ai_delete'.tr,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.w800,
                color: const Color(0xFFE53935),
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.deleteSession(sessionId);
    }
  }
}

class _SessionTile extends StatelessWidget {
  final AssistantSessionModel session;
  final bool isDark;
  final bool selected;
  final bool removing;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  const _SessionTile({
    required this.session,
    required this.isDark,
    required this.selected,
    required this.removing,
    required this.onOpen,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final title = session.displayTitle.trim().isEmpty
        ? 'ai_untitled_session'.tr
        : session.displayTitle;
    final locale = Get.locale?.languageCode ?? 'ar';
    final date = session.updatedAt ?? session.createdAt;
    final dateLabel = date == null
        ? ''
        : DateFormat.yMMMd(locale).add_jm().format(date.toLocal());

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: removing ? 1 : 0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: 1 - value,
          child: Transform.translate(
            offset: Offset(value * 80, 0),
            child: child,
          ),
        );
      },
      child: Material(
        color: selected
            ? AssistantPalette.sessionSelected(isDark)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: selected
                  ? Border.all(color: const Color(0xFF90CAF9), width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 18,
                  color: AssistantPalette.navy.withOpacity(isDark ? 0.8 : 1),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AssistantPalette.text(isDark),
                        ),
                      ),
                      if (dateLabel.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          dateLabel,
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: AssistantPalette.muted(isDark),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: AssistantPalette.muted(isDark),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
