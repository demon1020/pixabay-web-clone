import '/core.dart';

class HomeRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchImagesApi({Map<String, dynamic>? query}) async {
    return await _apiServices.callGetAPI(
        AppUrl.baseUrl, {}, Parser.parseImageResponse,
        query: query!);
  }
}
