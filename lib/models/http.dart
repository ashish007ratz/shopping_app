import 'package:dio/dio.dart';

/// initializing the client
class _Http{
  final Dio dio = Dio();
  Future get(url) => dio.get(url);
}

var http = _Http();