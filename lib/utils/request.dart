import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

export 'package:dio/dio.dart';

class Request {
  Dio _dio = Dio();
  CookieJar _cookieJar = CookieJar();

  Request() {
    // 初始化
    _addOptions();

    // 添加cookie和日志的拦截器
    _dio.interceptors.add(CookieManager(_cookieJar));
    _dio.interceptors.add(LogInterceptor(responseBody: false));
  }

  // 添加默认配置
  void _addOptions() {
    // _dio.options.baseUrl = 'http://elearning.ncst.edu.cn/meol/';
    _dio.options.headers = {
      'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36',
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
      'Accept-Encoding': 'gzip',
      'Accept-Language': 'zh-CN,zh;q=0.8,en;q=0.6,zh-TW;q=0.4'
    };
    _dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    // 任意HTTP响应码均不报错
    _dio.options.validateStatus = (code) => true;
  }

  // get方式获取响应
  Future<Response> get(String url, Map<String, Object> query) {
    return _dio.get(url, queryParameters: query);
  }

  // 用get方式获取流式响应
  Future<Response<List<int>>> getStream(
      String url, Map<String, Object> query) async {
    return _dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
      queryParameters: query,
    );
  }

  // 用post方式向url发送内容
  Future<Response> post(String url, Map<String, String> params) {
    return _dio.post(url, data: params);
  }

  // 用post方式向url发送内容并获取流式响应
  Future<Response<List<int>>> postStream(
      String url, Map<String, String> params) {
    return _dio.post<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
      data: params,
    );
  }
}

// 实例化方便使用
Request request = new Request();