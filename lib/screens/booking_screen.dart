import 'package:flutter/material.dart';
import 'package:mechanic/models/service_provider.dart';
import 'package:mechanic/models/vehicle.dart';
import 'package:mechanic/providers/controller.dart';
 import 'package:mechanic/utils/app_strings.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import 'package:mechanic/widgets/service_provider_item.dart';

class BookingScreen extends StatefulWidget {
      BookingScreen({super.key,required this.carModel,required this.car});
    String carModel ;
    Car car ;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final Controller controller = Controller();

  _bind(){
    controller.getServiceProviders().then((value) {
      controller.getCarModelProvider().then((value){
        controller.filterProviders(widget.carModel);
      });
    });

  }
  @override
  void initState() {
    _bind();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      /*  actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            icon: const Icon(Icons.filter_alt),
            onSelected: (String result) {
             controller.filterProviders(result);
             setState(() {

             });
            },
            itemBuilder: (BuildContext context) =>[const PopupMenuItem<String>(
              value: 'all',
              child: Text('all'),
            )]+ Controller.cars!.map((e) => PopupMenuItem<String>(
               onTap: () {
                 print(e.make);
               },
              value: e.make,
              child: Text(e.make),
            ),).toList()
          ),
        ],*/
        toolbarHeight: 86,
        centerTitle: true,
        title:Text(AppString.bookingTitle,style: TextStyle(color: AppColors.primary2Color,fontSize:20.0),),
      ),
      body: StreamBuilder<FlowState>(
    stream: controller.serviceProviderStateCon.stream,
    builder: (context, snapshot) => snapshot.data?.getScreenWidget(context, _body(), (){})??Container()),
    );
  }

    _body()=>StreamBuilder<List<ServiceProvider>>(
        stream: controller.serviceProviderListCon.stream,
        builder: (context, snapshot) {
          return     ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) =>Padding(
                padding: const EdgeInsets.all(10.0),
                child:snapshot.data ==null? Container(): ServiceProviderItem(serviceProvider: snapshot.data![index],car:widget.car)
            ) ,
            itemCount: snapshot.data?.length,);
        }
    ) ;
}



