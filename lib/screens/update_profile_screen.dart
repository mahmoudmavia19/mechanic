import 'package:flutter/material.dart';
import 'package:mechanic/models/user.dart';
import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import 'package:mechanic/widgets/custombtn.dart';

import '../utils/app_strings.dart';
import '../widgets/custom_text_field.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
    late final TextEditingController nameController ;
   late final TextEditingController addressController  ;
   late final TextEditingController emailController ;
   late final TextEditingController phoneNumberController ;
/*
   late final TextEditingController cardInfoController ;
*/
   late final TextEditingController passwordController  ;
   late final TextEditingController passwordCController  ;
  final   Controller _controller = Controller() ;

  @override
  void initState(){
    nameController = TextEditingController(text:Controller.user?.name);
    addressController = TextEditingController(text:Controller.user?.address);
    emailController = TextEditingController(text: Controller.user?.email);
    phoneNumberController = TextEditingController(text:Controller.user?.phoneNumber.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0.0,
        title: const Text(AppString.updateProfileTitle),
      ),
      body: StreamBuilder<FlowState>(
        stream: _controller.updateProfileStateCon.stream,
        builder: (context, snapshot) => snapshot.data?.getScreenWidget(context, _body(), (){})?? _body(),)
    );
  }

  _body()=>SingleChildScrollView(
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
                  backgroundImage: AssetImage(AppAssets.appLogo),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      labelText: AppString.name,
                      hintText:AppString.nameHint,
                      controller: nameController,
                      onSaved: (value) {
                        // Handle the saved value
                      },
                    ),
                    CustomTextField(
                      labelText: AppString.addressLabel,
                      hintText: AppString.addressHint,
                      controller: addressController,

                      onSaved: (value) {
                        // Handle the saved value
                      },
                    ),
                    CustomTextField(
                      enabled: false,
                      labelText: AppString.email,
                      hintText:AppString.emailHint,
                      controller: emailController,

                      onSaved: (value) {
                        // Handle the saved value
                      },
                    ),
                    CustomTextField(
                      labelText: AppString.phoneNumberLabel,
                      hintText: AppString.phoneNumberHint,
                      controller: phoneNumberController,

                      onSaved: (value) {
                        // Handle the saved value
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              CustomBTN(text: AppString.updateButton, onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final user = User(
                      name: nameController.text.trim(),
                      address: addressController.text.trim(),
                      email: emailController.text.trim(),
                      phoneNumber: int.parse(phoneNumberController.text.trim()),
                      cardInfo: '',
                      uid: Controller.user!.uid
                  );
                  _controller.updateProfileData(user);
                }
              }),
            ],
          ),
        ),
      ],
    ),
  );

  @override
  void dispose() {
    // Dispose of the controllers when the screen is no longer in use
    nameController.dispose();
    addressController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    // cardInfoController.dispose();
    super.dispose();
  }
}
