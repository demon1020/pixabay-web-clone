import 'package:dartz/dartz.dart';
import 'package:gallery/feature/home/model/image_model.dart';
import 'package:http/http.dart' as http;

import '../../core.dart';

class Parser {
  static Future<GetImageListResponse> parseImageResponse(
      String responseBody) async {
    return GetImageListResponse.fromJson(json.decode(responseBody));
  }

  static Future<Either<AppException, Q>> parseResponse<Q, R>(
      http.Response response, ComputeCallback<String, R> callback) async {
    if (response == null) {
      print('response is null ');
      return Left(UnknownError());
    } else {
      // log('callback : ${callback.toString()}response.statusCode : ${response.statusCode} | response.body ${response.body}');
      try {
        switch (response.statusCode) {
          case 200:
            {
              var result = await compute(callback, response.body.toString());
              return Right(result as Q);
            }
            break;
          case 400:
            var result = jsonDecode(response.body);

            return Left(
              BadRequestError(),
            );
            break;
          case 401:
            return Left(UnAuthorizedError());
            break;
          case 403:
            var result = jsonDecode(response.body);
            return Left(ForbiddenError());
            break;
          case 404:
            return Left(ServerError(
                statusCode: response.statusCode, message: "File not found"));
            break;
          case 500:
            return Left(ServerError(
                statusCode: response.statusCode, message: "Server Failure"));
            break;
          default:
            return Left(UnknownError(
                statusCode: response.statusCode, message: response.body));
        }
      } catch (e, s) {
        // print(s);
        // throw e;
        return Left(UnknownError());
      }
    }
  }
}
