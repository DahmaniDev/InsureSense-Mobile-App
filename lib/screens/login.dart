import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insuresense/model/customer.dart';
import 'package:insuresense/model/profile.dart';
import 'package:insuresense/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:insuresense/common/constants.dart' as constants;

class Signin extends StatefulWidget {
  static const String id = 'sign in';

  const Signin({Key? key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

// Customer Login : LastName@insuresense.com
// Customer Password : ID

class _SigninState extends State<Signin> {
  TextEditingController lgc = TextEditingController();
  TextEditingController pwdC = TextEditingController();
  late Customer user;
  late Profile userProfile;
  late bool fetched;
  bool type_error = false;
  bool auth_error = false;

  Future<Customer> loginCustomer(String login, String pwd) async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    final test = await http
        .get(Uri.parse(constants.url + '/customer/' + login + '/' + pwd),
            headers: headers)
        .then((http.Response response) async {
      if (response.statusCode == 200 && response.contentLength! > 2) {
        user = Customer.fromJson(jsonDecode(response.body)[0]);
        setState(() {
          auth_error = false;
        });
      } else {
        setState(() {
          auth_error = true;
        });
        user = const Customer();
      }
    });
    return user;
  }

  Future<Profile> loginCustomerProfile(int id) async {
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };
    final test = await http
        .get(Uri.parse(constants.url + '/profile/$id'), headers: headers)
        .then((http.Response response) async {
      if (response.statusCode == 200 && response.contentLength! > 2) {
        userProfile = Profile.fromJson(jsonDecode(response.body)[0]);
        setState(() {
          auth_error = false;
        });
      } else {
        setState(() {
          auth_error = true;
        });
        userProfile = const Profile();
      }
    });
    return userProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color(0XFF1f303f).withOpacity(1),
          Color(0XFF1f303f).withOpacity(0.7),
          Color(0XFF1f303f).withOpacity(0.4),
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            // #login, #welcome
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: 'KaushanScript'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'KaushanScript'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        // #email, #password
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(171, 171, 171, .7),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)),
                            ],
                          ),
                          child: Column(
                            children: [
                              type_error
                                  ? Center(
                                      child: Text(
                                        'Verify your inputs',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : Container(),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: lgc,
                                  decoration: const InputDecoration(
                                      hintText: "Email",
                                      hintStyle:
                                          TextStyle(color: Color(0xFF83BD75)),
                                      border: InputBorder.none),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: TextField(
                                  obscureText: true,
                                  keyboardType: TextInputType.number,
                                  controller: pwdC,
                                  decoration: const InputDecoration(
                                      hintText: "Password",
                                      hintStyle:
                                          TextStyle(color: Color(0xFF83BD75)),
                                      border: InputBorder.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        // #login
                        Container(
                          height: 50,
                          width: 200,
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xFF4E944F)),
                          child: TextButton(
                            //Login Method
                            onPressed: () async {
                              String log = "";
                              if (lgc.text.contains('@') &&
                                  lgc.text.length > 8 &&
                                  lgc.text.substring(lgc.text.lastIndexOf('@'),
                                          lgc.text.length) ==
                                      "@insuresense.com" &&
                                  pwdC.text.isNotEmpty) {
                                log = lgc.text
                                    .substring(0, lgc.text.lastIndexOf('@'));

                                await loginCustomer(log, pwdC.text);
                                if (auth_error) {
                                  setState(() {
                                    type_error = true;
                                  });
                                } else {
                                  await loginCustomerProfile(user.profileID!);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen(
                                                user: user,
                                                userProfile: userProfile,
                                              )));
                                }
                              } else {
                                setState(() {
                                  type_error = true;
                                });
                              }
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // #login SNS
                        Image.asset(
                          'assets/logo.png',
                          height: 160,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
