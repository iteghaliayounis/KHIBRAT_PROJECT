/// Base API configuration. Update [baseUrl] to point to the real
/// backend environment (staging / production) as needed.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'http://192.168.1.101:8000'; // TODO: set real base URL

  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String resendOtp = '/api/auth/resend-otp';

  // Company profile
  static const String companyProfile = '/api/company/profile';

  // Company policies & holidays
  static const String companyPolicies = '/api/employee/company-policies';
  static const String companyHolidays = '/api/employee/company-holidays';

  // Evaluations (My Evaluations feature)
  // GET  myReviews                          -> list + counters for the current user
  // GET  myReviews?status=pending|completed -> filtered list
  // GET  myReviewDetail(id)                 -> single review incl. questions
  // POST submitReview(id)                   -> submit answers for a review
  static const String myReviews = '/api/evaluations/my-reviews';
  static String myReviewDetail(dynamic reviewId) => '$myReviews/$reviewId';
  static String submitReview(dynamic reviewId) => '$myReviews/$reviewId/submit';

  // Employee Leaves
  static const String leaveTypes = '/api/employee/leaves/types';
  static const String leaveDashboard = '/api/employee/leaves/dashboard';
  static const String leaveApply = '/api/employee/leaves/apply';

  static const String overtimePreview = '/api/employee/overtime/preview';
  static const String overtimeApply = '/api/employee/overtime/apply';
  static const String overtimeList = '/api/employee/overtime';

  static const String profilePreview = '/api/profile';
  static const String profileUpdate = '/api/profile';
  static const String profileDocuments = '/api/profile/documents';

  // Attendance
  static const String attendanceDashboard =
      '/api/employee/attendance/dashboard';
  static const String attendanceCheckIn = '/api/employee/attendance/check-in';
  static const String attendanceCheckOut = '/api/employee/attendance/check-out';

  // Salary & Advances
  static const String advancesEligibility =
      '/api/employee/advances/eligibility';
  static const String advancesApply = '/api/employee/advances/apply';
  static const String advancesList = '/api/employee/advances';
  static const String employeeSalaries = '/api/employee/salaries';
  static String employeeSalaryDetail(String id) => '$employeeSalaries/$id';

  // Employee AI Assistant (Gemini is called by Laravel only)
  static const String assistantSessions = '/api/employee/assistant/sessions';
  static String assistantSession(String sessionId) =>
      '$assistantSessions/$sessionId';
  static String assistantSessionMessages(String sessionId) =>
      '$assistantSessions/$sessionId/messages';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration assistantReceiveTimeout = Duration(seconds: 90);
}
