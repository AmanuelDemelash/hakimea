import 'package:flutter/material.dart';

class No_doc_found extends StatelessWidget {
  const No_doc_found({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 200),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(
              height: 50,
            ),
            Image(
              image: AssetImage(
                "assets/images/no_data.png",
              ),
              fit: BoxFit.cover,
              width: 200,
              height: 200,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "No Doctor Found !",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
