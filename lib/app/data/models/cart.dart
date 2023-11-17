import 'package:skill_test_flutter/app/data/models/dummy_products.dart';

class Cart {
  String id;
  Products? product;
  int qty;

  Cart({this.id = "", this.product, this.qty = 0});

  Cart copyWith({
    required id,
    required Products product,
    required int qty,
  }) =>
      Cart(
          id: id ?? this.id,
          product: product ?? this.product,
          qty: qty ?? this.qty);

  // @override
  // List<Object> get props => [id, qty, product];

  void toggleDone() {
    qty++;
  }

  void decreaseDown() {
    qty--;
  }
}
