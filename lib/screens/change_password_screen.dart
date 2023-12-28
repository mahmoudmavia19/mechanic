import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import 'package:mechanic/widgets/custom_text_field.dart';
import 'package:mechanic/widgets/custombtn.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();
  final Controller _controller  = Controller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body:StreamBuilder<FlowState>(
        stream: _controller.changePasswordState.stream,
        builder: (context, snapshot) => snapshot.data?.getScreenWidget(context, _body(), (){})??_body(),
      )
    );
  }

  _body()=> Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CustomTextField(labelText: 'Current Password', hintText: 'Enter Current Password', controller: _currentPasswordController),
        CustomTextField(labelText: 'New Password', hintText: 'Enter New Password', controller: _newPasswordController),
        CustomTextField(labelText: 'Confirm New Password', hintText: 'Enter Confirm New Password', controller: _confirmNewPasswordController),
        const SizedBox(height: 20.0),
        CustomBTN(
          text: 'Change Password',
          onPressed: () {
            _controller.changePassword(_currentPasswordController.text, _newPasswordController.text, _confirmNewPasswordController.text);
          },
        ),
      ],
    ),
  );

}

