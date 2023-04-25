import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/controllers/splashcontroller.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/buttonspinner.dart';

class VerificationCode extends StatelessWidget {
  VerificationCode({super.key});

  int id = Get.find<SplashController>().prefs.getInt('id');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.whitesmoke,
      appBar: AppBar(
        backgroundColor: Constants.whitesmoke,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Verification Code",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "We send the verification code to your email enter the code and verify your account!",
                style: TextStyle(color: Colors.black45),
              ),
              const SizedBox(
                height: 30,
              ),
              // Mutation(
              //   options: MutationOptions(
              //     document: gql(),
              //     onError: (error) {},
              //     onCompleted: (data) {
              //       Get.find<SplashController>()
              //           .prefs
              //           .setBool('isverifay', data!["verify"]["is_verified"]);
              //       Get.find<SplashController>()
              //           .prefs
              //           .setBool('isdoctor', true);
              //       // Get.find<dsignupcontroller>().is_verifaying.value = true;
              //       showDialog(
              //           context: context,
              //           builder: (context) {
              //             return AlertDialog(
              //                 content: Container(
              //               height: 265,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(20)),
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: [
              //                   const Image(
              //                     image:
              //                         AssetImage("assets/images/checked.png"),
              //                     width: 100,
              //                     height: 100,
              //                   ),
              //                   const Text(
              //                     "verified",
              //                     style: TextStyle(
              //                         fontSize: 23,
              //                         fontWeight: FontWeight.bold,
              //                         color: Constants.primcolor),
              //                   ),
              //                   const SizedBox(
              //                     height: 15,
              //                   ),
              //                   const Text(
              //                     "Your Account is verified please add more information about you to make your account approved by HAKIME!",
              //                     style: TextStyle(
              //                         fontSize: 14, color: Colors.black54),
              //                   ),
              //                   const SizedBox(
              //                     height: 15,
              //                   ),
              //                   GestureDetector(
              //                     onTap: () => Get.offAllNamed("/dprofile"),
              //                     child: const Text(
              //                       "OK",
              //                       style: TextStyle(
              //                           color: Constants.primcolor,
              //                           fontSize: 20),
              //                     ),
              //                   )
              //                 ],
              //               ),
              //             ));
              //           });
              //     },
              //   ),
              //   builder: (runMutation, result) {
              //     if (result!.isLoading) {
              //       //Get.find<dsignupcontroller>().is_verifaying.value = true;
              //     }
              //     return Column(
              //       children: [
              //         const SizedBox(
              //           height: 20,
              //         ),
              //         OtpTextField(
              //           numberOfFields: 6,
              //           decoration: InputDecoration(
              //               filled: true,
              //               focusColor: Constants.primcolor,
              //               fillColor: Constants.primcolor.withOpacity(0.3)),
              //           cursorColor: Constants.primcolor,
              //           showFieldAsBox: true,
              //           onCodeChanged: (String code) {},
              //           onSubmit: (String verificationCode) {
              //             runMutation({"code": verificationCode, "id": id});
              //           }, // end onSubmit
              //         ),
              //         const SizedBox(
              //           height: 20,
              //         ),
              //         TextButton(
              //           onPressed: () {},
              //           child: const Text(
              //             "Resend?",
              //             style: TextStyle(color: Constants.primcolor),
              //           ),
              //         ),
              //         const SizedBox(
              //           height: 50,
              //         ),
              //         Obx(() => Container(
              //               width: Get.width,
              //               margin: const EdgeInsets.only(left: 15, right: 15),
              //               child: ClipRRect(
              //                   borderRadius: BorderRadius.circular(30),
              //                   child: ElevatedButton(
              //                       style: ElevatedButton.styleFrom(
              //                           elevation: 0,
              //                           padding: const EdgeInsets.all(15)),
              //                       onPressed: () {},
              //                       child: const Text("Verify")
              //                       //
              //                       //  Get.find<dsignupcontroller>()
              //                       //         .is_verifaying
              //                       //         .value
              //                       //     ? Row(
              //                       //         mainAxisAlignment:
              //                       //             MainAxisAlignment.center,
              //                       //         children: const [
              //                       //           ButtonSpinner(),
              //                       //           SizedBox(
              //                       //             width: 10,
              //                       //           ),
              //                       //           Text("Verifaying..")
              //                       //         ],
              //                       //       )
              //                       //     : const Text(
              //                       //         "Verify",
              //                       //       )),

              //                       )),
              //             ))
              //       ],
              //     );
              //   },
              // ),
            ],
          ),
        ),
      )),
    );
  }
}
