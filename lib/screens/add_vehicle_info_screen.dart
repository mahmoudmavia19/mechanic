import 'package:flutter/material.dart';
import 'package:mechanic/models/car_make.dart';
import 'package:mechanic/models/car_model.dart';
import 'package:mechanic/models/vehicle.dart';
import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import 'package:mechanic/widgets/custombtn.dart';
import '../utils/app_strings.dart';
import '../utils/constants.dart';

class AddCarInfoScreen extends StatefulWidget {
  const AddCarInfoScreen({super.key});

  @override
  _AddCarInfoScreenState createState() => _AddCarInfoScreenState();
}

class _AddCarInfoScreenState extends State<AddCarInfoScreen> {
  final Controller controller = Controller();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController makeController = TextEditingController();
  final TextEditingController productionYearController =
      TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController snController = TextEditingController();

  final TextEditingController engineTypeController = TextEditingController();
  CarMake? selectedMake;
  String? selectedModel;
  String? selectedEngineType;
  String? selectedMakeYear = '1990';

  bool modelsLoading = false;
  _bind() async {
    await controller.getCarMakes();
    controller.modelsLoadingState.stream.listen((event) {
      selectedModel = null;
      setState(() {
        modelsLoading = event;
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
          title: const Text(AppString.addCarInfoTitle),
        ),
        body: StreamBuilder<FlowState>(
          builder: (context, snapshot) =>
              snapshot.data?.getScreenWidget(context, _body(), () {}) ??
              _body(),
          stream: controller.addCarStateCo.stream,
        ));
  }

  _body() => SingleChildScrollView(
        child: Column(
          children: [
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
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 70.0,
                      backgroundColor: Colors.white,
                      backgroundImage: selectedMake != null
                          ? NetworkImage(
                                  'https://logo.clearbit.com/${selectedMake!.makeDisplay}.com')
                              as ImageProvider
                          : AssetImage(AppAssets.appLogo),
                      onBackgroundImageError: (exception, stackTrace) =>
                          AssetImage(AppAssets.appLogo),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value==null) {
                            return AppString.cantEmpty;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: AppString.productionYearLabel,
                          hintText: AppString.productionYearHint,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          floatingLabelStyle:
                          TextStyle(color: AppColors.primary2Color),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.primary2Color,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          labelStyle:
                          const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: selectedMakeYear,
                        hint: Text(selectedMakeYear ?? 'Select a car years of make'),
                        onChanged: (newValue) {
                          setState(() {
                            selectedMakeYear = newValue;
                            print(selectedMakeYear);
                          });
                        },
                        items: List<String>.generate(34, (index) => (1990 + index).toString())
                            .map<DropdownMenuItem<String>>(
                                (String model) {
                              return DropdownMenuItem<String>(
                                value: model,
                                child: Text(model ?? ''),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<CarMake>(
                        validator: (value) {
                          if (value==null) {
                            return AppString.cantEmpty;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: AppString.carMakeLabel,
                          hintText: AppString.carMakeHint,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          floatingLabelStyle:
                          TextStyle(color: AppColors.primary2Color),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.primary2Color, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          labelStyle:
                          const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: selectedMake,
                        hint: const Text('Select a car Make'),
                        onChanged: (newValue) {
                          setState(() {
                            selectedMake = newValue!;
                            controller.getCarModels(newValue.makeId!);
                          });
                        },
                        items: controller.carMakes
                            .map<DropdownMenuItem<CarMake>>((CarMake make) {
                          return DropdownMenuItem<CarMake>(
                            value: make,
                            child: Text(make.makeDisplay ?? ''),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                    modelsLoading
                        ? const Align(alignment: Alignment.center,child: CircularProgressIndicator())
                        : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField<String>(
                      validator: (value) {
                          if (value==null) {
                            return AppString.cantEmpty;
                          }
                          return null;
                      },
                      decoration: InputDecoration(
                          labelText: AppString.carModelLabel,
                          hintText: AppString.carModelHint,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          floatingLabelStyle:
                          TextStyle(color: AppColors.primary2Color),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.primary2Color,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          labelStyle:
                          const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: selectedModel,
                      hint: Text(selectedModel ?? 'Select a car model'),
                      onChanged: (newValue) {
                          setState(() {
                            selectedModel = newValue;
                            print(selectedModel);
                          });
                      },
                      items: controller.carModels
                            .map<DropdownMenuItem<String>>(
                                (CarModel model) {
                              return DropdownMenuItem<String>(
                                value: model.modelName,
                                child: Text(model.modelName ?? ''),
                              );
                            }).toList(),
                    ),
                        ),
                    const SizedBox(height: 10.0,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        validator: (value) {
                          if (value==null) {
                            return AppString.cantEmpty;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: AppString.engineTypeLabel,
                          hintText: AppString.engineTypeHint,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          floatingLabelStyle:
                          TextStyle(color: AppColors.primary2Color),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.primary2Color,
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          labelStyle:
                          const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: selectedEngineType,
                        hint: Text(selectedEngineType ?? 'Select a car engine type'),
                        onChanged: (newValue) {
                          setState(() {
                            selectedEngineType = newValue;
                            print(selectedEngineType);
                          });
                        },
                        items: ['Diesel', 'gasoline', 'hybrid', 'electric']
                            .map<DropdownMenuItem<String>>(
                                (String model) {
                              return DropdownMenuItem<String>(
                                value: model,
                                child: Text(model ?? ''),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10.0,),
                /*    CustomTextField(
                       optional: true,
                      labelText: AppString.serialNumber,
                      hintText: AppString.serialNumber,
                      controller: snController,
                      onSaved: (value) {
                        // Handle the saved value
                      },
                    ),
                    const SizedBox(height: 16.0),*/
                    CustomBTN(
                      text: AppString
                          .saveButtonLabel, // Use AppString for button text
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Car car = Car(
                              brand: makeController.text,
                              make: selectedMake!.makeDisplay!,
                              yearOfMake: selectedMakeYear!,
                              model: selectedModel!,
                              engineType: selectedEngineType!,
                              serialNumber: snController.text);
                          controller.addCarInfo(car);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  @override
  void dispose() {
    makeController.dispose();
    productionYearController.dispose();
    modelController.dispose();
/*
    trimController.dispose();
*/
    super.dispose();
  }
}
