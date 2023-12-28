import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/screens/track_order_screen.dart';
import 'package:mechanic/utils/app_strings.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import 'package:intl/intl.dart' as intl;
import '../widgets/custombtn.dart';
import '../widgets/order_rate_dialog.dart';

class OrdersHistory extends StatefulWidget {
  OrdersHistory({super.key});

  @override
  State<OrdersHistory> createState() => _OrdersHistoryState();
}

class _OrdersHistoryState extends State<OrdersHistory> {

  final Controller _controller = Controller();

  @override
  void initState() {
    _controller.getOrderHistoryInfo();
     super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.reservesHistory),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            StreamBuilder<FlowState>(
              stream: _controller.getOrderHistoryStateCo.stream,
              builder: (context, snapshot) =>
              snapshot.data?.getScreenWidget(context, _body(), () {
                _controller.getOrderHistoryInfo();
              }) ??
                  Container(),
            )
          ],
        ),
      ),
    );
  }

  _body() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _controller.orders?.length,
      itemBuilder: (context, index) {
        var order = _controller.orders![index];
        return  Card(
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
                                  _controller.removeOrderFromHistory(order.id);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );},
                  child: Container(
                    color:order.status=='canceled'?Colors.red: orderStatusColor[orderStatus.indexOf(order.status)],
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
                      Text(order.serviceProvider.name),
                      SizedBox(
                        width: 200,
                          child: Text(order.services.map((e) => e.name).toList().toString()
                              ,overflow: TextOverflow.ellipsis,
                          )),
                      Text(order.status),
                      Text(intl.DateFormat.yMMMd().format(order.orderDateTime)),
                      if(order.status==orderStatus[2])
                      RatingBar.builder(
                        initialRating: order.rate,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        ignoreGestures: true,
                        itemCount: 5,
                        itemSize: 20.0,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            order.rate = rating;
                          });
                        },
                      ),
                    ],
              ),
                 ),
               ),
              if(order.status==orderStatus[2])
                InkWell(
                  onTap: () {
                   // Navigator.push(context, MaterialPageRoute(builder: (context) => TrackOrder(order: order),));
                    showDialog(
                      context: context,
                      builder: (context) => OrderRateDialog(order),
                    ).then((value){
                      setState(() {

                      });
                    });
                  },
                  child:   SizedBox(
                     width: 70.0,
                    height:100.0,
                    child: order.rate ==0.0 ?  const Icon(Icons.star_border_outlined,) :const Icon(Icons.star,color: Colors.amber,)  ,
                  ),
                ),
                Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TrackOrder(order: order),));
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
        );
      },
    );
  }
}
