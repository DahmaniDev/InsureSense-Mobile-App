import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insuresense/common/constants.dart' as constants;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insuresense/common/custom_dialogbox.dart';
import 'package:insuresense/model/broker.dart';
import 'package:insuresense/model/complaincategory.dart';
import 'package:insuresense/model/customer.dart';
import 'package:insuresense/model/product.dart';
import 'package:insuresense/model/profile.dart';
import 'package:insuresense/screens/Customer/profile_page.dart';
import 'package:intl/intl.dart';

class CreateComplainPage extends StatefulWidget {
  Customer? user;
  Profile? profile;
  CreateComplainPage({Key? key, this.user, this.profile}) : super(key: key);

  @override
  State<CreateComplainPage> createState() => _CreateComplainPageState();
}

class _CreateComplainPageState extends State<CreateComplainPage> {
  //elements to be passed
  int _selectedcomplainDateId = 0;
  Broker? _selectedbroker;
  Product? _selectedproduct;
  ComplainCategory? _selectedCategory;
  bool posted = false;
  late bool categoriesfetched;
  late bool brokersfetched;
  late bool productsfetched;
  List<ComplainCategory> categories = <ComplainCategory>[];
  List<Broker> brokers = <Broker>[];
  List<Product> products = <Product>[];

  bool missing = false;

