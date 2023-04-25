import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class OrderMedicinController extends GetxController {
  var isclicked = false.obs;
  var is_ordering = false.obs;

  RxInt uploded_image = 0.obs;

  final ImagePicker _picker = ImagePicker();
  var is_image = false.obs;
  Rx<File> image = Rx<File>(File(""));
  var prescrip_image_base64 = "".obs;

  Future<void> getpres_camera() async {
    XFile? selectedImage = await _picker.pickImage(source: ImageSource.camera);
    if (selectedImage != null) {
      is_image.value = true;
      image.value = File(selectedImage.path);
      Uint8List imgbytes = await image.value.readAsBytes();
      prescrip_image_base64.value = base64.encode(imgbytes);
      update();
    }
  }

  Future<void> getpres_gallery() async {
    XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      is_image.value = true;
      image.value = File(selectedImage.path);
      Uint8List imgbytes = await image.value.readAsBytes();
      prescrip_image_base64.value = base64.encode(imgbytes);
      update();
    }
  }
}
