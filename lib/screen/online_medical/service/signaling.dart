import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';

import '../../../utils/Constant.dart';
import '../bloc/chat_bloc.dart';
import 'observer.dart';

enum SignalingState {
  ConnectionOpen,
  ConnectionClosed,
  ConnectionReconnected,
  ConnectionError,
}

enum CallState {
  CallStateNew,
  CallStateRinging,
  CallStateInvite,
  CallStateConnected,
  CallStateBye,
}

const int MSG_HANDSHAKE = 0;
const int MSG_PEERS = 1;
const int MSG_PEER_ON = 4;
const int MSG_PEER_OFF = 5;
const int MSG_CHAT = 2;
const int REPLY_CHAT = 6;
const int MSG_WEBRTC = 3;

const int HANDSHAKE_SYN = 0;
const int HANDSHAKE_ACK = 1;
const int HANDSHAKE_FIN = 2;
const int HANDSHAKE_FIN_DECLINE = 3;
const int HANDSHAKE_FIN_BUSY = 4;
const int HANDSHAKE_FIN_DISCONNECT = 5;
const int HANDSHAKE_SYN_RESEND = 6;

const int PEERS_ON = 0;
const int PEERS_JOINED = 1;
const int PEERS_LIST = 2;
const int PEERS_OFF = 3;

const int WEBRTC_OFFER = 0;
const int WEBRTC_ANSWER = 1;
const int WEBRTC_CANDIDATE = 2;
const int WEBRTC_LEAVE = 3;
const int WEBRTC_BYE = 4;

const int MEDIA_AUDIO = 0;
const int MEDIA_VIDEO = 1;
const int MEDIA_DATA = 2;

class Session {
  Session({this.sid, this.pid});
  String pid;
  String sid;
}

class RandomRetryPolicy extends RetryPolicy {
  Random random = Random();

  @override
  int nextRetryDelayInMilliseconds(RetryContext retryContext) =>
      random.nextInt(12 * 1000);
}

class SignalingProvider extends Observable {
  static final SignalingProvider _instance = SignalingProvider._internal();

  String _accessToken;
  bool _isConnected = false;
  String _selfId;
  String _sessionId;

  HubConnection _hubConnection;
  final List<dynamic> _peers = [];

  Function(SignalingState state) onSignalingStateChange;
  Function(dynamic event) onOffer;

  factory SignalingProvider() => _instance;

  SignalingProvider._internal();

  List<dynamic> get peers => _peers;
  String get sessionId => _sessionId;

  bool get isConnected => _isConnected;

  Future<void> stop() async {
    await _hubConnection?.stop();
  }

  // Future<void> getPeers() async {
  //   await _send('Peer', {'type': PEERS_LIST});
  // }

  Future<void> sendMessage(String content, String to) async {
    await _send('Chat', {'from': _selfId, 'to': to, 'body': content});
  }

  Future<void> connect() async {
    final kHostUrl = dotenv.env['URL_CHAT_VIDEO'];

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(Constants.prefAccessToken);
    _selfId = prefs.getString(Constants.prefUserName);

    _hubConnection = HubConnectionBuilder()
        .withUrl(
            '$kHostUrl/hub/signal?token=$_accessToken', HttpConnectionOptions())
        .withAutomaticReconnect(RandomRetryPolicy())
        .build();

    _hubConnection.serverTimeoutInMilliseconds = 120000;
    _hubConnection?.onclose((error) {
      if (kDebugMode) {
        print('onclose called: $error');
      }

      _isConnected = false;
      onSignalingStateChange?.call(SignalingState.ConnectionClosed);
    });

    _hubConnection.onreconnecting((error) {
      if (kDebugMode) {
        print('onreconnecting called: $error');
      }
    });

    _hubConnection?.onreconnected((connectionId) {
      if (kDebugMode) {
        print('onreconnected called');
      }
      _isConnected = true;
      onSignalingStateChange?.call(SignalingState.ConnectionReconnected);
    });

    _hubConnection?.on('Chat', (data) {
      final message = data[0];
      notifyObservers(MSG_CHAT, message);

      _send('ReplyChat', {
        'to': message['from'],
        'sequence': message['sequence'],
        'index': message['index'],
        'time': message['time']
      });
    });

    _hubConnection?.on('ReplyChat', (data) {
      // Server: true đã gửi, false đã nhận
      final message = data[0];
      notifyObservers(REPLY_CHAT, message);
    });

    _hubConnection.on('Peer', (msg) {
      final Map<String, dynamic> mapData = msg[0];

      final data = mapData['data'];
      switch (mapData['type']) {
        case PEERS_ON:
          notifyObservers(MSG_PEER_ON, data['id']);
          _peers.add(data);
          break;
        case PEERS_JOINED:
          break;
        case PEERS_OFF:
          // _peers.removeWhere((user) => user['id'] == data);
          notifyObservers(MSG_PEER_OFF, data);
          break;
        case PEERS_LIST:
          _peers.clear();
          data.forEach((item) {
            _peers.add(item);
          });
          break;
      }

      // final Map<String, dynamic> event = <String, dynamic>{};
      // event['self'] = _selfId;
      // event['peers'] = _peers;
      // notifyObservers(MSG_PEERS, event);
    });

    await _hubConnection.start();

    if (_hubConnection.state == HubConnectionState.connected) {
      onSignalingStateChange?.call(SignalingState.ConnectionOpen);
      _isConnected = true;
    }
  }

  Future<dynamic> _send(method, data) async =>
      await _hubConnection.invoke(method, args: [data]);
}
