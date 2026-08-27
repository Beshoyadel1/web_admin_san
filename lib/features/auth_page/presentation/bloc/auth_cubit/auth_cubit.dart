import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/theming/auth_local_storage.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/admin_details_request.dart';
import 'package:web_admin_san/features/auth_page/data/model/create_user_model/provider_details_request.dart';
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

  Timer? _timer;
  int secondsRemaining = 30;
  String otpCode = "";

  void generateOtp() {
    final random = Random();
    otpCode = (1000 + random.nextInt(9000)).toString();

    print("OTP CODE: $otpCode");

    startTimer();
    emit(AuthOtpGenerated());
  }

  void startTimer() {
    secondsRemaining = 30;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        timer.cancel();
        emit(AuthOtpExpired());
      } else {
        secondsRemaining--;
        emit(AuthOtpTimer());
      }
    });
  }

  bool isOtpError = false;

  void validateOtp(String code, BuildContext context, String email) {
    if (code == otpCode) {
      isOtpError = false;
      emit(AuthOtpSuccess());

      Navigator.pop(context);
      Navigator.push(
        context,
        NavigateToPageWidget(ChangePasswordPage(email: email)),
      );
    } else {
      isOtpError = true;
      emit(AuthOtpError(AppLanguageKeys.wrongCode));
    }
  }

  void resetOtpError() {
    if (isOtpError) {
      isOtpError = false;
      emit(AuthOtpReset());
    }
  }

  void resendOtp() {
    generateOtp();
    isOtpError = false;
    emit(AuthOtpGenerated());
  }

  void updatePhone(String phone) {
    phoneNumber = phone;
    emit(AuthInitial());
  }

  Future<void> checkIfUserExistOrNot({
    required String email,
    required String phone,
  }) async {
    emit(AuthLoginLoading());

    final result = await checkIfUserExistOrNotFunction(
      request: CheckIfUserExistOrNotRequest(
        user: email,
        type: UserType.employeeUser,
      ),
    );

    if (result != null && result.isNotEmpty) {
      final user = result.first;

      if (user.value == true && user.phone == phone) {
        emit(AuthLoginSuccess());
      } else {
        emit(AuthLoginError(AppLanguageKeys.emailOrPhoneInvalid));
      }
    } else {
      emit(AuthLoginError(AppLanguageKeys.userNotFound));
    }
  }

  void showLogin() => emit(AuthShowLogin());

  void showSignup() => emit(AuthShowSignup());

  void showRestPassword() => emit(AuthShowRestPassword());



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



  Future<void> checkEmailExist(
      CheckIfUserExistRequest checkIfUserExistRequest) async {
    emit(AuthLoginLoading());

    final bool isSuccess = await checkIfUserExistFunction(
        checkIfUserExistRequest: checkIfUserExistRequest);

    if (isSuccess) {
      emit(AuthLoginSuccess());
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> changePassword(
    ChangePasswordRequest request,
  ) async {
    emit(AuthLoginLoading());

    final result = await changePasswordFunction(
      changePasswordRequest: request,
    );

    if (result.success) {
      await AuthLocalStorage.clearUser();

      emit(
        AuthChangePasswordSuccess(),
      );
    } else {
      emit(
        AuthLoginError(
          result.message,
        ),
      );
    }
  }

  Future<void> signup(CreateUserRequest request) async {
    if (isClosed) return;

    emit(AuthSignupLoading());

    final result = await createUserFunction(
      createUserRequest: request,
    );

    if (isClosed) return;

    if (result.success) {
      emit(
        AuthSignupSuccess(
          result.message,
        ),
      );
    } else {
      emit(
        AuthSignupError(
          result.message,
        ),
      );
    }
  } // ================= Validators =================

  String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguageKeys.authCompanyNameRequired;
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguageKeys.authEmailRequired;
    } else if (!isValidEmail(value)) {
      return AppLanguageKeys.authEnterCorrectEmail;
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguageKeys.authPasswordRequired;
    } else if (value.length < 6) {
      return AppLanguageKeys.authWeakPassword;
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLanguageKeys.authPhoneNumberRequired;
    }

    final cleanNumber = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanNumber.length < 8 || cleanNumber.length > 15) {
      return AppLanguageKeys.authEnterCorrectPhoneNumber;
    }

    return null;
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email.trim());
  }
}
