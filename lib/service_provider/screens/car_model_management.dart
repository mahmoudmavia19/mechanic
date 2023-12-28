import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mechanic/models/car_model.dart';
import 'package:mechanic/service_provider/controller/service_provider_controller.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';

import '../../utils/app_strings.dart';
import '../../utils/constants.dart';

class CarModelManagement extends StatefulWidget {
  const CarModelManagement({super.key});

  @override
  _CarModelManagementState createState() =>
      _CarModelManagementState();
}

class _CarModelManagementState
    extends State<CarModelManagement> {
  final ServiceProviderController _controller = ServiceProviderController();


  @override
  void initState() {
    _controller.getCarsModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Types Management'),
      ),
      body:StreamBuilder<FlowState>(
         stream: _controller.carModelStateCon.stream,
        builder:(context, snapshot) =>snapshot.data?.getScreenWidget(context, _body(), (){
          _controller.getCarsModel();
        })??Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context).then((value) {
            setState(() {

            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _body()=> ListView.builder(
    itemCount: ServiceProviderController.carModel.length,
    itemBuilder: (BuildContext context, int index) {
      CarModel carModel = ServiceProviderController.carModel[index];
       return ListTile(
        title: Text(carModel.modelMakeId!),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showEditDialog(context, carModel);
              },
            ),
            IconButton(
              icon: Icon(carModel.hidden
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: () {
                setState(() {
                  carModel.hidden = !carModel.hidden;
                });
                _controller.updateCarModel(carModel);
              },
            ),
          ],
        ),
      );
    },
  );
var addForm = GlobalKey<FormState>();
  Future _showAddDialog(BuildContext context) {
    String? newMakeDisplay;
    String? newModelName;
   return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:(context, setState) =>  AlertDialog(
            title: const Text('Add Vehicle Type'),
            content: Form(
              key: addForm,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
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
                    value: newMakeDisplay,
                    hint: const Text('Select a car Make'),
                    onChanged: (newValue) {
                      newModelName = null;
                      setState(() {
                        newMakeDisplay = newValue!;
                       });
                    },
                    items: makes.where((element) => !ServiceProviderController.carModel.map((e) => e.modelMakeId).toList()
                        .contains(element))
                        .map<DropdownMenuItem<String>>((make) {
                      return DropdownMenuItem<String>(
                        value: make,
                        child: Text(make ?? ''),
                      );
                    }).toList(),
                  ),
                ],
              ),
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
                  if(addForm.currentState!.validate()) {

                    // Add the new car make and model to the respective lists
                     _controller.addCarModel(CarModel(
                       modelName: newModelName,
                       modelMakeId: newMakeDisplay,
                     ));

                    Navigator.of(context).pop();

                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, CarModel model) {
    String? editedName = model.modelMakeId;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Model'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
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
                value: editedName,
                hint: const Text('Select a car make'),
                onChanged: (newValue) {
                     editedName = newValue!;
                },
                items: makes.where((element) => !ServiceProviderController.carModel.map((e) => e.modelMakeId).toList()
                    .contains(element) || element == model.modelMakeId)
                    .map<DropdownMenuItem<String>>((make) {
                  return DropdownMenuItem<String>(
                    value: make,
                    child: Text(make ?? ''),
                  );
                }).toList(),
              ),
            ],
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
                setState(() {
                  model.modelMakeId = editedName;
                });
                _controller.updateCarModel(model);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }


}
