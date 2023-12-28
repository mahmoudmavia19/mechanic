import 'package:flutter/material.dart';
import 'package:mechanic/models/order.dart';
import 'package:mechanic/service_provider/controller/service_provider_controller.dart';
import 'package:mechanic/service_provider/screens/view_all_requests.dart';
import 'package:mechanic/utils/constants.dart';

import '../../models/car_services.dart';
import 'package:intl/intl.dart' as intl;

import '../../models/driver_model.dart';
import '../../utils/app_strings.dart';
import '../../utils/state_renderer/state_renderer_impl.dart';

class NewRequests extends StatefulWidget {
  const NewRequests({super.key});
  @override
  State<NewRequests> createState() => _NewRequestsState();
}

class _NewRequestsState extends State<NewRequests> {
  final ServiceProviderController _controller = ServiceProviderController();
  final PageController _pageController = PageController();
  @override
  void initState() {
    _controller.getDrivers().then((value){
      _controller.getNewOrders();
    });
    super.initState();
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Requests'),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AllRequests(),)) ;
          },icon: const Text('All',style: TextStyle(fontWeight: FontWeight.bold,),)),
        ],
      ),
      body:StreamBuilder<FlowState>(
        stream: _controller.newordersStateCon.stream,
        builder:(context, snapshot) => snapshot.data?.getScreenWidget(context, _body(), (){
          _controller.getNewOrders();
        })??Container(),
      )
    );

  }

  _body()=> DefaultTabController(
    length: 2,
    child:Column(
      children: [
          TabBar(
          onTap: (value) {
             _pageController.animateToPage(value, duration: const Duration(milliseconds: 500), curve:Curves.linear) ;
          },
            tabs:const [
          Tab(text:'In-home'),
          Tab(text: 'In-shop'),
        ] ),
        Expanded(
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
            return [_home(), _shop()][index];
          },controller:_pageController ,),
        )
      ],
    ) ,
      );
