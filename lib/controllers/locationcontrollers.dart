import 'package:geocoder2/geocoder2.dart';
import 'package:get/get.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:location/location.dart';

class Locationcontrollers extends GetxController {
  late LocationData locationData;
  var current_lat = 0.0.obs;
  var current_long = 0.0.obs;
  var address = "".obs;
  var city = "".obs;
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await get_current_location();
  }

  Future<void> get_current_location() async {
    Location location = new Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationData = await location.getLocation();
    current_lat.value = locationData.latitude!;
    current_long.value = locationData.longitude!;

    update();
    await getmycity(locationData);
  }

  Future<void> getmycity(LocationData locationData) async {
    // google geocoding
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: current_lat.value,
        longitude: current_long.value,
        googleMapApiKey: Constants.mapapi);
    address.value = data.address;
    city.value = data.city;
    // print(current_lat.value);
    // print(current_long.value);
    // print(city.value);

    update();
  }
}
