import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../bloc/bloc.dart';
import '../models/product_model.dart';
import '../routes/router.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProductBloc productBloc = context.read<ProductBloc>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Products"),
      ),
      body: StreamBuilder<QuerySnapshot<ProductModel>>(
        stream: productBloc.streamProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text("Data Not Found..."),
            );
          }
          List<ProductModel> allProducts = [];
          for (var element in snapshot.data!.docs) {
            allProducts.add(element.data());
            // print("coba ${allProducts[0]}");
          }

          if (allProducts.isEmpty) {
            return Center(child: Text("Data Product is Empty"));
          }
          return ListView.builder(
              itemCount: allProducts.length,
              itemBuilder: (context, index) {
                ProductModel product = allProducts[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      context.goNamed(Routes.detailProduct,
                          pathParameters: {"productId": product.productCode!},
                          extra: product);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 100,
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.productCode!),
                              Text(product.productName!),
                              Text("jumlah : ${product.quantity}"),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: QrImageView(
                              data: product.productCode!,
                              size: 200,
                              version: QrVersions.auto,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(Routes.addProduct);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
