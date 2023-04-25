import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/utils/constants.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();

  customsnack(String message) {
    return Get.snackbar("Error", message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        maxWidth: Get.width,
        snackStyle: SnackStyle.GROUNDED,
        margin: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
        padding: const EdgeInsets.all(10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.whitesmoke,
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const FaIcon(FontAwesomeIcons.arrowLeft),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Forgot Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "We need your registration email account",
                style: TextStyle(color: Colors.black45),
              ),
              const Text(
                "to send your password reset code!",
                style: TextStyle(color: Colors.black45),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == "") {
                            return customsnack("Email is empity");
                          } else if (!RegExp(
                                  "^[a-zA-Z0-9+_.-]+@[a-zA-Z.-]+.[a-z]")
                              .hasMatch(value!)) {
                            return customsnack("Please enter valid Email");
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            label: Text(
                              "Email",
                              style: TextStyle(color: Colors.black45),
                            ),
                            hintText: "youremail@gmail.com",
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black45),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black45),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black45),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            fillColor: Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Resend?",
                          style: TextStyle(color: Constants.primcolor),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Mutation(
                        options: MutationOptions(
                          document: gql(Mymutation.forgot_password),
                          onCompleted: (data) {
                            Get.toNamed("/verification");
                          },
                        ),
                        builder: (runMutation, result) {
                          return Container(
                              width: Get.width,
                              margin:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(40)),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: const EdgeInsets.all(15)),
                                    onPressed: () {
                                      // Get.toNamed("/verification");
                                      _formkey.currentState!.save();
                                      if (_formkey.currentState!.validate()) {}

                                      runMutation(
                                          {"email": _emailcontroller.text});
                                    },
                                    child: const Text(
                                      "Send",
                                    )),
                              ));
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
