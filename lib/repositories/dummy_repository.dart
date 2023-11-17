import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skill_test_flutter/app/data/models/dummy_products.dart';

class DummyRepository extends GetConnect {
  final String _baseUrl = 'https://dummyjson.com';

  Future<dynamic> fetchProducts(int skip, int limit) async {
    final storage = GetStorage();
    var checkStorage = storage.read("products");

    final response = await get("${_baseUrl}/products?skip=$skip&limit=$limit");

    var data = DummyProducts.fromJson(response.body);

    storage.write("totalProducts", data.total);
    storage.write("dummyProducts", data);

    if (data.products!.isNotEmpty) {
      if (checkStorage != null) {
        var removeDuplicate = await mergeArrays(checkStorage, data.products!);
        storage.write("products", removeDuplicate);
      } else {
        storage.write("products", data.products);
      }
    }

    return data;
  }

  searchProducts(String search) async {
    final storage = GetStorage();
    var checkStorage = storage.read("products");

    final response = await get("${_baseUrl}/products/search?q=$search");

    var data = DummyProducts.fromJson(response.body);

    if (data.products!.isNotEmpty) {
      if (checkStorage != null) {
        var removeDuplicate = await mergeArrays(checkStorage, data.products!);
        storage.write("products", removeDuplicate);

        return removeDuplicate;
      }
    }
  }
}
