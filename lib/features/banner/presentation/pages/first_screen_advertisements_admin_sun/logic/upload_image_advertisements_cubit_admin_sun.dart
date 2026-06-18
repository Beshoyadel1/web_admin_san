import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'upload_image_advertisements_state_admin_sun.dart';

class UploadImageAdvertisementsCubitAdminSun extends Cubit<UploadImageAdvertisementsStateAdminSun> {
  UploadImageAdvertisementsCubitAdminSun() : super(UploadImageInitial());

  Future<void> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        emit(UploadImageSelected(File(result.files.single.path!)));
      }
    } catch (e) {
      emit(UploadImageError("Error picking image: $e"));
    }
  }

  void clearImage() {
    emit(UploadImageInitial());
  }
}
