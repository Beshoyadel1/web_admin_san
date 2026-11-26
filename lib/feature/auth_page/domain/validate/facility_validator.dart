import 'package:web_admin_san/generated/locale_keys.g.dart';
import 'package:web_admin_san/feature/auth_page/data/model/create_user_model/create_user_request.dart';

class FacilityValidationResult {
  final bool isValid;
  final List<String> missingFields;

  FacilityValidationResult({
    required this.isValid,
    required this.missingFields,
  });
}

class FacilityValidator {
  static FacilityValidationResult validate({
    required CreateUserRequest user,
    // required BranchCubit branchCubit,
    // required UpdateWorkTimeCubit workTimeCubit,
  }) {
    final p = user.adminDetails;

    List<String> missing = [];

    bool isValid(String? value) {
      return value != null && value.trim().isNotEmpty && value.trim() != "null";
    }

    /// 🔴 Basic data
    // if (!isValid(p?.jobname)) missing.add(LocaleKeys.facilityName);
    // if (!isValid(p?.joblatinname)) missing.add(LocaleKeys.facilityNameEn);
    // if (!isValid(p?.cr)) missing.add(LocaleKeys.commercialRecordKey);
    // if (!isValid(p?.vatno)) missing.add(LocaleKeys.taxNumber);
    // if (!isValid(user.phone)) missing.add(LocaleKeys.phoneNumber);
    // if (!isValid(user.email)) missing.add(LocaleKeys.Email);
    //
    // if (!isValid(user.image?.toString())) missing.add(LocaleKeys.ownerIdKey);

    // /// 🔴 Branch
    // print("BRANCHES TYPE => ${branchCubit.branches.runtimeType}");
    // print("BRANCHES => ${branchCubit.branches}");

    // if (branchCubit.branches.isEmpty) {
    //   missing.add(LocaleKeys.addAtLeastOneBranch);
    // }

    // /// 🔴 Work Time
    // print("WORK TIMES TYPE => ${workTimeCubit.workTimes.runtimeType}");
    // print("WORK TIMES => ${workTimeCubit.workTimes}");

    // if (workTimeCubit.workTimes.isEmpty) {
    //   missing.add(LocaleKeys.addAtLeastOneWorkingHours);
    // }

    return FacilityValidationResult(
      isValid: missing.isEmpty,
      missingFields: missing,
    );
  }
}
