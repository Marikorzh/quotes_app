class Quote{
  final String quote;
  final String author;
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