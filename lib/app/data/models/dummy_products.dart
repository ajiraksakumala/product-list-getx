import 'dart:convert';

class DummyProducts {
  List<Products>? products;
  int? total;
  int? skip;
  int? limit;

  DummyProducts({this.products, this.total, this.skip, this.limit});

  DummyProducts.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['skip'] = this.skip;
    data['limit'] = this.limit;
    return data;
  }
}

class Products {
  int? id;
  String? title;
  String? description;
  int? price;
  dynamic discountPercentage;
  dynamic rating;
  int? stock;
  String? brand;
  String? category;
  String? thumbnail;
  List<String>? images;

  Products(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.discountPercentage,
      this.rating,
      this.stock,
      this.brand,
      this.category,
      this.thumbnail,
      this.images});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    discountPercentage = json['discountPercentage'];
    rating = json['rating'];
    stock = json['stock'];
    brand = json['brand'];
    category = json['category'];
    thumbnail = json['thumbnail'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    data['discountPercentage'] = this.discountPercentage;
    data['rating'] = this.rating;
    data['stock'] = this.stock;
    data['brand'] = this.brand;
    data['category'] = this.category;
    data['thumbnail'] = this.thumbnail;
    data['images'] = this.images;
    return data;
  }
}

List<Products> mergeArrays(array1, List<Products> array2) {
  var mergedArray = (array1 as Iterable)
      .map((val) => val is Map<String, dynamic>
          ? Products.fromJson(val)
          : val as Products)
      .toList();

  mergedArray.addAll(
      array2.where((obj2) => !mergedArray.any((obj1) => obj1.id == obj2.id)));

  return mergedArray;
}

List<Products> dynamicToProducts(data) {
  var result = (data as Iterable)
      .map((val) => val is Map<String, dynamic>
          ? Products.fromJson(val)
          : val as Products)
      .toList();

  return result;
}

dynamicToDummy(data) {
  if (data is Map<String, dynamic>) {
    var result = DummyProducts.fromJson(data);

    return result;
  } else {
    var result = data;

    return result;
  }
}
