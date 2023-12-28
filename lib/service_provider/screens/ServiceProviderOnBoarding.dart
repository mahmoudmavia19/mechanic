import 'package:flutter/material.dart';
import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/screens/login_screen.dart';
import 'package:mechanic/screens/main_screen.dart';
import 'package:mechanic/screens/registration_screen.dart';
import 'package:mechanic/service_provider/screens/login_screen.dart';
import 'package:mechanic/service_provider/screens/registration_screen.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/widgets/custombtn.dart';

import '../../utils/app_strings.dart';


class ServiceProviderOnBoarding extends StatefulWidget {
  const ServiceProviderOnBoarding({super.key});

  @override
  State<ServiceProviderOnBoarding> createState() => _ServiceProviderOnBoardingState();
}

class _ServiceProviderOnBoardingState extends State<ServiceProviderOnBoarding> {

  @override
  void initState() {
  /*  _controller.checkIsLogin();
    _controller.checkLogin.stream.listen((event) {
      if(event){
        _controller.getProfileData();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen(),), (route) => false);
      }
    });*/
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ServiceProviderLoginScreen()));
                },
              ),
              const SizedBox(height: 20.0,),
              CustomBTN(
                text: AppString.registerButtonText,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ServiceProviderRegistrationScreen()));
                },
              ),
              const SizedBox(height: 20.0,)
            ],
          ),
        )
    ) ;
  }
}
