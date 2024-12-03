import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

import '../../models/product_model.dart';
import 'package:pdf/widgets.dart' as pw;

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<ProductModel>> streamProduct() async* {
    yield* firestore
        .collection("products")
        .withConverter<ProductModel>(
          fromFirestore: (snapshot, _) =>
              ProductModel.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson(),
        )
        .snapshots();
  }

  ProductBloc() : super(ProductStateInitial()) {
    on<ProductEventAddProduct>((event, emit) async {
      try {
        emit(ProductStateLoading());
        var hasil = await firestore.collection("products").add({
          "productCode": event.pcode,
          "productName": event.pname,
          "quantity": event.pquantity,
        });

        await firestore.collection("products").doc(hasil.id).update({
          "productId": hasil.id,
        });
        emit(ProductStateComplete());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Tidak dapat menambah data"));
      } catch (e) {
        emit(ProductStateError("Tidak dapat menambah data"));
      }
    });
    on<ProductEventEditProduct>((event, emit) async {
      try {
        emit(ProductStateLoading());
        await firestore.collection("products").doc(event.pidEdit).update({
          "productName": event.pnameEdit,
          "quantity": event.pquantityEdit,
        });
        emit(ProductStateCompleteEdit());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ?? "Can't Modify this data"));
      } catch (e) {
        emit(ProductStateError("Can't modify this data"));
      }
    });
    on<ProductEventDeleteProduct>((event, emit) async {
      try {
        emit(ProductStateLoading());
        await firestore.collection("products").doc(event.id).delete();
        emit(ProductStateCompleteDelete());
      } on FirebaseException catch (e) {
        emit(ProductStateError(
            e.message ?? "Failed Delete Data from FirebaseException"));
      } catch (e) {
        emit(ProductStateError("Failed Delete Data"));
      }
    });
    on<ProductEventExportPdf>((event, emit) async {
      try {
        emit(ProductStateLoadingExportPdf());
        var getDataProduct = await firestore
            .collection("products")
            .withConverter<ProductModel>(
              fromFirestore: (snapshot, _) =>
                  ProductModel.fromJson(snapshot.data()!),
              toFirestore: (product, _) => product.toJson(),
            )
            .get();
        List<ProductModel> allProducts = [];
        for (var element in getDataProduct.docs) {
          ProductModel product = element.data();
          allProducts.add(product);
        }

        final pdf = pw.Document();
        pdf.addPage(pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              List<pw.TableRow> allData =
                  List.generate(allProducts.length, (index) {
                ProductModel productData = allProducts[index];
                return pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(20),
                    child: pw.Text(
                      "${index + 1}",
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(20),
                    child: pw.Text(
                      productData.productCode!,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(20),
                    child: pw.Text(
                      productData.productName!,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(20),
                    child: pw.Text(
                      productData.quantity.toString(),
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(20),
                      child: pw.BarcodeWidget(
                        color: PdfColor.fromHex("#000000"),
                        data: productData.productId!,
                        barcode: pw.Barcode.qrCode(),
                        height: 50,
                        width: 50,
                      )),
                ]);
              });
              return [
                pw.Center(
                  child: pw.Text(
                    "Catalog Product",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 24),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Table(
                    border: pw.TableBorder.all(
                      color: PdfColors.black,
                      width: 2,
                    ),
                    children: [
                      pw.TableRow(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(20),
                          child: pw.Text(
                            "No",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(20),
                          child: pw.Text(
                            "Product Code",
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(20),
                          child: pw.Text(
                            "Product Name",
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(20),
                          child: pw.Text(
                            "Quantity",
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(20),
                          child: pw.Text(
                            "Qr Code",
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ]),
                      ...allData,
                    ]),
              ];
            }));
        //simpan
        Uint8List bytes = await pdf.save();
        //buat file kosong ke direktori
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/mydocument.pdf');
        //memasukkan data dari bytes ke dalam file kosong
        await file.writeAsBytes(bytes);
        //open pdf
        await OpenFile.open(file.path);
        emit(ProductStateCompleteExportPdf());
      } on FirebaseException catch (e) {
        emit(ProductStateError(e.message ??
            "Failed Export Data Product To Pdf from FirebaseException"));
      } catch (e) {
        emit(ProductStateError("Failed Export Data Product To Pdf"));
      }
    });
    on<ProductEventScanQR>((event, emit) async {
      try {
        emit(ProductStateLoading());
        DocumentSnapshot<Map<String, dynamic>> result =
            await firestore.collection("products").doc(event.pid).get();
        print("data result : ${result.data()}");
        ProductModel productModel = ProductModel.fromJson(result.data()!);
        print("data productmodel : >${productModel.productId}");
        emit(ProductStateCompleteScanQR(productModel));
      } catch (e) {
        emit(ProductStateError("Failed Scan QR"));
      }

      // if (result.data() == null) {
      //   return {"error": true};
      // } else {
      //   List<ProductModel> allProducts = result;
      //   for (var element in result) {
      //     ProductModel product = element.data();
      //     allProducts.add(product);
      //   }
      // }

      // "data": ProductModel.fromJson(result.data()!),
    });
  }
}
