import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../controllers/splash_controller.dart';

/// Splash screen - واجهة البداية نظيفة بدون زر وبدون شريط تقدم
class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 3),
              // الشعار المتحرك - خلفية زرقاء بدون توهج
              const _AnimatedLogo(),
              const SizedBox(height: 24),
              // العنوان الرئيسي
              _FadeSlideIn(
                delay: const Duration(milliseconds: 500),
                child: Text('app_name'.tr, style: AppTextStyles.splashTitle),
              ),
              const SizedBox(height: 6),
              // العنوان الفرعي
              _FadeSlideIn(
                delay: const Duration(milliseconds: 650),
                child: Text('app_tagline'.tr, style: AppTextStyles.splashSubtitle),
              ),
              const SizedBox(height: 18),
              // الخط الذهبي المفصول
              _FadeSlideIn(
                delay: const Duration(milliseconds: 780),
                child: Container(
                  width: 72,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: const LinearGradient(colors: AppColors.goldGradient),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              // الوصف العربي
              _FadeSlideIn(
                delay: const Duration(milliseconds: 900),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'app_description'.tr,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.splashTagline,
                  ),
                ),
              ),
              const Spacer(flex: 4),
              // ❌❌❌ شريط التقدم محذوف بالكامل ❌❌❌
            ],
          ),
        ),
      ),
    );
  }
}

// ============ الشعار - خلفية زرقاء بدون توهج ============

class _AnimatedLogo extends StatefulWidget {
  const _AnimatedLogo();

  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: FadeTransition(
        opacity: _fade,
        child: Hero(
          tag: 'app_logo',
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.secondary, width: 1.4),
              // ✅ خلفية زرقاء (نفس لون الخلفية)
              color: AppColors.splashBackground,
              // ❌ لا توهج - boxShadow محذوف
            ),
            padding: const EdgeInsets.all(18),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

// ============ الأنيميشن للنصوص ============

class _FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _FadeSlideIn({required this.child, required this.delay});

  @override
  State<_FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<_FadeSlideIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}