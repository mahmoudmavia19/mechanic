import 'package:flutter/material.dart';
import 'package:mechanic/models/user.dart';
import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/screens/login_screen.dart';
import 'package:mechanic/screens/main_screen.dart';
import 'package:mechanic/utils/api.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
 import 'package:mechanic/widgets/custombtn.dart';
import '../utils/app_strings.dart';
import '../widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final Controller _controller = Controller() ;
@override
  void initState() {
  _controller.checkLogin.stream.listen((event) {
    if(event){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen(),), (route) => false);
    }
  });
    super.initState();
  }
  final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
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
        title: const Text(AppString.registrationTitle),
      ),
      body : StreamBuilder<FlowState>(
        stream: _controller.registerStateCon.stream,
        builder: (context, snapshot) => snapshot.data?.getScreenWidget(context,_body(), (){
          _register();
        })??_body(),
      )
    );
  }

  _body() =>SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.all(16.0),
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            AppAssets.appLogo,
            width: double.infinity,
            height: 200.0,
          ),
          CustomTextField(
            labelText: AppString.name,
            hintText: AppString.nameHint,
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
            labelText: AppString.email,
            hintText: AppString.emailHint,
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
          CustomTextField(
            labelText: AppString.passwordLabel,
            hintText: AppString.passwordHint,
            controller: passwordController,
            onSaved: (value) {
              // Handle the saved value
            },
          ), CustomTextField(
            labelText: AppString.passwordCLabel,
            hintText: AppString.passwordCHint,
            controller: passwordCController,
            onChange: (value) {
            },
            onSaved: (value) {
              // Handle the saved value
            },
          ),
          const SizedBox(height: 16.0),
          CustomBTN(text: AppString.registrationButton, onPressed: () {
            if (_formKey.currentState!.validate() && passwordCController.text == passwordController.text) {
              _register();
            }
          }),
        ],
      ),
    ),
  );

  void _register() {
    final user = User(
      name: nameController.text.trim(),
      address: addressController.text.trim(),
      email: emailController.text.trim(),
      phoneNumber: int.parse(phoneNumberController.text.trim()),
      cardInfo: '',
      uid: ''
    );
    _controller.createNewAccount(user, passwordController.text);
  }
  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }
}