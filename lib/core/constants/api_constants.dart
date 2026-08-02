/// Base API configuration. Update [baseUrl] to point to the real
/// backend environment (staging / production) as needed.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'http://10.187.2.222:8000'; // TODO: set real base URL

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

  // Employee Leaves
  static const String leaveTypes = '/api/employee/leaves/types';
  static const String leaveDashboard = '/api/employee/leaves/dashboard';
  static const String leaveApply = '/api/employee/leaves/apply';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
