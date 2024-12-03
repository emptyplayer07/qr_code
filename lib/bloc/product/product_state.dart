part of 'product_bloc.dart';

abstract class ProductState {}

final class ProductStateInitial extends ProductState {}

final class ProductStateLoading extends ProductState {}

final class ProductStateLoadingExportPdf extends ProductState {}

final class ProductStateComplete extends ProductState {}

final class ProductStateCompleteEdit extends ProductState {}

final class ProductStateCompleteDelete extends ProductState {}

final class ProductStateCompleteExportPdf extends ProductState {}

final class ProductStateCompleteScanQR extends ProductState {
  final ProductModel productModel;

  ProductStateCompleteScanQR(this.productModel);
}

final class ProductStateCompleteScanQR1 extends ProductState {}

final class ProductStateError extends ProductState {
  final String message;
  ProductStateError(this.message);
}
