import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/theming/auth_local_storage.dart';
import 'package:web_admin_san/features/auth_page/data/datasource/send_verification_code_datasource/send_verification_code_datasource.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/admin_details_request.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/provider_details_request.dart';
import 'package:web_admin_san/features/auth_page/data/request/send_verification_code_request/send_verification_code_request.dart';
import 'package:web_admin_san/features/notifications/data/datasource/signalr_datasource/signalr_service/signalr_service.dart';
import '../../../../../core/api/dio_function/api_constants.dart';
import '../../../../../core/language/language_constant.dart';
import '../../../../../core/pages_widgets/general_widgets/navigate_to_page_widget.dart';
import '../../../../../features/auth_page/data/datasource/change_password_datasource/change_password_repository.dart';
import '../../../../../features/auth_page/data/datasource/check_if_user_exist_datasource/check_if_user_exist_repository.dart';
import '../../../../../features/auth_page/data/datasource/check_if_user_exist_or_not_datasource/check_if_user_exist_or_not_repository.dart';
import '../../../../../features/auth_page/data/datasource/create_user_datasource/create_user_repository.dart';
import '../../../../../features/auth_page/data/datasource/login_datasource/login_repository.dart';
import '../../../../../features/auth_page/data/datasource/update_user_datasource/update_user_repository.dart';
import '../../../../../features/auth_page/data/model/create_user_model/create_user_request.dart';
import '../../../../../features/auth_page/data/request/change_password_request/change_password_request.dart';
import '../../../../../features/auth_page/data/request/check_if_user_exist_or_not_request/check_if_user_exist_or_not_request.dart';
import '../../../../../features/auth_page/data/request/check_if_user_exist_request/check_if_user_exist_request.dart';
import '../../../../../features/auth_page/data/request/login_request/login_request.dart';
import '../../../../../features/auth_page/domain/validate/facility_validator.dart';
import '../../../../../features/auth_page/presentation/pages/change_password/change_password_page.dart';
import 'auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  String phoneNumber = "";
  CreateUserRequest? user;
  bool _isConfirmPasswordObscure = true;

  bool get isConfirmPasswordObscure => _isConfirmPasswordObscure;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(AuthPasswordVisibilityChanged());
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(AuthPasswordVisibilityChanged());
  }

  Future<void> init() async {
    emit(AuthLoading());

    final localUser = await AuthLocalStorage.getUser();
    final password = await AuthLocalStorage.getPassword();

    if (localUser == null || password == null) {
      emit(AuthUnauthenticated());
      return;
    }

    final result = await loginFunction(
      loginRequest: LoginRequest(
        user: localUser.email!,
        password: password,
        type: UserType.adminUser,
      ),
    );

    // Login API failed
    if (!result.success || result.user == null) {
      await _forceLogout();
      return;
    }

    final apiUser = result.user!;

    // if (!localUser.isSameData(apiUser)) {
    //   print("INIT => Local user != API user");
    //
    //   await _forceLogout();
    //   return;
    // }


    // Connect SignalR
    if (!SignalRService.instance.isConnected) {
      await SignalRService.instance.connect(
        hubUrl: ApiLink.notificationHub,
      );
    }

    // Check facility completion
    await _checkFacilityCompletion(apiUser);
  }

  Future<void> _forceLogout() async {
    await AuthLocalStorage.clearUser();
    await AuthLocalStorage.clearPassword();

    await SignalRService.instance.disconnect();

    emit(AuthUnauthenticated());
  }
  Future<void> login(LoginRequest request) async {
    emit(AuthLoginLoading());

    final result = await loginFunction(
      loginRequest: request,
    );

    if (!result.success || result.user == null) {
      emit(
        AuthLoginError(
          result.message,
        ),
      );
      return;
    }

    final apiUser = result.user!;

    // First login → save API user
    await AuthLocalStorage.saveUser(apiUser);
    // Save password for auto-login after restart
    await AuthLocalStorage.savePassword(request.password);

    if (!SignalRService.instance.isConnected) {
      await SignalRService.instance.connect(
        hubUrl: ApiLink.notificationHub,
      );
    }

    emit(
      AuthLoginSuccess(
        message: result.message,
      ),
    );

    await _checkFacilityCompletion(apiUser);
  }

  Future<void> logout(BuildContext context) async {
    emit(AuthLoading());
    _forceLogout();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
  Future<void> reCheckFacility() async {
    final user = await AuthLocalStorage.getUser();

    if (user == null) {
      print("RECHECK => AuthUnauthenticated");
      emit(AuthUnauthenticated());
      return;
    }

    final result = FacilityValidator.validate(
      user: user,
    );

    if (result.isValid) {
      await AuthLocalStorage.saveUser(user);

      emit(AuthAuthenticated());
    } else {
      emit(AuthIncompleteProfile(result.missingFields));
    }
  }

  Future<void> _checkFacilityCompletion(
      CreateUserRequest user,
      ) async {
    final result = FacilityValidator.validate(
      user: user,
    );

    if (result.isValid) {
      await AuthLocalStorage.saveUser(user);

      emit(AuthAuthenticated());
    } else {
      emit(
        AuthIncompleteProfile(
          result.missingFields,
        ),
      );
    }
  }



  static Future<void> saveUserFromRequest(CreateUserRequest request) async {
    await AuthLocalStorage.saveUser(request);
  }


  Future<void> updateUser(
      CreateUserRequest request,
      ) async {
    if (isClosed) return;

    emit(AuthUpdateLoading());

    try {
      final oldUser = await AuthLocalStorage.getUser();

      if (oldUser == null) {
        emit(
          AuthUpdateError(
            'User not found',
          ),
        );
        return;
      }

      // ================= PROVIDER MERGE =================

      final oldProvider = oldUser.providerDetails;
      final newProvider = request.providerDetails;

      final mergedProvider = newProvider != null
          ? ProviderDetailsRequest(
        id: newProvider.id ?? oldProvider?.id,
        name: newProvider.name ?? oldProvider?.name,
        latinname:
        newProvider.latinname ?? oldProvider?.latinname,
        description:
        newProvider.description ?? oldProvider?.description,
        latindesc:
        newProvider.latindesc ?? oldProvider?.latindesc,
        provid:
        newProvider.provid ?? oldProvider?.provid,
        cr: newProvider.cr ?? oldProvider?.cr,
        vatno:
        newProvider.vatno ?? oldProvider?.vatno,
        packageid:
        newProvider.packageid ?? oldProvider?.packageid,

        subscriptionstartdate:
        newProvider.subscriptionstartdate ??
            oldProvider?.subscriptionstartdate,

        subscriptionenddate:
        newProvider.subscriptionenddate ??
            oldProvider?.subscriptionenddate,

        iban:
        newProvider.iban ?? oldProvider?.iban,

        nationaladdress:
        newProvider.nationaladdress ??
            oldProvider?.nationaladdress,

        crimage:
        newProvider.crimage ??
            oldProvider?.crimage,

        vatnoimage:
        newProvider.vatnoimage ??
            oldProvider?.vatnoimage,

        ibanimage:
        newProvider.ibanimage ??
            oldProvider?.ibanimage,

        isApproved:
        newProvider.isApproved ??
            oldProvider?.isApproved,

        approvalInfo:
        newProvider.approvalInfo ??
            oldProvider?.approvalInfo,
      )
          : oldProvider;

      // ================= ADMIN MERGE =================

      final oldAdmin = oldUser.adminDetails;
      final newAdmin = request.adminDetails;

      final mergedAdmin = newAdmin != null
          ? AdminDetailsRequest(
        id: newAdmin.id ?? oldAdmin?.id,
        jobname:
        newAdmin.jobname ?? oldAdmin?.jobname,
        joblatinname:
        newAdmin.joblatinname ??
            oldAdmin?.joblatinname,
        permissions:
        newAdmin.permissions ??
            oldAdmin?.permissions,
      )
          : oldAdmin;

      // ================= API REQUEST =================

      final mergedRequest = CreateUserRequest(
        userid: oldUser.userid,
        username:
        request.username ?? oldUser.username,
        phone:
        request.phone ?? oldUser.phone,
        email:
        request.email ?? oldUser.email,
        password:
        request.password ?? oldUser.password,
        age:
        request.age ?? oldUser.age,
        gender:
        request.gender ?? oldUser.gender,
        type:
        oldUser.type,
        nationality:
        request.nationality ?? oldUser.nationality,
        isActive:
        request.isActive ?? oldUser.isActive,
        joinDate:
        request.joinDate ?? oldUser.joinDate,
        referralCode:
        request.referralCode ?? oldUser.referralCode,
        image:
        request.image ?? oldUser.image,
        fcmToken:
        request.fcmToken ?? oldUser.fcmToken,
        currentCarId:
        request.currentCarId ?? oldUser.currentCarId,
        providerDetails: mergedProvider,
        adminDetails: mergedAdmin,
        companyDetails: request.companyDetails ?? oldUser.companyDetails,
        driverDetails: request.driverDetails ?? oldUser.driverDetails,
      );

      // ================= UPDATE API =================

      final result = await updateUserFunction(
        createUserRequest: mergedRequest,
      );

      if (isClosed) return;

      if (result.success) {
        await AuthLocalStorage.saveUser(
          mergedRequest,
        );
        emit(
          AuthUpdateSuccess(
            result.message,
          ),
        );

        return;
      }

      emit(
        AuthUpdateError(
          result.message,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        AuthUpdateError(
          e.toString(),
        ),
      );
    }
  }


  String? verificationEmail;
  String? verificationPhone;

  String otpCode = "";

  Timer? _timer;
  int secondsRemaining = 30;

  bool isOtpError = false;

  void generateOtp() {
    final random = Random();

    otpCode = (1000 + random.nextInt(9000)).toString();

    print("🔐 OTP CODE => $otpCode");

    startTimer();

    isOtpError = false;

    emit(AuthOtpGenerated());
  }

  void startTimer() {
    secondsRemaining = 30;

    _timer?.cancel();

    emit(AuthOtpTimer());

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (isClosed) {
          timer.cancel();
          return;
        }

        if (secondsRemaining <= 0) {
          timer.cancel();

          emit(AuthOtpExpired());
          return;
        }

        secondsRemaining--;

        emit(AuthOtpTimer());
      },
    );
  }

  void resetOtpError() {
    if (isClosed) return;

    if (isOtpError) {
      isOtpError = false;

      emit(
        AuthOtpReset(),
      );
    }
  }

  Future<void> validateOtp(String code) async {
    if (isClosed) return;

    final enteredOtp = code.trim();

    if (secondsRemaining <= 0) {
      isOtpError = true;

      emit(
        AuthOtpError(
          AppLanguageKeys.badRequestError,
        ),
      );

      return;
    }

    if (enteredOtp.length != 4) {
      isOtpError = true;

      emit(
        AuthOtpError(
          AppLanguageKeys.wrongCode,
        ),
      );

      return;
    }

    if (enteredOtp != otpCode) {
      isOtpError = true;

      emit(
        AuthOtpError(
          AppLanguageKeys.wrongCode,
        ),
      );

      return;
    }

    // ==========================================
    // OTP CORRECT
    // ==========================================

    isOtpError = false;
    _timer?.cancel();

    // SIGNUP
    if (_pendingSignup != null) {
      await completeSignupAfterOtp();
      return;
    }

    // FORGOT PASSWORD
    emit(AuthOtpSuccess());
  }

  Future<void> resendOtp() async {
    if (isClosed) return;

    final phone = verificationPhone;

    if (phone == null || phone.trim().isEmpty) {
      emit(
        AuthOtpError(
          AppLanguageKeys.phoneNumberNotFound,
        ),
      );
      return;
    }

    isOtpError = false;

    // Generate NEW OTP
    generateOtp();

    final message =
        'Your verification code is: $otpCode. '
        'Please do not share this code with anyone.';

    print("=================================");
    print("📤 RESEND OTP");
    print("📱 PHONE => $phone");
    print("🔐 NEW OTP => $otpCode");
    print("💬 MESSAGE => $message");
    print("=================================");

    try {
      final result =
      await sendVerificationCodeFunction(
        request: SendVerificationCodeRequest(
          user: phone,
          message: message,
        ),
      );

      if (isClosed) return;

      if (result) {
        print("✅ NEW OTP SENT SUCCESSFULLY");

        emit(
          AuthOtpResendSuccess(),
        );
      } else {
        print("❌ NEW OTP SEND FAILED");

        emit(
          AuthOtpError(
            AppLanguageKeys.somethingWentWrong,
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;

      print("❌ RESEND OTP ERROR => $e");

      emit(
        AuthOtpError(
          e.toString(),
        ),
      );
    }
  }

  // void resendOtp() {
  //   generateOtp();
  //   isOtpError = false;
  //   emit(AuthOtpGenerated());
  // }

  void updatePhone(String phone) {
    phoneNumber = phone;
    emit(AuthInitial());
  }
  Future<bool> sendOtp({
    required String email,
    required String phone,
  }) async {
    if (isClosed) return false;

    verificationEmail = email.trim();
    verificationPhone = phone.trim();

    final random = Random();

    final newOtp =
    (1000 + random.nextInt(9000)).toString();

    final message =
        'Your verification code is: $newOtp. '
        'Please do not share this code with anyone.';

    try {
      final sent = await _sendOtpToPhoneVariations(
        phone: phone.trim(),
        message: message,
      );

      if (isClosed) return false;

      if (!sent) {
        return false;
      }

      otpCode = newOtp;
      isOtpError = false;

      startTimer();

      return true;
    } catch (e) {
      if (isClosed) return false;

      return false;
    }
  }

  Future<void> checkIfUserExistOrNot({
    required String email,
  }) async {
    if (isClosed) return;

    emit(
      CheckIfUserExistOrNotLoading(),
    );

    try {
      print("=================================");
      print("CHECK USER EMAIL => $email");
      print("=================================");

      final result =
      await checkIfUserExistOrNotFunction(
        request: CheckIfUserExistOrNotRequest(
          user: email,
          type: UserType.adminUser,
        ),
      );

      if (isClosed) return;

      print("CHECK USER RESULT => $result");

      if (result == null || result.isEmpty) {
        emit(
          CheckIfUserExistOrNotError(
            AppLanguageKeys.userNotFound,
          ),
        );
        return;
      }

      final user = result.first;

      print("USER VALUE => ${user.value}");
      print("USER PHONE => ${user.phone}");

      if (user.value != true) {
        emit(
          CheckIfUserExistOrNotNotFound(
            user,
          ),
        );
        return;
      }

      final phone = user.phone?.trim();

      if (phone == null || phone.isEmpty) {
        emit(
          CheckIfUserExistOrNotError(
            AppLanguageKeys.phoneNumberNotFoundForThisAccount,
          ),
        );
        return;
      }

      print("=================================");
      print("CALLING SEND OTP");
      print("EMAIL => $email");
      print("PHONE => $phone");
      print("=================================");

      final sent = await sendOtp(
        email: email,
        phone: phone,
      );

      if (isClosed) return;

      print("OTP SENT RESULT => $sent");

      if (sent) {
        emit(
          CheckIfUserExistOrNotSuccess(
            user,
          ),
        );

        return;
      }

      emit(
        CheckIfUserExistOrNotError(
          AppLanguageKeys.failedToSendVerificationCode,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      print("CHECK USER ERROR => $e");

      emit(
        CheckIfUserExistOrNotError(
          e.toString(),
        ),
      );
    }
  }


  List<String> _getPhoneVariations(String phone) {
    final original = phone.trim();

    final List<String> phones = [];

    // 1. Original
    phones.add(original);

    // 2. Remove 966
    if (original.startsWith('966')) {
      final without966 = original.substring(3);

      if (without966.isNotEmpty) {
        phones.add(without966);

        // 3. Remove 966 + add 0
        phones.add('0$without966');
      }
    }

    return phones.toSet().toList();
  }
  Future<bool> _sendOtpToPhoneVariations({
    required String phone,
    required String message,
  }) async {
    final phones = _getPhoneVariations(phone);

    print("📱 PHONE OPTIONS => $phones");

    for (final phoneNumber in phones) {
      if (isClosed) return false;

      print(
        "📤 TRY OTP => $phoneNumber",
      );

      final result =
      await sendVerificationCodeFunction(
        request: SendVerificationCodeRequest(
          user: phoneNumber,
          message: message,
        ),
      );

      if (result) {
        verificationPhone = phoneNumber;
        print(
          "✅ OTP SENT => $phoneNumber",
        );
        return true;
      }

      print(
        "❌ OTP FAILED => $phoneNumber",
      );
    }

    return false;
  }

  Future<void> changePassword({
    required String user,
    required String password,
  }) async {
    if (isClosed) return;

    emit(ChangePasswordLoading());

    try {
      final result = await changePasswordFunction(
        changePasswordRequest: ChangePasswordRequest(
          user: user,
          password: password,
          type: UserType.adminUser,
        ),
      );

      if (isClosed) return;

      if (result.success) {
        emit(
          ChangePasswordSuccess(
            result.message,
          ),
        );
      } else {
        emit(
          ChangePasswordError(
            result.message,
          ),
        );
      }
    } catch (e) {
      if (isClosed) return;

      emit(
        ChangePasswordError(
          e.toString(),
        ),
      );
    }
  }

  CreateUserRequest? _pendingSignup;

  CreateUserRequest? get pendingSignup => _pendingSignup;

  void clearPendingSignup() {
    _pendingSignup = null;
  }

  Future<void> signup(CreateUserRequest request) async {
    if (isClosed) return;

    emit(AuthSignupLoading());

    try {
      // =========================================================
      // 1. GET & VALIDATE DATA
      // =========================================================

      final email = request.email?.trim() ?? '';
      final phone = request.phone?.trim() ?? '';

      if (email.isEmpty || phone.isEmpty) {
        emit(
          AuthSignupError(
            AppLanguageKeys.enterYourData,
          ),
        );
        return;
      }

      // =========================================================
      // 2. CHECK EMAIL FORMAT
      // =========================================================

      if (!isValidEmail(email)) {
        emit(
          AuthSignupError(
            AppLanguageKeys.pleaseEnterValidEmail,
          ),
        );
        return;
      }

      // =========================================================
      // 3. CHECK IF EMAIL ALREADY EXISTS
      // =========================================================

      print('=================================');
      print('CHECK SIGNUP EMAIL');
      print('EMAIL => $email');
      print('=================================');

      final existingUsers =
      await checkIfUserExistOrNotFunction(
        request: CheckIfUserExistOrNotRequest(
          user: email,
          type: UserType.adminUser,
        ),
      );

      if (isClosed) return;

      print(
        'CHECK SIGNUP EMAIL RESULT => $existingUsers',
      );

      // =========================================================
      // 4. CHECK API RESULT
      // =========================================================

      if (existingUsers == null || existingUsers.isEmpty) {
        emit(
          AuthSignupError(
            AppLanguageKeys.somethingWentWrong,
          ),
        );
        return;
      }

      final user = existingUsers.first;

      print(
        'EMAIL EXISTS => ${user.value}',
      );

      // =========================================================
      // 5. EMAIL ALREADY EXISTS
      // =========================================================

      if (user.value == true) {
        emit(
          AuthSignupError(
            AppLanguageKeys.emailExist,
          ),
        );
        return;
      }

      // =========================================================
      // 6. EMAIL AVAILABLE
      // Save request BEFORE sending OTP
      // =========================================================

      _pendingSignup = request;

      // =========================================================
      // 7. SEND OTP
      // =========================================================

      print('=================================');
      print('EMAIL AVAILABLE');
      print('SENDING SIGNUP OTP');
      print('EMAIL => $email');
      print('PHONE => $phone');
      print('=================================');

      final sent = await sendOtp(
        email: email,
        phone: phone,
      );

      if (isClosed) return;

      // =========================================================
      // 8. OTP FAILED
      // =========================================================

      if (!sent) {
        _pendingSignup = null;

        emit(
          AuthSignupError(
            AppLanguageKeys.failedToSendVerificationCode,
          ),
        );

        return;
      }

      // =========================================================
      // 9. OTP SENT SUCCESSFULLY
      // =========================================================

      print('=================================');
      print('OTP SENT FOR SIGNUP');
      print('EMAIL => $verificationEmail');
      print('PHONE => $verificationPhone');
      print('OTP => $otpCode');
      print('=================================');

      emit(
        AuthSignupSuccess(
          AppLanguageKeys.verificationCodeSent,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      _pendingSignup = null;

      print(
        'SIGNUP ERROR => $e',
      );

      emit(
        AuthSignupError(
          e.toString(),
        ),
      );
    }
  }
  Future<void> completeSignupAfterOtp() async {
    if (isClosed) return;

    final request = _pendingSignup;

    if (request == null) {
      emit(
        AuthSignupError(
          AppLanguageKeys.somethingWentWrong,
        ),
      );
      return;
    }

    emit(AuthSignupLoading());

    try {
      final result = await createUserFunction(
        createUserRequest: request,
      );

      if (isClosed) return;

      if (!result.success) {
        emit(
          AuthSignupError(
            result.message,
          ),
        );
        return;
      }

      _pendingSignup = null;

      emit(
        AuthSignupCompleted(
          result.message,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        AuthSignupError(
          e.toString(),
        ),
      );
    }
  }

// ================= Validators ================

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    return emailRegex.hasMatch(email);
  }

// =========================================================
// SIGNUP EMPLOYEE
// Check Email + Phone -> Create User
// NO OTP
// =========================================================

}
