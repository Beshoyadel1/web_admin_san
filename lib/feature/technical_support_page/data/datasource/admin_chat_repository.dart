import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/networking/api_link.dart';
import '../../../../core/networking/network.dart';
import '../model/admin_chat_model.dart';

class AdminChatRepository {
  const AdminChatRepository();

  /// Fetches all conversation summaries for the specified user.
  Future<List<GetAllMessagesModel>> getAllMessages({
    required int userId,
    required int userType,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'userId': userId,
        'userType': userType,
      };

      final response = await Network.postDataWithBodyAndParams(
        {},
        queryParams,
        ApiLink.getUserChats,
      );

      final responseData = response.data;
      if (responseData == null) return [];

      List rawList = [];
      if (responseData is List) {
        rawList = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        rawList = responseData['data'];
      }

      return rawList
          .whereType<Map>()
          .map((item) =>
              GetAllMessagesModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          e.message ??
          'Failed to load conversations');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Fetches team members associated with the admin / support system.
  Future<List<WorkTeamMemberModel>> getWorkTeam({
    required int userId,
    required int userType,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'userId': userId,
        'user': userId,
        'userType': userType,
      };

      final response = await Network.postDataWithBodyAndParams(
        {},
        queryParams,
        ApiLink.getWorkTeamChat,
      );

      final responseData = response.data;
      if (responseData == null) return [];

      List rawList = [];
      if (responseData is List) {
        rawList = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        rawList = responseData['data'];
      }

      return rawList
          .whereType<Map>()
          .map((item) =>
              WorkTeamMemberModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          e.message ??
          'Failed to load work team');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Fetches the recent conversation messages using the GetChatMessages endpoint.
  Future<List<ChatMessageModel>> getChatMessages({
    required int fromUserId,
    required int fromUserType,
    required int toUserId,
    required int toUserType,
    bool? isClosed,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'fromUserId': fromUserId,
        'fromUserType': fromUserType,
        'toUserId': toUserId,
        'toUserType': toUserType,
        if (isClosed != null) 'isClosed': isClosed,
      };

      final response = await Network.postDataWithBodyAndParams(
        {},
        queryParams,
        ApiLink.getChatMessages,
      );

      final responseData = response.data;
      if (responseData == null) return [];

      List rawList = [];
      if (responseData is List) {
        rawList = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        rawList = responseData['data'];
      }

      if (rawList.isNotEmpty && rawList.first is Map) {
        final firstMap = Map<String, dynamic>.from(rawList.first);
        final messages = firstMap['Messages'] ?? firstMap['messages'];
        if (messages is List) {
          return messages
              .whereType<Map>()
              .map((item) =>
                  ChatMessageModel.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        }
      }

      return rawList
          .whereType<Map>()
          .map((item) =>
              ChatMessageModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          e.message ??
          'Failed to load chat messages');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Fetches older messages for a conversation before the specified [date].
  Future<List<ChatMessageModel>> getOlderMessages({
    required int fromUser,
    required int fromUserType,
    required int toUser,
    required int toUserType,
    required String date,
    bool? isClosed,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'fromUser': fromUser,
        'fromUserType': fromUserType,
        'toUser': toUser,
        'toUserType': toUserType,
        'date': date,
        if (isClosed != null) 'isClosed': isClosed,
      };

      final response = await Network.postDataWithBodyAndParams(
        {},
        queryParams,
        ApiLink.getOtherMessages,
      );

      final responseData = response.data;
      if (responseData == null) return [];

      List rawList = [];
      if (responseData is List) {
        rawList = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        rawList = responseData['data'];
      }

      return rawList
          .whereType<Map>()
          .map((item) =>
              ChatMessageModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          e.message ??
          'Failed to load older messages');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Sends a new chat message to the recipient.
  Future<dynamic> sendChatMessage({
    required SendChatMessageModel message,
  }) async {
    try {
      final bodyString = jsonEncode(message.toJson());
      final response = await Network.postDataWithBody(
        bodyString,
        ApiLink.sendMessage,
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          e.message ??
          'Failed to send message');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Marks the conversation between users as viewed.
  Future<bool> makeChatViewed({
    required int fromUser,
    required int fromUserType,
    required int toUser,
    required int toUserType,
    int? orderId,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'fromUser': fromUser,
        'fromUserType': fromUserType,
        'toUser': toUser,
        'toUserType': toUserType,
      };
      if (orderId != null && orderId > 0) {
        queryParams['orderId'] = orderId;
      }

      final response = await Network.postDataWithBodyAndParams(
        {},
        queryParams,
        ApiLink.makeChatViewed,
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Fetches support tickets filtered by [status] ('unassigned', 'mine', or 'closed').
  Future<List<GetAllMessagesModel>> getSupportTickets({
    required int adminId,
    required String status,
    String lang = 'ar',
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'adminId': adminId,
        'status': status,
        'lang': lang,
      };

      final response = await Network.postDataWithBodyAndParams(
        {},
        queryParams,
        ApiLink.getSupportConversations,
      );

      final responseData = response.data;
      if (responseData == null) return [];

      List rawList = [];
      if (responseData is List) {
        rawList = responseData;
      } else if (responseData is Map && responseData['data'] is List) {
        rawList = responseData['data'];
      }

      return rawList
          .whereType<Map>()
          .map((item) =>
              GetAllMessagesModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          e.message ??
          'Failed to load support tickets');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Opens (claims/assigns) or closes a support ticket.
  /// [isClose] == false assigns to [toUser] (admin).
  /// [isClose] == true closes the ticket.
  Future<bool> openCloseChat({
    required int fromUser,
    required int fromUserType,
    required int toUser,
    required int toUserType,
    required bool isClose,
    String lang = 'ar',
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'fromUser': fromUser,
        'fromUserType': fromUserType,
        'toUser': toUser,
        'toUserType': toUserType,
        'isClose': isClose,
        'lang': lang,
      };

      final response = await Network.postDataWithBodyAndParams(
        {},
        queryParams,
        ApiLink.openCloseChat,
      );

      final responseData = response.data;
      if (responseData is Map) {
        final success = responseData['success'] ?? false;
        if (!success) {
          throw Exception(responseData['message'] ?? 'Failed to update ticket');
        }
        return true;
      }
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ??
          e.message ??
          'Failed to update ticket status');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
