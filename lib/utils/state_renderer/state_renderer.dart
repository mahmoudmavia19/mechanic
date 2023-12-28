
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mechanic/utils/app_strings.dart';
import 'package:mechanic/widgets/custombtn.dart';

import '../constants.dart';

enum StateRendererType {
  // POPUP STATES (DIALOG)
  popupLoadingState,
  popupErrorState,
  popupSuccessState,

  // FULL SCREEN STATED (FULL SCREEN)
  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,
  fullScreenSuccessState,
  // general
  contentState
}

class StateRenderer extends StatelessWidget {
  StateRendererType stateRendererType;
  String message;
  String title;
  Function retryActionFunction;

  StateRenderer(
      {required this.stateRendererType,
        this.message = AppString.loading,
        this.title = "",
        required this.retryActionFunction});

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context) {
    switch (stateRendererType) {
      case StateRendererType.popupLoadingState:
        return _getPopUpDialog(
            context, [_getAnimatedImage(AppAssets.loading)]);
      case StateRendererType.popupErrorState:
        return _getPopUpDialog(context, [
          _getAnimatedImage(AppAssets.error),
          _getMessage(message),
          _getRetryButton(AppString.ok, context)
        ]);
      case StateRendererType.fullScreenLoadingState:
        return _getItemsColumn(
            [_getAnimatedImage(AppAssets.loading), _getMessage(message)]);
      case StateRendererType.fullScreenErrorState:
        return _getItemsColumn([
          _getAnimatedImage(AppAssets.error),
          _getMessage(message),
          _getRetryButton(AppString.retryAgain, context)
        ]);
      case StateRendererType.fullScreenEmptyState:
        return _getItemsColumn(
            [_getAnimatedImage(AppAssets.error), _getMessage(message)]);
      case StateRendererType.popupSuccessState:
        return _getPopUpDialog(context, [
          _getAnimatedImage(AppAssets.success),
          _getMessage(message),
          _getRetryButton(AppString.ok, context)
        ]);
      case StateRendererType.fullScreenSuccessState:
        return _getItemsColumn(
            [_getAnimatedImage(AppAssets.success), _getMessage(message)]);
      case StateRendererType.contentState:
        return Container();
      default:
        return Container();
    }
  }

  Widget _getPopUpDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)),
      elevation: 1.5,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(top:18),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [BoxShadow(color: Colors.black26)]),
        child: _getDialogContent(context, children),
      ),
    );
  }

  Widget _getDialogContent(BuildContext context, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getItemsColumn(List<Widget> children) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget _getAnimatedImage(String animationName) {
    return SizedBox(
        height:100,
        width:100,
        child: Lottie.asset(animationName));
  }

  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize:18),
        ),
      ),
    );
  }

  Widget _getRetryButton(String buttonTitle, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: SizedBox(
            width: double.infinity,
            child: CustomBTN(text: buttonTitle,
                onPressed: () {
                  if (stateRendererType ==
                      StateRendererType.fullScreenErrorState) {
                    // call retry function
                    retryActionFunction.call();
                  } else {
                    // popup error state
                    Navigator.of(context).pop();
                  }
                },)),
      ),
    );
  }
}
