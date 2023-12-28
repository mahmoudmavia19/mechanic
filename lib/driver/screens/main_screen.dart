import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:lottie/lottie.dart';
import 'package:mechanic/driver/controller/driver_controller.dart';
import 'package:mechanic/utils/app_strings.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../models/order.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart' as intl;

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({Key? key}) : super(key: key);

  @override
  _DriverMainScreenState createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  final DriverController _controller = DriverController();

  @override
  void initState() {
    _controller.getAllOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(AppString.home),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _controller.logout();
                Phoenix.rebirth(context);
              },
            )
          ],
        ),
        body: StreamBuilder<FlowState>(
          stream: _controller.ordersStateCon.stream,
          builder: (context, snapshot) =>
              snapshot.data?.getScreenWidget(context, _body(), () {
                _controller.getAllOrders();
              }) ??
              Container(),
        ));
  }

  _body() => DriverController.orders.isEmpty
      ? Lottie.asset(AppAssets.error)
      : Column(
          children: [
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
                  child: Text('< Last Orders >'),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.primary2Color,
                    height: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 190,
              child:DriverController.newOrders.isEmpty?
              const Center(
                    child:  Text('No Data Found'),
                  )
                  :  ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: DriverController.newOrders.length,
                itemBuilder: (BuildContext context, int index) {
                  Order request = DriverController.newOrders[index];
                  return Card(
                    margin: const EdgeInsets.all(20.0),
                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: ${request.status}'),
                          Text(
                              'Payment Status: ${request.paymentStatus}'),
                          Text(
                              'Payment Type: ${request.paymentType}'),
                          Text(
                              'Order Date: ${intl.DateFormat.yMMMd().format(request.orderDateTime)}'),
                      MaterialButton(
                        onPressed: () {
                          _showOrderDetailsDialog(
                              context, request);
                        },
                        child: const Text('View Details'),
                      ),
                        ],
                      ),
                    )/*ListTile(
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: ${request.status}'),
                          Text(
                              'Payment Status: ${request.paymentStatus}'),
                          Text(
                              'Payment Type: ${request.paymentType}'),
                          Text(
                              'Order Date: ${intl.DateFormat.yMMMd().format(request.orderDateTime)}'),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _showOrderDetailsDialog(
                              context, request);
                        },
                        child: const Text('View Details'),
                      ),
                    ),*/
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
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
                  child: Text('< All Orders >'),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.primary2Color,
                    height: 0.5,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: DriverController.orders.length,
                itemBuilder: (context, index) {
                  Order order = DriverController.orders[index];
                  return Card(
                    margin: const EdgeInsets.all(20.0),
                    child: ListTile(
                      title: Text('Order : ${index + 1}',
                          overflow: TextOverflow.ellipsis, maxLines: 1),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payment Status: ${order.paymentStatus}'),
                          Text('Payment Type: ${order.paymentType}'),
                          Text('Status: ${order.status}'),
                          Text(
                              'Order Date: ${intl.DateFormat.yMMMd().format(order.orderDateTime)}'),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _showOrderDetailsDialog(context, order);
                        },
                        child: const Text('View Details'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );

  void _showOrderDetailsDialog(BuildContext context, Order order) async {
    await _controller.getUsers(order.user).then((value) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Order Details'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('User Info'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${value.name}'),
                      Text('Number: ${value.phoneNumber}'),
                      Text('Address: ${value.address}'),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Service Provider Info'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${order.serviceProvider.name}'),
                      Text('Number: ${order.serviceProvider.phoneNumber}'),
                      Text(
                          'Address: ${order.serviceProvider.workshop.district}'),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Payment Info'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${order.paymentStatus}'),
                      Text('Type: ${order.paymentType}'),
                    ],
                  ),
                ),
                const Divider(),
                Text('Service: ${order.services.map((e) => e.name).toList()}'),
                Text(
                    'Order Date: ${intl.DateFormat.yMMMd().format(order.orderDateTime)}'),
                Text('Status: ${order.status}'),
                // Add other details here
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
              if (order.status == orderStatus[1] && order.paymentStatus == paymentStatus[1])
                TextButton(
                  onPressed: () {
                    order.status = orderStatus[2];
                    setState(() {});
                    _controller.updateOrder(order);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Finish'),
                ),
              if (order.paymentStatus == paymentStatus[0])
                TextButton(
                  onPressed: () {
                    order.paymentStatus = paymentStatus[1];
                    setState(() {});
                    _controller.updateOrder(order);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Pay'),
                ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                        child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PopupMenuItem(
                            child: const Text('WhatsApp'),
                            onTap: () async {
                              String url = "https://wa.me/${value.phoneNumber}";
                              await launchUrlString(url);
                            },
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            child: const Text('Phone Call'),
                            onTap: () async {
                              await launchUrlString('tel:${value.phoneNumber}');
                            },
                          ),
                        ],
                      ),
                    )),
                  );
                },
                child: const Text('call'),
              ),
            ],
          );
        },
      );
    });
  }
}
