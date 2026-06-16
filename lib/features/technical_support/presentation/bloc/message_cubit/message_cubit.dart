import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../../features/technical_support/data/datasource/get_user_chats_datasource/get_user_chats_repository.dart';
import '../../../../../../../../../features/technical_support/data/request/get_user_chats_request/get_user_chats_request.dart';
import '../../../../../../../../../features/auth_page/data/datasource/login_datasource/login_repository.dart';
import '../../../../../../../../../features/technical_support/presentation/bloc/message_cubit/message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  Future<void> getMessages() async {
    if (isClosed) return;

    emit(MessageLoading());

    try {
      final user = await AuthLocalStorage.getUser();

      if (isClosed) return;

      final messages = await getUserMessagesFunction(
        request: GetUserChatsRequest(
          userId: user?.userid ?? 5,
          userType: user?.type ?? 4,
        ),
      );

      if (isClosed) return;

      emit(MessageSuccess(messages));
    } catch (e) {
      if (isClosed) return;

      emit(MessageError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    print('MessageCubit CLOSED');
    return super.close();
  }
}