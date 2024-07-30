import 'package:flutter/material.dart';

import '../data/models/product_model.dart';


class ProductDetailPage extends StatelessWidget {
  final Product product;
  final bool show;

  const ProductDetailPage({required this.product, required this.show});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
          maxLines: 1,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body:SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                product.thumbnail,
                width: 440,
                height: 460,
              ),
              Text("Name: ${product.title}", style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18
              ),),
              const SizedBox(height: 20),
              SizedBox(width:MediaQuery.of(context).size.width * .7,child: Text(product.description,maxLines: 3, overflow: TextOverflow.ellipsis,)),
              const SizedBox(height: 20),
              (show) ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text( "\$${product.price.toString()}", style: const TextStyle(
                      fontFamily: 'Poppins',
                      decoration: TextDecoration.lineThrough, fontSize: 18
                  ),),
                  SizedBox(width: MediaQuery.of(context).size.width * .05,),
                  Text("\$${calculateDiscountedPrice(product.price,
                      product.discountPercentage).toStringAsFixed(2)
                  }", style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold, fontSize: 18
                  ),),
                  SizedBox(width: MediaQuery.of(context).size.width * .05,),                        Text("${product.discountPercentage.toStringAsFixed(2)
                  }% Off", style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18
                  ),)
                ],
              )
                  : Text( "\$${product.price.toString()}"),
            ],
          ),
        ),
      ),
    );
  }
}

double calculateDiscountedPrice(double originalPrice, double discountPercentage) {
  return originalPrice * (1 - discountPercentage / 100);
}