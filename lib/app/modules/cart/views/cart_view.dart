import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:skill_test_flutter/app/modules/widgets/cart_card.dart';
import 'package:skill_test_flutter/helpers/theme.dart';

import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: greyColorSecond,
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(24, 30, 24, 0),
          child: Stack(
            children: [
              ListView(
                children: [
                  GetX<CartController>(builder: (controller) {
                    return Column(
                        children: cartController.cartItems
                            .map((e) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: CartCard(
                                  function1: () {
                                    cartController.increasQty(e);
                                  },
                                  function2: () {
                                    cartController.decreasqty(cart: e);
                                  },
                                  product: e,
                                )))
                            .toList());
                  }),
                  SizedBox(
                    height: 150,
                  )
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    color: greyColorSecond,
                    width: double.infinity,
                    height: 130,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total', style: TextStyle(fontSize: 18)),
                            GetBuilder<CartController>(builder: (controller) {
                              return Text(
                                '\$ ${controller.count2}',
                                style: const TextStyle(fontSize: 20),
                              );
                            }),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 64,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Center(
                            child: Text(
                              'Checkout',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}
