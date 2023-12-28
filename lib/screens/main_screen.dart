import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/screens/about_car.dart';
import 'package:mechanic/screens/add_vehicle_info_screen.dart';
import 'package:mechanic/screens/change_password_screen.dart';
import 'package:mechanic/screens/deactive_screen.dart';
import 'package:mechanic/screens/home_screen.dart';
import 'package:mechanic/screens/orders_history.dart';
import 'package:mechanic/screens/select_car_model_screen.dart';
import 'package:mechanic/screens/update_profile_screen.dart';
import 'package:mechanic/utils/app_strings.dart';
import 'package:mechanic/utils/constants.dart';
class MainScreen extends StatefulWidget {
    const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Controller _controller = Controller() ;
  List<Widget> pages = [HomeScreen(), const AboutCar(), OrdersHistory(),   SelectCarModelScreen() ] ;
  PageController pageController = PageController() ;
  int currIndex = 0 ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scfKey,
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DrawerHeader(
                padding: EdgeInsets.zero,
                 decoration: BoxDecoration(color: AppColors.primaryColor),
                  child: Image.asset(AppAssets.appLogo)),
            ),
              ListTile(title: const Text(AppString.updateProfileTitle),trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProfileScreen(),)) ;
                },),
              ListTile(title: const Text(AppString.addCarInfoTitle),trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCarInfoScreen(),)) ;
                },),
            ListTile(title: const Text('Change Password'),trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen(),)) ;
              },),
              const Divider(),
              ListTile(title: const Text(AppString.logoutTitleText),trailing: const Icon(Icons.arrow_forward_ios),
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: () {
                  _controller.logout();
                  Phoenix.rebirth(context);
            },),
              ListTile(title: const Text(AppString.disActiveAccount),trailing: const Icon(Icons.arrow_forward_ios),
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DeactivateAccountPage(),));
                },),
          ],
        ),
      ),

      body: PageView.builder(
        controller: pageController,
          itemBuilder: (context, index) =>pages[index],
          onPageChanged: (value) {
            setState(() {
              currIndex = value ;
            });
          },
          itemCount:pages.length),
      bottomNavigationBar: BottomNavigationBar(items: const[
        BottomNavigationBarItem(icon:Icon(Icons.home),label: AppString.home ),
        BottomNavigationBarItem(icon:Icon(Icons.car_crash_outlined),label: AppString.carInfoTitle),
        BottomNavigationBarItem(icon:Icon(Icons.history_edu),label: AppString.reservesHistory),
        BottomNavigationBarItem(icon:Icon(Icons.bookmark_add),label: AppString.reserve),
      ] ,
      backgroundColor: AppColors.primary2Color,
      currentIndex: currIndex ,
      onTap: (value) {
        setState(() {
          currIndex = value ;
        });
        pageController.animateToPage(value, duration: const Duration(milliseconds: 500), curve: Curves.linear) ;
      },),
    );
  }
}
