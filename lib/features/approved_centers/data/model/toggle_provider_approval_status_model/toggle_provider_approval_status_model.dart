class ToggleProviderApprovalStatusModel {
  final bool? success;
  final String? message;

  const ToggleProviderApprovalStatusModel({
    this.success,
    this.message,
  });

  factory ToggleProviderApprovalStatusModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ToggleProviderApprovalStatusModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}