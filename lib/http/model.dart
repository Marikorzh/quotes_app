import 'package:hive/hive.dart';

part 'model.g.dart';

@HiveType(typeId: 0)
class Quote{
  @HiveField(0)
  final String quote;
  @HiveField(1)
  final String author;
  @HiveField(2)
  final String category;

  const Quote({
    required this.quote,
    required this.author,
    required this.category
  });

  factory Quote.fromJson(Map<String, dynamic> json){
    return switch (json){
      {"quote" : String quote,
      "author" : String author,
      "category" : String category,}
      =>
          Quote(
              quote: quote,
              author: author,
              category: category
          ),
      _ => throw const FormatException('Failed to load album.'),

    };
  }
}