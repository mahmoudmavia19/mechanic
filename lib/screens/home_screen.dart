import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mechanic/models/order.dart';
import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/screens/track_order_screen.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../utils/app_strings.dart';
import '../widgets/custombtn.dart';
import '../widgets/order_rate_dialog.dart';
import 'driver_profile.dart';
import 'package:intl/intl.dart' as intl;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Controller _controller = Controller();


  @override
  void initState() {
    _controller.getProfileData();
    _controller.getAds();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("order : ${Controller.user?.currentOrder?.length}");
    return SingleChildScrollView(
     // physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: 20.0,
            width: double.infinity,
            color: AppColors.primaryColor,
          ),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {
                              scfKey.currentState!.openDrawer();
                            },
                          ),
                        ],
                      ),
                    ),
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
          const SizedBox(
            height: 10.0,
          ),
        StreamBuilder<FlowState>(
            builder: (context, snapshot) =>snapshot.data?.getScreenWidget(context, _adsContent(),(){})??Container() ,
            stream:_controller.adsStateCon.stream ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1.0,
                  color: AppColors.primary2Color,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(AppString.serviceName),
              ),
              Expanded(
                child: Container(
                  height: 1.0,
                  color: AppColors.primary2Color,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          SizedBox(
            height: 100.0,
            width: double.infinity,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: lisOfServiceCard(context),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1.0,
                  color: Colors.grey,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(AppString.currentReservation),
              ),
              Expanded(
                child: Container(
                  height: 1.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          StreamBuilder<FlowState>(
            stream: _controller.profileStateCon.stream,
            builder: (context, snapshot) =>
                snapshot.data
                    ?.getScreenWidget(context, _currentOrder(), () {
                      _controller.getProfileData();
                }) ??
                _currentOrder(),
          )
        ],
      ),
    );
  }

  _currentOrder() {
    return Controller.user?.currentOrder == null
      ? _controller.orders?.first.rate==0.0 ?
   Column(
     children: [
       const Text('Please rate this order'),
       Card(
         clipBehavior: Clip.antiAliasWithSaveLayer,
         child: Row(
           children: [
             Expanded(
               flex: 1,
               child: InkWell(
                 onTap:() {
                   showDialog(
                     context: context,
                     builder: (context) => Dialog(
                       child: Padding(
                         padding: const EdgeInsets.all(20.0),
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             Lottie.asset(AppAssets.error, height: 150),
                             const Text(
                               'are you sure you want remove this order from history',
                               style: TextStyle(fontSize: 18.0),
                             ),
                             const SizedBox(
                               height: 20.0,
                             ),
                             CustomBTN(
                               text: AppString.yes,
                               onPressed: () {
                                 _controller.removeOrderFromHistory(_controller.orders!.first.id);
                               },
                             )
                           ],
                         ),
                       ),
                     ),
                   );},
                 child: Container(
                   color:_controller.orders!.first.status=='canceled'?Colors.red: orderStatusColor[orderStatus.indexOf(_controller.orders!.first.status)],
                   width: 70.0,
                   height:100.0,
                   // child: const Icon(Icons.remove_circle,color: Colors.white,),
                 ),
               ),
             ),
             Expanded(
               flex: 5,
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(_controller.orders!.first.serviceProvider.name),
                     SizedBox(
                         width: 200,
                         child: Text(_controller.orders!.first.services.map((e) => e.name).toList().toString()
                           ,overflow: TextOverflow.ellipsis,
                         )),
                     Text(_controller.orders!.first.status),
                     Text(intl.DateFormat.yMMMd().format(_controller.orders!.first.orderDateTime)),

                   ],
                 ),
               ),
             ),
             if(_controller.orders!.first.status!=orderStatus[0]&&_controller.orders!.first.status!='canceled')
               InkWell(
                 onTap: () {
                   // Navigator.push(context, MaterialPageRoute(builder: (context) => TrackOrder(order: order),));
                   showDialog(
                     context: context,
                     builder: (context) => OrderRateDialog(_controller.orders!.first),
                   ).then((value){
                     setState(() {

                     });
                   });
                 },
                 child:   SizedBox(
                   width: 70.0,
                   height:100.0,
                   child: _controller.orders!.first.rate ==0.0 ?  const Icon(Icons.star_border_outlined,) :const Icon(Icons.star,color: Colors.amber,)  ,
                 ),
               ),
             Expanded(
               flex: 1,
               child: InkWell(
                 onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => TrackOrder(order: _controller.orders!.first),));
                 },
                 child: const SizedBox(
                   width: 70.0,
                   height:100.0,
                   child: Icon(Icons.arrow_forward_ios,),
                 ),
               ),
             ),
           ],
         ),
       )
     ],
   )
        : const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Not Found Orders'),
         ],
      )
      : SizedBox(
        child: ListView.builder(
        shrinkWrap: true,
        physics : const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          Order? order = _controller.orders?.where((element) => element.id==Controller.user?.currentOrder![index]).toList()[0] ;
          print(_controller.orders?.length);
          return order==null ? Container():  Padding(
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
                ListTile(title: const Text(AppString.name), subtitle: Text(order!.serviceProvider.name), trailing: const Icon(Icons.garage_outlined)),
                if(order.driver!=null)
                  ListTile(title: const Text(AppString.driver), subtitle:  Text(order.driver!.name), trailing: Icon(Icons.person,color: AppColors.primaryColor,),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: DriverProfileScreen(user:order.driver!),
                        ),
                      );
                    },),
                ListTile(
                    title: const Text(AppString.wb),
                    trailing: InkWell(
                        onTap: ()async {
                          String url = "https://wa.me/${order.serviceProvider.phoneNumber}";
                          await launchUrlString(url);
                        },
                        child: Image.network("https://img.icons8.com/ios-filled/50/000000/whatsapp--v1.png",
                          height: 25,width: 25,color: Colors.green,))),
                ListTile(
                    title: const Text(AppString.phoneNumberLabel),
                    subtitle: Text(order.serviceProvider.phoneNumber
                        .toString()),
                    trailing: InkWell(
                        onTap: () async{
                          await launchUrlString('tel:${order.serviceProvider.phoneNumber}');
                        },
                        child: const Icon(Icons.phone))),
                ListTile(
                  title: const Text(AppString.orderStatus),
                  subtitle: Text(order.status,style: TextStyle(color: order.status == 'canceled'?Colors.red :orderStatusColor[orderStatus.indexOf(order.status)]),),
                  trailing: orderStatusIcon[orderStatus
                      .indexOf(order.status)],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrackOrder(
                                  order:order),
                            ));
                      },
                      color: AppColors.primaryColor,
                      child: const Text(AppString.trackOrder,
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 20.0),
                    if(order.status == orderStatus[0])
        
                      MaterialButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Lottie.asset(AppAssets.error, height: 150),
                                    const Text(
                                      'are you sure you want cancel the order',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    CustomBTN(
                                      text: AppString.yes,
                                      onPressed: () {
                                        _controller.cancelCurrentOrder(order.id);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        color: AppColors.primary2Color,
                        child: const Text(AppString.cancelOrder,
                            style: TextStyle(color: Colors.white)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
        } ,
        itemCount: Controller.user?.currentOrder?.length,
            ),
      );
  }

  _adsContent()=> CarouselSlider(
    items: Controller.ads
        .map((item) => Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: Center(
        child:
        Image.network(item, fit: BoxFit.cover, width: 1000),
      ),
    ))
        .toList(),
    options: CarouselOptions(
      height: 200.0,
      autoPlay: true,
      aspectRatio: 2.0,
      enlargeCenterPage: true,
    ),
  );
}
