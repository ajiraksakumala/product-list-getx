import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:skill_test_flutter/app/data/models/dummy_products.dart';
import 'package:skill_test_flutter/app/modules/cart/controllers/cart_controller.dart';
import 'package:skill_test_flutter/app/modules/cart/views/cart_view.dart';
import 'package:skill_test_flutter/helpers/theme.dart';

import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  final Products product = (Get.arguments as Map<String, dynamic>)["product"];

  @override
  Widget build(BuildContext context) {
    final detailProductController =
        Get.lazyPut(() => DetailProductController());
    final cartController = Get.put(CartController());

    return Scaffold(
      backgroundColor: greyColorSecond,
      appBar: AppBar(
        title: Text('Detail Product'),
        centerTitle: true,
        actions: [
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
                      child: GetX<CartController>(builder: (controller) {
                        return Text(
                          controller.count.toString(),
                          style: const TextStyle(color: Colors.white),
                        );
                      }),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider(
                options: CarouselOptions(
                  enableInfiniteScroll:
                      product.images!.length > 1 ? true : false,
                  autoPlayInterval: const Duration(seconds: 20),
                  height: 600,
                  viewportFraction: 1,
                  autoPlay: product.images!.length > 1 ? true : false,
                  onPageChanged: (index, reason) =>
                      controller.handleCarouselChange(index),
                  scrollDirection: Axis.horizontal,
                ),
                items: product.images!.map((i) {
                  return ImageSlider(image: i);
                }).toList()),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.brand! + ' (' + product.category! + ')',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 202, 184, 20),
                        ),
                        Text(
                          product.rating.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Stok ${product.stock}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Deskripsi',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  product.description!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 7,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 25.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            '\$ ${product.price}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 23, fontWeight: FontWeight.w800),
                          ),
                          SizedBox(width: 5),
                          Text(
                            '\$ ${product.discountPercentage}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => cartController.addToCart(context, product),
                      child: Container(
                        height: 64,
                        width: 150,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: const Center(
                          child: Text(
                            'Add Cart',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ]),
            ),
          )
        ],
      ),
    );
  }
}

class ImageSlider extends StatelessWidget {
  const ImageSlider({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String? image;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(image!), fit: BoxFit.cover)),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.8)
                    ])),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        );
      },
    );
  }
}
