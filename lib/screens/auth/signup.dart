import 'package:country_phone_code_picker/controller/country_controller.dart';
import 'package:country_phone_code_picker/core/country_phone_code_picker_widget.dart';
import 'package:country_phone_code_picker/models/country.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/buttonspinner.dart';

import '../../controllers/splashcontroller.dart';
import '../../controllers/user_controllers/signupcontroller.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final _formkey = GlobalKey<FormState>();
  CountryController countryController = CountryController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _firstnamecontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();
  final TextEditingController _datebirthcontroller = TextEditingController();

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 200,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            //height: 245,
            margin: const EdgeInsets.only(top: 40),
            child: Column(
              children: const [
                SizedBox(
                  height: 15,
                ),
                Image(
                  image: AssetImage("assets/images/logo.png"),
                  width: 110,
                  height: 110,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Create new  account",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          backgroundColor: Constants.whitesmoke,
          elevation: 0,
        ),
        body:
            // signup for patient
            SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // sign up form
                Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // first name
                        const Text("Full name"),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _firstnamecontroller,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return customsnack("enter your name");
                            } else if (!RegExp("^[a-zA-Z0-9+_.-]")
                                .hasMatch(value)) {
                              customsnack("enter valid name");
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              hintText: "full name",
                              filled: true,
                              contentPadding: const EdgeInsets.all(17),
                              border: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Constants.whitesmoke),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Constants.primcolor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Constants.primcolor.withOpacity(0.2)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              fillColor: Colors.white),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        //gender
                        ListTile(
                          title: const Text("Gender *"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Obx(
                                    () => Radio(
                                      value: "male",
                                      groupValue: Get.find<SignUpController>()
                                          .gender
                                          .value,
                                      onChanged: (value) {
                                        Get.find<SignUpController>()
                                            .gender
                                            .value = value!;
                                      },
                                      activeColor: Colors.green,
                                    ),
                                  ),
                                  const Text("Male"),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Obx(() => Radio(
                                        value: "female",
                                        groupValue: Get.find<SignUpController>()
                                            .gender
                                            .value,
                                        onChanged: (value) {
                                          Get.find<SignUpController>()
                                              .gender
                                              .value = value!;
                                        },
                                        activeColor: Colors.green,
                                      )),
                                  const Text("Female")
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // date of birth
                        const Text("Date of birth"),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _datebirthcontroller,
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return customsnack("enter your date of birth");
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              hintText: "date of birth",
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    DateTime? date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1970),
                                        lastDate: DateTime(2060),
                                        keyboardType: TextInputType.datetime);
                                    if (!date.isNull) {
                                      _datebirthcontroller.text =
                                          "${date?.day}/${date?.month}/${date?.year}";
                                    }
                                  },
                                  icon:
                                      const FaIcon(FontAwesomeIcons.calendar)),
                              filled: true,
                              contentPadding: const EdgeInsets.all(17),
                              border: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Constants.whitesmoke),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Constants.primcolor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Constants.primcolor.withOpacity(0.2)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              fillColor: Colors.white),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        //phone number
                        const Text("Phone number*"),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            CountryPhoneCodePicker.withDefaultSelectedCountry(
                              defaultCountryCode: Country(
                                  name: 'Ethiopia',
                                  countryCode: 'ET',
                                  phoneCode: '+251'),
                              showPhoneCode: true,
                              borderRadius: 10,
                              borderWidth: 1,
                              width: 110,
                              borderColor: Constants.primcolor.withOpacity(0.2),
                              style: const TextStyle(fontSize: 13),
                              searchBarHintText: 'Search by name',
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _phonecontroller,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return customsnack("enter phone number");
                                  } else if (!RegExp("^[0-9]")
                                      .hasMatch(value)) {
                                    customsnack(
                                        "Please enter valid phone number");
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: "Phone number",
                                    filled: true,
                                    contentPadding: const EdgeInsets.all(17),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.whitesmoke),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.primcolor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.primcolor
                                                .withOpacity(0.2)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    fillColor: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //email
                        const Text("Email*"),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _emailcontroller,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == "") {
                              return customsnack("Email is empity");
                            } else if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value!)) {
                              customsnack("Please enter valid Email");
                            } else {
                              return null;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              hintText: "email",
                              filled: true,
                              contentPadding: const EdgeInsets.all(17),
                              border: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Constants.whitesmoke),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Constants.primcolor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Constants.primcolor.withOpacity(0.2)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              fillColor: Colors.white),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // pssword
                        const Text("Password*"),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(() => TextFormField(
                              controller: _passwordcontroller,
                              keyboardType: TextInputType.text,
                              obscureText: Get.find<SignUpController>()
                                  .password_visible
                                  .value,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return customsnack("enter password");
                                } else if (value.length < 6) {
                                  return customsnack(
                                      "password length must be 6");
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: "password",
                                  filled: true,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        Get.find<SignUpController>()
                                                .password_visible
                                                .value =
                                            !Get.find<SignUpController>()
                                                .password_visible
                                                .value;
                                      },
                                      icon: Get.find<SignUpController>()
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
                                  contentPadding: const EdgeInsets.all(17),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Constants.whitesmoke),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Constants.primcolor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Constants.primcolor
                                              .withOpacity(0.2)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  fillColor: Colors.white),
                            )),

                        const SizedBox(
                          height: 70,
                        ),

                        // sign up button
                        Mutation(
                          options: MutationOptions(
                            document: gql(Mymutation.usersignup),
                            onError: (error) {
                              customsnack(error.toString());
                              Get.find<SignUpController>().is_signup.value =
                                  false;
                            },
                            onCompleted: (data) {
                              if (data!.isNotEmpty) {
                                Get.find<SplashController>()
                                    .prefs
                                    .setInt('id', data["userSignUp"]["id"]);
                                Get.find<SplashController>().prefs.setString(
                                    'token', data["userSignUp"]["token"]);

                                Get.offAllNamed("/mainhomepage");
                              }
                              Get.find<SignUpController>().is_signup.value =
                                  false;
                            },
                          ),
                          builder: (runMutation, result) {
                            if (result!.hasException) {
                              Get.find<SignUpController>().is_signup.value =
                                  false;
                            }
                            if (result.isLoading) {
                              Get.find<SignUpController>().is_signup.value =
                                  true;
                            }

                            return Container(
                                width: Get.width,
                                margin:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Obx(() => ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              padding:
                                                  const EdgeInsets.all(15)),
                                          onPressed: () {
                                            _formkey.currentState!.save();
                                            if (_formkey.currentState!
                                                .validate()) {
                                              if (Get.find<SignUpController>()
                                                  .gender
                                                  .value
                                                  .isEmpty) {
                                                customsnack(
                                                    "enter your gender");
                                              } else {
                                                // run mutation hear
                                                runMutation({
                                                  "full_name":
                                                      _firstnamecontroller.text,
                                                  "sex": Get.find<
                                                          SignUpController>()
                                                      .gender
                                                      .value,
                                                  "phone_number":
                                                      _phonecontroller.text,
                                                  "email":
                                                      _emailcontroller.text,
                                                  "password":
                                                      _passwordcontroller.text,
                                                  "date_of_birth":
                                                      _datebirthcontroller.text
                                                });
                                              }
                                            }
                                          },
                                          child: Get.find<SignUpController>()
                                                  .is_signup
                                                  .value
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    ButtonSpinner(),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Text("Signing Up...")
                                                  ],
                                                )
                                              : const Text(
                                                  "Sign Up",
                                                )),
                                    )));
                          },
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                            ),
                            TextButton(
                              onPressed: () {
                                Get.offNamed("/login");
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(color: Constants.primcolor),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
        // signup for doctor
      ),
    );
  }
}
