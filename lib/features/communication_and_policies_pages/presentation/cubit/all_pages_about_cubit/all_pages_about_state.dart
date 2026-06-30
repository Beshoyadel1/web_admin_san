import 'package:web_admin_san/features/communication_and_policies_pages/data/model/get_all_pages_about_model/get_all_pages_about_model.dart';

abstract class AllPagesAboutState {}

class AllPagesAboutInitial extends AllPagesAboutState {}

class AllPagesAboutLoading extends AllPagesAboutState {}

class AllPagesAboutSuccess extends AllPagesAboutState {
  final List<AboutPageModel> pages;

  AllPagesAboutSuccess(this.pages);
}

class AllPagesAboutError extends AllPagesAboutState {
  final String message;

  AllPagesAboutError(this.message);
}

/// Update
class UpdatePageAboutLoading extends AllPagesAboutState {}

class UpdatePageAboutSuccess extends AllPagesAboutState {}

class UpdatePageAboutError extends AllPagesAboutState {
  final String message;

  UpdatePageAboutError(this.message);
}