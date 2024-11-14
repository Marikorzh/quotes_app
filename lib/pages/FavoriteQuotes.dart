import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jffff/http/model.dart';

class FavoriteQuotes extends StatefulWidget {
  const FavoriteQuotes({super.key});

  @override
  State<FavoriteQuotes> createState() => _FavoriteQuotesState();
}

class _FavoriteQuotesState extends State<FavoriteQuotes> {
  final quoteBox = Hive.box("quotes");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
            itemCount: quoteBox.length,
            itemBuilder: (context, index){
              final quote = quoteBox.getAt(index) as Quote;

              return ListTile(
                title: Text(quote.quote.toString()),
              );
            }
        ),
      ),
    );
  }
}
