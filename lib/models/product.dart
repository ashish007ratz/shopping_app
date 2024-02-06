import 'http.dart';

class ProductModel {
  int id;
  String title;
  String price;
  String category;
  String description;
  String image;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.description,
    required this.image,
  });

  // Convert Product object to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'category': category,
    'description': description,
    'image': image,
  };

  // Create Product object from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] as int,
    title: json['title'] as String,
    price: "${json['price']??"0.0"}",
    category: json['category'] as String,
    description: json['description'] as String,
    image: json['image'] as String,
  );

  // Fetch list of Products
  static Future<List<ProductModel>> fetchProducts() async {
    final response = await http.GetData('https://fakestoreapi.com/products');
    if (response.statusCode == 200) {
      print(response);
      final List<dynamic> jsonProducts = response.data;
      return jsonProducts.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  // Fetch single Product by ID
  static Future<ProductModel> fetchProductById(int id) async {
    final response = await http.GetData('https://fakestoreapi.com/products/$id');
    if (response.statusCode == 200) {
      /// converting response into json
      print(response.data);
      return ProductModel.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch product');
    }
  }
}

class CartModel{
  int itemKey;
  int itemCount;
  ProductModel product;
  CartModel({required this.itemKey,required this.itemCount,required this.product});
}