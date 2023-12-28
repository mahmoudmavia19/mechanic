import 'package:flutter/material.dart';

import 'constants.dart';

enum UIState { initial, loading, success, error }

class UIStateManager extends StatelessWidget {
  final UIState state;
  final Widget Function() successBuilder;
  final Widget Function()? loadingBuilder;
  final Widget Function()? errorBuilder;

  UIStateManager({
    required this.state,
    required this.successBuilder,
    this.loadingBuilder,
    this.errorBuilder,
   });

   @override
  Widget build(BuildContext context) {
    if (state == UIState.success) {
      return successBuilder();
    } else if (state == UIState.loading) {
      return loadingBuilder !=null ? loadingBuilder!() : Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
    } else if (state == UIState.error) {
      return errorBuilder != null ? errorBuilder!():Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.error, color: Colors.red, size: 100.0),
            const SizedBox(height: 20.0,),
            const Text('حدث خطأ!',style: TextStyle(fontSize: 20.0),),
            IconButton(onPressed: () {}, icon: const Icon(Icons.downloading_rounded),iconSize: 50,)
          ],
        ),
      );
    } else {
      return Container(); // Return an empty container for the initial state
    }
  }

  void showSuccessSnackbar(String message,context) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