  Future<bool> fetchCategories() async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    final test = await http
        .get(Uri.parse(constants.url + '/categories'), headers: headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        for (var i = 0; i < l.length; i++) {
          ComplainCategory c = ComplainCategory.fromJson(l.elementAt(i));
          if (c != null) categories.add(c);
        }
        print("Cat Length : ${categories.length}");
      }
    });

    return true;
  }

  Future<bool> fetchProducts() async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    final test = await http
        .get(Uri.parse(constants.url + '/products'), headers: headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        for (var i = 0; i < l.length; i++) {
          Product c = Product.fromJson(l.elementAt(i));
          if (c != null) products.add(c);
        }
      }
    });
    return true;
  }

  Future<bool> fetchBrokers() async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    final test = await http
        .get(Uri.parse(constants.url + '/brokers'), headers: headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        for (var i = 0; i < l.length; i++) {
          Broker c = Broker.fromJson(l.elementAt(i));
          if (c != null) brokers.add(c);
        }
      }
    });
    return true;
  }

  Future<bool> getDateId(String code) async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    final test = await http
        .get(Uri.parse(constants.url + '/dates/' + code), headers: headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        setState(() {
          _selectedcomplainDateId = l.first['DateID'];
        });
      }
    });
    return true;
  }

  Future<bool> postComplain(int compDateId, int brokId, int custID, int prodId,
      int profId, int catId) async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    final test = await http
        .post(
            Uri.parse(constants.url +
                '/complain/create/$compDateId/$brokId/$custID/$prodId/$profId/$catId'),
            headers: headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        setState(() {
          posted = true;
        });
      }
    });
    return true;
  }

  void _getData() async {
    categoriesfetched = await fetchCategories();
    productsfetched = await fetchProducts();
    brokersfetched = await fetchBrokers();
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF61c29b),
        title: const Text("Create a new Complain :"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                leading: _selectedCategory == null
                    ? missing
                        ? Icon(Icons.navigate_next, color: Colors.red)
                        : Icon(Icons.navigate_next)
                    : Icon(
                        Icons.check_box,
                        color: Colors.green,
                      ),
                title: const Text("Complain Category"),
                subtitle: _selectedCategory == null
                    ? const Text("")
                    : Text(_selectedCategory!.description!),
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) =>
                      _buildBottomSheetCategories(ctx, categories));
            },
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                leading: _selectedproduct == null
                    ? missing
                        ? Icon(Icons.navigate_next, color: Colors.red)
                        : Icon(Icons.navigate_next)
                    : Icon(
                        Icons.check_box,
                        color: Colors.green,
                      ),
                title: const Text("Complain Product"),
                subtitle: _selectedproduct == null
                    ? const Text("")
                    : Text(_selectedproduct!.productCode!),
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) => _buildBottomSheetProducts(ctx, products));
            },
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                  leading: _selectedbroker == null
                      ? missing
                          ? Icon(Icons.navigate_next, color: Colors.red)
                          : Icon(Icons.navigate_next)
                      : Icon(
                          Icons.check_box,
                          color: Colors.green,
                        ),
                  title: const Text("Complain Broker"),
                  subtitle: _selectedbroker == null
                      ? const Text("")
                      : Text(_selectedbroker!.fullName!)),
            ),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) => _buildBottomSheetBrokers(ctx, brokers));
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            width: 150,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF1f303f)),
            child: TextButton(
              onPressed: () async {
                if (_selectedCategory == null ||
                    _selectedbroker == null ||
                    _selectedproduct == null) {
                  setState(() {
                    missing = true;
                  });
                } else {
                  final DateTime now = DateTime.now();
                  final DateFormat formatter = DateFormat('dd-MM-yyyy');
                  final String formatted = formatter.format(now);
                  final String code = formatted.replaceAll('-', '');
                  await getDateId(code).then((value) async {
                    if (_selectedcomplainDateId != 0) {
                      await postComplain(
                              _selectedcomplainDateId,
                              _selectedbroker!.brokerID!,
                              widget.user!.customerID!,
                              _selectedproduct!.productId!,
                              widget.profile!.profileID!,
                              _selectedCategory!.categoryID!)
                          .then((value) => posted
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogBox(
                                        title: "Creating Complain",
                                        descriptions:
                                            "Your complain was created successfully",
                                        text: "complain created");
                                  })
                              : showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogBox(
                                        title: "Creating Complain",
                                        descriptions:
                                            "Error on creating complain",
                                        text: "complain not created");
                                  }));
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialogBox(
                                title: "Creating Complain",
                                descriptions: "Error on creating complain",
                                text: "complain not created");
                          });
                    }
                  });
                }
              },
              child: const Text(
                "New Complain",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildBottomSheetCategories(
      BuildContext ctx, List<ComplainCategory> compCats) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.greenAccent, width: 2.0),
          borderRadius: BorderRadius.circular(8.0)),
      child: ListView.builder(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          itemCount: compCats.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: buildComplain(compCats[index]),
            );
          }),
    );
  }

  Widget buildComplain(ComplainCategory compCat) {
    return GestureDetector(
      child: ListTile(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.lightGreen, width: 1),
            borderRadius: BorderRadius.circular(5)),
        title: Text('${compCat.description}'),
      ),
      onTap: () {
        setState(() {
          _selectedCategory = compCat;
        });
        Navigator.pop(context);
      },
    );
  }

  Container _buildBottomSheetProducts(
      BuildContext ctx, List<Product> compProds) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.greenAccent, width: 2.0),
          borderRadius: BorderRadius.circular(8.0)),
      child: ListView.builder(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          itemCount: compProds.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: buildProduct(compProds[index]),
            );
          }),
    );
  }

  Widget buildProduct(Product prod) {
    return GestureDetector(
      child: ListTile(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.lightGreen, width: 1),
            borderRadius: BorderRadius.circular(5)),
        title: Text('${prod.productCode}'),
      ),
      onTap: () {
        setState(() {
          _selectedproduct = prod;
        });
        Navigator.pop(context);
      },
    );
  }

  Container _buildBottomSheetBrokers(BuildContext ctx, List<Broker> brokers) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.greenAccent, width: 2.0),
          borderRadius: BorderRadius.circular(8.0)),
      child: ListView.builder(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          itemCount: brokers.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: buildBroker(brokers[index]),
            );
          }),
    );
  }

  Widget buildBroker(Broker brok) {
    return GestureDetector(
      child: ListTile(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.lightGreen, width: 1),
            borderRadius: BorderRadius.circular(5)),
        title: Text('${brok.fullName}'),
      ),
      onTap: () {
        setState(() {
          _selectedbroker = brok;
        });
        Navigator.pop(context);
      },
    );
  }
}
