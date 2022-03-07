import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:spaces/data/message.dart';

class SocketIO {
  final String baseUrl;
  IO.Socket? socket;
  String? token;

  final _socketResponse = StreamController<Message>.broadcast();
  void Function(Message event) get addMessageResponse =>
      _socketResponse.sink.add;
  Stream<Message> get getMessageResponse => _socketResponse.stream;

  SocketIO({required this.baseUrl});

  void dispose() {
    _socketResponse.close();
    socket?.close();
  }

  void startConnection(String token) {
    this.token = token;

    socket = IO.io(
      "$baseUrl/socketIO",
      kIsWeb
          ? IO.OptionBuilder().setExtraHeaders({"token": token}).build()
          : IO.OptionBuilder().setTransports(["websocket"]).setExtraHeaders(
              {"token": token}).build(),
    );

    log("conneting at ${socket?.io.uri}");

    socket?.on("connect", (_) => log('socket connected'));
    socket?.onConnectError((data) => print(data));
    socket?.onError((data) => log("onError: \n" + data));
    socket?.on(
      "message",
      (message) => {
        addMessageResponse(
          Message.fromJson(
            unpackSocketPayload(message),
          ),
        ),
        log(message)
      },
    );

    socket?.on("disconnect", (_) => log('socket disconnected'));
  }

  Future<Message> sendMessage(Message message) async {
    final completer = Completer<Message>();

    if (socket != null && token != null) {
      socket!.emitWithAck(
          "newMessage", packSocketPayload(Message.toMap(message)),
          ack: (data) => {
                print(data),
                completer.complete(Message.fromJson(unpackSocketPayload(data)))
              });
    } else {
      completer.completeError(Exception("no token"));
    }

    return completer.future;
  }

  List<String> roomsUserJoined = [];

  void joinSocketRoom(List<String> socketRoomIds) {
    if (socket != null && token != null) {
      socket!.emit(
        "join",
        packSocketPayload({
          "roomId": socketRoomIds,
        }),
      );

      roomsUserJoined.addAll(socketRoomIds);
    }
  }

  void leaveSocketRoom(List<String> socketRoomIds) {
    if (socket != null && token != null) {
      socket!.emit(
        "join",
        packSocketPayload({
          "roomId": socketRoomIds,
        }),
      );

      socketRoomIds.forEach(roomsUserJoined.remove);
    }
  }

  void closeConnection() {
    socket?.disconnect();
  }

  String packSocketPayload(dynamic payload) {
    return jsonEncode({
      "header": {
        "token": token,
      },
      "data": payload,
    });
  }

  dynamic unpackSocketPayload(payload) {
    return jsonDecode(payload);
  }
}
