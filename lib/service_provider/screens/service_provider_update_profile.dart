import 'package:flutter/material.dart';
import 'package:mechanic/models/service_provider.dart';
import 'package:mechanic/models/workshop.dart';
import 'package:mechanic/service_provider/controller/service_provider_controller.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import 'package:mechanic/widgets/custombtn.dart';
import 'package:mechanic/widgets/custom_text_field.dart';

class ServiceProviderUpdateProfile extends StatefulWidget {
  const ServiceProviderUpdateProfile({Key? key}) : super(key: key);

  @override
  _ServiceProviderUpdateProfileState createState() =>
      _ServiceProviderUpdateProfileState();
}

class _ServiceProviderUpdateProfileState
    extends State<ServiceProviderUpdateProfile> {
  final _formKey = GlobalKey<FormState>();
 late final TextEditingController nameController;
 late final TextEditingController districtController;
 late final TextEditingController streetNameController ;
 late final TextEditingController cityController ;
 late final TextEditingController emailController ;
 late final TextEditingController phoneNumberController ;
  String? dropdownValue ;
  final ServiceProviderController _controller = ServiceProviderController() ;


  @override
  void initState() {
    nameController       = TextEditingController(text: ServiceProviderController.spUser!.name) ;
    districtController   = TextEditingController(text: ServiceProviderController.spUser!.workshop.district)  ;
    streetNameController = TextEditingController(text: ServiceProviderController.spUser!.workshop.streetName) ;
    cityController       = TextEditingController(text: ServiceProviderController.spUser!.workshop.city) ;
    emailController      = TextEditingController(text: ServiceProviderController.spUser!.email) ;
    phoneNumberController= TextEditingController(text: ServiceProviderController.spUser!.phoneNumber) ;
    dropdownValue =  ServiceProviderController.spUser!.workshop.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0.0,
        title: const Text('Update Profile'),
         actions: [
           Image.asset(AppAssets.appLogo)
         ],
      ),
      body: StreamBuilder<FlowState>(
        stream:_controller.updateProfileStateCon.stream,
        builder:(context, snapshot) =>snapshot.data?.getScreenWidget(context, _buildUpdateProfileForm(),(){})?? _buildUpdateProfileForm(),
      )
    );
  }

  Widget _buildUpdateProfileForm() {
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
              enabled: false,
            ),
            CustomTextField(
              labelText: 'District',
              hintText: 'Enter your district',
              controller: districtController,
              enabled: false,
            ),
            CustomTextField(
              labelText: 'Street Name',
              hintText: 'Enter your street name',
              controller: streetNameController,
              enabled: false,
            ),
            CustomTextField(
              labelText: 'City',
              hintText: 'Enter your city',
              controller: cityController,
              enabled: false,
            ),
            CustomTextField(
              labelText: 'Email',
              hintText: 'Enter your email',
              controller: emailController,
              enabled: false,
            ),
            CustomTextField(
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              controller: phoneNumberController,
              enabled: false,
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                value: dropdownValue,
                decoration:InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  floatingLabelStyle: TextStyle(color: AppColors.primary2Color),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: AppColors.primary2Color, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'status',
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  hintText: 'Choose the status',
                ),
                items: <String>['Available', 'Not Available']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16.0),

            CustomBTN(
                text: 'Update Profile',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateProfile();
                  }
                }),
          ],
        ),
      ),
    );
  }

  void _updateProfile() {
     var user = ServiceProvider(
         id: ServiceProviderController.spUser!.id,
         name: nameController.text,
         phoneNumber: phoneNumberController.text,
         email: emailController.text,
         workshop: Workshop(district: districtController.text,
             streetName: streetNameController.text,
             status:dropdownValue!,
             city: cityController.text)) ;
     _controller.updateProfileData(user);
  }

  @override
  void dispose() {
    nameController.dispose();
    districtController.dispose();
    streetNameController.dispose();
    cityController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }
}
