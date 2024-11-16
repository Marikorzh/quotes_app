import 'dart:convert';

import 'package:jffff/StringUrl.dart';
import 'package:jffff/http/model.dart';
import "package:http/http.dart" as http;

StringUrl strUri = StringUrl();

Future<Quote> fetchQuote() async {
  final response = await http.get(strUri.url,
      headers: {
        strUri.headerKey : strUri.headerValue});

  if (response.statusCode == 200) {
    return Quote.fromJson(jsonDecode(response.body)[0]);
  } else {
    throw Exception('Failed to load album');
  }
}