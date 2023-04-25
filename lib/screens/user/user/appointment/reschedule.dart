import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:emoji_alert/arrays.dart';
import 'package:emoji_alert/emoji_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/controllers/notification_controller.dart';
import 'package:hakimea/controllers/user_controllers/myappointmentcontroller.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/buttonspinner.dart';

class Reschedule extends StatelessWidget {
  const Reschedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int id = Get.arguments;
    return Scaffold(
      backgroundColor: Constants.whitesmoke,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.whitesmoke,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.black,
            )),
        title: const Text(
          "Reschedule Appointment",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25,
            ),
            const Text(
              "Select Date*",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: DatePickerWidget(
                looping: false, // default is not looping
                firstDate: DateTime.now(), //DateTime(1960),
                //  lastDate: DateTime(2002, 1, 1),
                initialDate: DateTime.now(), // DateTime(1994),
                dateFormat: "dd/MMMM/yyyy",
                onChange: (dateTime, selectedIndex) {
                  Get.find<MyappointmentController>().resc_date.value =
                      "${dateTime.year}/${dateTime.month}/${dateTime.day}";
                },
                pickerTheme: DateTimePickerTheme(
                  backgroundColor: Colors.white,
                  itemTextStyle:
                      const TextStyle(color: Constants.primcolor, fontSize: 19),
                  dividerColor: Constants.primcolor.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Select Time*",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            // time picker
            Container(
              width: Get.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TimePickerSpinner(
                  is24HourMode: false,
                  normalTextStyle: TextStyle(
                      fontSize: 15,
                      color: Constants.primcolor.withOpacity(0.5)),
                  highlightedTextStyle:
                      const TextStyle(fontSize: 23, color: Constants.primcolor),
                  spacing: 10,
                  itemHeight: 50,
                  isShowSeconds: false,
                  isForce2Digits: true,
                  minutesInterval: 10,
                  onTimeChange: (p0) {
                    Get.find<MyappointmentController>().resc_time.value =
                        p0.toString();
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Mutation(
              options: MutationOptions(
                document: gql(Mymutation.reschedule_appointment),
                onError: (error) {
                  Get.find<MyappointmentController>().is_reschedule.value =
                      false;
                },
                onCompleted: (data) {
                  // run mutation for notification

                  Get.find<NotificationController>().crateNotification(
                      "Rescheduled succesfully",
                      "your appointment was rescheduled succesfully please follow your appointment");

                  Get.find<MyappointmentController>().is_reschedule.value =
                      false;
                  // alert dialog
                  EmojiAlert(
                    alertTitle: const Text("Rescheduling",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    description: Column(
                      children: const [
                        Text(
                          "appointment rescheduled succesfully",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    enableMainButton: true,
                    mainButtonColor: Constants.primcolor,
                    onMainButtonPressed: () {
                      Navigator.pop(context);
                      Get.back();
                    },
                    cancelable: false,
                    emojiType: EMOJI_TYPE.HAPPY,
                    height: 260,
                    mainButtonText: const Text("ok"),
                    animationType: ANIMATION_TYPE.ROTATION,
                  ).displayAlert(context);
                },
              ),
              builder: (runMutation, result) {
                if (result!.isLoading) {
                  Get.find<MyappointmentController>().is_reschedule.value =
                      true;
                }

                return Obx(() => Container(
                    width: Get.width,
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Constants.primcolor,
                              padding: const EdgeInsets.all(15)),
                          onPressed: () {
                            // run mutation
                            runMutation({
                              "id": Get.arguments,
                              "date": Get.find<MyappointmentController>()
                                  .resc_date
                                  .value,
                              "time": Get.find<MyappointmentController>()
                                  .resc_time
                                  .value
                            });
                          },
                          child: Get.find<MyappointmentController>()
                                  .is_reschedule
                                  .value
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    ButtonSpinner(),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Rescheduling...")
                                  ],
                                )
                              : const Text(
                                  "Reschedule",
                                )),
                    )));
              },
            )
          ],
        ),
      ),
    );
  }
}
