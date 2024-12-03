import 'package:flutter/material.dart';

import '../bloc/bloc.dart';
import '../routes/router.dart';

class AddProductPage extends StatelessWidget {
  AddProductPage({super.key});

  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController quantityC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: codeC,
            maxLength: 10,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Product Code",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: nameC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Product Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
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
              labelText: "Quantity",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Center(child: Text("Info")),
                      content: Text("Are you sure to save product data?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Close"),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<ProductBloc>()
                                .add(ProductEventAddProduct(
                                  pname: nameC.text,
                                  pcode: codeC.text,
                                  pquantity: int.tryParse(quantityC.text) ?? 0,
                                ));
                            context.goNamed(Routes.products);
                          },
                          child: Text("Yes"),
                        )
                      ],
                    );
                  });
            },
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blue),
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductStateError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return Text(
                    state is ProductStateLoading ? "Loading..." : "Add Product",
                    style: TextStyle(color: Colors.white));
              },
            ),
          )
        ],
      ),
    );
  }
}
