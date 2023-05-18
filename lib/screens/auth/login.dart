import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/controllers/connectivity.dart';
import 'package:hakimea/controllers/splashcontroller.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/buttonspinner.dart';

import '../../controllers/user_controllers/logincontroller.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

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
              const SizedBox(
                height: 30,
              ),
              const Align(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage("assets/images/logo.png"),
                    width: 110,
                    height: 110,
                  )),
              const SizedBox(
                height: 5,
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Login to your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              // login form
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        key:const Key("login email"),
                        controller: _emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == "") {
                            Get.find<LoginController>().is_loging.value = false;
                            return customsnack("Email is empity");
                          } else if (!RegExp(
                                  "^[a-zA-Z0-9+_.-]+@[a-zA-Z.-]+.[a-z]")
                              .hasMatch(value!)) {
                            Get.find<LoginController>().is_loging.value = false;
                            return customsnack("Please enter valid Email");
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "email",
                            filled: true,
                            contentPadding: const EdgeInsets.all(15),
                            prefixIcon: const Icon(Icons.email),
                            errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Constants.whitesmoke),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Constants.primcolor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Constants.primcolor.withOpacity(0.2)),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30))),
                            fillColor: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() => TextFormField(
                        key: const Key("login password"),
                            controller: _passwordcontroller,
                            obscureText: Get.find<LoginController>()
                                .password_visible
                                .value,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return customsnack("empity password");
                              } else if (value.length < 6) {
                                return customsnack("Password length must be 6");
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(15),
                                hintText: "password",
                                filled: true,
                                prefixIcon: const Icon(Icons.key_sharp),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      Get.find<LoginController>()
                                              .password_visible
                                              .value =
                                          !Get.find<LoginController>()
                                              .password_visible
                                              .value;
                                    },
                                    icon: Get.find<LoginController>()
                                                .password_visible
                                                .value ==
                                            true
                                        ? const Icon(
                                            Icons.visibility_off,
                                            color: Colors.black45,
                                          )
                                        : const Icon(
                                            Icons.visibility,
                                            color: Colors.black45,
                                          )),
                                border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Constants.whitesmoke),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Constants.primcolor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Constants.primcolor
                                            .withOpacity(0.2)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30))),
                                fillColor: Colors.white),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      // forgot pass button
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed("/forgotpassword");
                          },
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(color: Constants.primcolor),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Mutation(
                        options: MutationOptions(
                          document: gql(Mymutation.login),
                          onError: (error) {
                            Get.find<LoginController>().is_loging.value = false;
                            customsnack(error!.graphqlErrors.first.message);
                          },
                          onCompleted: (data) {
                            if (data != null) {
                              Get.find<SplashController>()
                                  .prefs
                                  .setInt('id', data["login"]["id"]);
                              Get.find<SplashController>()
                                  .prefs
                                  .setString('token', data["login"]["token"]);
                              if (data["login"]["user_name"] == null) {
                                Get.offAllNamed("/mainhomepage");
                              } else {}
                              Get.find<LoginController>().is_loging.value =
                                  false;
                            } else {}
                          },
                        ),
                        builder: (runMutation, result) {
                          if (result!.hasException) {
                            Get.find<LoginController>().is_loging.value =false;
                          }
                          if (result.isLoading) {
                            Get.find<LoginController>().is_loging.value = true;
                          }

                          return Container(
                              width: Get.width,
                              margin:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Obx(() => ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(40)),
                                    child: ElevatedButton(
                                      key: const Key("login button"),
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            padding: const EdgeInsets.all(15)),
                                        onPressed: ()async{
                                          _formkey.currentState!.save();
                                          if (_formkey.currentState!
                                              .validate()) {
                                            Get.find<CheekConnecctivityController>()
                                                    .has_connecction
                                                    .value
                                                ? runMutation({
                                                    "email":
                                                        _emailcontroller.text,
                                                    "password":
                                                        _passwordcontroller.text
                                                  })
                                                : customsnack(
                                                    "cheek your connection");
                                          }
                                        },
                                        child: Get.find<LoginController>()
                                                .is_loging
                                                .value
                                            ? const ButtonSpinner()
                                            : const Text(
                                                "Login",style: TextStyle(color: Colors.white),
                                              )),
                                  )));
                        },
                      ),
                      // login button
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () {
                            Get.offAllNamed("/mainhomepage");
                          },
                          child: const Text(
                            "Continue as guest",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),

                      const SizedBox(
                        height: 30,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Expanded(
                            child: Divider(
                              color: Colors.black12,
                              thickness: 1,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "OR",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.black12,
                              thickness: 1,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 30,
                            ),
                            FaIcon(
                              FontAwesomeIcons.google,
                              color: Colors.blue,
                              size: 30,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            FaIcon(
                              FontAwesomeIcons.facebook,
                              color: Colors.blue,
                              size: 30,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Dont have an account?",
                            style: TextStyle(color: Colors.black54),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed("/signup");
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Constants.primcolor,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
