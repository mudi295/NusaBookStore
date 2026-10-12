class Book {
  final String id;
  final String title;
  final String author;
  final int price;
  final String? imageUrl;
  final String category;
  final double rating;
  final int coverColor;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    this.imageUrl,
    this.category = 'Novel',
    this.rating = 4.8,
    this.coverColor = 0xFF800F2F,
  });
}
