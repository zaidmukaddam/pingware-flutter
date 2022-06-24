// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

class WhoisApi {
  WhoisApi({http.Client? client}) : _httpClient = client ?? http.Client();

  static const String _baseUrl =
      'https://whois-dns-api-pingware-eqcbuys6ya-el.a.run.app/whois';
  final http.Client _httpClient;

  Future<String> getWhois(String domain) async {
    final request = Uri.parse('$_baseUrl/$domain');
    late final http.Response response;

    try {
      response = await _httpClient.get(request);
    } catch (exc) {
      throw WhoisRequestFailure();
    }

    if (response.statusCode == 400) {
      throw WhoisRequestFailure();
    }

    if (response.statusCode != 200) {
      throw WhoisNotFound();
    }

    late final Map<String, dynamic> bodyJson;

    try {
      bodyJson = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (exc) {
      throw WhoisNotFound();
    }

    return bodyJson['response'] as String;
  }
}

class WhoisRequestFailure implements Exception {}

class WhoisNotFound implements Exception {}
