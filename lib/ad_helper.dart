import 'dart:io';

import 'package:flutter/foundation.dart';

class AdHelper {

  static String get bannerAdUnitId {
    if (!kReleaseMode) {
      return dotenv.env['TEST_BANNER_UNIT_ID'];
    }
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_BANNER_UNIT_ID'];
    } else if (Platform.isIOS) {
      return dotenv.env['IOS_BANNER_UNIT_ID']; // TODO 변경 필요
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}