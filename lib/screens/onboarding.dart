import 'package:flutter/material.dart';
import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/screens/login_screen.dart';
import 'package:mechanic/screens/main_screen.dart';
import 'package:mechanic/screens/registration_screen.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/widgets/custombtn.dart';

import '../utils/app_strings.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final Controller _controller = Controller() ;

  @override
  void initState() {
    _controller.checkIsLogin();
    _controller.checkLogin.stream.listen((event) {
      if(event){
        _controller.getProfileData();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen(),), (route) => false);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                  child: Image.asset(AppAssets.appLogo,
                  width: double.infinity,)),
            CustomBTN(
              text: AppString.loginButtonText,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
            const SizedBox(height: 20.0,),
            CustomBTN(
              text: AppString.registerButtonText,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegistrationScreen()));
              },
            ),
            const SizedBox(height: 20.0,)
          ],
        ),
      )
    ) ;
  }
}
