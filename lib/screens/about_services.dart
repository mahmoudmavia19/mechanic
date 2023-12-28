import 'package:flutter/material.dart';

class CarService {
  final String name;
  final String description;

  CarService(this.name, this.description);
}

class ServicesScreen extends StatelessWidget {
  final List<CarService> services = [
    CarService(
      'Vehicle maintenance and repair',
      'Includes periodic car checks, engine oil changes, and various repair services.',
    ),
    CarService(
      'Electrical and electronics',
      'Covers issues with lighting systems, electrical operations, audio, and safety systems.',
    ),
    CarService(
      'Tires and Wheels',
      'Provides tire inspections, balancing, alignment, and repair services.',
    ),
    CarService(
      'Refrigeration and air conditioning system',
      'Inspect and repair the car\'s cooling and air conditioning system.',
    ),
    CarService(
      'Exhaust System',
      'Check and repair the car\'s exhaust system and emissions components.',
    ),
    CarService(
      'Brake System',
      'Inspect and maintain the brake system, including discs, pads, and fluids.',
    ),
    CarService(
      'Oil and Fluid Change',
      'Change engine oil, transmission oil, power steering fluid, brake fluid, and more.',
    ),
    CarService(
      'Comprehensive repair services',
      'Includes major engine and transmission repairs, as well as comprehensive electrical work.',
    ),
    CarService(
      'Car Wash',
      'Exterior and interior car cleaning services.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Services'),
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(services[index].name),
            subtitle: Text(services[index].description),
          );
        },
      ),
    );
  }
}
