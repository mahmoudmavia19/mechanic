import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
 import 'package:mechanic/models/service_provider.dart';
import 'package:mechanic/models/vehicle.dart';
import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/screens/about_services.dart' as service;
import 'package:mechanic/screens/bill_screen.dart';
import 'package:mechanic/utils/app_strings.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import 'package:mechanic/widgets/custombtn.dart';

import '../models/car_services.dart' ;
import '../models/order.dart';
import '../utils/notifi_service.dart';
DateTime scheduleTime = DateTime.now();

class CarServicePage extends StatefulWidget {
    CarServicePage({super.key, required this.serviceTYpe, required this.serviceProvider,required this.car});
   String serviceTYpe ;
   Car car ;
   ServiceProvider serviceProvider;
  @override
  _CarServicePageState createState() => _CarServicePageState();
}

class _CarServicePageState extends State<CarServicePage> {
  final Controller _controller = Controller() ;
  List<CarService> services = [];

  List<CarService> selectedServices = [];
  _bind()async{
    services = (await _controller.getCarServices(widget.serviceProvider.id,widget.serviceTYpe=='Service request' ?'in-home':'in-shop' ));
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
        actions: [IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>service.ServicesScreen(),));
        }, icon: const Icon(Icons.info))],
        title: const Text('Car Services Selection'),
      ),
      body: StreamBuilder<FlowState>(
        stream: _controller.makeOrderState.stream,
        builder: (context, snapshot) => snapshot.data?.getScreenWidget(context, _body(), (){})??_body(),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(selectedServices.isNotEmpty)
          FloatingActionButton(
            onPressed: () {
              // Calculate and display the total price
              showTotalPriceDialog(context, selectedServices);
            },
            child: const Icon(Icons.check),
          ),
          const SizedBox(width: 20.0,),
          if(widget.serviceTYpe=='Service request' && selectedServices.isNotEmpty)
          FloatingActionButton(
            onPressed: () {
          DatePicker.showDateTimePicker(
                context,
                showTitleActions: true,
                minTime: DateTime.now(),
                onChanged: (date) => scheduleTime = date,
                onConfirm: (date) {
                  debugPrint('Notification Scheduled for $scheduleTime');
                  NotificationService().scheduleNotification(
                      title: 'Scheduled Order',
                      body: 'you need ${selectedServices.map((e) => e.name).toList()}',
                      scheduledNotificationDateTime: scheduleTime);
                },
              );
              },
            child: const Icon(Icons.alarm),
          ),
          const SizedBox(width: 20.0,),

          FloatingActionButton(
            onPressed: () {
              selectedServices.clear();
              if(widget.serviceTYpe == serviceTypes[0]){
              widget.serviceTYpe = serviceTypes[1];
              }else {
                widget.serviceTYpe = serviceTypes[0];
              }

               setState(() {
                 _bind();
               });
            },
            child: Text(widget.serviceTYpe=='Service request' ?'in-home':'in-shop'),
          ),
        ],
      )
    );
  }
  _body()=>ListView.builder(
    itemCount: services.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(services[index].name),
        subtitle: Text('Price: ${services[index].price.toStringAsFixed(2)} SAR'),
        trailing: Checkbox(
          value: services[index].isSelected,
          onChanged: (bool? newValue) {
            setState(() {
              services[index].isSelected = newValue!;
              if (newValue) {
                selectedServices.add(services[index]);
              } else {
                selectedServices.remove(services[index]);
              }
            });
          },
        ),
      );
    },
  );
  double calculateTotalPrice(List<CarService> selectedServices) {
    double totalPrice = 0.0;

    for (CarService service in selectedServices) {
      if (service.isSelected) {
        totalPrice += service.price;
      }
    }

    // Calculate VAT (assuming 15% VAT rate)
    double vat = totalPrice * 0.15;

    // Calculate the total price including VAT
    double totalPriceWithVat = totalPrice + vat;

    return totalPrice;
  }
  double calVAT(){
    var price = calculateTotalPrice(selectedServices);
   var vat = price * 0.15;
   return price + vat ;
  }


  void showTotalPriceDialog(BuildContext context, List<CarService> selectedServices) {

    double totalPrice = calculateTotalPrice(selectedServices);
    double totalPriceWithVat = calVAT();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selected Services and Total Price'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Selected Services:'),
                for (CarService service in selectedServices)
                  if (service.isSelected)
                    ListTile(
                      title: Text(service.name),
                      subtitle: Text('Price: ${service.price.toStringAsFixed(2)} SAR'),
                    ),
                const Divider(),
                ListTile(
                  title: const Text('Value Added Tax (VAT)'),
                  subtitle: Text('15% of Total Price: ${(totalPriceWithVat - totalPrice)} SAR'),
                ),
                ListTile(
                  title: const Text('Total Price (Including VAT)'),
                  subtitle: Text('${totalPriceWithVat.toStringAsFixed(2)} SAR'),
                ),
              ],
            ),
          ),
          actionsOverflowButtonSpacing: 10.0,
          actions: <Widget>[
            CustomBTN(text: AppString.cash, onPressed: (){
              var order =  Order(
                id: '',
                  user:Controller.user!.uid ,
                  serviceProvider: widget.serviceProvider,
                  car: widget.car,
                  services: this.selectedServices,
                  orderDateTime: DateTime.now(),
                  paymentStatus: paymentStatus[0],
                  paymentType: paymentType[0],
                  type: widget.serviceTYpe, status: orderStatus[0]) ;
              _controller.makeOrder(order);

            }),
            CustomBTN(text: AppString.pay, onPressed: (){
              var order =  Order(
                  id: '',
                  user:Controller.user!.uid ,
                  serviceProvider: widget.serviceProvider,
                  car: widget.car,
                  services: this.selectedServices,
                  orderDateTime: DateTime.now(),
                  type: widget.serviceTYpe,
                  paymentStatus: paymentStatus[0],
                  paymentType: paymentType[1],
                  status: orderStatus[0]);
              Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(order:order),));
            }),
          ],
        );
      },
    );
  }
}
