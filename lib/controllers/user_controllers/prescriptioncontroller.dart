
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class PrescriptionController extends GetxController{
  final GlobalKey key = GlobalKey();

  Rx<List<String>> medicines=Rx<List<String>>([]);

  // take screen shot
  void takeScreenshot() async {
    RenderRepaintBoundary boundary =
    key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();
      // Saving the screenshot to the gallery
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(pngBytes),
          quality: 90,
          name: 'Hakime-${DateTime.now()}.png');

      Get.snackbar("Success","you successfully take a copy of your prescription",
      snackPosition:SnackPosition.TOP,
        icon:const FaIcon(FontAwesomeIcons.print,color: Colors.white,),
        backgroundColor: Colors.green,
          colorText: Colors.white
      );
    }
  }


  Future<void> getmedicines(List medcdata)async{
    medicines.value.clear();
    for(int i=0;i<medcdata.length;i++){
      medicines.value.add(medcdata[i]["medicine_name"]);
    }
    update();



}





}