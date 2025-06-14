import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/local_storage.dart';

class ApiService {
  final String baseUrl;
  final LocalStorage localStorage;

  ApiService({
    // this.baseUrl = 'http://192.168.8.101:3008/api',
    // this.baseUrl = 'http://192.168.8.100:3008/api',
    // this.baseUrl = 'http://192.168.8.104:3008/api',
    this.baseUrl = 'https://transport-booking-api.gexperten.tech/api',
    required this.localStorage,
  });

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
      final token = await localStorage.getToken();

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      return _handleResponse(response);
    } catch (e) {
      throw 'Failed to GET $endpoint: $e';
    }
  }

  Future<dynamic> post(String endpoint, dynamic data) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final token = await localStorage.getToken();

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw 'Failed to POST $endpoint: $e';
    }
  }

  Future<dynamic> put(String endpoint, dynamic data) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final token = await localStorage.getToken();

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw 'Failed to PUT $endpoint: $e';
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final token = await localStorage.getToken();

      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      return _handleResponse(response);
    } catch (e) {
      throw 'Failed to DELETE $endpoint: $e';
    }
  }

  dynamic _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded; // Can be Map or List
    } else {
      final error = decoded is Map ? decoded['error'] : 'Unknown error';
      throw error ?? 'Request failed with status ${response.statusCode}';
    }
  }
}




// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';
//
// import '../services/local_storage.dart';
//
// class ApiService {
//   final String baseUrl;
//   final LocalStorage localStorage;
//
//   ApiService({this.baseUrl = 'http://192.168.8.101:3008/api', required this.localStorage});
//
//   Future<Map<String, dynamic>> get(String endpoint, {Map<String, dynamic>? params}) async {
//     try {
//       final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
//       final token = await localStorage.getToken();
//
//       final response = await http.get(
//         uri,
//         headers: {
//           'Content-Type': 'application/json',
//           if (token != null) 'Authorization': 'Bearer $token',
//         },
//       );
//       return _handleResponse(response);
//     } catch (e) {
//       throw 'Failed to GET $endpoint: $e';
//     }
//   }
//
//   Future<Map<String, dynamic>> post(String endpoint, dynamic data) async {
//     try {
//       final uri = Uri.parse('$baseUrl$endpoint');
//       final token = await localStorage.getToken();
//
//       final response = await http.post(
//         uri,
//         headers: {
//           'Content-Type': 'application/json',
//           if (token != null) 'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(data),
//       );
//
//       return _handleResponse(response);
//     } catch (e) {
//       throw 'Failed to POST $endpoint: $e';
//     }
//   }
//
//   Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
//     try {
//       final uri = Uri.parse('$baseUrl$endpoint');
//       final token = await localStorage.getToken();
//
//       final response = await http.put(
//         uri,
//         headers: {
//           'Content-Type': 'application/json',
//           if (token != null) 'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(data),
//       );
//
//       return _handleResponse(response);
//     } catch (e) {
//       throw 'Failed to PUT $endpoint: $e';
//     }
//   }
//
//   Future<Map<String, dynamic>> delete(String endpoint) async {
//     try {
//       final uri = Uri.parse('$baseUrl$endpoint');
//       final token = await localStorage.getToken();
//
//       final response = await http.delete(
//         uri,
//         headers: {
//           'Content-Type': 'application/json',
//           if (token != null) 'Authorization': 'Bearer $token',
//         },
//       );
//
//       return _handleResponse(response);
//     } catch (e) {
//       throw 'Failed to DELETE $endpoint: $e';
//     }
//   }
//
//   Map<String, dynamic> _handleResponse(http.Response response) {
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       return jsonDecode(response.body);
//     } else {
//       final error = jsonDecode(response.body);
//       throw error['error'] ?? 'Request failed with status ${response.statusCode}';
//     }
//   }
// }