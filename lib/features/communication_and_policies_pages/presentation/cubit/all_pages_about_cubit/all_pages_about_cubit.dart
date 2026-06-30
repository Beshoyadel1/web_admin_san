import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_admin_san/core/api/dio_function/failures.dart';
import 'package:web_admin_san/features/communication_and_policies_pages/data/datasource/get_all_pages_about_datasource/get_all_pages_about_datasource.dart';
import 'package:web_admin_san/features/communication_and_policies_pages/data/datasource/update_all_pages_about_datasource/update_all_pages_about_datasource.dart';
import 'package:web_admin_san/features/communication_and_policies_pages/data/model/get_all_pages_about_model/get_all_pages_about_model.dart';
import 'all_pages_about_state.dart';


class AllPagesAboutCubit extends Cubit<AllPagesAboutState> {
  AllPagesAboutCubit() : super(AllPagesAboutInitial());

  List<AboutPageModel> pages = [];

  int selectedIndex = 0;

  bool isUpdating = false;

  AboutPageModel? get selectedPage =>
      pages.isEmpty ? null : pages[selectedIndex];

  void selectPage(int index) {
    selectedIndex = index;

    if (state is AllPagesAboutSuccess) {
      emit(AllPagesAboutSuccess(List.from(pages)));
    }
  }

  @override
  Future<void> close() {
    pages.clear();
    return super.close();
  }

  Future<void> getAllPagesAbout() async {
    if (isClosed) return;

    emit(AllPagesAboutLoading());

    try {
      pages = await getAllPagesAboutFunction();

      if (isClosed) return;

      if (selectedIndex >= pages.length) {
        selectedIndex = 0;
      }

      emit(AllPagesAboutSuccess(List.from(pages)));
    } catch (e) {
      if (isClosed) return;

      emit(AllPagesAboutError(e.toString()));
    }
  }

  Future<bool> updatePageAbout({
    required AboutPageModel page,
  }) async {
    if (isClosed) return false;

    try {
      isUpdating = true;

      if (!isClosed && state is AllPagesAboutSuccess) {
        emit(AllPagesAboutSuccess(List.from(pages)));
      }

      await updatePageAboutFunction(page: page);

      if (isClosed) return false;

      await getAllPagesAbout();

      if (isClosed) return false;

      isUpdating = false;

      emit(AllPagesAboutSuccess(List.from(pages)));

      return true;
    } catch (e) {
      isUpdating = false;

      if (!isClosed) {
        emit(AllPagesAboutSuccess(List.from(pages)));
      }

      return false;
    }
  }
}