import 'package:flutter/material.dart';
import 'package:mechanic/models/driver_model.dart';
import 'package:mechanic/models/user.dart';
 import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';

import '../utils/app_strings.dart';

class DriverProfileScreen extends StatefulWidget {
  Driver user ;

  DriverProfileScreen({super.key,required this.user});

  @override
  _DriverProfileScreenState createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _body() ;
  }

  Widget _body() => SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min,
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
              _buildProfileItem(
                  label: AppString.name,
                  value: widget.user.name ?? ''),
             /* _buildProfileItem(
                  label: AppString.addressLabel,
                  value: widget.user.address ?? ''),*/
              _buildProfileItem(
                  label: AppString.email, value: widget.user.email ?? ''),
              _buildProfileItem(
                  label: AppString.phoneNumberLabel,
                  value: widget.user.phoneNumber.toString() ?? ''),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildProfileItem({required String label, required String value}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),side: BorderSide(color:AppColors.primaryColor)),
       child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(width: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
