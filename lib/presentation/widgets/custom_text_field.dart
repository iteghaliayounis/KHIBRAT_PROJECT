import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FocusScope(
          child: Focus(
            onFocusChange: (focus) => setState(() => _isFocused = focus),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20), // إنحناء أكثر نعومة
                border: Border.all(
                  color: widget.errorText != null
                      ? Colors.red.shade400
                      : (_isFocused ? const Color(0xFFCBA158) : const Color(0xFFF1E6D3)),
                  width: _isFocused ? 1.6 : 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    // وهج ذهبي ناعم ودافئ متطابق مع التصميم
                    color: const Color(0xFFCBA158).withOpacity(_isFocused ? 0.15 : 0.07),
                    blurRadius: _isFocused ? 18 : 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: widget.controller,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                onChanged: widget.onChanged,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w500, // خط ناعم وليس bold
                  color: const Color(0xFF002166),
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: Icon(
                    widget.prefixIcon,
                    color: const Color(0xFFCBA158), // لون ذهبي للأيقونات
                    size: 20,
                  ),
                  suffixIcon: widget.suffixIcon,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8),
            child: Text(
              widget.errorText!,
              style: GoogleFonts.cairo(fontSize: 11, color: Colors.red.shade600),
            ),
          ),
        ],
      ],
    );
  }
}