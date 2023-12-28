import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mechanic/screens/choose_user_type_screen.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/utils/notifi_service.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService().initNotification();
  tz.initializeTimeZones();
   runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mechanic',
      theme: ThemeData(
        listTileTheme: ListTileThemeData(
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold,
              color: AppColors.primary2Color,fontFamily: AppAssets.amiriFontFamily,
              fontSize: 18),
              iconColor: AppColors.primary2Color
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.primary2Color ,
          selectedItemColor:  AppColors.primaryColor  ,
          unselectedItemColor: Colors.grey
        ) ,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: AppColors.primary2Color),
          color: AppColors.primaryColor ,
        ),
        fontFamily: AppAssets.amiriFontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary2Color),
        useMaterial3: true,
      ),
      home: const ChooseUserTypeScreen(),
    );
  }
}



