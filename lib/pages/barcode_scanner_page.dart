import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../bloc/bloc.dart';
import '../routes/router.dart';

class BarcodeScannerPage extends StatelessWidget {
  const BarcodeScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productBloc = context.watch<ProductBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcode Scanner"),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        bloc: productBloc,
        builder: (context, state) {
          return MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates,
              returnImage: true,
            ),
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              // final Uint8List? image = capture.image;

              for (final barcode in barcodes) {
                //var dataQR = barcode.rawValue!;
                if (barcode.rawValue != null) {
                  productBloc.add(ProductEventScanQR(pid: barcode.rawValue!));
                  //productBloc.
                  if (state is ProductStateCompleteScanQR) {
                    // context.goNamed(Routes.products);
                    context.goNamed(Routes.detailProduct,
                        pathParameters: {
                          "productId": state.productModel.productId!
                        },
                        extra: state.productModel);
                  }
                  if (state is ProductStateError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }

                  // if (state is ProductStateCompleteScanQR1) {
                  //   // context.goNamed(Routes.detailProduct,
                  //   //     pathParameters: {
                  //   //       "productId": state.productModel.productId!
                  //   //     },
                  //   //     extra: state.productModel);
                }
                //   context.goNamed(Routes.products);
                // }
                // if (state is ProductStateError) {
                //   ScaffoldMessenger.of(context)
                //       .showSnackBar(SnackBar(content: Text(state.message)));
                // }
                // CircularProgressIndicator();
                // }
              }
              // productBloc.add(ProductEventScanQR(pid: dataQR));
            },
          );
        },
      ),
    );
  }
}
