import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../bloc/bloc.dart';
import '../models/product_model.dart';
import '../routes/router.dart';

class DetailProductPage extends StatelessWidget {
  final String id;
  final ProductModel data;
  DetailProductPage(this.id, this.data, {super.key});

  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController quantityC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    codeC.text = data.productCode!;
    nameC.text = data.productName!;
    quantityC.text = data.quantity.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Product"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: QrImageView(data: data.productId!),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: codeC,
            readOnly: true,
            decoration: InputDecoration(
              label: Text("Product Code"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: nameC,
            decoration: InputDecoration(
              label: Text("Product Name"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: quantityC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              label: Text("Quantity"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(ProductEventEditProduct(
                  pidEdit: data.productId!,
                  pcodeEdit: codeC.text,
                  pnameEdit: nameC.text,
                  pquantityEdit: int.tryParse(quantityC.text) ?? 0));
            },
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20), backgroundColor: Colors.blue),
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
                if (state is ProductStateCompleteEdit) {
                  context.pop();
                }
              },
              builder: (context, state) {
                return Text(
                  "Edit Product",
                  style: TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              context
                  .read<ProductBloc>()
                  .add(ProductEventDeleteProduct(id: data.productId!));
            },
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
                if (state is ProductStateCompleteDelete) {
                  context.goNamed(Routes.products);
                }
              },
              builder: (context, state) {
                return Text(
                  "Delete Product",
                  style: TextStyle(color: Colors.red),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
