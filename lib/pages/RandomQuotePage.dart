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
  double size = 20;
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

  void doIt() async{
    setState(() {
      futureQuote = fetchQuote();
    });
  }

  void changeIcon() {
    setState(() {
      isLike = !isLike;
    });
  }

  void addToHive(Quote? quotes) {
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
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FavoriteQuotes(backgroundColor: colorBackground,)));
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
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        height: 500,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                quote.data!.quote,
                style: GoogleFonts.getFont(
                  currentFont,
                  fontSize: size,
                ),
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                  onPressed: () => doIt(),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(colorBackground),
                  ),
                  child: Text("New Quote", style: TextStyle(color: Colors.white, fontSize: 18),)),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _circularIconButton(Icon(Icons.text_fields, size: 30), getFont),
                RawMaterialButton(
                  onPressed: () => addToHive(quote.data),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  child: Icon(
                    isLike ? Icons.favorite : Icons.favorite_border,
                    size: 30,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                ),
                _circularIconButton(
                    Icon(Icons.palette_outlined, size: 30), randomColor),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _circularIconButton(Icon icon, Function func) {
    return RawMaterialButton(
      onPressed: () => func(),
      elevation: 2.0,
      fillColor: Colors.white,
      child: icon,
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(),
    );
  }
}
