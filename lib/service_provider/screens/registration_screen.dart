import 'package:flutter/material.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/widgets/custombtn.dart';
import 'package:mechanic/widgets/custom_text_field.dart';

import 'main_screen.dart';

class ServiceProviderRegistrationScreen extends StatefulWidget {
  const ServiceProviderRegistrationScreen({Key? key}) : super(key: key);

  @override
  _ServiceProviderRegistrationScreenState createState() =>
      _ServiceProviderRegistrationScreenState();
}

class _ServiceProviderRegistrationScreenState
    extends State<ServiceProviderRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0.0,
        title: const Text('Service Provider Registration'),
      ),
      body: _buildRegistrationForm(),
    );
  }

  Widget _buildRegistrationForm() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomTextField(
              labelText: 'Name',
              hintText: 'Enter your name',
              controller: nameController,
            ),
            CustomTextField(
              labelText: 'District',
              hintText: 'Enter your district',
              controller: districtController,
            ),
            CustomTextField(
              labelText: 'Street Name',
              hintText: 'Enter your street name',
              controller: streetNameController,
            ),
            CustomTextField(
              labelText: 'City',
              hintText: 'Enter your city',
              controller: cityController,
            ),
            CustomTextField(
              labelText: 'Email',
              hintText: 'Enter your email',
              controller: emailController,
            ),
            CustomTextField(
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              controller: phoneNumberController,
            ),
            CustomTextField(
              labelText: 'Password',
              hintText: 'Enter your password',
              controller: passwordController,
             ),
            CustomTextField(
              labelText: 'Confirm Password',
              hintText: 'Confirm your password',
              controller: passwordCController,
             ),
            const SizedBox(height: 16.0),
            CustomBTN(
                text: 'Register',
                onPressed: () {
                  // if (_formKey.currentState!.validate() &&
                  //     passwordCController.text == passwordController.text) {
                  //   _register();
                  // }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ServiceProviderMainScreen(),));
                }),
          ],
        ),
      ),
    );
  }

  void _register() {
    // Implement the registration logic here
    // You can access the values from the controllers and perform necessary actions
  }

  @override
  void dispose() {
    nameController.dispose();
    districtController.dispose();
    streetNameController.dispose();
    cityController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    passwordCController.dispose();
    super.dispose();
  }
}
