import 'pivot.dart';

class Product {
  int? id;
  String? name;
  String? description;
  dynamic price;
  int? categoryId;
  String? image;
  String? length;
  String? width;
  String? height;
  String? weight;
  int? merchantId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  Pivot? pivot;
  int? quantity = 1;
  ProductCategory? productCategory;

  Product(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.categoryId,
      this.image,
      this.length,
      this.width,
      this.height,
      this.weight,
      this.merchantId,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.pivot,
      this.quantity,
      this.productCategory});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    categoryId = json['category_id'];
    image = json['image'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    weight = json['weight'];
    merchantId = json['merchant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
    productCategory = json['product_category'] != null
        ? ProductCategory.fromJson(json['product_category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['category_id'] = categoryId;
    data['image'] = image;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['weight'] = weight;
    data['merchant_id'] = merchantId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (pivot != null) {
      data['pivot'] = pivot?.toJson();
    }
    if (productCategory != null) {
      data['product_category'] = productCategory?.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, price: $price, categoryId: $categoryId, image: $image, length: $length, width: $width, height: $height, weight: $weight, merchantId: $merchantId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, pivot: $pivot, quantity: $quantity}';
  }
}

class ProductCategory {
  int? id;
  String? name;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ProductCategory(
      {this.id,
      this.name,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
