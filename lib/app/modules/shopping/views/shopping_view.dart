import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:skill_test_flutter/app/data/models/dummy_products.dart';
import 'package:skill_test_flutter/app/modules/cart/controllers/cart_controller.dart';
import 'package:skill_test_flutter/app/modules/cart/views/cart_view.dart';
import 'package:skill_test_flutter/app/modules/detail_product/views/detail_product_view.dart';
import 'package:skill_test_flutter/helpers/theme.dart';
import 'package:skill_test_flutter/repositories/dummy_repository.dart';

import '../controllers/shopping_controller.dart';

class ShoppingView extends GetView<ShoppingController> {
  ShoppingView({super.key});

  @override
  Widget build(BuildContext context) {
    final shoppingController = Get.lazyPut(() => ShoppingController());
    final cartController = Get.put(CartController());

    controller.scrollController.addListener(controller.onScroll);

    return Scaffold(
      backgroundColor: greyColorSecond,
      body: Stack(
        children: [
          SafeArea(
            child: Container(
                margin: const EdgeInsets.only(
                    top: 150, left: 24, right: 24, bottom: 50),
                padding: const EdgeInsets.only(top: 20),
                child: FutureBuilder<DummyProducts>(
                  future: controller.getProducts(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: Text("No Data"));
                    }
                    return RefreshIndicator(
                      onRefresh: controller.refreshData,
                      child: Obx(() => (controller.searching.value &&
                              controller.products.isEmpty)
                          ? const Center(child: Text("No Data"))
                          : GridView.builder(
                              controller: controller.scrollController,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.perPage.value,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 20,
                                      childAspectRatio: 1.8 / 2,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 2),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => DetailProductView(),
                                        arguments: {
                                          "product": controller.products[index]
                                        });
                                    // cartController
                                    //     .addToCart(controller.products[index]);
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(() => DetailProductView(),
                                            arguments: {
                                              "product":
                                                  controller.products[index]
                                            });
                                        // cartController
                                        //     .addToCart(controller.products[index]);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 13,
                                          right: 13,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 15),
                                            Container(
                                              height: 80,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8)),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          controller
                                                              .products[index]
                                                              .thumbnail!),
                                                      fit: BoxFit.cover)),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              controller.products[index].title!,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              'Rp ${controller.products[index].price.toString()}',
                                              style: const TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                    );
                  },
                )),
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.fromLTRB(24, 30, 24, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Image(
                          height: 24,
                          width: 24,
                          image: AssetImage('assets/logo.png')),
                      InkWell(
                        onTap: () {
                          Get.to(() => CartView());
                        },
                        child: Stack(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Get.to(() => CartView());
                                },
                                icon: Icon(Icons.shopping_cart)),
                            Positioned(
                              top: 3,
                              right: 5,
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                child: Center(
                                  child: GetX<CartController>(
                                      builder: (controller) {
                                    return Text(
                                      controller.count.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    );
                                  }),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) =>
                                controller.filterProducts(value),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Search',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              suffixIcon: Icon(
                                Icons.search,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
