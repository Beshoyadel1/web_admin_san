abstract class FacilityTabProviderState {}

class FacilityDataState extends FacilityTabProviderState {}

class IdentityState extends FacilityTabProviderState {}

class IdentityUploadedState extends FacilityTabProviderState {}

class WorkingHoursState extends FacilityTabProviderState {}

class WorkingHoursDaySelectedState extends FacilityTabProviderState {
  final Set<int> selectedDays;

  WorkingHoursDaySelectedState(this.selectedDays);
}

class BranchesState extends FacilityTabProviderState {}

class AddBranchState extends FacilityTabProviderState {}

class BankAccountState extends FacilityTabProviderState {}

class TimerCompleteState extends FacilityTabProviderState {}

class ChangeIndexState extends FacilityTabProviderState {}

class GetImageFromDeviceState extends FacilityTabProviderState {}

class ChangeGetImageFromDeviceState extends FacilityTabProviderState {}

class IdentityDeletedState extends FacilityTabProviderState {}
