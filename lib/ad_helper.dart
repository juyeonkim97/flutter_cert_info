import 'dart:io';

import 'package:flutter/foundation.dart';

class AdHelper {

  static String get bannerAdUnitId {
    if (!kReleaseMode) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    if (Platform.isAndroid) {
      return 'ca-app-pub-3216336784534816/4188846193';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // TODO 변경 필요
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}