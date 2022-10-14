class Product {
  final String id;
  final String title;
  final String description;
  final double cost;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}
