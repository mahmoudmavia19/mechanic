import 'package:flutter/material.dart';
import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/screens/main_screen.dart';
import 'package:mechanic/service_provider/controller/service_provider_controller.dart';
import 'package:mechanic/service_provider/screens/main_screen.dart';
import 'package:mechanic/utils/app_strings.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import 'package:mechanic/widgets/custombtn.dart';

import '../../widgets/custom_text_field.dart';


class  ServiceProviderLoginScreen extends StatefulWidget {
  const ServiceProviderLoginScreen({super.key});

  @override
  _ServiceProviderLoginScreenState createState() => _ServiceProviderLoginScreenState();
}

class _ServiceProviderLoginScreenState extends State<ServiceProviderLoginScreen> {

  final ServiceProviderController _controller = ServiceProviderController();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    _controller.checkLogin.stream.listen((event) {
      if(event){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ServiceProviderMainScreen(),), (route) => false);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0.0,
        title: const Text(AppString.loginButtonText),
      ),
      body: StreamBuilder<FlowState>(
      stream: _controller.loginStateCon.stream,
        builder:(context, snapshot) => snapshot.data?.getScreenWidget(context, _body(), (){})??_body(),
      )
    );
  }
  _body()=>SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 100.0,),
          Image.asset(AppAssets.appLogo,
            width: double.infinity,height: 200.0,),
          CustomTextField(
            labelText: AppString.email,
            hintText: AppString.emailHint,
            controller: emailController,
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
          ),

          const SizedBox(height: 16.0),
          CustomBTN(text: AppString.loginButton, onPressed: (){
            if (_formKey.currentState!.validate()) {
              _controller.login(emailController.text, passwordController.text);
             }

          })
        ],
      ),
    ),
  );

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
     super.dispose();
  }
}
