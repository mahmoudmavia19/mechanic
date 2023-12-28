
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mechanic/service_provider/controller/service_provider_controller.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import 'package:mechanic/widgets/service_provider_item.dart';

import '../../models/driver_model.dart';

class DriverManagement extends StatefulWidget {
  const DriverManagement({super.key});

  @override
  _DriversManagementScreenState createState() =>
      _DriversManagementScreenState();
}

class _DriversManagementScreenState extends State<DriverManagement> {
 final ServiceProviderController _controller = ServiceProviderController();

 @override
  void initState() {
    _controller.getDrivers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drivers Management'),
      ),
      body: StreamBuilder<FlowState>(
        stream: _controller.driverStateCon.stream,
        builder:(context, snapshot) => snapshot.data?.getScreenWidget(context, _body(), (){})??Container() ,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  _body()=>ListView.builder(
    itemCount: ServiceProviderController.drivers.length,
    itemBuilder: (BuildContext context, int index) {
      Driver driver = ServiceProviderController.drivers[index];
      var rate = calRate(driver.rate);
      return ListTile(
        title: Text(driver.name),
        subtitle:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(driver.email),
            RatingBar.builder(
              initialRating: rate,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              ignoreGestures: true,
              itemCount: 5,
              itemSize: 20.0,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ), onRatingUpdate: (double value) {  },
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showEditDialog(context, driver);
              },
            ),
            IconButton(
              icon:   Icon(!driver.block? Icons.person  :  Icons.person_add_disabled),
              onPressed: () {
                setState(() {
                  driver.block = !driver.block;
                  _controller.updateDriver(driver);
                });
              },
            ),
          ],
        ),
      );
    },
  );

  void _showAddDialog(BuildContext context) {
    String name = '';
/*
    String address = '';
*/
    String email = '';
    String phoneNumber = '';
    String password = '';
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Driver'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                  ),
               /*   TextFormField(
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      address = value!;
                    },
                  ),*/
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length != 10) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phoneNumber = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                  ),

                ],
              ),
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
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                    var  d =  Driver(
                      name: name,
/*
                      address: address,
*/
                      email: email,
                      phoneNumber: phoneNumber,
                      password: password,
                    );
                     _controller.addDriver(d);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }



  void _showEditDialog(BuildContext context, Driver driver) {
    String editedName = driver.name;
/*
    String editedAddress = driver.address;
*/
    String editedEmail = driver.email;
    String editedPhoneNumber = driver.phoneNumber;

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Driver Details'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    initialValue: editedName,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      editedName = value!;
                    },
                  ),
                /*  TextFormField(
                    initialValue: editedAddress,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      editedAddress = value!;
                    },
                  ),*/
                  TextFormField(
                    initialValue: editedEmail,
                    enabled: false,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      editedEmail = value!;
                    },
                  ),
                  TextFormField(
                    initialValue: editedPhoneNumber,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length != 10) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      editedPhoneNumber = value!;
                    },
                  ),
                ],
              ),
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
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  setState(() {
                    driver.name = editedName;
/*
                    driver.address = editedAddress;
*/
                    driver.email = editedEmail;
                    driver.phoneNumber = editedPhoneNumber;
                   });
                  _controller.updateDriver(driver);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

}