import '../../../../../core/networking/api_link.dart';
import '../../../../../core/networking/network.dart';
import '../../request/send_verification_code_request/send_verification_code_request.dart';

Future<bool> sendVerificationCodeFunction({
  required SendVerificationCodeRequest request,
}) async {
  try {
    final response = await Network.postDataWithBodyAndParams(
      {},
      request.toJson(),
      ApiLink.sendVerificationCode,
    );

    final data = response.data;

    if (data is Map<String, dynamic>) {
      final statusCode = data['statusCode'];

      return statusCode == 201;
    }

    return false;
  } catch (_) {
    return false;
  }
}
