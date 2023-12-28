import 'dart:async';
import 'package:mechanic/models/driver_model.dart';
import 'package:mechanic/utils/constants.dart';
import '../../models/order.dart';
import '../../models/user.dart';
import '../../utils/api.dart';
import '../../utils/state_renderer/state_renderer.dart';
import '../../utils/state_renderer/state_renderer_impl.dart';

class DriverController {
  RemoteDataSource remoteDataSource = RemoteDataSource();
  StreamController<FlowState> loginStateCon = StreamController<FlowState>() ;
  StreamController<FlowState> ordersStateCon = StreamController<FlowState>() ;
  StreamController<bool> checkLogin = StreamController<bool>() ;
  static Driver? driver ;
  void login(email,password){
    loginStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    remoteDataSource.signInDriver(email, password).then((value){
      if(value!=null){
        driver= value;
        if(!driver!.block) {
          checkLogin.add(true);
        }else{
          loginStateCon.add(ErrorState(StateRendererType.popupErrorState,'this account is blocked'));

        }
      }else {
        loginStateCon.add(ErrorState(StateRendererType.popupErrorState,'This account is not Driver'));
      }
    }).catchError((error){
      loginStateCon.add(ErrorState(StateRendererType.popupErrorState,error.toString().replaceRange(0, error.toString().indexOf(']')+1, '')));
    });

  }

  static List<Order> orders = [] ;
  static List<Order> newOrders = [] ;
   Future getAllOrders()async{
    ordersStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    orders = [] ;
    newOrders = [] ;
   await remoteDataSource.allOrdersForDriver().then((value) async{
     orders.addAll(value);
     for(var ord in orders){
       if(ord.status !=orderStatus[2]){
         print(ord.user);
         newOrders.add(ord);
       }
     }
      ordersStateCon.add(ContentState());
   }) .catchError((error){
     ordersStateCon.add(ErrorState(StateRendererType.fullScreenErrorState, error.toString()));
   });
  }

  Future<User> getUsers(userID)async{
    return await remoteDataSource.getUser(userID);
  }


  Future updateOrder(Order order)async{
     print(order.paymentStatus);
    await remoteDataSource.updateOrder(order).then((value){}).catchError((error){
      print(error.toString());
    });
  }

  logout(){
    remoteDataSource.signOut();
    checkLogin.add(false) ;
  }
}