import 'package:flutter/material.dart';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:jffff/http/http_requests.dart';
import 'package:jffff/http/model.dart';
import 'package:jffff/pages/FavoriteQuotes.dart';

class RandomQuotePage extends StatefulWidget {
  const RandomQuotePage({super.key});

  @override
  State<RandomQuotePage> createState() => _RandomQuotePageState();
}

class _RandomQuotePageState extends State<RandomQuotePage> {
  double size = 12;
  int indexFont = 0;
  bool isLike = false;
  late Color colorBackground;
  late Future<Quote> futureQuote;
  String currentFont = "";
  List<String> fonts = [
    "Noto Sans NKo Unjoined",
    "Noto Serif Old Uyghur",
    "Onest",
    "Pixelify Sans",
    "Playpen Sans",
    "Protest Guerrilla",
    "Protest Revolution",
    "Protest Riot",
    "Protest Strike",
  ];

  @override
  void initState() {
    randomColor();
    getFont();
    futureQuote = fetchQuote();
    super.initState();
  }

  void changeIcon(){
    setState(() {
      isLike = !isLike;
    });
  }

  void addToHive(String quote, String author, String category){
    Quote quotes = Quote(
        quote: quote, author: author, category: category);
    Hive.box("quotes").add(quotes);
    changeIcon();
  }

  void getFont() {
    setState(() {
      indexFont++;
      if (indexFont == fonts.length - 1) indexFont = 0;
    });
    currentFont = fonts[indexFont];
  }

  int randomNumber() {
    return Random().nextInt(256);
  }

  void randomColor() {
    setState(() {
      colorBackground =
          Color.fromRGBO(randomNumber(), randomNumber(), randomNumber(), 50);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => FavoriteQuotes()));
              },
              icon: Icon(Icons.navigate_next_outlined))
        ],
      ),
        backgroundColor: colorBackground,
        body: FutureBuilder<Quote>(
          future: futureQuote,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildQuotePage(snapshot);
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }

  Widget buildQuotePage(AsyncSnapshot<Quote> quote) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              quote.data!.quote,
              style: GoogleFonts.getFont(
                currentFont,
                fontSize: size,
              ),
            ),
          ),
          Slider(
            value: size,
            min: 12,
            max: 30,
            onChanged: (value) {
              setState(() {
                size = value;
              });
            },
          ),
          IconButton(
              iconSize: 35,
              onPressed: () => addToHive(
                  quote.data!.quote,
                  quote.data!.author,
                  quote.data!.category
              ),
              icon: Icon(
                  isLike ? Icons.favorite : Icons.favorite_border)),
          ElevatedButton(
              onPressed: () => getFont(), child: Text("Зміна шрифта")),
          ElevatedButton(
              onPressed: () {
                randomColor();
              },
              child: Text("Зміна кольору фону")),
        ],
      ),
    );
  }
}
