class ProductModel {
  String? productCode;
  String? productId;
  String? productName;
  int? quantity;

  ProductModel({
    required this.productCode,
    required this.productName,
    required this.quantity,
    required this.productId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productCode: json["productCode"] ?? "",
        productId: json["productId"] ?? "",
        productName: json["productName"] ?? "",
        quantity: json["quantity"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "product_code": productCode,
        "product_Id": productId,
        "product_name": productName,
        "quantity": quantity,
      };
}
