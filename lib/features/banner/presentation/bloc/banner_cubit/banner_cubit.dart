import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_admin_san/core/language/language_constant.dart';
import 'package:web_admin_san/core/theming/image_compressor.dart';
import 'package:web_admin_san/features/banner/data/datasource/create_banner_datasource/create_banner_repository.dart';
import 'package:web_admin_san/features/banner/data/datasource/delete_banner_datasource/delete_banner_repository.dart';
import 'package:web_admin_san/features/banner/data/datasource/update_banner_datasource/update_banner_repository.dart';
import 'package:web_admin_san/features/banner/data/model/delete_banner_model/delete_banner_model.dart';
import '../../../data/datasource/get_banners_datasource/get_banners_datasource.dart';
import '../../../data/model/get_banners_models/banner_model.dart';
import 'banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  BannerCubit() : super(BannerInitial());

  final ImagePicker picker = ImagePicker();

  List<BannerModel> banners = [];

  Uint8List? imageBytes;
  DateTime? startDate;
  DateTime? endDate;

  int? selectedBannerId;
  Future<void> deleteBanner({
    required int id,
  }) async {
    try {
      emit(BannerDeleteLoading());

      await deleteBannerFunction(
        deleteBannerRequest: DeleteBannerRequest(
          id: id,
        ),
      );

      emit(BannerDeleteSuccess());

      await getBanner();
    } catch (e) {
      emit(
        BannerError(
          e.toString(),
        ),
      );
    }
  }
  void clearData() {
    selectedBannerId = null;
    imageBytes = null;
    startDate = null;
    endDate = null;

    emit(BannerInitial());
  }
  void setBannerData(BannerModel banner) {
    selectedBannerId = banner.imageId;
    imageBytes = banner.image;
    startDate = banner.startDate;
    endDate = banner.endDate;

    emit(BannerImageSelected());
  }
  Future<void> pickImage() async {
    try {
      final XFile? file = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (file == null) return;

      final bytes = await file.readAsBytes();

      imageBytes = await ImageCompressor.compressImage(
        bytes,
        minWidth: 800,
        minHeight: 800,
        quality: 70,
      );

      emit(BannerImageSelected());
    } catch (e) {
      emit(BannerError(e.toString()));
    }
  }

  void setStartDate(DateTime date) {
    startDate = date;
  }

  void setEndDate(DateTime date) {
    endDate = date;
  }
  Future<void> updateBanner({
    required int imageId,
  }) async {
    try {
      if (imageBytes == null) {
        emit(BannerError(AppLanguageKeys.pleaseSelectImage));
        return;
      }

      if (startDate == null) {
        emit(BannerError(AppLanguageKeys.pleaseSelectStartDate));
        return;
      }

      if (endDate == null) {
        emit(BannerError(AppLanguageKeys.pleaseSelectEndDate));
        return;
      }

      if (endDate!.isBefore(startDate!)) {
        emit(BannerError(
          AppLanguageKeys.endDateMustBeAfterStartDate,
        ));
        return;
      }

      emit(BannerUpdateLoading());

      await updateBannerFunction(
        bannerModel: BannerModel(
          imageId: imageId,
          image: imageBytes,
          startDate: startDate,
          endDate: endDate,
        ),
      );

      emit(BannerUpdateSuccess());

      await getBanner();
    } catch (e) {
      emit(
        BannerError(
          e.toString(),
        ),
      );
    }
  }
  Future<void> createBanner() async {
    try {
      if (imageBytes == null) {
        emit(BannerError(AppLanguageKeys.pleaseSelectImage));
        return;
      }

      if (startDate == null) {
        emit(BannerError(AppLanguageKeys.pleaseSelectStartDate));
        return;
      }

      if (endDate == null) {
        emit(BannerError(AppLanguageKeys.pleaseSelectEndDate));
        return;
      }

      if (endDate!.isBefore(startDate!)) {
        emit(BannerError(AppLanguageKeys.endDateMustBeAfterStartDate));
        return;
      }

      emit(BannerCreateLoading());

      await createBannerFunction(
        bannerModel: BannerModel(
          imageId: 0,
          image: imageBytes,
          startDate: startDate,
          endDate: endDate,
        ),
      );

      emit(BannerCreateSuccess());

      await getBanner();
    } catch (e) {
      emit(BannerError(e.toString()));
    }
  }

  Future<void> getBanner() async {
    try {
      if (isClosed) return;

      emit(BannerLoading());

      banners = await getBannersFunction();

      if (isClosed) return;

      emit(BannerSuccess(banners));
    } catch (e) {
      if (isClosed) return;

      emit(BannerError(e.toString()));
    }
  }
}