import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../models/service_provider.dart';
import '../models/vehicle.dart';
import '../screens/appointment_booking_screen.dart';
import '../utils/app_strings.dart';
import '../utils/constants.dart';

class ServiceProviderItem extends StatelessWidget {
    ServiceProviderItem({super.key,required this.serviceProvider,required this.car});
  ServiceProvider serviceProvider ;
  double rate = 0 ;
  Car car ;

  @override
  Widget build(BuildContext context) {
    rate = calRate(serviceProvider.rate);
    return Container(
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
              const Text(AppString.workshop,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
              const SizedBox(width: 10.0,) ,
              Icon(Icons.car_crash_outlined,color: AppColors.primary2Color,)
            ],
          ) ,
            ListTile(title: const Text(AppString.name), subtitle: Text(serviceProvider.name), trailing: const Icon(Icons.person)),
          ListTile(
            onTap: () async{
              String url = "https://wa.me/${serviceProvider.phoneNumber}";
              await launchUrlString(url);
            },
              title: const Text(AppString.wb),
              /*  subtitle: Text(
                        Controller.user!.currentOrder!.serviceProvider.email),*/
              trailing: Image.network("https://img.icons8.com/ios-filled/50/000000/whatsapp--v1.png",
                height: 25,width: 25,color: Colors.green,)),
          ListTile(title: const Text(AppString.phoneNumberLabel), subtitle: Text(serviceProvider.phoneNumber),
              onTap: () async{
                await launchUrlString('tel:${serviceProvider.phoneNumber}');
              },
              trailing: const Icon(Icons.phone)),
          ListTile(title: const Text('Rate'), subtitle: RatingBar.builder(
            initialRating: rate,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            ignoreGestures: true,
            itemCount: 5,
            itemSize: 20.0,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ), onRatingUpdate: (double value) {  },
          ),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>   AppointmentBookingScreen(serviceProvider: serviceProvider,car:car) ,)) ;
                },
                color: AppColors.primaryColor,
                child: const Text(AppString.reserve, style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 20.0),
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
                              ListTile(title: const Text(AppString.district), subtitle: Text(serviceProvider.workshop.district), trailing: const Icon(Icons.cabin_rounded)),
                              ListTile(title: const Text(AppString.strName), subtitle: Text(serviceProvider.workshop.streetName), trailing: const Icon(Icons.drive_file_rename_outline)),
                              ListTile(title: const Text(AppString.city), subtitle: Text(serviceProvider.workshop.city), trailing: const Icon(Icons.location_city)),
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

        ],
      ),
    );
  }

}
double calRate(Map<String,double>? rates){
  double rate = 0.0;
  if(rates!={}) {
    rates?.forEach((key, value) {
    rate +=value ;
  });
    rate/=rates!.keys.length;
  }
  return rate;
}