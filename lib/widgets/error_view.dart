import 'package:gallery/core.dart';
import 'package:gallery/utils/config/size_config.dart';

class ErrorView extends StatelessWidget {
  final String errorMessage;
  final String title;
  final bool show;
  final VoidCallback? retry;

  const ErrorView({
    super.key,
    required this.errorMessage,
    this.retry,
    this.title = "Retry",
    this.show = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                height: 500.h,
                fit: BoxFit.contain,
                "assets/icons/error.jpg",
              ),
              Text(
                errorMessage,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Visibility(
                visible: show,
                child: SizedBox(
                  height: 60.h,
                  width: 50.w,
                  child: ElevatedButton(
                    onPressed: retry,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
