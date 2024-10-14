import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../Models/category.dart';
import '../Models/category_data.dart';
import '../Models/image.dart';
import '../Models/last_5_main_product.dart';
import '../Models/main_product.dart';
import '../Models/product_model.dart';
import '../Utilits/constants.dart';
import '../httpHelper/http_helper.dart';
import 'auth_provider.dart';

class ProductProvider with ChangeNotifier {
  static ProductProvider get(BuildContext context) =>
      Provider.of<ProductProvider>(context);

  static ProductProvider listenFalse(BuildContext context) =>
      Provider.of<ProductProvider>(context, listen: false);
  List<CategoryData> _categories = [];
  bool _imageLoading = false;
  bool _isLoading = false;
  bool _productIsEmpty = true;
  bool _last5ProductIsEmpty = true;
  List<Product> _products = [];
  List<Product> _last5Products = [];
  List<Product> _productsSearch = [];
  Product? _productById;
  NetworkState? _productState;
  NetworkState? _productByIdState;
  NetworkState? _state;
  NetworkState? _removeProductState;
  NetworkState _last5ProductState = NetworkState.WAITING;
  NetworkState _catState = NetworkState.WAITING;
  bool _refreshing = false;
  bool _addProductLoading = false;

  NetworkState? get state => _state;

  NetworkState? get removeProductState => _removeProductState;

  bool get addProductLoading => _addProductLoading;

  bool get refreshing => _refreshing;

  NetworkState? get productState => _productState;

  bool get imageLoading => _imageLoading;

  bool get isLoading => _isLoading;

  void setImageLoading(bool value) {
    _imageLoading = value;
    notifyListeners();
  }

  NetworkState? get productByIdState => _productByIdState;

  void setProductLoading(bool v) {
    _addProductLoading = v;
    notifyListeners();
  }

  Future<void> getAllCategories() async {
    _categories = [];
    try {
      _catState = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpGet(
        'product-categories',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Categories model = Categories.fromJson(
          jsonDecode(r.body),
        );
        _categories = model.data!;
        _catState = NetworkState.SUCCESS;
      } else {
        _catState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }

    notifyListeners();
  }

  List<CategoryData> get categories => _categories;

  Future<void> addProduct(Product p) async {
    try {
      _state = NetworkState.WAITING;
      notifyListeners();
      Response r = await HttpHelper.instance.httpPost(
        'products',
        true,
        body: p.toJson(),
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _products.add(p);
        _productIsEmpty = _products.isEmpty;
        notifyListeners();
        _state = NetworkState.SUCCESS;
      } else {
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      _state = NetworkState.ERROR;
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> clearProductList() async {
    _refreshing = true;
    notifyListeners();
    _products.clear();
    notifyListeners();
    await getProducts(true);
    _refreshing = false;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Product? get productById => _productById;

  Future<void> getProductById(int id) async {
    try {
      _productByIdState = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpGet(
        'products/$id',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _productById = Product.fromJson(
          jsonDecode(r.body),
        );
        _productByIdState = NetworkState.SUCCESS;
      } else {
        _productByIdState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  void filterProducts(String title) {
    _productsSearch = [];
    _productsSearch = _products
        .where(
          (element) =>
              element.name?.toLowerCase().contains(title.toLowerCase()) ??
              false,
        )
        .toList();
    notifyListeners();
  }

  List<Product> get productsSearch => _productsSearch;

  Future<Img?> uploadPhoto({
    String? path,
    String? imageName,
  }) async {
    try {
      Response response = await HttpHelper.instance.httpPost(
        'products/upload-image',
        true,
        body: {
          'file': path,
          'filename': imageName,
        },
      );
      log('image -> ${response.body}');
      log('image -> ${response.statusCode}');
      if (response.statusCode == 200) {
        return Img.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> deletePhoto({
    required String token,
    required String imageName,
  }) async {
    try {
      Response response = await HttpHelper.instance.httpPost(
        'products/delete-image',
        true,
        body: {
          'filename': imageName,
          'token': token,
        },
      );
      if (response.statusCode == 200) {
        return AuthProvider.success;
      } else {
        return 'Error';
      }
    } catch (e) {
      return 'Error';
    }
  }

  Future<void> getProducts(bool isRefreshing) async {
    _products = [];
    try {
      if (!isRefreshing) {
        _productState = NetworkState.WAITING;
      }
      Response r = await HttpHelper.instance.httpGet(
        'products',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        log('products -> ${json.decode(r.body)}');
        MainProduct main = MainProduct.fromJson(jsonDecode(r.body));
        _products = main.data!;
        _productIsEmpty = _products.isEmpty;
        _productState = NetworkState.SUCCESS;
      } else {
        log('products -> ${r.statusCode}');
        _productState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> getLast5Products() async {
    _last5Products = [];
    try {
      _last5ProductState = NetworkState.WAITING;
      Response r = await HttpHelper.instance.httpGet(
        'products?paginate=5',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Last5MainProduct main = Last5MainProduct.fromJson(jsonDecode(r.body));
        _last5Products = main.data!;
        _last5ProductIsEmpty = last5Products.isEmpty;
        _last5ProductState = NetworkState.SUCCESS;
      } else {
        _last5ProductState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  bool get last5ProductIsEmpty => _last5ProductIsEmpty;

  Future<void> removeProduct(int id) async {
    try {
      _removeProductState = NetworkState.WAITING;
      _products.removeWhere((p) => p.id == id);
      _productIsEmpty = _products.isEmpty;
      notifyListeners();
      Response r = await HttpHelper.instance.httpDelete(
        'products/$id',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _removeProductState = NetworkState.SUCCESS;
      } else {
        _removeProductState = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateProduct(Product p) async {
    try {
      _state = NetworkState.WAITING;
      notifyListeners();
      Response r = await HttpHelper.instance.httpPost(
        'products/${p.id}?_method=PUT',
        true,
        body: p.toJson(),
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        int productIndex = _products.indexWhere(
          (item) => item.id == p.id,
        );
        _products[productIndex] = p;
        _state = NetworkState.SUCCESS;
      } else {
        _state = NetworkState.ERROR;
      }
    } catch (e) {
      log(e.toString());
      _state = NetworkState.ERROR;
    }
    notifyListeners();
  }

  bool get productIsEmpty => _productIsEmpty;

  CategoryData? getCatById(int id) {
    int index = _categories.indexWhere((element) => element.id == id);
    if (index == -1) {
      return null;
    }
    return _categories[index];
  }

  List<Product> get products => _products;

  List<Product> get last5Products => _last5Products;

  NetworkState get last5ProductState => _last5ProductState;

  NetworkState get catState => _catState;
}
