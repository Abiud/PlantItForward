import 'package:flutter/material.dart';
import 'package:plant_it_forward/Models/Product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final Function onDeleteItem;
  const ProductItem({
    Key key,
    this.product,
    this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      product.quantity,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Spacer(),
                    Column(
                      children: [Text(product.price.toString())],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
