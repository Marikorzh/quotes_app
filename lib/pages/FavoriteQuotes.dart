import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jffff/http/model.dart';

class FavoriteQuotes extends StatefulWidget {
  final Color backgroundColor;
  const FavoriteQuotes({
    super.key,
    required this.backgroundColor,
  });

  @override
  State<FavoriteQuotes> createState() => _FavoriteQuotesState();
}

class _FavoriteQuotesState extends State<FavoriteQuotes> {
  final quoteBox = Hive.box("quotes");
  late List<GlobalKey> containerKeys;
  Map<int, double> tileHeights = {};

  @override
  void initState() {
    super.initState();
    containerKeys = List<GlobalKey>.generate(
        quoteBox.length, (int index) => GlobalKey(),
        growable: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateHeights();
    });
  }

  void _calculateHeights() {
    Map<int, double> newTileHeights = {};
    for (int i = 0; i < containerKeys.length; i++) {
      final context = containerKeys[i].currentContext;
      if (context != null) {
        final height = context.size?.height;
        if (height != null) {
          newTileHeights[i] = height;
        }
      }
    }
    setState(() {
      tileHeights = newTileHeights;
    });
  }

  double _borderRadius(int index) {
    return tileHeights[index] != null ? (tileHeights[index]! / 2).clamp(8.0, 20.0) : 12.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My favorite"),
      ),
      backgroundColor: widget.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: SafeArea(
            child: ListView.builder(
                itemCount: quoteBox.length,
                itemBuilder: (context, index) {
                  final quote = quoteBox.getAt(index) as Quote;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        child: ListTile(
                          key: containerKeys[index],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_borderRadius(index)),
                          ),
                          tileColor: Colors.white,
                          title: Text(
                            quote.quote.toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
