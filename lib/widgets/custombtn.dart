import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomBTN extends StatelessWidget {
    CustomBTN({super.key,required this.text,required this.onPressed});
  String text ;
  VoidCallback? onPressed ;
  @override
  Widget build(BuildContext context) {
    return  Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0) ,
      ),
      width: double.infinity,
      height: 50.0,
      child: MaterialButton(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        onPressed:onPressed,
        color: AppColors.primary2Color,
        child:Text(text,style:TextStyle(color: AppColors.fontColor,fontSize: 18.0,fontWeight: FontWeight.bold)),),
    );
  }
}
