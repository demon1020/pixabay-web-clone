import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../app_excaptions.dart';

abstract class BaseApiServices {
  Future<Either<AppException, Q>> callPostAPI<Q, R>(String apiURL,
      Map<String, String> headers, ComputeCallback<String, R> callback,
      {body, disableTokenValidityCheck = true});

  Future<Either<AppException, Q>> callPostAPIForm<Q, R>(String apiURL,
      Map<String, String> headers, ComputeCallback<String, R> callback,
      {body, disableTokenValidityCheck = true});

  Future<Either<AppException, Q>> callGetAPI<Q, R>(String apiURL,
      Map<String, String> headers, ComputeCallback<String, R> callback,
      {Map<String, dynamic> query});
}
