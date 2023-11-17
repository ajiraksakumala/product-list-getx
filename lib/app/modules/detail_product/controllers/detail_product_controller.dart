import 'package:get/get.dart';

class DetailProductController extends GetxController {
  var activeCarousel = 0.obs;

  handleCarouselChange(int index) {
    activeCarousel.value = index;
  }
}
