import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/user_controllers/doctorprofilecontroller.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/buttonspinner.dart';
import 'package:hakimea/widgets/loading.dart';

import '../../../../controllers/splashcontroller.dart';

class EditAccount extends StatelessWidget {
  EditAccount({Key? key}) : super(key: key);

  TextEditingController fullnamecontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController gendercontroller = TextEditingController();
  TextEditingController datebirthcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.whitesmoke,
      appBar: AppBar(
        backgroundColor: Constants.primcolor,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.white,
            )),
        title: const Text(
          "Edit Account",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [

              Query(
                options: QueryOptions(
                  document: gql(Myquery.userprofile),
                  variables: {
                    "id": Get.find<SplashController>().prefs.getInt("id")
                  },
                  onComplete: (data) {},
                ),
                builder: (result, {fetchMore, refetch}) {
                  if (result.isLoading) {
                    return const Center(
                      child: loading(),
                    );
                  }

                  if (result.data != null && result.data!.isNotEmpty) {
                    fullnamecontroller.text =
                        result.data!["users_by_pk"]["full_name"];
                    phonecontroller.text =
                        result.data!["users_by_pk"]["phone_number"];
                    gendercontroller.text = result.data!["users_by_pk"]["sex"];
                    datebirthcontroller.text =
                        result.data!["users_by_pk"]["date_of_birth"];
                    emailcontroller.text = result.data!["users_by_pk"]["email"];
                  }

                  return  Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: Get.width,
                                height: 120,
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  width: Get.width,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                      color: Constants.primcolor,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20))),
                                ),
                              ),

                              Positioned(
                                bottom:0,
                                top:1,
                                left:Get.width/2-60,

                                child: Container(
                                  padding:const EdgeInsets.all(5),
                                  decoration:const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white

                                  ),
                                  child: CircleAvatar(
                                      radius: 60,
                                      backgroundColor:
                                      Constants.primcolor.withOpacity(0.3),
                                      backgroundImage: result.data!["users_by_pk"]
                                      ["profile_image"] ==
                                          null
                                          ? const AssetImage("assets/images/user.png")
                                          : NetworkImage(
                                          result.data!["users_by_pk"]
                                          ["profile_image"]["url"])
                                      as ImageProvider),
                                ),
                              )

                            ],
                          ),
                          Text(result.data!["users_by_pk"]["full_name"],textAlign: TextAlign.center,),

                          const SizedBox(
                            height: 30,
                          ),
                  Form(
                  child:
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                    children:[
                            // first name
                            TextFormField(
                              controller: fullnamecontroller,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                  label: Text(
                                    "Full Name",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  hintText: "first name",
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.whitesmoke),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.whitesmoke),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.whitesmoke),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  fillColor: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: phonecontroller,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                  label: Text(
                                    "Phone",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  hintText: "Phone number",
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.whitesmoke),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.whitesmoke),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.whitesmoke),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  fillColor: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: gendercontroller,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  label: const Text(
                                    "Gender",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  hintText: "male",
                                  filled: true,
                                  suffixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const FaIcon(
                                          FontAwesomeIcons.angleDown)),
                                  border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.whitesmoke),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.whitesmoke),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.whitesmoke),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  fillColor: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: datebirthcontroller,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  label: const Text(
                                    "Date of birth",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  hintText: "Date of birth",
                                  filled: true,
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        var date = await DatePickerDialog(
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2030));
                                      },
                                      icon: const FaIcon(
                                          FontAwesomeIcons.calendar)),
                                  border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.whitesmoke),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.whitesmoke),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.whitesmoke),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  fillColor: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: emailcontroller,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                  label: Text(
                                    "Email",
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                  hintText: "Email",
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.whitesmoke),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.whitesmoke),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Constants.whitesmoke),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15))),
                                  fillColor: Colors.white),
                            ),

                            const SizedBox(
                              height: 50,
                            ),
                            Mutation(
                              options: MutationOptions(
                                document: gql(Mymutation.update_user),
                                onCompleted: (data) {
                                  Get.find<DoctorProfileController>()
                                      .is_updating_user
                                      .value = false;
                                  Get.back();
                                },
                                onError: (error) {
                                  Get.find<DoctorProfileController>()
                                      .is_updating_user
                                      .value = false;
                                },
                              ),
                              builder: (runMutation, result) {
                                if (result!.isLoading) {
                                  Get.find<DoctorProfileController>()
                                      .is_updating_user
                                      .value = true;
                                }
                                return Obx(() => Container(
                                    width: Get.width,
                                    margin: const EdgeInsets.all(15),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(15),
                                          ),
                                          onPressed: () {
                                            runMutation({
                                              "id": Get.find<SplashController>()
                                                  .prefs
                                                  .getInt("id"),
                                              "full_name":
                                                  fullnamecontroller.text,
                                              "phone_number":
                                                  phonecontroller.text,
                                              "sex": gendercontroller.text,
                                              "emil": emailcontroller.text,
                                              "date_of_birth":
                                                  datebirthcontroller.text
                                            });
                                          },
                                          child:
                                              Get.find<DoctorProfileController>()
                                                      .is_updating_user
                                                      .value
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        ButtonSpinner(),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text("updating....")
                                                      ],
                                                    )
                                                  : const Text("Update")),
                                    )));
                              },
                            )
                          ],
                    ),
                  )
                  ),
                      ]

                  );
                },
              ),
            ],
          )),
    );
  }
}
