import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code/models/product_model.dart';
import 'package:qr_code/pages/add_product_page.dart';
import 'package:qr_code/pages/barcode_scanner_page.dart';
import 'package:qr_code/pages/detail_product_page.dart';
import 'package:qr_code/pages/error_page.dart';
import 'package:qr_code/pages/home_page.dart';
import 'package:qr_code/pages/login_page.dart';
import 'package:qr_code/pages/products_page.dart';
import 'package:qr_code/pages/test_page.dart';

export 'package:go_router/go_router.dart';

part 'routes_name.dart';

// GoRouter configuration
final router = GoRouter(
  redirect: (context, state) {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      return "/login";
    } else {
      return null;
    }
  },
  errorBuilder: (context, state) => const ErrorPage(),
  routes: [
    GoRoute(
        path: '/',
        name: Routes.home,
        builder: (context, state) => HomePage(),
        routes: [
          GoRoute(
              path: 'product',
              name: Routes.products,
              builder: (context, state) => ProductsPage(),
              routes: [
                GoRoute(
                  path: ':productId',
                  name: Routes.detailProduct,
                  builder: (context, state) => DetailProductPage(
                    state.pathParameters['productId'].toString(),
                    state.extra as ProductModel,
                  ),
                ),
              ]),
          GoRoute(
            path: 'add-product',
            name: Routes.addProduct,
            builder: (context, state) => AddProductPage(),
          ),
          GoRoute(
            path: 'barcode-scanner',
            name: Routes.barcodeScanner,
            builder: (context, state) => BarcodeScannerPage(),
          ),
          GoRoute(
            path: 'test-page',
            name: Routes.testPage,
            builder: (context, state) => TestPage(),
          )
        ]),
    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (context, state) => LoginPage(),
    ),
  ],
);
