import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileUploadBox extends StatelessWidget {
  final String label;
  final IconData icon;
  final File? file;
  final VoidCallback onTap;
  final bool required;

  const ProfileUploadBox({
    super.key,
    required this.label,
    required this.icon,
    required this.file,
    required this.onTap,
    this.required = false,
  });

  bool get _isArabic => Get.locale?.languageCode == 'ar';

  @override
  Widget build(BuildContext context) {
    final filled = file != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: _isArabic ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            required ? '$label *' : '$label (${'profile_optional'.tr})',
            style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 26),
            decoration: BoxDecoration(
              color: filled ? const Color(0xFFECFDF5) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: filled
                    ? const Color(0xFF34D399)
                    : const Color(0xFFCBD5E1),
                width: 1.6,
                style: filled ? BorderStyle.solid : BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  filled ? Icons.check_circle : icon,
                  size: 26,
                  color: filled
                      ? const Color(0xFF10B981)
                      : const Color(0xFF835C21),
                ),
                const SizedBox(height: 8),
                Text(
                  filled
                      ? 'profile_file_attached'.trParams({
                          'filename': file!.path
                              .split(Platform.pathSeparator)
                              .last,
                        })
                      : 'profile_tap_to_choose'.trParams({'label': label}),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: filled
                        ? const Color(0xFF059669)
                        : const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 2),
                if (!filled)
                  Text(
                    'profile_file_formats_hint'.tr,
                    style: GoogleFonts.cairo(
                      fontSize: 10,
                      color: Colors.grey.shade400,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
