import 'package:flutter/material.dart';
import 'package:mechanic/models/vehicle.dart';
import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/screens/reminderscreen.dart';
import 'package:mechanic/utils/app_strings.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import '../utils/constants.dart';

class AboutCar extends StatefulWidget {
  const AboutCar({super.key});

  @override
  State<AboutCar> createState() => _AboutCarState();
}

class _AboutCarState extends State<AboutCar> {
  List<Car>? myCars;

  final Controller _controller = Controller();

  @override
  void initState() {
    _controller.getCarInfo();
    myCars = Controller.cars;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.carInfoTitle),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            StreamBuilder<FlowState>(
              stream: _controller.getCarStateCo.stream,
              builder: (context, snapshot) =>
                  snapshot.data?.getScreenWidget(context, _body(), () {
                    _controller.getCarInfo();
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
      itemCount: Controller.cars?.length,
      itemBuilder: (context, index) {
        var car = Controller.cars![index];
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Colors.white,
            child: Column(
              children: [
                Container(
              /*    color: AppColors.primaryColor,*/
                  height: 140,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(40.0))),
                          child: Row(
                            children: [
                              InkWell(
                                  onTap: () {
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
                                                        'Are you sure you want delete your car information'),
                                                    Row(
                                                      children: [
                                                        MaterialButton(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0)),
                                                            onPressed: () {
                                                              _controller
                                                                  .deleteCarInfo(
                                                                      car.serialNumber!);
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
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CircleAvatar(
                            radius: 70.0,
                            backgroundColor: Colors.white,
                            backgroundImage: car.make != null
                                ? NetworkImage(
                                        'https://logo.clearbit.com/${car.make}.com')
                                    as ImageProvider
                                : AssetImage(AppAssets.appLogo),
                            onBackgroundImageError: (exception, stackTrace) =>
                                AssetImage(AppAssets.appLogo),
                          ),
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
                      _buildInfoContainer('Make: ${car.make}'),
                      _buildInfoContainer('Year: ${car.yearOfMake}'),
                      _buildInfoContainer('Model: ${car.model}'),
                      _buildInfoContainer('Engine Type: ${car.engineType}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoContainer(String text) {
    return Container(
      height: 60.0,
      width: double.infinity,
      /* decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.black, // Border color
          width: 1.0, // Border width
        ),
      ),*/
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 0.5))),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Align(alignment: Alignment.centerLeft, child: Text(text)),
    );
  }
}
