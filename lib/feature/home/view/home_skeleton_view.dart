import 'package:flutter/material.dart';
import 'package:gallery/resources/asset_constants.dart';
import 'package:gallery/resources/text_constants.dart';
import 'package:gallery/utils/config/size_config.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../../../resources/color.dart';
import '../../../widgets/app_textfield.dart';

class HomeSkeletonView extends StatelessWidget {
  const HomeSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Skeletonizer(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 350.h,
              floating: true,
              pinned: false,
              centerTitle: false,
              foregroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                background: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(AssetConstants.placeholder),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        TextConstants.heading,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColor.white,
                        ),
                      ),
                      Text(
                        TextConstants.subHeading,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColor.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                title: Container(
                  margin: EdgeInsets.only(bottom: 10.h, right: 70.h),
                  child: AppTextField(
                    hintText: "Search for all images on Pixabay",
                  ),
                ),
              ),
              title: SvgPicture.asset(
                width: 30.w,
                height: 50.h,
                AssetConstants.logoSvg,
                theme: SvgTheme(currentColor: AppColor.black),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
            SliverToBoxAdapter(
              child: Container(
                  margin: EdgeInsets.all(20.h),
                  child: Wrap(
                    runSpacing: 10.h,
                    spacing: 10.h,
                    alignment: WrapAlignment.start,
                    children: List.generate(
                      18,
                      (index) => index == 0
                          ? Text(
                              TextConstants.popularSearch,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 15.sp,
                              ),
                            )
                          : ChoiceChip(
                              onSelected: (isTrue) {},
                              selectedColor: Colors.grey.shade300,
                              checkmarkColor: Colors.black,
                              elevation: 0,
                              label: Text("data"),
                              selected: false,
                            ),
                    ),
                  )),
            ),
            buildSkeletonGridView(context),
          ],
        ),
      ),
    );
  }

  Widget buildSkeletonGridView(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(10.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width ~/ 250,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Center(
              child: Card(
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                        child: Image.asset(
                          AssetConstants.placeholder,
                          width: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'item.likes',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.thumb_up,
                                    size: 15,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'item.downloads',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.download,
                                    size: 15,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'item.views',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.remove_red_eye,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: 30,
        ),
      ),
    );
  }
}
