import 'package:flutter/material.dart';
import 'package:qr_code/bloc/bloc.dart';
import 'package:qr_code/routes/router.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              context
                  .read<ProductBloc>()
                  .add(ProductEventScanQR(pid: "irYaiAkivWNamREQrmDE"));
            },
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateCompleteScanQR) {
                  context.goNamed(Routes.detailProduct,
                      pathParameters: {
                        "productId": state.productModel.productId!
                      },
                      extra: state.productModel);

                  // context.goNamed(Routes.products);
                }
              },
              builder: (context, state) {
                return Text("data");
              },
            )),
      ),
    );
  }
}
