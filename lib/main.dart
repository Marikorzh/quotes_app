import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jffff/pages/RandomQuotePage.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'http/model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(QuoteAdapter());

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: FutureBuilder(
      future: Hive.openBox("quotes"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return RandomQuotePage();
          } else {
            return Text(snapshot.error.toString());
          }
        } else {
          return Scaffold();
        }
      },
    ));
  }
}
