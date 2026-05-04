import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Centralized Agora RTC service for managing video calls.
/// Handles engine lifecycle, channel management, and media controls.
class AgoraService {
  // ─── Singleton ───────────────────────────────────────────────────────
  static final AgoraService _instance = AgoraService._internal();
  factory AgoraService() => _instance;
  AgoraService._internal();

  // ─── Constants ───────────────────────────────────────────────────────
  static const String appId = 'de585668e3ba4ffd955428708e57c178';

  // ─── State ───────────────────────────────────────────────────────────
  RtcEngine? _engine;
  bool _isInitialized = false;
  bool _isInChannel = false;
  bool _isMicOn = true;
  bool _isCamOn = true;
  int? _remoteUid;

  // ─── Callbacks ───────────────────────────────────────────────────────
  VoidCallback? onJoinSuccess;
  ValueChanged<int>? onRemoteUserJoined;
  ValueChanged<int>? onRemoteUserLeft;
  VoidCallback? onDisconnected;

  // ─── Getters ─────────────────────────────────────────────────────────
  RtcEngine? get engine => _engine;
  bool get isInitialized => _isInitialized;
  bool get isInChannel => _isInChannel;
  bool get isMicOn => _isMicOn;
  bool get isCamOn => _isCamOn;
  int? get remoteUid => _remoteUid;

  // ─── Permissions ─────────────────────────────────────────────────────
  Future<bool> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();
    return cameraStatus.isGranted && micStatus.isGranted;
  }

  // ─── Initialize Engine ───────────────────────────────────────────────
  Future<void> initialize() async {
    if (_isInitialized && _engine != null) return;

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    // Register event handlers
    _engine!.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        debugPrint('AgoraService: Joined channel ${connection.channelId}');
        _isInChannel = true;
        onJoinSuccess?.call();
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        debugPrint('AgoraService: Remote user $remoteUid joined');
        _remoteUid = remoteUid;
        onRemoteUserJoined?.call(remoteUid);
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        debugPrint('AgoraService: Remote user $remoteUid left');
        _remoteUid = null;
        onRemoteUserLeft?.call(remoteUid);
      },
      onConnectionLost: (RtcConnection connection) {
        debugPrint('AgoraService: Connection lost');
        onDisconnected?.call();
      },
    ));

    await _engine!.enableVideo();
    await _engine!.startPreview();

    _isMicOn = true;
    _isCamOn = true;
    _isInitialized = true;
    debugPrint('AgoraService: Initialized successfully');
  }

  // ─── Join Channel ────────────────────────────────────────────────────
  Future<void> joinChannel(String channelName, {int uid = 0}) async {
    if (!_isInitialized || _engine == null) {
      throw Exception('AgoraService not initialized. Call initialize() first.');
    }

    _remoteUid = null;

    // In testing mode (no token server), pass empty string for token
    await _engine!.joinChannel(
      token: '',
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );

    debugPrint('AgoraService: Joining channel "$channelName"');
  }

  // ─── Leave Channel ───────────────────────────────────────────────────
  Future<void> leaveChannel() async {
    if (_engine != null && _isInChannel) {
      await _engine!.leaveChannel();
      _isInChannel = false;
      _remoteUid = null;
      debugPrint('AgoraService: Left channel');
    }
  }

  // ─── Toggle Microphone ───────────────────────────────────────────────
  Future<void> toggleMic() async {
    _isMicOn = !_isMicOn;
    await _engine?.muteLocalAudioStream(!_isMicOn);
    debugPrint('AgoraService: Mic ${_isMicOn ? "ON" : "OFF"}');
  }

  // ─── Toggle Camera ──────────────────────────────────────────────────
  Future<void> toggleCamera() async {
    _isCamOn = !_isCamOn;
    await _engine?.muteLocalVideoStream(!_isCamOn);
    debugPrint('AgoraService: Camera ${_isCamOn ? "ON" : "OFF"}');
  }

  // ─── Switch Camera (front/rear) ──────────────────────────────────────
  Future<void> switchCamera() async {
    await _engine?.switchCamera();
    debugPrint('AgoraService: Camera switched');
  }

  // ─── Dispose ─────────────────────────────────────────────────────────
  Future<void> dispose() async {
    await leaveChannel();
    if (_engine != null) {
      await _engine!.stopPreview();
      await _engine!.release();
      _engine = null;
      _isInitialized = false;
      debugPrint('AgoraService: Engine disposed');
    }

    // Clear callbacks
    onJoinSuccess = null;
    onRemoteUserJoined = null;
    onRemoteUserLeft = null;
    onDisconnected = null;
  }

  /// Generates a deterministic channel name from an appointment/patient ID.
  /// Both doctor and patient will derive the same channel name.
  static String channelForAppointment(String appointmentId) {
    return 'movewell_$appointmentId';
  }
}
