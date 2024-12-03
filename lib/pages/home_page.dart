import 'package:flutter/material.dart';

import '../bloc/bloc.dart';
import '../routes/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
        centerTitle: true,
      ),
      body: GridView.builder(
          padding: EdgeInsets.all(20),
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
          itemBuilder: (context, index) {
            late String title;
            late IconData icon;
            late VoidCallback onTap;
            switch (index) {
              case 0:
                title = "Add Product";
                icon = Icons.post_add_rounded;
                onTap = () => context.goNamed(Routes.addProduct);
                break;
              case 1:
                title = "Products";
                icon = Icons.list_alt_outlined;
                onTap = () => context.goNamed(Routes.products);
                {}
                break;
              case 2:
                title = "QR Code";
                icon = Icons.qr_code;
                onTap = () {
                  // context.read<ProductBloc>().add(ProductEventBarcodeScanner());
                  context.goNamed(Routes.barcodeScanner);
                  // context.goNamed(Routes.testPage);
                };
                break;
              case 3:
                title = "Catalog";
                icon = Icons.document_scanner;
                onTap = () {
                  context.read<ProductBloc>().add(ProductEventExportPdf());
                };
                break;
              default:
            }
            return Material(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onTap,
                child: Center(
                  child: (index == 3)
                      ? BlocConsumer<ProductBloc, ProductState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            if (state is ProductStateLoadingExportPdf) {
                              return CircularProgressIndicator();
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  icon,
                                  size: 50,
                                ),
                                Text("Catalog"),
                              ],
                            );
                          },
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icon,
                              size: 50,
                            ),
                            Text(title),
                          ],
                        ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AuthBloc>().add(AuthEventLogout());
        },
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthStateLogout) {
              context.goNamed(Routes.login);
            }
          },
          child: Icon(Icons.logout),
        ),
      ),
    );
  }
}
