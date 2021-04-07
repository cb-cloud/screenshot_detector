import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// プラグイン本体．ネイティブ側で実装したスクリーンショット検知機構を利用して，スクリーンショットが
/// 撮影されたときに登録してあるコールバックを実行する．
class ScreenshotDetector {
  final _channel = MethodChannel('cb-cloud/screenshot_detector');

  final _callbacks = <VoidCallback>[];

  /// `true` のときに権限を確認するためのフラグ． デフォルトは `true`．
  bool requestPermissions;

  /// コールバック実行をするかどうかを制御するためのフラグ．デフォルトは `true`．
  bool isActive;

  bool get hasAnyCallback => _callbacks.isNotEmpty;

  ScreenshotDetector({
    this.requestPermissions = true,
    this.isActive = true,
  }) {
    Future(() async {
      if (Platform.isAndroid && requestPermissions) {
        await Permission.storage.request();
      }

      _channel.setMethodCallHandler((call) => _handleNativeMethodCall(call));
      await _channel.invokeMethod('initialize');
    });
  }

  /// コールバック実行を有効化する．
  void activate() {
    isActive = true;
    _channel.invokeMethod('activate');
  }

  /// コールバック実行を無効化する．
  void inactivate() {
    isActive = false;
    _channel.invokeMethod('inactivate');
  }

  /// コールバックを登録するためのメソッド．
  void addListener(VoidCallback callback) {
    assert(callback != null, 'A non-null callback must be provided.');
    _callbacks.add(callback);
  }

  /// ネイティブからのメソッド呼び出しを制御するメソッド．
  Future<dynamic> _handleNativeMethodCall(MethodCall call) async {
    if (!isActive) return;

    switch (call.method) {
      case 'onCallback':
        for (final callback in _callbacks) {
          callback();
        }
        break;

      default:
        throw UnimplementedError(
            'Method not implemented in ${this.runtimeType}.');
    }
  }

  /// 処理をやめるためのメソッド．`ViewModel` などの `dispose()` に合わせて呼ぶ．
  Future dispose() async {
    _callbacks.clear();
    await _channel.invokeMethod('dispose');
  }
}
