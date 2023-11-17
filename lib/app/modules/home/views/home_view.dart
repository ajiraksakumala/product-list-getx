import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:skill_test_flutter/app/modules/shopping/views/shopping_view.dart';
import 'package:skill_test_flutter/app/modules/widgets/custom_navbar.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
              child: PageView(
            children: [
              ShoppingView(),
            ],
          ))
        ],
      ),
    );
  }
}
