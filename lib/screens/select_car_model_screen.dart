import 'package:flutter/material.dart';
import 'package:mechanic/models/vehicle.dart';
import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/screens/booking_screen.dart';
import 'package:mechanic/utils/state_renderer/state_renderer.dart';
import '../utils/app_strings.dart';
 import '../widgets/custombtn.dart';

class SelectCarModelScreen extends StatefulWidget {
    SelectCarModelScreen({super.key});

  @override
  State<SelectCarModelScreen> createState() => _SelectCarModelScreenState();
}

class _SelectCarModelScreenState extends State<SelectCarModelScreen> {
  final Controller _controller =Controller();
  Car? car ;
  String? selectedCarType ;
  List<String> myCarsMake = [];
  final GlobalKey<FormState> _frmKey = GlobalKey<FormState>() ;
  bool _loading = true ;
  @override
  void initState() {
    _controller.getCarInfo().then((value) {
      var list = Controller.cars?.map((e) => e.make);
    var setList =   <String>{} ;
    setList.addAll(list!);
    myCarsMake = setList.toList();

    });

    _controller.getCarStateCo.stream.listen((event) {
      if(event.getStateRendererType()== StateRendererType.fullScreenLoadingState) {
        setState(() {
        _loading = true ;
      });
      }else{
        setState(() {
          _loading = false ;
        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key:_frmKey ,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 16.0),
              const Text(
                'Select Car Make',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 8.0),
              if(_loading)
                const CircularProgressIndicator(),
              if(!_loading)
              _body(),
              const SizedBox(height: 16.0),
              CustomBTN(text: AppString.continue_, onPressed: () {
                if(_frmKey.currentState!.validate()){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  BookingScreen(carModel: selectedCarType!,car: car!,)));
                }
              },),
            ],
          ),
        ),
      ),
    );
  }

  _body()=>DropdownButtonFormField<Car>(
    validator: (value) {
      if(value==null){
        return AppString.cantEmpty ;
      }else{
        return null;
      }
    },
    borderRadius: BorderRadius.circular(10.0),
    onChanged: (value) {
      setState(() {
        selectedCarType = value!.make;
        car =value ;
      });
    },
    items: Controller.cars?.map((Car car) {
      return DropdownMenuItem<Car>(
        value: car, // Make sure each value is unique
        child: Text('${car.make} : ${car.model}'),
      );
    }).toList(),
    decoration: const InputDecoration(
      hintText: 'Select Car Make',
      border: OutlineInputBorder(),
    ),
  );
}
