import 'package:flutter/material.dart';
import 'package:mechanic/screens/add_vehicle_info_screen.dart';
import 'package:mechanic/screens/chat_screen.dart';
import 'package:mechanic/screens/report_screen.dart';
import 'package:mechanic/screens/update_profile_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../widgets/service_card.dart';
import 'app_strings.dart';

class AppColors {
  static Color primaryColor = const Color(0xFFFBCD08) ;
  static Color primary2Color = const Color(0xFF362E17) ;
  static Color fontColor =  Colors.white70;
}


class AppAssets {

  static String amiriFontFamily = 'Amiri' ;

  static String baseUrl = 'assets/images' ;
  static String appLogo = '$baseUrl/applogo.jpeg' ;

  static String error  = 'assets/json/error.json';
  static String loading  = 'assets/json/loading.json';
  static String success  = 'assets/json/success.json';
  static String user  = 'assets/json/user.json';
  static String driver  = 'assets/json/driver.json';
  static String grage  = 'assets/json/garage.json';

}
GlobalKey<ScaffoldState> scfKey =GlobalKey<ScaffoldState>();

List<ServiceCard> lisOfServiceCard(BuildContext context) => [
  ServiceCard(
    title: AppString.updateProfileTitle,
    iconData: Icons.person,
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProfileScreen()));
    },
  ),
  ServiceCard(
    title: AppString.addCarInfoTitle,
    iconData: Icons.car_crash_rounded,
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCarInfoScreen()));
    },
  ),
  ServiceCard(
    title: AppString.chatTitle,
    iconData: Icons.chat,
    onTap: () async{
      String url = "https://wa.me/0526874982";
      await launchUrlString(url);
      //Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
    },
  ),
/*  ServiceCard(
    title: AppString.reportTitle,
    iconData: Icons.report,
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportScreen()));
    },
  ),*/
];

List<String> orderStatus = [
  'Under processing',
  'In Progress',
  'Done',
];
List<String> paymentStatus = [
  'Pending',
  'Successfully Processed',
];

List<String> paymentType = [
  'Cash',
  'online',
];
final List<String> serviceTypes = [
  'Book an appointment for the workshop',
  'Service request',
];
List<Color> orderStatusColor = [
  Colors.grey,
  Colors.yellow,
  Colors.green,
];

List<Icon> orderStatusIcon =  const [
  Icon(Icons.recycling_outlined),
  Icon(Icons.directions_run_rounded),
  Icon(Icons.lock),
];





final makes = [
"Hyundai",
"Lexus",
 "Toyota",
  "Honda",
];

final makesLogo = {
  "Hyundai" : 'assets/images/hyundai.jpg',
  "Lexus": 'assets/images/Lexus.jpg',
  "Toyota": 'assets/images/toyota.jpg',
  "Honda": 'assets/images/Honda.jpg',
} ;

final map = {
  'toyota':
  [
    {
      "model_name": "Fortuner",
      "model_make_id": "toyota"
    },
    {
      "model_name": "Corolla",
      "model_make_id": "toyota"
    },
    {
      "model_name": "Camry",
      "model_make_id": "toyota"
    },
  ]
  ,
  'hyundai':
  [
    {
      "model_name": "Sonata",
      "model_make_id": "hyundai"
    },
    {
      "model_name": "Accent",
      "model_make_id": "hyundai"
    },
    {
      "model_name": "Elantra",
      "model_make_id": "hyundai"
    },
  ]
  ,
  'lexus':
  [
    {
      "model_name": "RX",
      "model_make_id": "lexus"
    },
    {
      "model_name": "IS",
      "model_make_id": "lexus"
    },
    {
      "model_name": "LX",
      "model_make_id": "lexus"
    },
  ]
  ,
  'honda' :
  [
    {
      "model_name": "Civic",
      "model_make_id": "honda"
    },
    {
      "model_name": "Accord",
      "model_make_id": "honda"
    },
    {
      "model_name": "Odyssey",
      "model_make_id": "honda"
    },
  ]
  ,
} ;