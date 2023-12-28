import 'package:dashed_stepper/dashed_stepper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mechanic/models/order.dart';
import 'package:mechanic/screens/driver_profile.dart';
import 'package:mechanic/utils/app_strings.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import 'package:mechanic/widgets/custombtn.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart' as intl;

import '../providers/controller.dart';

class TrackOrder extends StatelessWidget {
   TrackOrder({super.key,required this.order});
  Order order;
  final Controller _controller = Controller() ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.trackOrder),
      ),
      body: StreamBuilder<FlowState>(
        stream: _controller.profileStateCon.stream,
        builder: (context, snapshot) =>snapshot.data?.getScreenWidget(context, _body(context), (){})??_body(context),
      )
    );
  }
  _body(context)=>SingleChildScrollView(
    child: Column(
      children: [
        const SizedBox(height: 20.0,) ,
        if(order.status!='canceled')
        DashedStepper(
          indicatorColor: AppColors.primaryColor,
          disabledColor: AppColors.primary2Color,
          height: 30,
          gap: 5,
          icons: orderStatusIcon,
          labels: orderStatus ,
          length: 3,
          step: orderStatus.indexOf(order.status)+1,
        ),
        if(order.status=='canceled')
          DashedStepper(
            indicatorColor: Colors.red,
            disabledColor: Colors.red,
            height: 30,
            gap: 5,
            icons: [orderStatusIcon[0],const Icon(Icons.free_cancellation,color: Colors.red,)] ,
            labels: [orderStatus[0],'canceled'] ,
            length: 2,
            step:2
          ),
        const SizedBox(height: 10.0,),
        Padding(
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
            child: Column(
              children: [
                ListTile(title: const Text(AppString.name), subtitle: Text(order.serviceProvider.name), trailing: const Icon(Icons.garage_outlined)),
                if(order.driver!=null)
                ListTile(title: const Text(AppString.driver), subtitle: Text(order.driver!.name), trailing: Icon(Icons.person,color: AppColors.primaryColor,),onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: DriverProfileScreen(user:order.driver!),
                    ),
                  );
                    },),
                ListTile(
                    title: const Text(AppString.wb),
                    /*  subtitle: Text(
                        Controller.user!.currentOrder!.serviceProvider.email),*/
                    trailing: InkWell(
                        onTap: ()async {
                          String url = "https://wa.me/${order.serviceProvider.phoneNumber}";
                          await launchUrlString(url);
                        },
                        child: Image.network("https://img.icons8.com/ios-filled/50/000000/whatsapp--v1.png",
                          height: 25,width: 25,color: Colors.green,))),
                ListTile(title: const Text(AppString.phoneNumberLabel),
                    subtitle: Text(order.serviceProvider.phoneNumber),
                    trailing: InkWell(
                        onTap: () async{
                          await launchUrlString('tel:${order.serviceProvider.phoneNumber}');
                        },
                        child: const Icon(Icons.phone))),
                ListTile(
                  title: const Text(AppString.orderStatus),
                  subtitle: Text(order.status,style: TextStyle(color: order.status == 'canceled'?Colors.red :orderStatusColor[orderStatus.indexOf(order.status)]),),
                  trailing:order.status == 'canceled' ? const Icon(Icons.free_cancellation,color: Colors.red,) : orderStatusIcon[orderStatus.indexOf(order.status)],
                ),
                ListTile(
                    title: const Text(AppString.carType),
                    subtitle:order.car==null ? const Text('unknown'):  Text('${order.car?.make} | ${order.car?.model}'),
                    trailing:const Icon(Icons.car_rental,)
                ),
                ListTile(
                  title: const Text(AppString.orderData),
                  subtitle: Text(intl.DateFormat.yMMMd().format(order.orderDateTime),),
                  trailing:const Icon(Icons.access_time_filled,)
                ),
                if(order.status == orderStatus[0])
                MaterialButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Lottie.asset(AppAssets.error,height: 150),
                            const Text('are you sure you want cancel the order',style: TextStyle(fontSize: 18.0),) ,
                            const SizedBox(height: 20.0,),
                            CustomBTN(text: AppString.yes, onPressed:  () {
                              _controller.cancelCurrentOrder(order.id) ;
                            },)
                          ],
                        ),
                      ),
                    ),);
                  },
                  color: AppColors.primary2Color,
                  child: const Text(AppString.cancelOrder, style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10.0,),
        Padding(
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(AppString.showDetails,style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                    const SizedBox(width: 10.0,) ,
                    Icon(Icons.car_crash_outlined,color: AppColors.primary2Color,)
                  ],
                ) ,
                ListTile(title: const Text(AppString.district), subtitle: Text(order.serviceProvider.workshop.district), trailing: const Icon(Icons.cabin_rounded)),
                ListTile(title: const Text(AppString.strName), subtitle: Text(order.serviceProvider.workshop.streetName), trailing: const Icon(Icons.drive_file_rename_outline)),
                ListTile(title: const Text(AppString.city), subtitle: Text(order.serviceProvider.workshop.city), trailing: const Icon(Icons.location_city)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
