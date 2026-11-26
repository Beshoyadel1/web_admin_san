import 'dart:io';

abstract class UploadImageAdvertisementsState {}

class UploadImageInitial extends UploadImageAdvertisementsState {}

class UploadImageSelected extends UploadImageAdvertisementsState {
  final File imageFile;

  UploadImageSelected(this.imageFile);
}

class UploadImageError extends UploadImageAdvertisementsState {
  final String message;

  UploadImageError(this.message);
}
