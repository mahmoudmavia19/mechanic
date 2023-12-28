import 'package:flutter/material.dart';
import 'package:mechanic/models/service_provider.dart';
import 'package:mechanic/models/vehicle.dart';
import 'package:mechanic/screens/car_services_sceen.dart';
import 'package:mechanic/utils/app_strings.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/widgets/custombtn.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../providers/controller.dart';


class AppointmentBookingScreen extends StatefulWidget {
    AppointmentBookingScreen({super.key, required this.serviceProvider,required this.car});
  ServiceProvider serviceProvider ;
  Car car ;
  @override
  _AppointmentBookingScreenState createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  // Define variables to hold the booking number and service type
   String selectedServiceType = 'Book an appointment for the workshop';
    final Controller _controller = Controller();


@override
  void initState() {
  _controller.getCarInfo().then((value){
  });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.reserve),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 140,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 70.0,
                      width: double.infinity,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 70.0,
                      backgroundImage: AssetImage(AppAssets.appLogo),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  const SizedBox(height: 8.0),
                  const Text(
                    'select type of service',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(10.0),
                    value: selectedServiceType,
                    onChanged: (value) {
                      setState(() {
                        selectedServiceType = value!;
                      });
                    },
                    items: serviceTypes.map((String serviceType) {
                      return DropdownMenuItem<String>(
                        value: serviceType, // Make sure each value is unique
                        child: Text(serviceType==serviceTypes[0]?'At the workshop':'Service at home'),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      hintText: 'select type of service',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16.0),
                CustomBTN(text: AppString.selectServices, onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>   CarServicePage(serviceTYpe: selectedServiceType,serviceProvider: widget.serviceProvider,car:widget.car),));
                },),
                  const SizedBox(height: 10.0,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: AppColors.primaryColor),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor ,blurRadius: 3,
                            )
                          ],
                          color: const Color(0xFFf0f0f0)
                      ),
                      width: double.infinity,
                      child:   Column(
                        children: [
                          const SizedBox(height: 10.0,) ,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                const Text(AppString.workshop ,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                              const SizedBox(width: 10.0,) ,
                              Icon(Icons.car_crash_outlined,color: AppColors.primary2Color,)
                            ],
                          ) ,
                            ListTile(title: const Text(AppString.name), subtitle: Text(widget.serviceProvider.name), trailing: const Icon(Icons.person)),
                          ListTile(
                              title: const Text(AppString.wb),
                              /*  subtitle: Text(
                        Controller.user!.currentOrder!.serviceProvider.email),*/
                              trailing: InkWell(
                                  onTap: ()async {
                                    String url = "https://wa.me/${widget.serviceProvider.phoneNumber}";
                                    await launchUrlString(url);
                                  },
                                  child: Image.network("https://img.icons8.com/ios-filled/50/000000/whatsapp--v1.png",
                                    height: 25,width: 25,color: Colors.green,))),
                          ListTile(
                              title: const Text(AppString.phoneNumberLabel),
                              subtitle: Text(widget.serviceProvider.phoneNumber
                                  .toString()),
                              trailing: InkWell(
                                  onTap: () async{
                                    await launchUrlString('tel:${widget.serviceProvider.phoneNumber}');
                                  },
                                  child: const Icon(Icons.phone))),
                          MaterialButton(
                            onPressed: () {
                              showDialog(context: context, builder: (context) => Dialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0.0,
                                child:  SingleChildScrollView(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: AppColors.primaryColor),
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(color: AppColors.primaryColor, blurRadius: 2.0),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(10.0),
                                    child:   Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(AppString.showDetails,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                                            const SizedBox(width: 10.0,) ,
                                            Icon(Icons.car_crash_outlined,color: AppColors.primary2Color,)
                                          ],
                                        ) ,
                                         ListTile(title: const Text(AppString.district), subtitle: Text(widget.serviceProvider.workshop.district), trailing: const Icon(Icons.cabin_rounded)),
                                         ListTile(title: const Text(AppString.strName), subtitle: Text(widget.serviceProvider.workshop.streetName), trailing: const Icon(Icons.drive_file_rename_outline)),
                                         ListTile(title: const Text(AppString.city), subtitle: Text(widget.serviceProvider.workshop.city), trailing: const Icon(Icons.location_city)),
                                      ],
                                    ),
                                  ),
                                ),),);
                            },
                            color: AppColors.primary2Color,
                            child:   const Text(AppString.showDetails, style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ) ,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



}
