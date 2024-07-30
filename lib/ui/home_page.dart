import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pingo_learn_demo_app/ui/product_details_page.dart';
import 'package:pingo_learn_demo_app/utils/utilities.dart';

import '../data/models/product_model.dart';
import '../utils/constants/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  bool _isLoading = true;

  void _openProductDetailPage(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product,show: _remoteConfig.getBool('discount_price_show'), ),
      ),
    );
  }

  Future<void> _fetchRemoteConfig() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      bool updated = await _remoteConfig.fetchAndActivate();
      if (updated) {
        print('Remote config updated');
      } else {
        print('No update');
      }
      setState(() {});
    } catch (e) {
      print('Error fetching remote config: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _remoteConfig.setDefaults(<String, bool>{
      'discount_price_show': false,
    });
    _fetchRemoteConfig();
    _getData();
  }

  ProductsModel? dataFromAPI;
  _getData() async {
    try {
      String url = "https://dummyjson.com/products";
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        dataFromAPI = ProductsModel.fromJson(json.decode(res.body));
        _isLoading = false;
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  double calculateDiscountedPrice(double originalPrice, double discountPercentage) {
    return originalPrice * (1 - discountPercentage / 100);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color4,
      appBar: AppBar(
        title: const Text(
          "e-Shop",
          style: TextStyle(
            fontFamily: 'Poppins',
            color: AppColors.color3,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(onPressed: ()async{
            try {
              bool result = await authService.logout();
              if (result) {
                navigationService.pushReplacementNamed("/login_page");
              }
            } catch (e) {
              print(e);
            }
          }, icon: const Icon(Icons.logout, color: AppColors.color3,))
        ],
        backgroundColor: AppColors.color1,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : dataFromAPI == null
          ? const Center(
        child: Text("Failed to load data"),
      )
          : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7
        ),
        itemCount: dataFromAPI!.products.length,
        itemBuilder: (context, index) {
          final product = dataFromAPI!.products[index];
          return InkWell(
            onTap: () {
              _openProductDetailPage(product);
            },
            child: Container(
                height: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.color3,
                        blurRadius: 0,
                        spreadRadius: 1,
                      )
                    ]
                ),
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      product.thumbnail,
                      height: 90,
                    ),
                    const SizedBox(height: 10),
                    Text(product.title, style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold, fontSize: 18
                    ),maxLines: 1,),
                    const SizedBox(height: 5),
                    SizedBox(width:MediaQuery.of(context).size.width * .3,child: Text(product.description,maxLines: 3, overflow: TextOverflow.ellipsis,)),
                    const SizedBox(height: 5),
                    (_remoteConfig.getBool('discount_price_show')) ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text( "\$${product.price.toString()}", style: const TextStyle(
                            fontFamily: 'Poppins',
                            decoration: TextDecoration.lineThrough, fontSize: 11
                        ),),
                        SizedBox(width: MediaQuery.of(context).size.width * .01,),
                        Text("\$${calculateDiscountedPrice(product.price,
                            product.discountPercentage).toStringAsFixed(2)
                        }", style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold, fontSize: 11
                        ),),
                        SizedBox(width: MediaQuery.of(context).size.width * .01,),                        Text("${product.discountPercentage.toStringAsFixed(2)
                        }% Off", style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11
                        ),)
                      ],
                    )
                        : Text( "\$${product.price.toString()}"),  /// Write the same logic using provider in ProductsDetailsPage
                  ],
                )
            ),
          );
        },
      ),
    );
  }
}
