// To parse this JSON data, do
//
//     final subModel = subModelFromJson(jsonString);

import 'dart:convert';

List<SubModel> subModelFromJson(String str) =>
    List<SubModel>.from(json.decode(str).map((x) => SubModel.fromJson(x)));

String subModelToJson(List<SubModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubModel {
  SubModel();

  String title;
  dynamic catId;
  String image;
  String description;
  List<Product> products;

  SubModel.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    catId = json["cat_id"];
    image = json["image"];
    description = json["description"];
    products =
        List<Product>.from(json["Products"].map((x) => Product.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "cat_id": catId,
        "image": image,
        "description": description,
        "Products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  Product();

  dynamic storeId;
  dynamic stock;
  dynamic varientId;
  dynamic productId;
  String productName;
  String productImage;
  String description;
  dynamic price;
  dynamic mrp;
  String varientImage;
  dynamic unit;
  dynamic quantity;
  dynamic type;
  double discountper;
  dynamic avgrating;
  String isFavourite;
  dynamic cartQty;
  dynamic countrating;
  dynamic maxprice;
  List<Image> images;
  List<Tag> tags;
  List<Varient> varients;
  String hideVarient;
  String grossWt;
  Product.fromJson(Map<String, dynamic> json) {
    storeId = json["store_id"];
    stock = json["stock"];
    varientId = json["varient_id"];
    productId = json["product_id"];
    productName = json["product_name"];
    productImage = json["product_image"];
    description = json["description"];
    price = json["price"];
    mrp = json["mrp"];
    varientImage = json["varient_image"];
    unit = json["unit"];
    quantity = json["quantity"];
    type = json["type"];
    discountper = json["discountper"].toDouble();
    avgrating = json["avgrating"];
    isFavourite = json["isFavourite"];
    cartQty = json["cart_qty"];
    countrating = json["countrating"];
    grossWt = json["gross_wt"];
    hideVarient = json["hide_varient"];

    maxprice = json["maxprice"];
    images = List<Image>.from(json["images"].map((x) => Image.fromJson(x)));
    tags = List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x)));
    varients =
        List<Varient>.from(json["varients"].map((x) => Varient.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "stock": stock,
        "varient_id": varientId,
        "product_id": productId,
        "product_name": productName,
        "product_image": productImage,
        "description": description,
        "price": price,
        "mrp": mrp,
        "varient_image": varientImage,
        "unit": unit,
        "quantity": quantity,
        "type": type,
        'gross_wt': grossWt,
        'hide_varient': hideVarient,
        "discountper": discountper,
        "avgrating": avgrating,
        "isFavourite": isFavourite,
        "cart_qty": cartQty,
        "countrating": countrating,
        "maxprice": maxprice,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
        "varients": List<dynamic>.from(varients.map((x) => x.toJson())),
      };
}

class Image {
  Image();

  String image;

  Image.fromJson(Map<String, dynamic> json) {
    image = json["image"];
  }

  Map<String, dynamic> toJson() => {
        "image": image,
      };
}

class Tag {
  Tag();

  dynamic tagId;
  dynamic productId;
  String tag;

  Tag.fromJson(Map<String, dynamic> json) {
    tagId = json["tag_id"];
    productId = json["product_id"];
    tag = json["tag"];
  }

  Map<String, dynamic> toJson() => {
        "tag_id": tagId,
        "product_id": productId,
        "tag": tag,
      };
}

class Varient {
  Varient();

  dynamic storeId;
  dynamic stock;
  dynamic varientId;
  String description;
  dynamic type;
  dynamic price;
  dynamic mrp;
  String varientImage;
  String unit;
  dynamic quantity;
  dynamic dealPrice;
  dynamic validFrom;
  dynamic validTo;
  String isFavourite;
  dynamic cartQty;
  dynamic avgrating;
  dynamic countrating;
  double discountper;
  dynamic maxprice;

  Varient.fromJson(Map<String, dynamic> json) {
    storeId = json["store_id"];
    stock = json["stock"];
    varientId = json["varient_id"];
    description = json["description"] ?? '';
    description = json["type"];
    price = json["price"];
    mrp = json["mrp"];
    varientImage = json["varient_image"];
    unit = json["unit"];
    quantity = json["quantity"];
    dealPrice = json["deal_price"];
    validFrom = json["valid_from"];
    validTo = json["valid_to"];
    isFavourite = json["isFavourite"];
    cartQty = json["cart_qty"];
    avgrating = json["avgrating"];
    countrating = json["countrating"];
    discountper = json["discountper"].toDouble();
    maxprice = json["maxprice"];
  }

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "stock": stock,
        "varient_id": varientId,
        "description": description,
        "price": price,
        "mrp": mrp,
        "varient_image": varientImage,
        "unit": unit,
        "quantity": quantity,
        "deal_price": dealPrice,
        "valid_from": validFrom,
        "valid_to": validTo,
        "isFavourite": isFavourite,
        "cart_qty": cartQty,
        "avgrating": avgrating,
        "countrating": countrating,
        "discountper": discountper,
        "maxprice": maxprice,
      };
}
