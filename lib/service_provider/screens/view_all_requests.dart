import 'package:flutter/material.dart';
import 'package:mechanic/models/order.dart';
import 'package:mechanic/service_provider/controller/service_provider_controller.dart';
import 'package:mechanic/service_provider/screens/new_requests.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';

import '../../utils/constants.dart';


class AllRequests extends StatefulWidget {

  const AllRequests({super.key});

  @override
  State<AllRequests> createState() => _AllRequestsState();
}

class _AllRequestsState extends State<AllRequests> {

  final ServiceProviderController _controller = ServiceProviderController();
  final PageController _pageController = PageController();

  @override
  void initState() {
    _controller.getAllOrders();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Requests'),
      ),
      body: StreamBuilder<FlowState>(
        stream: _controller.allordersStateCon.stream,
        builder:(context, snapshot) =>snapshot.data?.getScreenWidget(context, _body(), (){
          _controller.getAllOrders();
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
    var newOrdersHome =  ServiceProviderController.allOrders.where((element) => element.type==serviceTypes[1]).toList();
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
                    Text('Location: ${ServiceProviderController.allOrdersUsers[request.user]!.address}'),
                    Text('Phone Number: ${ServiceProviderController.allOrdersUsers[request.user]!.phoneNumber}'),
                    Text('Payment Type: ${request.paymentType}'),
                    Text('Payment Status: ${request.paymentStatus}'),
                    Text('Order Date Time: ${intl.DateFormat.yMMMd().format(request.orderDateTime)}'),
                    Text('Status: ${request.status}'),
                    request.car==null ? const Text('Car : unknown') :  Text('Car : ${request.car?.make} | ${request.car?.model}'),

                  ],
                ),
              ),
            ],
          ),

        );
      },
    );
  }
  Widget? _shop() {
    var newOrdersShop =  ServiceProviderController.allOrders.where((element) => element.type==serviceTypes[0]).toList();
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
                    Text('Location: ${ServiceProviderController.allOrdersUsers[request.user]!.address}'),
                    Text('Phone Number: ${ServiceProviderController.allOrdersUsers[request.user]!.phoneNumber}'),
                    Text('Payment Type: ${request.paymentType}'),
                    Text('Payment Status: ${request.paymentStatus}'),
                     Text('Order Date Time: ${intl.DateFormat.yMMMd().format(request.orderDateTime)}'),
                    Text('Status: ${request.status}'),
                    request.car==null ? const Text('Car : unknown') :  Text('Car : ${request.car?.make} | ${request.car?.model}'),

                  ],
                ),
              ),
            ],
          ),

        );
      },
    );
  }
}

