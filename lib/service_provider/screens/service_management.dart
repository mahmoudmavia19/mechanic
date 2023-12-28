import 'package:flutter/material.dart';
import 'package:mechanic/service_provider/controller/service_provider_controller.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';

import '../../models/car_services.dart';

class ServiceManagement extends StatefulWidget {
  @override
  _ServiceManagementState createState() => _ServiceManagementState();
}

class _ServiceManagementState extends State<ServiceManagement> {
  final ServiceProviderController _controller =ServiceProviderController();

  @override
  void initState() {
    _controller.getCarServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Management'),
      ),
      body: StreamBuilder<FlowState>(
        stream: _controller.serviceStateCon.stream,
        builder:(context, snapshot) => snapshot.data?.getScreenWidget(context, _body(),(){})??_body(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _body()=> ServiceProviderController.services.isEmpty ?const Center(child:Text('Not found data !'),) :ListView.builder(
    itemCount:ServiceProviderController.services.length,
    itemBuilder: (BuildContext context, int index) {
      CarService service = ServiceProviderController.services[index];
      return ListTile(
        title: Text(service.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${service.price.toStringAsFixed(2)}'),
            Text('Type: ${service.type}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showEditDialog(context, service);
              },
            ),
            IconButton(
              icon: Icon(!service.hidden ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  service.hidden = !service.hidden;
                  _controller.updateCarService(service);
                });
              },
            ),
          ],
        ),
      );
    },
  );

  void _showAddDialog(BuildContext context) {
    String serviceName = '';
    double servicePrice = 0.0;
    String serviceType = 'all'; // Default service type

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Service'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Service Name'),
                    onChanged: (value) {
                      serviceName = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Service Price'),
                    onChanged: (value) {
                      servicePrice = double.tryParse(value) ?? 0.0;
                    },
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  ListTile(
                    title: const Text('All'),
                    leading: Radio(
                      value: 'all',
                      groupValue: serviceType,
                      onChanged: (value) {
                        setState(() {
                          serviceType = value as String;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('In-home'),
                    leading: Radio(
                      value: 'in-home',
                      groupValue: serviceType,
                      onChanged: (value) {
                        setState(() {
                          serviceType = value as String;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('In-shop'),
                    leading: Radio(
                      value: 'in-shop',
                      groupValue: serviceType,
                      onChanged: (value) {
                        setState(() {
                          serviceType = value as String;
                        });
                      },
                    ),
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
                    _controller.addCarService(CarService(
                      ServiceProviderController.services.length.toString(),
                      serviceName,
                      false,
                      servicePrice,
                      type: serviceType,
                    ));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _showEditDialog(BuildContext context, CarService service) {
    String editedName = service.name;
    double editedPrice = service.price;
    String editedType = service.type;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Service'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Service Name'),
                    controller: TextEditingController(text: editedName),
                    onChanged: (value) {
                      editedName = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Service Price'),
                    controller: TextEditingController(text: editedPrice.toString()),
                    onChanged: (value) {
                      editedPrice = double.tryParse(value) ?? 0.0;
                    },
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  ListTile(
                    title: const Text('All'),
                    leading: Radio(
                      value: 'all',
                      groupValue: editedType,
                      onChanged: (value) {
                        setState(() {
                          editedType = value as String;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('In-home'),
                    leading: Radio(
                      value: 'in-home',
                      groupValue: editedType,
                      onChanged: (value) {
                        setState(() {
                          editedType = value as String;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('In-shop'),
                    leading: Radio(
                      value: 'in-shop',
                      groupValue: editedType,
                      onChanged: (value) {
                        setState(() {
                          editedType = value as String;
                        });
                      },
                    ),
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
                      service.name = editedName;
                      service.price = editedPrice;
                      service.type = editedType;
                      _controller.updateCarService(service);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

}
