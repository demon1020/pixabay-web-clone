import 'package:get/get.dart';

import '../model/image_model.dart';
import '../repository/home_repository.dart';
import '/core.dart';

class HomeViewModel extends GetxController {
  final HomeRepository _myRepo = HomeRepository();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Timer? _debounce;
  Map<String, String> query = {'page': '1', 'per_page': '20', 'id': ''};

  RxInt page = 1.obs;
  RxBool isLoading = false.obs;
  RxList<Hits> imageList = <Hits>[].obs;
  Rx<ApiResponse> apiResponse = ApiResponse.loading().obs;

  setLoading(bool status) => isLoading.value = status;

  setResponse(ApiResponse<GetImageListResponse> response) =>
      apiResponse.value = response;

  RxList<String> popularSearch = [
    "Popular Search: ",
    "background",
    "wallpaper",
    "flowers",
    "woman",
    "business",
    "landscape",
    "cat",
    "people",
    "money",
    "spring",
    "dog",
    "anime",
    "iphone",
  ].obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchTextChanged);
    scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchImages();
    });
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    searchController.removeListener(_onSearchTextChanged);
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void _scrollListener() async {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        !isLoading.value) {
      await fetchNextPage();
    }
  }

  void _onSearchTextChanged() {
    if (_debounce != null && _debounce!.isActive) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchImages(searchController.text);
    });
  }

  Future<void> fetchImages() async {
    query["id"] = "";
    imageList.value = [];
    setResponse(ApiResponse.loading());

    dynamic response = await _myRepo.fetchImagesApi(query: query);

    response.fold((failure) {
      setResponse(ApiResponse.error(failure.message));
      Utils.flushBarErrorMessage(failure.message);
    }, (data) {
      setResponse(ApiResponse.completed(data));
      imageList.addAll(data.hits);
    });
  }

  void searchImages(String searchQuery) async {
    imageList.value = [];
    query["q"] = Uri.encodeQueryComponent(searchQuery);
    query["id"] = "";
    setLoading(true);
    dynamic response = await _myRepo.fetchImagesApi(query: query);

    response.fold((failure) {
      Utils.flushBarErrorMessage(failure.message);
      // setResponse(ApiResponse.error(failure.message));
    }, (data) async {
      setLoading(false);
      RxList<Hits> temp = RxList.from(data.hits);
      imageList = temp;
    });
  }

  Future<void> fetchNextPage() async {
    page++;
    query["page"] = page.toString();
    setLoading(true);
    dynamic response = await _myRepo.fetchImagesApi(query: query);
    response.fold((failure) {
      Utils.flushBarErrorMessage(failure.message);
      // setResponse(ApiResponse.error(failure.message));
    }, (data) async {
      setLoading(false);
      imageList.addAll(data.hits);
      print(page);
    });
  }

// Future<void> getImageById(String id) async {
//   query["id"] = id;
//   setResponse(ApiResponse.loading());
//   dynamic response = await _myRepo.fetchImagesApi(query: query);
//   response.fold((failure) {
//     setResponse(ApiResponse.error(failure.message));
//   }, (data) {
//     setResponse(ApiResponse.completed(data));
//     RxList<Hits> temp = RxList.from(data.hits);
//     imageList.addAll(temp);
//   });
// }
}
