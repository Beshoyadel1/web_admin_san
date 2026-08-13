class ToggleProviderApprovalStatusRequest {
  final int providerId;
  final bool isActive;
  final String lang;

  const ToggleProviderApprovalStatusRequest({
    required this.providerId,
    required this.isActive,
    this.lang = 'ar',
  });

  Map<String, dynamic> toJson() {
    return {
      'providerId': providerId,
      'isActive': isActive,
      'lang': lang,
    };
  }
}