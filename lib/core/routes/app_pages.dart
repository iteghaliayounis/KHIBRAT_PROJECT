import 'package:get/get.dart';
import 'package:khibrat_flutter2/presentation/bindings/forgot_password_binding.dart';
import 'package:khibrat_flutter2/presentation/bindings/reset_password_binding.dart';
import 'package:khibrat_flutter2/presentation/bindings/verify_code_binding.dart';
import 'package:khibrat_flutter2/presentation/views/forgot_password_view.dart';
import 'package:khibrat_flutter2/presentation/views/reset_password_view.dart';
import 'package:khibrat_flutter2/presentation/views/verify_code_view.dart';
import '../../presentation/bindings/attendance_binding.dart';
import '../../presentation/bindings/attendance_scanner_binding.dart';
import '../../presentation/bindings/evaluation_binding.dart';
import '../../presentation/bindings/home_binding.dart';
import '../../presentation/bindings/language_binding.dart';
import '../../presentation/bindings/login_binding.dart';
import '../../presentation/bindings/my_evaluations_binding.dart';
import '../../presentation/bindings/onboarding_binding.dart';
import '../../presentation/bindings/salary_binding.dart';
import '../../presentation/bindings/splash_binding.dart';
import '../../presentation/views/attendance/attendance_dashboard_view.dart';
import '../../presentation/views/attendance/attendance_scanner_view.dart';
import '../../presentation/views/evaluation_detail_view.dart';
import '../../presentation/views/home_view.dart';
import '../../presentation/views/language_selection_view.dart';
import '../../presentation/views/login_view.dart';
import '../../presentation/views/my_evaluations_view.dart';
import '../../presentation/views/onboarding_welcome_view.dart';
import '../../presentation/views/salary/salary_dashboard_view.dart';
import '../../presentation/views/splash_view.dart';


import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.language,
      page: () => const LanguageSelectionView(),
      binding: LanguageBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingWelcomeView(),
      binding: OnboardingBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.rightToLeftWithFade,
    ),



    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(), // 👈 هكذا يتم تحضير الـ Controller ولن يظهر خطأ الـ Null أبدًا
    ),
    GetPage(
  name: AppRoutes.verifyCode,
  page: () => const VerifyCodeView(),
  binding: VerifyCodeBinding(),
  transition: Transition.rightToLeftWithFade,
),
GetPage(
  name: AppRoutes.resetPassword,
  page: () => const ResetPasswordView(),
  binding: ResetPasswordBinding(),
  transition: Transition.rightToLeftWithFade,
),
    GetPage(
      name: AppRoutes.myEvaluations,
      page: () => const MyEvaluationsView(),
      binding: MyEvaluationsBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.evaluationDetail,
      page: () => const EvaluationDetailView(),
      binding: EvaluationBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.attendance,
      page: () => const AttendanceDashboardView(),
      binding: AttendanceBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.attendanceScanner,
      page: () => const AttendanceScannerView(),
      binding: AttendanceScannerBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.salaryDashboard,
      page: () => const SalaryDashboardView(),
      binding: SalaryBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
