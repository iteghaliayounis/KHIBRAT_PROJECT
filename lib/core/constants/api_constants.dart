/// Base API configuration. Update [baseUrl] to point to the real
/// backend environment (staging / production) as needed.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://192.168.1.105:8000'; // TODO: set real base URL

  static const String login = '/api/auth/login';
  static const String resendOtp = '/api/auth/resend-otp';

  // Evaluations (My Evaluations feature)
  // GET  myReviews                          -> list + counters for the current user
  // GET  myReviews?status=pending|completed -> filtered list
  // GET  myReviewDetail(id)                 -> single review incl. questions
  // POST submitReview(id)                   -> submit answers for a review
  static const String myReviews = '/api/evaluations/my-reviews';
  static String myReviewDetail(dynamic reviewId) => '$myReviews/$reviewId';
  static String submitReview(dynamic reviewId) => '$myReviews/$reviewId/submit';

  // Attendance
  static const String attendanceDashboard = '/api/employee/attendance/dashboard';
  static const String attendanceCheckIn = '/api/employee/attendance/check-in';
  static const String attendanceCheckOut = '/api/employee/attendance/check-out';

  // Salary & Advances
  static const String advancesEligibility = '/api/employee/advances/eligibility';
  static const String advancesApply = '/api/employee/advances/apply';
  static const String advancesList = '/api/employee/advances';
  static const String employeeSalaries = '/api/employee/salaries';
  static String employeeSalaryDetail(String id) => '$employeeSalaries/$id';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
