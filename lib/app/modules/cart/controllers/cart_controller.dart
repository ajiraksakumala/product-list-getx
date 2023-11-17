import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_test_flutter/app/data/models/cart.dart';
import 'package:skill_test_flutter/app/data/models/dummy_products.dart';
import 'package:skill_test_flutter/helpers/theme.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();
  final cart = Cart().obs;

  var cartItems = <Cart>[].obs;
  int get count => cartItems.length;
  var count2 = 0.0;
  double get totalPrice => cartItems.fold(
      0, (sum, item) => sum + (item.product?.price ?? 0) * item.qty);

  void addToCart(BuildContext context, Products product) {
    try {
      if (isAlredyAdded(product)) {
        Get.snackbar("Cek keranjang",
            "${product.title} sudah dimasukan ke dalam keranjang",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3));
      } else {
        var uuid = product.id;
        String itemId = uuid.toString();
        cartItems.add(Cart(
          id: itemId,
          product: product,
          qty: 1,
        ));
        getTotalsMount();
        update();
      }
    } catch (e) {}
  }

  bool isAlredyAdded(Products product) =>
      cartItems.where((item) => item.product?.id == product.id).isNotEmpty;

  void decreasqty({
    required Cart cart,
  }) {
    if (cart.qty == 1) {
      removeCart(cart);

      Get.snackbar("Berhasil", "Produk berhasil terhapus",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    } else {
      int index = cartItems.indexWhere((e) => e.id == cart.id);
      cartItems[index].qty = --cart.qty;
      getTotalsMount();
      update();
    }
  }

  void increasQty(Cart cart) {
    if (cart.qty >= 1) {
      cart.toggleDone();
      getTotalsMount();
      update();
    }
  }

  void removeCart(Cart cart) {
    cartItems.remove(cart);
    getTotalsMount();
    update();
  }

  void getTotalsMount() {
    double totalamount = cartItems.fold(
        0, (sum, item) => sum + (item.product?.price ?? 0) * item.qty);
    count2 = totalamount;
  }
}
