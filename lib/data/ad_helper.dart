import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2268924820751234/1847291913";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw  UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2268924820751234/1847291913";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/5135589800";
    } else {
      throw  UnsupportedError("Unsupported platform");
    }
  }
}