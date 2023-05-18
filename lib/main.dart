import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/bindings/appbinding.dart';
import 'package:hakimea/screens/auth/forgotpassword.dart';
import 'package:hakimea/screens/auth/login.dart';
import 'package:hakimea/screens/auth/signup.dart';
import 'package:hakimea/screens/auth/verificationcode.dart';
import 'package:hakimea/screens/onbording/onbordscreen.dart';
import 'package:hakimea/screens/onbording/splash.dart';
import 'package:hakimea/screens/setting.dart';
import 'package:hakimea/screens/user/user/appointment/appointment.dart';
import 'package:hakimea/screens/user/user/appointment/myappointment.dart';
import 'package:hakimea/screens/user/user/appointment/myappointmentdetail.dart';
import 'package:hakimea/screens/user/user/appointment/paymentoverview.dart';
import 'package:hakimea/screens/user/user/appointment/reschedule.dart';
import 'package:hakimea/screens/user/user/blog/allblog.dart';
import 'package:hakimea/screens/user/user/blog/blogdetail.dart';
import 'package:hakimea/screens/user/user/chat/callended.dart';
import 'package:hakimea/screens/user/user/chat/chat_detail.dart';
import 'package:hakimea/screens/user/user/chat/voice_call.dart';
import 'package:hakimea/screens/user/user/chat/zegocloudcall.dart';
import 'package:hakimea/screens/user/user/doctor_detail/doctor.dart';
import 'package:hakimea/screens/user/user/doctor_detail/doctordetail.dart';
import 'package:hakimea/screens/user/user/doctor_detail/doctorsearch.dart';
import 'package:hakimea/screens/user/user/doctor_detail/topdoc.dart';
import 'package:hakimea/screens/user/user/favorite/favorite.dart';
import 'package:hakimea/screens/user/user/history/history.dart';
import 'package:hakimea/screens/user/user/history/video_detail_history.dart';
import 'package:hakimea/screens/user/user/history/voice_detail_history.dart';
import 'package:hakimea/screens/user/user/homepage/homepage.dart';
import 'package:hakimea/screens/user/user/main_home_page.dart';
import 'package:hakimea/screens/user/user/medicin/medicin.dart';
import 'package:hakimea/screens/user/user/medicin/medicindetail.dart';
import 'package:hakimea/screens/user/user/near_map/nearbymap.dart';
import 'package:hakimea/screens/user/user/notification/notification.dart';
import 'package:hakimea/screens/user/user/pharmacy/myorders.dart';
import 'package:hakimea/screens/user/user/pharmacy/orderdetail.dart';
import 'package:hakimea/screens/user/user/pharmacy/orderdetail_status.dart';
import 'package:hakimea/screens/user/user/pharmacy/ordermedicin.dart';
import 'package:hakimea/screens/user/user/pharmacy/pharmacy.dart';
import 'package:hakimea/screens/user/user/pharmacy/pharmacydetail.dart';
import 'package:hakimea/screens/user/user/prescription/prescriptiondetail.dart';
import 'package:hakimea/screens/user/user/prescription/prescriptions.dart';
import 'package:hakimea/screens/user/user/profile/editaccount.dart';
import 'package:hakimea/screens/user/user/profile/myprofile.dart';
import 'package:hakimea/screens/user/user/review/submitreview.dart';
import 'package:hakimea/theme/light_theme.dart';
import 'package:hakimea/translations/apptranslations.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();

  // notification
  AwesomeNotifications().initialize(
      //set the icon to null if you want to use the default app icon
      'resource://drawable/logo',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Constants.primcolor,
            importance: NotificationImportance.High,
            ledColor: Colors.white),
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Scheduled Notifications',
          defaultColor: Constants.primcolor,
          importance: NotificationImportance.High,
          channelDescription: 'Notification channel for schdule',
        ),
      ],
      //Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  MyApp({super.key});

  Future<String> getTokenFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    HttpLink httpLink = HttpLink("https://hakime-2.hasura.app/v1/graphql",
        defaultHeaders: {"x-hasura-admin-secret": "hakime"}
    );
    final WebSocketLink websocketLink = WebSocketLink(
      "wss://hakime-2.hasura.app/v1/graphql",
      config: const SocketClientConfig(
          autoReconnect: true,
          inactivityTimeout: Duration(seconds: 30),
         headers: {"x-hasura-admin-secret": "hakime"}
      ),
    );
    final Link link = Link.split(
        (request) => request.isSubscription, websocketLink, httpLink);

    final authLink =AuthLink(
      getToken: () async {
        String token = await getTokenFromSharedPreferences();
        return 'Bearer $token';
      },
    );

    final Link mainLink = authLink.concat(link);
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: link,
        // The default store is the InMemoryStofre, which does NOT persist to disk
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
    return GraphQLProvider(
      client: client,
      child: GetMaterialApp(
        initialBinding: AppBinding(),
        translations: AppTranslations(),
        locale: const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.leftToRight,
        title: Constants.app_name,
        theme: light,
        initialRoute: "/splash",
        getPages: [
          GetPage(name: "/splash", page: () => Splash()),
          GetPage(name: "/login", page: () => Login()),
          GetPage(name: "/signup", page: () => Signup()),
          GetPage(name: "/forgotpassword", page: () => ForgotPassword()),
          GetPage(name: "/homepage", page: () => Homepage()),
          GetPage(name: "/verification", page: () => VerificationCode()),
          GetPage(name: "/onbording", page: () => Onbordscreen()),
          GetPage(name: "/mainhomepage", page: () => MainHomePage()),
          GetPage(name: "/favorite", page: () => Favorite()),
          GetPage(name: "/doctorprofile", page: () => DoctorDetail()),
          GetPage(name: "/appointment", page: () => Appointment()),
          GetPage(name: "/reschedule", page: () => Reschedule()),
          GetPage(name: "/chatdetail", page: () => ChatDetail()),
          GetPage(name: "/voicehistory", page: () => VoiceHistoryDetail()),
          GetPage(name: "/videohistory", page: () => VideoHistoryDetail()),
          GetPage(name: "/myprofile", page: () => Myprofile()),
          GetPage(name: "/myappointment", page: () => Myappointment()),
          GetPage(
              name: "/myappointmentdetail", page: () => MyappointmentDetail()),
          GetPage(name: "/history", page: () => History()),
          GetPage(name: "/review", page: () => SubmitReview()),
          GetPage(name: "/callended", page: () => CallEnded()),
          GetPage(name: "/nearbymap", page: () => NearByMap()),
          GetPage(name: "/pharmacy", page: () => Pharmacy()),
          GetPage(name: "/pharmdetail", page: () => PharmacyDetail()),
          GetPage(name: "/blogdetail", page: () => BlogDetail()),
          GetPage(name: "/medicin", page: () => Medicin()),
          GetPage(name: "/editprofile", page: () => EditAccount()),
          GetPage(name: "/notification", page: () => MyNotification()),
          GetPage(name: "/topdoc", page: () => TopDoc()),
          GetPage(name: "/docsearch", page: () => DoctorSearch()),
          GetPage(name: "/paymentoverview", page: () => PaymentOverview()),
          GetPage(name: "/ZegoCloudCall", page: () => ZegoCloudCall()),
          GetPage(
            name: "/voicecll",
            page: () => VoiceCall(),
          ),
          GetPage(name: "/presc", page: () =>Prescription()),
          GetPage(name: "/prescdetail", page: () =>PrescriptionDetail()),
          GetPage(
            name: "/allblog",
            page: () => AllBlog(),
          ),
          GetPage(name: "/myorder", page: () => Myorder()),
          GetPage(name: "/doctor", page: () => Doctor()),
          GetPage(name: "/orderdetailstatus", page: () => OrderDetailStatus()),
          GetPage(name: "/orderdetail", page: () => OrderDetail()),
          GetPage(
            name: "/ordermedicin",
            page: () => Order_medicin(),
          ),
          GetPage(name: "/medicindetail", page:() => MedicinDetail(),),
          // both screen
          GetPage(name: "/setting", page: () => Setting()),
        ],
      ),
    );
  }
}
