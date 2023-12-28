import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
 import 'package:mechanic/models/order.dart';
import 'package:mechanic/service_provider/controller/service_provider_controller.dart';
import 'package:mechanic/service_provider/screens/car_model_management.dart';
import 'package:mechanic/service_provider/screens/new_requests.dart';
import 'package:mechanic/service_provider/screens/service_management.dart';
import 'package:mechanic/service_provider/screens/service_provider_update_profile.dart';
import 'package:mechanic/utils/app_strings.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import '../../screens/change_password_screen.dart';
import 'drivers_management.dart';


class ServiceProviderMainScreen extends StatefulWidget {
  const ServiceProviderMainScreen({super.key});

  @override
  State<ServiceProviderMainScreen> createState() => _ServiceProviderMainScreenState();
}

class _ServiceProviderMainScreenState extends State<ServiceProviderMainScreen> {
  final ServiceProviderController _controller = ServiceProviderController();

  @override
  void initState() {
    _controller.getNewOrders();
    _controller.getCarsModel();
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppString.home),
        actions: [
          Image.asset(AppAssets.appLogo)
        ],
      ),
      drawer:Drawer(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DrawerHeader(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(color: AppColors.primaryColor),
                  child: Image.asset(AppAssets.appLogo)),
            ),
            ListTile(
              title: const Text('Available'),trailing: Switch(value: ServiceProviderController.spUser!.workshop.status=='Available', onChanged: (value) {
              ServiceProviderController.spUser!.workshop.status = value?'Available' : 'Not Available';
             setState(() {
             });
              _controller.updateProfileData(ServiceProviderController.spUser!);
              },),),
            ListTile(
              title:   Row(
                children: [
                  const Text(AppString.newRequests),
                  const SizedBox(width: 10.0,),
                  if(ServiceProviderController.newOrders.isNotEmpty)
                  const CircleAvatar(backgroundColor: Colors.red,radius: 5.0,),
                ],
              ),trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>   const NewRequests(),)) ;
              },),
            ListTile(title: const Text(AppString.serviceManagement),trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>   ServiceManagement(),)) ;
              },),
            ListTile(title: const Text(AppString.carModelManagement),trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>   const CarModelManagement(),)) ;

              },),
            ListTile(title: const Text(AppString.driverManagement),trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>   const DriverManagement(),)) ;

              },),
            ListTile(title: const Text('Change Password'),trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen(),)) ;

              },),
            const Divider(),
            ListTile(title: const Text(AppString.logoutTitleText),
              trailing: const Icon(Icons.arrow_forward_ios),
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () {
              _controller.logout();
              Phoenix.rebirth(context);
                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ChooseUserTypeScreen(),), (route) => false) ;
              },),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: AppColors.primary2Color,
                    height: 0.5,
                   ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NewRequests(),)) ;
                    },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('<  New Requests  >'),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.primary2Color,
                    height: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0,),
            SizedBox(
                child: StreamBuilder<FlowState>(
                 stream: _controller.newordersStateCon.stream,
                 builder:(context, snapshot) => snapshot.data?.getScreenWidget(context, newRequests(), (){
                   _controller.getNewOrders();
                 })??Container()),
               ),
            const SizedBox(height: 20.0,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: AppColors.primary2Color,
                    height: 0.5,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>   const CarModelManagement(),));
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('<  Cars Makes  >'),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.primary2Color,
                    height: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0,),
           StreamBuilder<FlowState>(
              stream: _controller.carModelStateCon.stream,
               builder: (context, snapshot) => snapshot.data?.getScreenWidget(context, _makesView(), (){
                 _controller.getCarsModel();
               })??Container(),),
            const SizedBox(height: 20.0,),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: AppColors.primary2Color,
                    height: 0.5,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('< Notification >'),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.primary2Color,
                    height: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0,),
            Card(
              margin: const EdgeInsets.all(20.0),
              child: ListTile(
                title: const Text('Note!!', style: TextStyle(color: Colors.red),),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text('Your workshop is ${ServiceProviderController.spUser!.workshop.status} now go to update profile to change it if you need ',style: const TextStyle(fontSize: 18.0,),textAlign: TextAlign.center,),
                      const SizedBox(height:20.0,),
                      Row(
                        children: [
                          Text(intl.DateFormat('dd/mm/yy').format(DateTime.now()),style: TextStyle(color: AppColors.primaryColor),),
                          const Spacer(),
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ServiceProviderUpdateProfile(),));
                          }, child: Text('Go',style: TextStyle(color: AppColors.primaryColor))),
                        ],
                      )
                   ]
                  ),
                ),
              ),
            )
          ],
        ),
      ),
        bottomSheet: Container(
          height: 20.0,
          decoration: BoxDecoration(
            color: AppColors.primary2Color,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(10.0) ,topLeft: Radius.circular(10.0))
          ),
    ),
    );
  }

  newRequests()=>SizedBox(
    height: 160,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: ServiceProviderController.newOrders.length,
      itemBuilder: (BuildContext context, int index) {
        Order request = ServiceProviderController.newOrders[index];
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>   const NewRequests(),)) ;
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child:  Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Request Number: ${index + 1}'),
                  Text('Service Required: ${request.services.map((e) => e.name).toList()}'),
                  Text('Order Date Time: ${intl.DateFormat.yMMMd().format(request.orderDateTime)}'),
                  Text('Status: ${request.status}'),
                  request.car==null ? const Text('Car : unknown') :  Text('Car : ${request.car?.make} | ${request.car?.model}'),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );

  _makesView()=> ServiceProviderController.carModel.isEmpty? Container() :  CarouselSlider.builder(
    options: CarouselOptions(
        autoPlay: true,
        autoPlayAnimationDuration: const Duration(seconds: 5),
        aspectRatio: 2 ,
        viewportFraction: 0.5
    ),
    itemCount: ServiceProviderController.carModel.length,
    itemBuilder:(context, index, realIndex){
      return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>   const CarModelManagement(),));
        },
        child: SizedBox(
          width: double.infinity,
          child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(makesLogo[ServiceProviderController.carModel[index].modelMakeId]!,
                filterQuality: FilterQuality.high,
                fit: BoxFit.fill,)),
        ),
      );
    },
  );
}
