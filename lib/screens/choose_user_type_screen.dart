import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mechanic/driver/screens/login_screen.dart';
import 'package:mechanic/screens/onboarding.dart';
import 'package:mechanic/service_provider/screens/login_screen.dart';
import 'package:mechanic/utils/constants.dart';
class ChooseUserTypeScreen extends StatefulWidget {
  const ChooseUserTypeScreen({super.key});

  @override
  State<ChooseUserTypeScreen> createState() => _ChooseUserTypeScreenState();
}

class _ChooseUserTypeScreenState extends State<ChooseUserTypeScreen> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
             Container(
               height: 250.0,
               clipBehavior: Clip.antiAliasWithSaveLayer,
               width: double.infinity,
               decoration: BoxDecoration(
                 color: AppColors.primaryColor,
                 borderRadius: BorderRadius.only(bottomRight: Radius.circular(MediaQuery.of(context).size.width*0.25) ,bottomLeft: Radius.circular(MediaQuery.of(context).size.width*0.25) ),
               ),
               child: Image.asset(AppAssets.appLogo,
                 width: double.infinity,),
             ),
              const SizedBox(height: 20.0,),
              const Text('Choose User Type To Login',style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),),
              const SizedBox(height: 20.0,),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  _userTypeItem('User',Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Lottie.asset(AppAssets.user,height: 110.0),
                  ),(){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const OnBoarding() ,)) ;
                  }),
                  _userTypeItem('Service Provider',Lottie.asset(AppAssets.success,height: 150.0,),(){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ServiceProviderLoginScreen() ,)) ;
                  }),
                  _userTypeItem('Driver',Transform.scale(
                    scale: 2,
                      child: Lottie.asset(AppAssets.driver,height: 150.0,reverse: true)),(){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverLoginScreen() ,)) ;
                  }),
                ],
              )
           ],
            ),
        )
    ) ;
  }

  _userTypeItem(user,lotte,onTap)=> Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: 250.0,
        width: 170.0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 0.5, color: AppColors.primaryColor)
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            lotte,
            Text(user,style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    ),
  );
}
