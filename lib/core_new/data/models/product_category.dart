class ProductCategory {
  final int id;
  final String name;
  final String image;

  ProductCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        id: json['id'],
        name: json['name'],
        image: json['image'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
      };
}
