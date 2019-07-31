import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:gbk2utf8/gbk2utf8.dart';

export 'package:dio/dio.dart';

/// 封装dio操作的的请求类
class Request {
  Dio _dio = Dio();

  Request() {
    // 初始化
    _addOptions();
    _addInterceptors();
  }

  /// 添加拦截器
  void _addInterceptors() {
    // 添加cookie和日志的拦截器
    _dio.interceptors.add(CookieManager(CookieJar()));
    _dio.interceptors.add(LogInterceptor(responseBody: false));
  }

  /// 添加默认配置
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
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 10000;
  }

  /// get方式获取响应
  Future<Response> get(String url, [Map query]) {
    return _dio.get(url, queryParameters: query);
  }

  /// 用get方式获取流式响应
  Future<Response<List<int>>> getStream(String url, [Map query]) async {
    return _dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
      queryParameters: query,
    );
  }

  /// 获取转码后的响应文本
  /// 因为教务系统和教学系统的页面都是GBK编码，所以要进行一次转码
  ///
  /// url: 请求地址
  Future<String> getContent(String url) async {
    // 获取字节流并转换成gbk编码的文本
    Response<List<int>> response = await getStream(url);
    if (response.statusCode == 200) {
      return gbk.decode(response.data);
    }
    return null;
  }

  /// 用post方式向url发送内容
  Future<Response> post(String url, Map params) {
    return _dio.post(url, data: params);
  }

  /// 用post方式向url发送内容并获取流式响应
  Future<Response<List<int>>> postStream(String url, Map params) {
    return _dio.post<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
      data: params,
    );
  }

  download(String url,
      String savePath, {
        ProgressCallback onReceiveProgress,
        CancelToken cancelToken,
      }) {
    return _dio.download(
      url,
      savePath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      options: Options(receiveTimeout: 100000),
    );
  }
}

// 实例化方便使用
Request request = new Request();
