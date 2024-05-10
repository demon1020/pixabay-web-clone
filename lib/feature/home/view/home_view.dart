import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gallery/core.dart';
import 'package:gallery/feature/home/model/image_model.dart';
import 'package:gallery/resources/asset_constants.dart';
import 'package:gallery/resources/text_constants.dart';
import 'package:gallery/utils/config/size_config.dart';
import 'package:gallery/widgets/error_view.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:svg_flutter/svg.dart';

import '../../../widgets/app_textfield.dart';
import '../view_model/home_view_model.dart';
import 'home_skeleton_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel viewModel = Get.put(HomeViewModel());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (viewModel.apiResponse.value.status) {
        case Status.loading:
          return HomeSkeletonView();

        case Status.error:
          return ErrorView(
            errorMessage: viewModel.apiResponse.value.message.toString(),
            show: true,
            retry: () async {
              await viewModel.fetchImages();
            },
          );

        case Status.completed:
          return SizeConfig.isWebTrue ? buildWebBody() : buildMobileBody();
        default:
          return Center(child: Text('Default'));
      }
    });
  }

  Scaffold buildWebBody() {
    return Scaffold(
      body: CustomScrollView(
        // key: ValueKey<int>(0),
        controller: viewModel.scrollController,
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
                    image: NetworkImage(
                      "https://cdn.pixabay.com/index/2024/04/30/20-56-35-555_1920x550.jpg",
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Stunning royalty-free images & royalty-free stock',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColor.white,
                      ),
                    ),
                    Text(
                      'Over 4.5 million+ high quality stock images, videos and music shared by our talented community.',
                      style: TextStyle(
                        fontSize: 12.sp,
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
                  height: 70.h,
                  width: 200.w,
                  controller: viewModel.searchController,
                  hintText: "Search for all images on Pixabay",
                  suffix: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      'Images',
                      style: TextStyle(
                        color: AppColor.primary.withGreen(100),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            title: SvgPicture.asset(
              width: 30.w,
              height: 50.h,
              "assets/icons/logo.svg",
              color: AppColor.white,
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
                  children: viewModel.popularSearch
                      .map(
                        (element) => element == "Popular Search: "
                            ? Text(
                                element,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                ),
                              )
                            : ChoiceChip(
                                onSelected: (isTrue) {
                                  viewModel.searchController.text = element;
                                  viewModel.searchImages(element);
                                },
                                selectedColor: Colors.grey.shade300,
                                checkmarkColor: Colors.black,
                                elevation: 0,
                                label: Text(element),
                                selected:
                                    viewModel.searchController.text == element
                                        ? true
                                        : false,
                              ),
                      )
                      .toList()),
            ),
          ),
          !viewModel.isLoading.value && viewModel.imageList.isEmpty
              ? SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Divider(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "No results for ",
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                            TextSpan(
                              text: viewModel.searchController.text,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColor.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: ", try something else.",
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            )
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.only(left: 10.h, right: 10.h),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width ~/ 250,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        var item = viewModel.imageList[index];
                        return AnimationConfiguration.staggeredGrid(
                          key: ValueKey<int>(index),
                          position: index,
                          duration: const Duration(milliseconds: 300),
                          columnCount: SizeConfig.screenWidth ~/ 250,
                          child: ScaleAnimation(
                            child: buildImageItem(item),
                          ),
                        );
                      },
                      childCount: viewModel.imageList.length,
                    ),
                  ),
                ),
        ],
      ),
      bottomNavigationBar: viewModel.isLoading.value
          ? SizedBox(
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Scaffold buildMobileBody() {
    return Scaffold(
      body: CustomScrollView(
        controller: viewModel.scrollController,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 150.h,
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
                    image: NetworkImage(
                      AssetConstants.backgroundImage,
                    ),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(10.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppTextField(
                        height: 60.h,
                        width: SizeConfig.screenWidth,
                        controller: viewModel.searchController,
                        hintText: TextConstants.searchHint,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            title: SvgPicture.asset(
              width: 30.w,
              height: 30.h,
              AssetConstants.logoSvg,
              color: AppColor.white,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(10.h),
              child: Column(
                children: [
                  Text(
                    viewModel.popularSearch.first,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                      runSpacing: 10.h,
                      spacing: 10.h,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.spaceEvenly,
                      children: viewModel.popularSearch
                          .sublist(1, 12)
                          .map(
                            (element) => ChoiceChip(
                              onSelected: (isTrue) {
                                viewModel.searchController.text = element;
                                viewModel.searchImages(element);
                              },
                              selectedColor: Colors.grey.shade300,
                              checkmarkColor: Colors.black,
                              elevation: 0,
                              label: Text(element),
                              selected:
                                  viewModel.searchController.text == element
                                      ? true
                                      : false,
                            ),
                          )
                          .toList()),
                ],
              ),
            ),
          ),
          !viewModel.isLoading.value && viewModel.imageList.isEmpty
              ? SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Divider(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: TextConstants.noResultPart1,
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                            TextSpan(
                              text: viewModel.searchController.text,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColor.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: TextConstants.noResultPart2,
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            )
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.only(left: 10.h, right: 10.h),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width ~/ 250,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        var item = viewModel.imageList[index];
                        return AnimationConfiguration.staggeredGrid(
                          key: ValueKey<int>(index),
                          position: index,
                          duration: const Duration(milliseconds: 300),
                          columnCount: SizeConfig.screenWidth ~/ 250,
                          child: ScaleAnimation(
                            child: buildImageItem(item),
                          ),
                        );
                      },
                      childCount: viewModel.imageList.length,
                    ),
                  ),
                ),
        ],
      ),
      bottomNavigationBar: viewModel.isLoading.value
          ? SizedBox(
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget buildImageItem(Hits item) {
    return GestureDetector(
      onTap: () {
        context.go("/${AppRoute.detail}/${item.id}",
            extra: "${item.largeImageURL}");
      },
      child: Hero(
        tag: item.id.toString(),
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
                  child: CachedNetworkImage(
                    imageUrl: item.webformatURL.toString(),
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${item.likes}',
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
                            '${item.downloads}',
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
                            '${item.views}',
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
            ],
          ),
        ),
      ),
    );
  }
}
