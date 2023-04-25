import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:hakimea/controllers/user_controllers/payment_controllers.dart';
import 'package:hakimea/utils/constants.dart';

class InappWebview extends StatelessWidget {
  String chapa_url;
  InappWebview({super.key, required this.chapa_url});
  late InAppWebViewController webview;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: SizedBox(
          height: Get.height / 1.2,
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(chapa_url)),
                onWebViewCreated: (controller) => webview = controller,
                onProgressChanged: (controller, progress) {
                  Get.find<PaymentControllers>().webview_progress.value =
                      progress / 100;
                },
              ),
              Obx(() => Visibility(
                  visible:
                      Get.find<PaymentControllers>().webview_progress.value == 1
                          ? false
                          : true,
                  child: Center(
                    child: Obx(() => CircularProgressIndicator(
                          value: Get.find<PaymentControllers>()
                              .webview_progress
                              .value,
                          color: Constants.primcolor,
                        )),
                  )))
            ],
          ),
        ),
      ),
    );
  }
}
