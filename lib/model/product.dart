class Product {
  final int? productId;
  final String? productCode;
  final String? productCategory;
  final String? productSubCategory;

  const Product(
      {this.productId,
      this.productCode,
      this.productCategory,
      this.productSubCategory});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        productId: json['ProductID'],
        productCode: json['ProductCode'],
        productCategory: json['ProductCategory'],
        productSubCategory: json['ProductSubCategory']);
  }
}
