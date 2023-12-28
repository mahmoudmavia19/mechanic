import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:mechanic/models/order.dart';
import 'package:mechanic/utils/app_strings.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import 'package:mechanic/widgets/custombtn.dart';

import '../providers/controller.dart';

class PaymentScreen extends StatelessWidget {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>() ;
  Order order ;
  final Controller _controller = Controller();
  PaymentScreen({super.key,required this.order,});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Screen'),
      ),
      body: StreamBuilder<FlowState>(
        stream: _controller.makeOrderState.stream,
        builder: (context, snapshot) => snapshot.data?.getScreenWidget(context, _body(), (){})??_body(),
      )
    );
  }

  _body()=>SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CreditCardForm(
          formKey:_formKey , // Required
          onCreditCardModelChange: (CreditCardModel data) {}, // Required
          themeColor: Colors.red,
          obscureCvv: true,
          obscureNumber: false,
          isHolderNameVisible: true,
          isCardNumberVisible: true,
          isExpiryDateVisible: true,
          enableCvv: true,
          cardNumberValidator: (String? cardNumber){
            if(cardNumber!.isEmpty){
              return AppString.cantEmpty ;
            }else {
              return null;
            }
          },
          expiryDateValidator: (String? expiryDate){
            if(expiryDate!.isEmpty){
              return AppString.cantEmpty ;
            }else {
              return null;
            }
          },
          cvvValidator: (String? cvv){
            if(cvv!.isEmpty){
              return AppString.cantEmpty ;
            }else {
              return null;
            }
          },
          cardHolderValidator: (String? cardHolderName){
            if(cardHolderName!.isEmpty){
              return AppString.cantEmpty ;
            }else {
              return null;
            }
          },
          onFormComplete: () {

          },
          autovalidateMode:AutovalidateMode.always,
          cardNumberDecoration:   InputDecoration(
            border: const OutlineInputBorder(),
            focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary2Color)),
            labelText: 'Card Number',
            labelStyle: TextStyle(color: AppColors.primary2Color),
            hintText: 'XXXX XXXX XXXX XXXX',
          ),
          expiryDateDecoration:   InputDecoration(
              border: const OutlineInputBorder(),
              focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary2Color)),
              labelText: 'Expired Date',
              hintText: 'XX/XX',
              labelStyle: TextStyle(color: AppColors.primary2Color)
          ),
          cvvCodeDecoration:   InputDecoration(
              border: const OutlineInputBorder(),
              focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary2Color)),
              labelText: 'CVV',
              hintText: 'XXX',
              labelStyle: TextStyle(color: AppColors.primary2Color)

          ),
          cardHolderDecoration:   InputDecoration(
              border: const OutlineInputBorder(),
              focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary2Color)),
              labelText: 'Name On Card',
              labelStyle: TextStyle(color: AppColors.primary2Color)
          ), cardNumber: '', expiryDate: '', cardHolderName: '', cvvCode: '',
        ),
        const SizedBox(height: 20,),
        CustomBTN(
          onPressed: () {
            if(_formKey.currentState!.validate()){
              order.paymentStatus = paymentStatus[1];
              order.paymentType = paymentType[1];
              _controller.makeOrder(order);
            }
          },
          text: 'Proceed to Payment',
        ),
      ],
    ),
  );
}

