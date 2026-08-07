import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  int? _hoveredCardIndex;

  @override
  Widget build(BuildContext context) {
    const primaryNavy = Color(0xFF002166);

    // قائمة الخدمات (مترجمة ديناميكياً باستخدام .tr)
    final List<Map<String, dynamic>> services = [
      {
        'title': 'attendance_tracking'.tr,
        'subtitle': 'attendance_subtitle'.tr,
        'icon': Icons.qr_code_scanner_rounded, // 👈 أيقونة الـ QR بدلاً من البصمة
        'color': const Color(0xFF1E88E5),
        'bgColor': const Color(0xFFE3F2FD),
        'route': AppRoutes.attendance,
      },
      {
        'title': 'company_policies'.tr,
        'subtitle': 'policies_subtitle'.tr,
        'icon': Icons.gavel_rounded,
        'color': const Color(0xFFD84315),
        'bgColor': const Color(0xFFFBE9E7),
      },
      {
        'title': 'my_annual_leaves'.tr,
        'subtitle': 'leaves_subtitle'.tr,
        'icon': Icons.calendar_month_rounded,
        'color': const Color(0xFFE91E63),
        'bgColor': const Color(0xFFFCE4EC),
      },
      {
        'title': 'permission_overtime'.tr,
        'subtitle': 'overtime_subtitle'.tr,
        'icon': Icons.more_time_rounded,
        'color': const Color(0xFF8E24AA),
        'bgColor': const Color(0xFFF3E5F5),
      },
      {
        'title': 'payroll_loans'.tr,
        'subtitle': 'payroll_subtitle'.tr,
        'icon': Icons.account_balance_wallet_rounded,
        'color': const Color(0xFF3F51B5),
        'bgColor': const Color(0xFFE8EAF6),
        'route': AppRoutes.salaryDashboard,
      },
      {
        'title': 'company_hr_info'.tr,
        'subtitle': 'hr_info_subtitle'.tr,
        'icon': Icons.business_rounded,
        'color': const Color(0xFF2E7D32),
        'bgColor': const Color(0xFFE8F5E9),
      },
      {
        'title': 'ai_buddy'.tr,
        'subtitle': 'ai_buddy_subtitle'.tr,
        'icon': Icons.smart_toy_rounded,
        'color': const Color(0xFF00897B),
        'bgColor': const Color(0xFFE0F2F1),
      },
      {
        'title': 'evaluations'.tr,
        'subtitle': 'evaluations_subtitle'.tr,
        'icon': Icons.star_rounded,
        'color': const Color(0xFFFF8F00),
        'bgColor': const Color(0xFFFFF8E1),
        'route': AppRoutes.myEvaluations,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 1. القسم العلوي الشخصي (Header)
            _buildHeader(primaryNavy),

            // 🔹 2. شبكة الخدمات (Grid Services)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0, // أبعاد تمنع أي Overflow
                    ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      final isSelected = _hoveredCardIndex == index;

                      return GestureDetector(
                        onTapDown: (_) => setState(() => _hoveredCardIndex = index),
                        onTapUp: (_) => setState(() => _hoveredCardIndex = null),
                        onTapCancel: () => setState(() => _hoveredCardIndex = null),
                        onTap: () {
                          final route = service['route'] as String?;
                          if (route != null) Get.toNamed(route);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? service['color'] as Color
                                  : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? (service['color'] as Color).withOpacity(0.2)
                                    : Colors.black.withOpacity(0.04),
                                blurRadius: isSelected ? 12 : 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: AlignmentDirectional.topEnd, // 👈 محاذاة تناسب RTL و LTR
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: service['bgColor'] as Color,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    service['icon'] as IconData,
                                    color: service['color'] as Color,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service['title'] as String,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w900,
                                      color: service['color'] as Color,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    service['subtitle'] as String,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),

      // 🔹 3. شريط التنقل السفلي المترجم
      bottomNavigationBar: SafeArea(
        child: _buildAnimatedBottomBar(primaryNavy),
      ),
    );
  }

  // 👤 بناء الهيدر العلوي
  Widget _buildHeader(Color primaryColor) {
    const String userName = 'أحمد المحمد';
    const String userRole = 'مهندس برمجيات | سوريا';
    const String? userImageUrl = null;

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر تسجيل الخروج
          InkWell(
            onTap: () {
              Get.offAllNamed('/login');
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          // معلومات المستخدم
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                userName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                userRole,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          // الصورة الشخصية / الاختصار
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white.withOpacity(0.2),
            backgroundImage:
                userImageUrl != null ? NetworkImage(userImageUrl) : null,
            child: userImageUrl == null
                ? const Text(
                    'AM',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  // 🚀 بناء شريط التنقل السفلي (المترجم بالكامل)
  Widget _buildAnimatedBottomBar(Color primaryNavy) {
    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home_rounded, 'label': 'nav_home'.tr},
      {'icon': Icons.person_rounded, 'label': 'nav_account'.tr},
      {'icon': Icons.info_outline_rounded, 'label': 'nav_company'.tr},
      {'icon': Icons.settings_rounded, 'label': 'nav_settings'.tr},
    ];

    return Container(
      height: 68,
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(navItems.length, (index) {
          final isSelected = _selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 14 : 8,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? primaryNavy : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primaryNavy.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    navItems[index]['icon'] as IconData,
                    color: isSelected ? Colors.white : Colors.grey.shade500,
                    size: isSelected ? 22 : 20,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 6),
                    Text(
                      navItems[index]['label'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}