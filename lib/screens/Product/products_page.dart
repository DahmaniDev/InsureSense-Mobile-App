import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insuresense/model/product.dart';
import 'package:insuresense/common/constants.dart' as constants;

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<bool> fetched;
  List<Product> products = [];

  final _random = new Random();
  int next(int min, int max) => min + _random.nextInt(max - min);

  Future<bool> fetchProducts() async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    final test = await http
        .get(Uri.parse(constants.url + '/products'), headers: headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        products =
            List<Product>.from(l.map((model) => Product.fromJson(model)));
      }
    });
    return true;
  }

  @override
  void initState() {
    fetched = fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetched,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return index != products.length - 1
                      ? buildProduct(
                          products[index].productCategory!,
                          products[index].productSubCategory!,
                          products[index].productCode!)
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: buildProduct(
                              products[index].productCategory!,
                              products[index].productSubCategory!,
                              products[index].productCode!),
                        );
                });
          } else {
            return const SizedBox(
                height: 10, width: 10, child: CircularProgressIndicator());
          }
        });
  }

  Widget buildProduct(
      String prodCategory, String prodSubCategory, String prodCode) {
    int x = next(1, 4);
    return GestureDetector(
      child: ListTile(
        leading: x == 1
            ? Icon(
                Icons.shopping_bag_outlined,
                color: Colors.blueGrey.shade300,
              )
            : x == 2
                ? Icon(
                    Icons.shop,
                    color: Colors.blueGrey.shade300,
                  )
                : x == 3
                    ? Icon(
                        Icons.production_quantity_limits,
                        color: Colors.blueGrey.shade300,
                      )
                    : Icon(
                        Icons.add_shopping_cart,
                        color: Colors.blueGrey.shade300,
                      ),
        title: Text(prodCategory),
        subtitle: Row(children: [
          Text(prodSubCategory),
          SizedBox(width: 20),
          Text(prodCode),
        ]),
      ),
      onTap: () {},
    );
  }
}
