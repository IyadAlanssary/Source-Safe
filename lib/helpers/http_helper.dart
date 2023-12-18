// import 'dart:convert';
// import 'dart:developer' as dev;
// import 'dart:math' as math;
// import 'package:http/http.dart' as http;
// import 'package:network_applications/helpers/storage_helper.dart';
//
// import '../constants/api.dart';
// import '../constants/strings.dart';
//
// // final httpHelper = Provider<HttpHelper>((ref) {
// //   return HttpHelperImpl(storage: ref.watch(storageHelper));
// // });
//
// enum _Verb { get, post, put, patch, delete }
//
// abstract class HttpHelper {
//   Future<http.Response> get(
//     String path, {
//     Map<String, String>? queryParameters,
//     Map<String, String>? headers,
//   });
//
//   Future<http.Response> post(
//     String path, {
//     Map<String, String>? queryParameters,
//     Map<String, dynamic>? body,
//     Map<String, String>? headers,
//   });
//
//   Future<http.Response> put(
//     String path, {
//     Map<String, String>? queryParameters,
//     Map<String, dynamic>? body,
//     Map<String, String>? headers,
//   });
//
//   Future<http.Response> patch(
//     String path, {
//     Map<String, String>? queryParameters,
//     Map<String, dynamic>? body,
//     Map<String, String>? headers,
//   });
//
//   Future<http.Response> delete(
//     String path, {
//     Map<String, String>? queryParameters,
//     Map<String, dynamic>? body,
//     Map<String, String>? headers,
//   });
// }
//
// class HttpHelperImpl extends HttpHelper {
//   final StorageHelper storage;
//
//   HttpHelperImpl({required this.storage});
//
//   @override
//   Future<http.Response> get(
//     String path, {
//     Map<String, String>? queryParameters,
//     Map<String, String>? headers,
//   }) =>
//       _sendRequest(_Verb.get, path,
//           queryParameters: queryParameters, headers: headers);
//
//   @override
//   Future<http.Response> post(
//     String path, {
//     Map<String, String>? queryParameters,
//     Map<String, dynamic>? body,
//     Map<String, String>? headers,
//   }) =>
//       _sendRequest(_Verb.post, path,
//           queryParameters: queryParameters, body: body, headers: headers);
//
//   @override
//   Future<http.Response> put(
//     String path, {
//     Map<String, String>? queryParameters,
//     Map<String, dynamic>? body,
//     Map<String, String>? headers,
//   }) =>
//       _sendRequest(_Verb.put, path,
//           queryParameters: queryParameters, body: body, headers: headers);
//
//   @override
//   Future<http.Response> patch(
//     String path, {
//     Map<String, String>? queryParameters,
//     Map<String, dynamic>? body,
//     Map<String, String>? headers,
//   }) =>
//       _sendRequest(_Verb.patch, path,
//           queryParameters: queryParameters, body: body, headers: headers);
//
//   @override
//   Future<http.Response> delete(
//     String path, {
//     Map<String, String>? queryParameters,
//     Map<String, dynamic>? body,
//     Map<String, String>? headers,
//   }) =>
//       _sendRequest(_Verb.delete, path,
//           queryParameters: queryParameters, body: body, headers: headers);
//
//   Future<http.Response> _sendRequest(
//     _Verb verb,
//     String path, {
//     Map<String, String>? queryParameters,
//     Map<String, dynamic>? body,
//     Map<String, String>? headers,
//   }) async {
//     final uri = _makeUri(path, queryParameters: queryParameters);
//     final allHeaders = _makeHeaders(extraHeaders: headers);
//     final encoded = body == null ? null : jsonEncode(body);
//     dev.log(uri.toString(), name: "HttpHelper.${verb.name}");
//     dev.log(allHeaders.toString(), name: "HttpHelper.${verb.name}.headers");
//     dev.log(body.toString(), name: "HttpHelper.${verb.name}.body");
//     final http.Response response;
//     switch (verb) {
//       case _Verb.get:
//         response = await http.get(uri, headers: allHeaders);
//         break;
//       case _Verb.post:
//         response = await http.post(uri, body: encoded, headers: allHeaders);
//         break;
//       case _Verb.put:
//         response = await http.put(uri, body: encoded, headers: allHeaders);
//         break;
//       case _Verb.patch:
//         response = await http.patch(uri, body: encoded, headers: allHeaders);
//         break;
//       case _Verb.delete:
//         response = await http.delete(uri, body: encoded, headers: allHeaders);
//         break;
//     }
//     dev.log(
//       response.body.substring(0, math.min(response.body.length, 100)),
//       name: "HttpHelper.${verb.name}.response",
//     );
//     if (response.statusCode == 401 && token.isNotEmpty) {
//       await storage.remove(StorageKeys.accessToken);
//       throw Exception("Expired access token");
//     } else if (response.statusCode != 200 && response.statusCode != 201) {
//       throw Exception(
//         jsonDecode(response.body)["message"]?.toString() ??
//             response.statusCode.toString(),
//       );
//     }
//     return response;
//   }
//
//   Uri _makeUri(String path, {Map<String, String>? queryParameters}) =>
//       Uri.https(baseUrl, [basePath, path].join(), queryParameters);
//
//   Map<String, String> _makeHeaders({Map? extraHeaders}) {
//     return {
//       "Accept": "application/json",
//       "Content-Type": "application/json",
//       if (token.isNotEmpty) "Authorization": "Bearer $token",
//       ...?extraHeaders,
//     };
//   }
//
//   String get token {
//     return storage.getString(StorageKeys.accessToken) ?? "";
//   }
// }
