abstract class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const language = '/language';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';
  static const verifyCode = '/verify-code';         // المسار الذي كان ناقصاً
  static const resetPassword = '/reset-password';   // مسار تعيين كلمة المرور الجديدة
  static const changePassword = '/change-password';
  static const home = '/home';

  // Evaluations
  static const myEvaluations = '/my-evaluations';
  static const evaluationDetail = '/evaluation-detail';

  // Attendance
  static const attendance = '/attendance';
  static const attendanceScanner = '/attendance-scanner';

  // Salary & Advances
  static const salaryDashboard = '/salary-dashboard';
}
