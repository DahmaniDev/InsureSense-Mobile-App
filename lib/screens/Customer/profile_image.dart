import 'dart:io';

import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String? sexe;
  ProfileWidget(Key? key, this.sexe) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Colors.black87;

    return Center(
      child: Stack(
        children: [
          buildImage(sexe!),
        ],
      ),
    );
  }
}

Widget buildImage(String sexe) {
  final image = AssetImage('assets/maleicon.jpg');
  final image2 = AssetImage('assets/femaleicon.jpg');
  return ClipOval(
    child: Material(
      color: Colors.transparent,
      child: Ink.image(
        image: sexe.compareTo("MALE") == 0 ? image : image2,
        fit: BoxFit.cover,
        width: 128,
        height: 128,
        child: InkWell(),
      ),
    ),
  );
}

Widget buildEditIcon(Color color) => InkWell(
      onTap: () {},
      child: buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );

Widget buildCircle({
  required Widget child,
  required double all,
  required Color color,
}) =>
    ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
