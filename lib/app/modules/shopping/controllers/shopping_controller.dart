import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:skill_test_flutter/app/data/models/dummy_products.dart';
import 'package:skill_test_flutter/app/modules/cart/controllers/cart_controller.dart';
import 'package:skill_test_flutter/repositories/dummy_repository.dart';

class ShoppingController extends GetxController {
  final cartController = Get.put(CartController());
  final ScrollController scrollController = ScrollController();
  final DummyRepository _dummyRepository = DummyRepository();
  var dummyProducts = DummyProducts().obs;
  var products = <Products>[].obs;
  var tempProducts = <Products>[].obs;
  var searchProducts = <Products>[].obs;
  final totalPage = 1.obs;
  final page = 1.obs;
  final hasMore = true.obs;
  final searching = false.obs;
  final perPage = 30.obs;
  final countText = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    dispose();
  }

  Future<dynamic> refreshData() async {
    final storage = GetStorage();
    storage.remove("products");
    storage.remove("totalProducts");
    storage.remove("dummyProducts");
    page.value = 1;
    hasMore.value = true;
    products.value = [];

    await getProducts();
  }

  Future<DummyProducts> getProducts() async {
    try {
      final storage = GetStorage();
      var checkStorage = storage.read("products");
      final checkTotalStorage = storage.read("totalProducts");
      var dummyStorage = storage.read("dummyProducts");

      if (checkStorage != null) {
        checkStorage = dynamicToProducts(checkStorage);
        dummyStorage = dynamicToDummy(dummyStorage);
      }

      var skip = 0;
      var limit = 30;
      if (page.value == 1) {
        products.value = [];
      } else {
        skip = 0 + ((page.value - 1) * 30);
      }

      if ((checkTotalStorage != null &&
              checkStorage != null &&
              checkStorage.length < checkTotalStorage) ||
          (checkTotalStorage == null && checkStorage == null)) {
        if (page.value <= totalPage.value) {
          DummyProducts result =
              await _dummyRepository.fetchProducts(skip, limit);

          if (page.value == 1) {
            totalPage.value =
                ((result.total ?? 0) / (result.limit ?? 0)).ceil();
          }

          dummyProducts.value = result;
          products.value.addAll(result.products!);
          perPage.value = page.value == totalPage.value
              ? result.total ?? 0
              : page.value * limit;
          page.value++;
          tempProducts.value = products.value;
          update();

          return result;
        } else {
          hasMore.value = false;
          return dummyProducts.value;
        }
      } else {
        dummyProducts.value = dummyStorage;
        products.value = checkStorage;
        page.value = ((dummyProducts.value.total ?? 0) / limit).ceil();
        totalPage.value = page.value;
        perPage.value = page.value == totalPage.value
            ? dummyProducts.value.total ?? 0
            : page.value * limit;
        tempProducts.value = products.value;
        page.value += 1;
        hasMore.value = false;

        update();
        return dummyProducts.value;
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return DummyProducts();
    }
  }

  Future<void> onScroll() async {
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;

    if (maxScroll == currentScroll && hasMore.value) {
      if ((page.value - 1) == totalPage.value) {
        await show();
        hasMore.value = false;
      } else {
        getProducts();
      }
    }
  }

  Future show() async {
    return Get.snackbar('Info', "Max data",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3));
  }

  Future filterProducts(String searchName) async {
    final storage = GetStorage();
    final checkTotalStorage = storage.read("totalProducts");
    if (searchName.isEmpty) {
      searchProducts.value = <Products>[].obs;
      products.value = tempProducts.value;
      perPage.value = products.value.length;
      update();
    } else {
      products.value = tempProducts.value;
      if (searchName.length > 2 &&
          hasMore.value &&
          products.value.length < checkTotalStorage &&
          countText.value < searchName.length) {
        products.value =
            await _dummyRepository.searchProducts(searchName.toLowerCase());
        tempProducts.value = products.value;
      }

      if (countText.value < searchName.length) {
        countText.value += 1;
      } else {
        countText.value -= 1;
      }

      searchProducts.value = products
          .where((element) => element.title
              .toString()
              .toLowerCase()
              .contains(searchName.toLowerCase()))
          .toList();
      products.value = searchProducts.value;
      perPage.value = products.value.length;
      searching.value = true;
      update();
    }
  }
}
