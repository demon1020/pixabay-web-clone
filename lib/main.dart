import 'package:gallery/core.dart';
import 'package:gallery/utils/config/size_config.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            SizeConfig.init(constraints, orientation);
            return GetMaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Pixabay Clone',
              themeMode: ThemeMode.system,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              routeInformationParser: AppRouter.router.routeInformationParser,
              routerDelegate: AppRouter.router.routerDelegate,
              routeInformationProvider:
                  AppRouter.router.routeInformationProvider,
            );
          },
        );
      },
    );
  }
}