Widget? _home() {
  var newOrdersHome =  ServiceProviderController.newOrders.where((element) => element.type==serviceTypes[1]).toList();
  return newOrdersHome.isEmpty? const Center(child:Text('Not found data !'),) : ListView.builder(
  itemCount: newOrdersHome.length,
  itemBuilder: (BuildContext context, int index) {
    Order request =  newOrdersHome[index];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          ListTile(
            title: Text('Request Number: ${index+1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Service Required: ${request.services.map((e) => e.name).toList()}'),
                Text('Price: ${calTotalPriceServices(request.services)}'),
                Text('Location: ${ServiceProviderController.newOrdersUsers[request.user]!.address}'),
                Text('Phone Number: ${ServiceProviderController.newOrdersUsers[request.user]!.phoneNumber}'),
                Text('Payment Type: ${request.paymentType}'),
                Text('Payment Status: ${request.paymentStatus}'),
                Text('Order Date Time: ${intl.DateFormat.yMMMd().format(request.orderDateTime)}'),
                Text('Status: ${request.status}'),
                request.car==null ? const Text('Car : unknown') :  Text('Car : ${request.car?.make} | ${request.car?.model}'),

              ],
            ),
          ),
          if(request.status==orderStatus[0])
            ElevatedButton(
              style:const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  backgroundColor: MaterialStatePropertyAll(Colors.green)) ,
              onPressed: () {
                if(request.type == 'Service request') {
                  _showAssignDialog(context, request,ServiceProviderController.drivers);
                }else {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: Padding(
                          padding:
                          const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [
                              const Text(
                                  'Are you sure you want accept this order'),
                              Row(
                                children: [
                                  MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              15.0)),
                                      onPressed: () {
                                        request .status = orderStatus[1];
                                        setState(() {
                                          _controller.updateOrder(request);
                                        });
                                      },
                                      color: Colors.red,
                                      child: const Text(
                                          'Yes')),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            15.0)),
                                    onPressed: () {
                                      Navigator.pop(
                                          context);
                                    },
                                    color: Colors.grey,
                                    child:
                                    const Text('No'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ));
                }
              },
              child: const Text('Accept'),
            ),
          if(request.status!=orderStatus[2]&&request.paymentStatus==paymentStatus[1])
            ElevatedButton(
              style:  ButtonStyle(
                  foregroundColor: const MaterialStatePropertyAll(Colors.white),
                  backgroundColor: MaterialStatePropertyAll(AppColors.primaryColor)) ,
              onPressed: () {

                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: Padding(
                        padding:
                        const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            const Text(
                                'Are you sure you want accept this order'),
                            Row(
                              children: [
                                MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            15.0)),
                                    onPressed: () {
                                      request.status = orderStatus[2] ;
                                      setState(() {
                                        _controller.updateOrder(request);
                                      });
                                    },
                                    color: Colors.red,
                                    child: const Text(
                                        'Yes')),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                          15.0)),
                                  onPressed: () {
                                    Navigator.pop(
                                        context);
                                  },
                                  color: Colors.grey,
                                  child:
                                  const Text('No'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ));
              },
              child: const Text('Done'),
            ),
          const SizedBox(height: 10.0,),

        ],
      ),

    );
  },
);
}
  Widget? _shop() {
    var newOrdersShop =  ServiceProviderController.newOrders.where((element) => element.type==serviceTypes[0]).toList();
    return newOrdersShop.isEmpty?const Center(child:Text('Not found data !'),) : ListView.builder(
      itemCount: newOrdersShop.length,
      itemBuilder: (BuildContext context, int index) {
        Order request =  newOrdersShop[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            children: [
              ListTile(
                title: Text('Request Number: ${index+1}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Service Required: ${request.services.map((e) => e.name).toList()}'),
                    Text('Price: ${calTotalPriceServices(request.services)}'),
                    Text('Location: ${ServiceProviderController.newOrdersUsers[request.user]!.address}'),
                    Text('Phone Number: ${ServiceProviderController.newOrdersUsers[request.user]!.phoneNumber}'),
                    Text('Payment Type: ${request.paymentType}'),
                    Text('Payment Status: ${request.paymentStatus}'),
                    Text('Order Date Time: ${intl.DateFormat.yMMMd().format(request.orderDateTime)}'),
                    Text('Status: ${request.status}'),
                    request.car==null ? const Text('Car : unknown') :  Text('Car : ${request.car?.make} | ${request.car?.model}'),

                  ],
                ),
              ),
              if(request.status==orderStatus[0])
                ElevatedButton(
                  style:const ButtonStyle(
                      foregroundColor: MaterialStatePropertyAll(Colors.white),
                      backgroundColor: MaterialStatePropertyAll(Colors.green)) ,
                  onPressed: () {
                    if(request.type == 'Service request') {
                      _showAssignDialog(context, request,ServiceProviderController.drivers);
                    }else {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Padding(
                              padding:
                              const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  const Text(
                                      'Are you sure you want accept this order'),
                                  Row(
                                    children: [
                                      MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  15.0)),
                                          onPressed: () {
                                            request .status = orderStatus[1];
                                            setState(() {
                                              _controller.updateOrder(request);
                                            });
                                          },
                                          color: Colors.red,
                                          child: const Text(
                                              'Yes')),
                                      const SizedBox(
                                        width: 20.0,
                                      ),
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                15.0)),
                                        onPressed: () {
                                          Navigator.pop(
                                              context);
                                        },
                                        color: Colors.grey,
                                        child:
                                        const Text('No'),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ));
                    }
                  },
                  child: const Text('Accept'),
                ),
              if(request.status==orderStatus[1] && request.paymentStatus == paymentStatus[1])
                ElevatedButton(
                  style:  ButtonStyle(
                      foregroundColor: const MaterialStatePropertyAll(Colors.white),
                      backgroundColor: MaterialStatePropertyAll(AppColors.primaryColor)) ,
                  onPressed: () {

                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Padding(
                            padding:
                            const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [
                                const Text(
                                    'Is order finished ?'),
                                Row(
                                  children: [
                                    MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                15.0)),
                                        onPressed: () {
                                          request.status = orderStatus[2] ;
                                          setState(() {
                                            _controller.updateOrder(request);
                                          });
                                        },
                                        color: Colors.red,
                                        child: const Text(
                                            'Yes')),
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              15.0)),
                                      onPressed: () {
                                        Navigator.pop(
                                            context);
                                      },
                                      color: Colors.grey,
                                      child:
                                      const Text('No'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));

                  },
                  child: const Text('Done'),
                ),
              const SizedBox(height: 10.0,),
              if(request.paymentStatus == paymentStatus[0] && request.status==orderStatus[1])
                ElevatedButton(
                  style:  ButtonStyle(
                      foregroundColor: const MaterialStatePropertyAll(Colors.white),
                      backgroundColor: MaterialStatePropertyAll(AppColors.primary2Color)) ,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Padding(
                            padding:
                            const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [
                                const Text('Are you sure'),
                                Row(
                                  children: [
                                    MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                15.0)),
                                        onPressed: () {
                                          request.paymentStatus = paymentStatus[1];
                                          setState(() {
                                            _controller.updateOrder(request);
                                          });
                                        },
                                        color: Colors.red,
                                        child: const Text(
                                            'Yes')),
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              15.0)),
                                      onPressed: () {
                                        Navigator.pop(
                                            context);
                                      },
                                      color: Colors.grey,
                                      child:
                                      const Text('No'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));


                   },
                  child: const Text('Pay'),
                ),
            ],
          ),

        );
      },
    );
  }
  void _showAssignDialog(BuildContext context, Order request, List<Driver> drivers) {
    Driver? selectedDriver;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Assign Request to a Driver'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButton<Driver>(
                    value: selectedDriver,
                    hint: const Text('Select a driver'),
                    onChanged: (Driver? newValue) {
                      setState(() {
                        selectedDriver = newValue;
                      });
                    },
                    items: drivers.where((element) => !element.block).map<DropdownMenuItem<Driver>>((Driver driver) {
                      return DropdownMenuItem<Driver>(
                        value: driver,
                        child: Text(driver.name),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (selectedDriver != null) {
                  Navigator.of(context).pop();
                  request .status = orderStatus[1];
                  request.driver = selectedDriver;
                  setState(() {
                    _controller.updateOrder(request);
                  });
                }
              },
              child: const Text('Assign'),
            ),
          ],
        );
      },
    );
  }
}

calTotalPriceServices(List<CarService> services){
  double totalPrice = 0 ;
  for(var service in services){
    totalPrice += service.price;
  }
  return totalPrice;
}