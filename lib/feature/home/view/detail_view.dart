import 'package:cached_network_image/cached_network_image.dart';
import 'package:gallery/core.dart';
import 'package:gallery/utils/config/size_config.dart';
import 'package:go_router/go_router.dart';

class DetailView extends StatefulWidget {
  final String id;
  final String url;

  DetailView({super.key, required this.id, required this.url});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  bool isFullScreen = true;

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: widget.id,
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: InteractiveViewer(
                  scaleEnabled: true,
                  maxScale: 100,
                  scaleFactor: 100,
                  trackpadScrollCausesScale: true,
                  child: CachedNetworkImage(
                    height: SizeConfig.screenHeight,
                    width: SizeConfig.screenWidth,
                    imageUrl: widget.url,
                    fit: isFullScreen ? BoxFit.cover : BoxFit.contain,
                    fadeInCurve: Curves.easeIn,
                  ),
                ),
              ),
              Container(
                height: 70.h,
                margin: EdgeInsets.all(20.h),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Card(
                      child: IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(
                          size: 35.h,
                          Icons.arrow_back,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.h),
                    Card(
                      child: IconButton(
                        onPressed: () {
                          isFullScreen = !isFullScreen;
                          setState(() {});
                        },
                        icon: Icon(
                          size: 35.h,
                          isFullScreen
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
