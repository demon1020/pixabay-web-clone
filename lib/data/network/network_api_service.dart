import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core.dart';

Duration apiTimeOut = Duration(seconds: 30);

class NetworkApiService extends BaseApiServices {
  @override
  Future<Either<AppException, Q>> callGetAPI<Q, R>(String apiURL,
      Map<String, String> headers, ComputeCallback<String, R> callback,
      {Map<String, dynamic>? query}) async {
    try {
      apiURL = "$apiURL&${Uri(queryParameters: query).query}";
      print('apiURL : $apiURL');

      http.Response response =
          await http.get(Uri.parse(apiURL)).timeout(apiTimeOut);
      if (response != null) {
        return Parser.parseResponse(response, callback);
      }
      return Left(UnknownError());
    } on SocketException {
      return Left(NoInternetError());
    } on TimeoutException {
      return Left(TimeoutError());
    } on HandshakeException {
      return Left(HandshakeError());
    }
  }

  @override
  Future<Either<AppException, Q>> callPostAPI<Q, R>(String apiURL,
      Map<String, String> headers, ComputeCallback<String, R> callback,
      {body, disableTokenValidityCheck = false}) async {
    try {
      print('apiURL : $apiURL');
      print('headers : ${jsonEncode(headers)}');
      print('body : ${jsonEncode(body)}');
      http.Response response = await http
          .post(Uri.parse(apiURL), body: body, headers: headers)
          .timeout(apiTimeOut);
      if (response != null) {
        return Parser.parseResponse(response, callback);
      }
      return Left(UnknownError());
    } on SocketException {
      return Left(NoInternetError());
    } on TimeoutException {
      return Left(TimeoutError());
    } on HandshakeException {
      return Left(HandshakeError());
    }
  }

  @override
  Future<Either<AppException, Q>> callPostAPIForm<Q, R>(String apiURL,
      Map<String, String> headers, ComputeCallback<String, R> callback,
      {body, disableTokenValidityCheck = true}) async {
    try {
      print('apiURL : $apiURL');
      print('headers : ${jsonEncode(headers)}');
      print('body : ${jsonEncode(body)}');
      var request = await http.MultipartRequest("POST", Uri.parse(apiURL));
      if (body != null) {
        body.forEach((key, value) {
          request.fields[key] = value;
          print('Key: $key, Value: $value');
        });
      }

      var response = await http.Response.fromStream(await request.send());

      if (response != null) {
        return Parser.parseResponse(response, callback);
      }
      return Left(UnknownError());
    } on SocketException {
      return Left(NoInternetError());
    } on TimeoutException {
      return Left(TimeoutError());
    } on HandshakeException {
      return Left(HandshakeError());
    }
  }
}
