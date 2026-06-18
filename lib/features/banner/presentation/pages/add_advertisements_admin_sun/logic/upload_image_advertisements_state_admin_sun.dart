import 'dart:io';

abstract class UploadImageAdvertisementsStateAdminSun {}

class UploadImageInitial extends UploadImageAdvertisementsStateAdminSun {}

class UploadImageSelected extends UploadImageAdvertisementsStateAdminSun {
  final File imageFile;
  UploadImageSelected(this.imageFile);
}

class UploadImageError extends UploadImageAdvertisementsStateAdminSun {
  final String message;
  UploadImageError(this.message);
}
