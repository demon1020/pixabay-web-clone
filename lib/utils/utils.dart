import 'package:gallery/utils/config/size_config.dart';

import '/core.dart';

enum Result { success, warning, error }

class Utils {
  static void flushBarErrorMessage(String message, {int duration = 3}) {
    showFlushbar(
      context: AppRouter.router.configuration.navigatorKey.currentContext!,
      flushbar: Flushbar(
        maxWidth: SizeConfig.screenWidth / 2,
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        duration: Duration(seconds: duration),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.BOTTOM,
        backgroundColor: Colors.red,
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        icon: const Icon(
          Icons.error,
          size: 28,
          color: Colors.white,
        ),
      )..show(AppRouter.router.configuration.navigatorKey.currentContext!),
    );
  }

  static snackBar(String message,
      {Result result = Result.success, int duration = 3}) {
    Color getColor(result) {
      if (result == Result.warning) {
        return AppColor.warning;
      }
      if (result == Result.error) {
        return AppColor.error;
      }
      return AppColor.primary;
    }

    return ScaffoldMessenger.of(
            AppRouter.router.configuration.navigatorKey.currentContext!)
        .showSnackBar(
      SnackBar(
        backgroundColor: getColor(result),
        content: Text(message),
        duration: Duration(seconds: duration),
      ),
    );
  }
}
