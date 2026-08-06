import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/company_profile_model.dart';
import '../controllers/company_info_controller.dart';

class CompanyInfoView extends GetView<CompanyInfoController> {
  const CompanyInfoView({super.key});

  static const _navy = Color(0xFF002166);
  static const _gold = Color(0xFFCBA158);
  static const _bg = Color(0xFFF4F7FB);
  static const _fieldBg = Color(0xFFF5F5F5);
  static const _divider = Color(0xFFE8EEF5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.profile.value == null) {
                return const Center(
                  child: CircularProgressIndicator(color: _navy),
                );
              }

              final error = controller.errorMessage.value;
              if (error != null && controller.profile.value == null) {
                return _buildError(error);
              }

              final data = controller.profile.value;
              if (data == null) {
                return const SizedBox.shrink();
              }

              return RefreshIndicator(
                color: _navy,
                onRefresh: controller.loadProfile,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    _buildIdentityCard(data),
                    const SizedBox(height: 14),
                    _buildAboutCard(data),
                    const SizedBox(height: 14),
                    _buildContactCard(data),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Container(
      width: double.infinity,
      color: _navy,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
          child: Row(
            children: [
              _backButton(isRtl: isRtl),
              Expanded(
                child: Text(
                  'company_info_title'.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _gold,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton({required bool isRtl}) {
    return InkWell(
      onTap: () => Get.back(),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isRtl
              ? Icons.arrow_forward_ios_rounded
              : Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildIdentityCard(CompanyProfileModel data) {
    return _card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLogo(data.logoUrl),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _navy,
                    height: 1.35,
                  ),
                ),
                if ((data.tagline ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    data.tagline!,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(String? logoUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 64,
        height: 64,
        color: _navy,
        child: logoUrl != null && logoUrl.isNotEmpty
            ? Image.network(
                logoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _logoPlaceholder(),
              )
            : _logoPlaceholder(),
      ),
    );
  }

  Widget _logoPlaceholder() {
    return const Center(
      child: Icon(Icons.apartment_rounded, color: _gold, size: 30),
    );
  }

  Widget _buildAboutCard(CompanyProfileModel data) {
    final about = (data.about ?? '').trim();
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'company_about_title'.tr,
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 1, color: _divider),
          const SizedBox(height: 12),
          if (about.isEmpty)
            Text(
              '—',
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            )
          else
            _buildAboutText(about, data.name),
        ],
      ),
    );
  }

  Widget _buildAboutText(String about, String companyName) {
    final baseStyle = GoogleFonts.cairo(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Colors.grey.shade700,
      height: 1.7,
    );
    final boldStyle = GoogleFonts.cairo(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: _navy,
      height: 1.7,
    );

    // Bold short name fragments when present (e.g. "خبرات لينك")
    final highlight = _extractHighlightName(companyName);
    if (highlight == null || !about.contains(highlight)) {
      return Text(about, style: baseStyle);
    }

    final parts = about.split(highlight);
    final spans = <TextSpan>[];
    for (var i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(TextSpan(text: parts[i], style: baseStyle));
      }
      if (i < parts.length - 1) {
        spans.add(TextSpan(text: highlight, style: boldStyle));
      }
    }
    return Text.rich(TextSpan(children: spans));
  }

  String? _extractHighlightName(String fullName) {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return null;
    // Prefer a short distinctive phrase from Arabic names.
    if (trimmed.contains('خبرات لينك')) return 'خبرات لينك';
    if (trimmed.contains('Khibrat')) {
      final match = RegExp(r'Khibrat\s+\w+', caseSensitive: false)
          .firstMatch(trimmed);
      if (match != null) return match.group(0);
    }
    final words = trimmed.split(RegExp(r'\s+'));
    if (words.length >= 2) return '${words[0]} ${words[1]}';
    return trimmed;
  }

  Widget _buildContactCard(CompanyProfileModel data) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'company_contact_title'.tr,
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 1, color: _divider),
          const SizedBox(height: 12),
          _contactRow(
            icon: Icons.location_on_rounded,
            text: data.address,
          ),
          const SizedBox(height: 10),
          _contactRow(
            icon: Icons.phone_rounded,
            text: data.phone,
          ),
          const SizedBox(height: 10),
          _contactRow(
            icon: Icons.email_rounded,
            text: data.email,
          ),
        ],
      ),
    );
  }

  Widget _contactRow({required IconData icon, required String? text}) {
    final value = (text ?? '').trim().isEmpty ? '—' : text!.trim();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: _gold, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _navy,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.isNotEmpty ? message : 'company_info_load_error'.tr,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: controller.loadProfile,
              child: Text(
                'company_info_retry'.tr,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w700,
                  color: _navy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
