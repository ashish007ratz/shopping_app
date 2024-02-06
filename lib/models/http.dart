import 'package:dio/dio.dart';

/// initializing the client
class _Http{
  final Dio dio = Dio();

  Future GetData(path, {Map<String, String> ? qp}) async {
    return dio.get(path, queryParameters: qp);
  }

  Future PostData(path, {required Map<String, dynamic> body, Map<String, String> ? qp}) async {
    return dio.post(path, queryParameters: qp,data: body);
  }

  Future DeleteData(path, {Map<String, String> ? qp}) async {
    return dio.delete(path, queryParameters: qp);
  }

  Future UpdateData(path, {required Map<String, String> body, Map<String, String> ? qp}) async {
    return dio.patch(path, queryParameters: qp, data: body);
  }
}

var http = _Http();