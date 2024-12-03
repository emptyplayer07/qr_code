part of 'product_bloc.dart';

abstract class ProductEvent {}

class ProductEventAddProduct extends ProductEvent {
  final String pcode;

  final String pname;
  final int pquantity;

  ProductEventAddProduct({
    required this.pname,
    required this.pcode,
    required this.pquantity,
  });
}

class ProductEventEditProduct extends ProductEvent {
  final String pcodeEdit;
  final String pidEdit;
  final String pnameEdit;
  final int pquantityEdit;

  ProductEventEditProduct(
      {required this.pcodeEdit,
      required this.pidEdit,
      required this.pnameEdit,
      required this.pquantityEdit});
}

class ProductEventDeleteProduct extends ProductEvent {
  final String id;

  ProductEventDeleteProduct({required this.id});
}

class ProductEventExportPdf extends ProductEvent {}

class ProductEventScanQR extends ProductEvent {
  // final String pcode;
  // final String pid;
  // final String pname;
  // final int pquantity;

  // ProductEventScanQR(this.pcode, this.pname, this.pquantity,
  //     {required this.pid});
  final String pid;

  ProductEventScanQR({required this.pid});
}
