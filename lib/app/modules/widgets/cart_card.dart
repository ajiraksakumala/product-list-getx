import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_test_flutter/app/data/models/cart.dart';
import 'package:skill_test_flutter/app/modules/cart/controllers/cart_controller.dart';
import 'package:skill_test_flutter/helpers/theme.dart';

class CartCard extends StatelessWidget {
  final CartController cartController = Get.find();
  final Cart product;
  final void Function()? function1;
  final void Function()? function2;

  CartCard(
      {super.key,
      required this.product,
      required this.function1,
      required this.function2});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(left: 6, top: 10, bottom: 10, right: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            height: 82,
            width: 82,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: greyColorSecond),
            child: Center(
              child: Image.network(product.product!.images!.first),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.product?.title ?? "",
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis)),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  product.product?.description ?? "",
                  maxLines: 2,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  '\$ ${product.product!.price.toString()}',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.all(6),
                    height: 40,
                    decoration: BoxDecoration(
                        color: greyColorSecond,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: function2,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            child: const Center(
                                child: Text(
                              '-',
                              style: TextStyle(fontSize: 24),
                            )),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                            height: 30,
                            width: 30,
                            child: GetBuilder<CartController>(
                                builder: (controller) {
                              return Center(
                                  child: Text(
                                product.qty.toString(),
                                style: const TextStyle(fontSize: 18),
                              ));
                            })),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: function1,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            height: 30,
                            width: 30,
                            child: const Center(
                                child: Text(
                              '+',
                              style: TextStyle(fontSize: 24),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
