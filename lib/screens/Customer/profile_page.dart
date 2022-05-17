import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insuresense/model/complain.dart';
import 'package:insuresense/model/complaincategory.dart';
import 'package:insuresense/model/customer.dart';
import 'package:http/http.dart' as http;
import 'package:insuresense/model/product.dart';
import 'package:insuresense/model/profile.dart';
import 'package:insuresense/model/regions.dart';
import 'package:insuresense/screens/Customer/create_complain.dart';
import 'package:insuresense/screens/Customer/profile_image.dart';
import 'package:insuresense/common/constants.dart' as constants;

class ProfilePage extends StatefulWidget {
  Customer? user;
  Profile? userProfile;
  ProfilePage({Key? key, @required this.user, @required this.userProfile})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Complain> complains = <Complain>[];
  late bool fetched;
  int nbrComplains = 0;
  List<ComplainCategory> complainCategories = <ComplainCategory>[];
  List<Product> products = <Product>[];
  Region? region;

  Future<bool> fetchComplains() async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    final test = await http
        .get(
            Uri.parse(constants.url +
                '/complain/getByCustomerId/${widget.user!.customerID}'),
            headers: headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        setState(() {
          nbrComplains = l.length;
        });

        for (var i = 0; i < l.length; i++) {
          Complain c = Complain.fromJson(l.elementAt(i));
          if (c != null) {
            complains.add(c);
            getCategory(c.categoryID!);
            getproduct(c.productID!);
          }
        }
      }
    });
    return true;
  }

  Future<bool> getCategory(int idC) async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    final test = await http
        .get(Uri.parse(constants.url + '/categories/$idC'), headers: headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        ComplainCategory complainCategory = ComplainCategory.fromJson(l.first);
        complainCategories.add(complainCategory);
      }
    });
    return true;
  }

  Future<bool> getproduct(int idP) async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    final test = await http
        .get(Uri.parse(constants.url + '/products/$idP'), headers: headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        Product complainProduct = Product.fromJson(l.first);
        products.add(complainProduct);
      }
    });
    return true;
  }

  Future<bool> getUserRegion(int idR) async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    final test = await http
        .get(Uri.parse(constants.url + '/regions/$idR'), headers: headers)
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        setState(() {
          region = Region.fromJson(l.first);
        });
        return true;
      }
    });
    return true;
  }

  void _assignComplains() async {
    complains = [];
    complainCategories = [];
    products = [];
    fetched = await fetchComplains();
    getUserRegion(widget.user!.regionID!);
  }

  @override
  void initState() {
    print(widget.user!.regionID);
    _assignComplains();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 24),
        ProfileWidget(widget.key, widget.userProfile!.sexe),
        const SizedBox(height: 24),
        buildName(),
        const SizedBox(height: 24),
        NumbersWidget(nbrComplains),
        const SizedBox(height: 24),
        buildProfileStats(),
        const SizedBox(height: 24),
        Center(child: buildComplainsButtons()),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget buildName() => Column(
        children: [
          Text(
            widget.user!.firstName! + ' ' + widget.user!.lastName!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            '@insuresense.com',
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildProfileStats() => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 30),
                const SizedBox(width: 10),
                Text('Sexe :', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Text(widget.userProfile!.sexe!,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1f303f),
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.date_range, size: 30),
                const SizedBox(width: 10),
                Text('Birth Date :', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Text(
                    '${widget.user!.birthDate!.day}-${widget.user!.birthDate!.month}-${widget.user!.birthDate!.year}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1f303f),
                        fontWeight: FontWeight.bold))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.family_restroom, size: 30),
                const SizedBox(width: 10),
                Text('Marital Status :', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Text(widget.userProfile!.marital_status!,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1f303f),
                        fontWeight: FontWeight.bold))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pin_drop, size: 30),
                const SizedBox(width: 10),
                Text('Region :', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Flexible(
                    child: region != null
                        ? Text('${region!.state} - ${region!.county}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1f303f),
                                fontWeight: FontWeight.bold))
                        : Text('',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1f303f),
                                fontWeight: FontWeight.bold))),
              ],
            ),
          ],
        ),
      );

  Widget buildComplainsButtons() => Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 150,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFF1f303f)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateComplainPage(
                                    user: widget.user,
                                    profile: widget.userProfile,
                                  )))
                      .then((value) => value ? _assignComplains() : null);
                },
                child: const Text(
                  "New Complain",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 150,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFF374e59)),
              child: TextButton(
                onPressed: () async {
                  showModalBottomSheet(
                      context: context,
                      builder: (ctx) => _buildBottomSheet(ctx, complains));
                },
                child: const Text(
                  "Complains History",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );

  Container _buildBottomSheet(BuildContext ctx, List<Complain> comp) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.greenAccent, width: 2.0),
          color: Color(0xFFB4E197),
          borderRadius: BorderRadius.circular(8.0)),
      child: ListView.builder(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          itemCount: comp.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Center(
                      child: Text("Your complains",
                          style: TextStyle(
                              color: Color(0xFF1f303f),
                              fontSize: 20,
                              fontFamily: 'KaushanScript')),
                    ),
                  ),
                  buildComplain(comp[index], index),
                ],
              );
            }
            return buildComplain(comp[index], index);
          }),
    );
  }

  Widget buildComplain(Complain comp, int index) {
    return GestureDetector(
      child: Card(
        elevation: 7.0,
        child: ListTile(
          leading: comp.handledBy == 0
              ? Icon(
                  Icons.access_time,
                  color: Colors.yellow,
                )
              : comp.clientSatisfaction == "SAT"
                  ? Icon(
                      Icons.gpp_good,
                      color: Colors.green,
                    )
                  : comp.clientSatisfaction == "NSA"
                      ? Icon(
                          Icons.gpp_bad,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.gpp_maybe,
                          color: Colors.blue,
                        ),
          title: Text(
              '${complainCategories[index].description}'), //***********************
          subtitle: Text(
            '${products[index].productCode}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      onTap: () {},
    );
  }
}

class NumbersWidget extends StatelessWidget {
  final int? param;

  NumbersWidget(this.param);
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, param!, 'Complaints'),
          buildDivider(),
          buildButton(context, param!, 'Score'),
        ],
      );
  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, int value, String text) {
    final image;
    if (value == 2 || value == 3)
      image = AssetImage('assets/yellow_dot.png');
    else if (value < 2)
      image = AssetImage('assets/green_dot.png');
    else
      image = AssetImage('assets/red_dot.png');
    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 4),
      onPressed: () {},
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          value == -1
              ? SizedBox(
                  height: 10, width: 10, child: CircularProgressIndicator())
              : text != 'Score'
                  ? Text(
                      '$value',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    )
                  : Ink.image(
                      image: image,
                      fit: BoxFit.cover,
                      width: 28,
                      height: 28,
                      child: InkWell(),
                    ),
          SizedBox(height: 2),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
