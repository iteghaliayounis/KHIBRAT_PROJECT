class CompleteFirstLoginResponseModel {
  final bool success;
  final String message;

  CompleteFirstLoginResponseModel({
    required this.success,
    required this.message,
  });

  factory CompleteFirstLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return CompleteFirstLoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}