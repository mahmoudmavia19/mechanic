import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ServiceCard extends StatelessWidget {
    ServiceCard({super.key, required this.title , required this.iconData, this.onTap});
    String title ;
    IconData iconData ;
    GestureTapCallback? onTap  ;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap:onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: AppColors.primary2Color,
              boxShadow: [
                BoxShadow(color: AppColors.primaryColor,blurRadius: 5.0,spreadRadius:1),
              ],
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: AppColors.primaryColor)
          ),
          width: 100.0,
          child:   Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData,color: Colors.white,) ,
              const SizedBox(height: 5.0,),
              Text(title,textAlign:TextAlign.center ,style: const TextStyle(color:  Colors.white,),)
            ],
          ),
        ),
      ),
    )  ;
  }
}
