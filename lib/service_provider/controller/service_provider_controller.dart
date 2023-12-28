import 'dart:async';
import 'package:mechanic/models/car_services.dart';
import 'package:mechanic/models/order.dart';
import 'package:mechanic/models/user.dart';
import '../../models/car_model.dart';
import '../../models/driver_model.dart';
import '../../models/service_provider.dart';
import '../../utils/api.dart';
import '../../utils/state_renderer/state_renderer.dart';
import '../../utils/state_renderer/state_renderer_impl.dart';

class ServiceProviderController {
  RemoteDataSource remoteDataSource = RemoteDataSource();
  StreamController<FlowState> loginStateCon = StreamController<FlowState>() ;
  StreamController<bool> checkLogin = StreamController<bool>() ;
  StreamController<FlowState> updateProfileStateCon = StreamController<FlowState>() ;
  StreamController<FlowState> serviceStateCon = StreamController<FlowState>() ;
  StreamController<FlowState> newordersStateCon = StreamController<FlowState>() ;
  StreamController<FlowState> allordersStateCon = StreamController<FlowState>() ;
  StreamController<FlowState> driverStateCon = StreamController<FlowState>() ;
  StreamController<FlowState> carModelStateCon = StreamController<FlowState>() ;
  static ServiceProvider? spUser ;
  static List<CarService> services = [];
  void login(email,password){
    loginStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    remoteDataSource.signInServiceProvider(email, password).then((value){
      if(value!=null){
        spUser = value ;
        if(!spUser!.blocked) {
          checkLogin.add(true);
        }else{
          loginStateCon.add(ErrorState(StateRendererType.popupErrorState,'this account is blocked'));
        }
      }else {
        loginStateCon.add(ErrorState(StateRendererType.popupErrorState,'This use not a Service Provider !'));      }
    }).catchError((error){
      loginStateCon.add(ErrorState(StateRendererType.popupErrorState,error.toString().replaceRange(0, error.toString().indexOf(']')+1, '')));
    });

  }
  logout(){
    remoteDataSource.signOut();
    checkLogin.add(false) ;
  }

  Future updateProfileData(ServiceProvider user)async{
    updateProfileStateCon.add(LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    await  remoteDataSource.updateProfileDataServiceProvider(user).then((value) {
      spUser = value;
      updateProfileStateCon.add(SuccessState(StateRendererType.popupSuccessState, 'successful updated !'));
    }).catchError((error){
      updateProfileStateCon.add(ErrorState(StateRendererType.popupErrorState, error.toString()));
    });
  }

  Future addCarService(CarService service)async{
    serviceStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    await remoteDataSource.addCarService(spUser!.id,service).then((value){
      services.add(service);
      serviceStateCon.add(ContentState());
    }).catchError((error){
      print(error.toString());
      serviceStateCon.add(ErrorState(StateRendererType.fullScreenErrorState,'Error Happen!!'));

    });
  }
  Future updateCarService(CarService service,)async{
   // serviceStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    await remoteDataSource.updateCarService(spUser!.id,service).then((value){
      serviceStateCon.add(ContentState());
    }).catchError((error){
      print(error.toString());
      serviceStateCon.add(ErrorState(StateRendererType.fullScreenErrorState,'Error Happen!!'));
    });
  }
  Future getCarServices()async{
    serviceStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    services = [] ;
    await remoteDataSource.getCarServices(spUser!.id).then((value){
      services.addAll(value);
      serviceStateCon.add(ContentState());
    }).catchError((error){
      serviceStateCon.add(ErrorState(StateRendererType.fullScreenLoadingState,'Error Happen!!'));

    });
  }

  static List<Order> newOrders = [];
  static Map<String,User> newOrdersUsers = {};
  Future getNewOrders() async{
    newordersStateCon.add(LoadingState(stateRendererType:StateRendererType.fullScreenLoadingState));
    newOrders = [];
    remoteDataSource.newOrders().then((value)async{
      newOrders.addAll(value);
      for(var order in newOrders){
       var user =  await remoteDataSource.getUser(order.user);
       newOrdersUsers[order.user]  = user;
      }
      if(newOrders.isNotEmpty) {
        newordersStateCon.add(ContentState()) ;
      }else{
        newordersStateCon.add(ErrorState(StateRendererType.fullScreenErrorState, 'Not found data')) ;
      }
    }).catchError((error){
      newordersStateCon.add(ErrorState(StateRendererType.fullScreenErrorState, error.toString()));
    });
  }

  static List<Order> allOrders = [];
  static Map<String,User> allOrdersUsers = {};

  Future getAllOrders() async{
    allordersStateCon.add(LoadingState(stateRendererType:StateRendererType.fullScreenLoadingState));
    allOrders = [];
    remoteDataSource.allOrdersForProvider().then((value)async{
      allOrders.addAll(value);
      for(var order in allOrders){
        var user =  await remoteDataSource.getUser(order.user);
        allOrdersUsers[order.user]  = user;
      }
      if(allOrders.isNotEmpty) {
        allordersStateCon.add(ContentState()) ;
      }else {
        allordersStateCon.add(ErrorState(StateRendererType.fullScreenErrorState, 'Not found data')) ;
      }
    }).catchError((error){
      allordersStateCon.add(ErrorState(StateRendererType.fullScreenErrorState, error.toString()));
    });
  }

  static List<Driver> drivers = [];
  Future addDriver(Driver driver) async{
   // driverStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    driver.spId= spUser!.id;
    remoteDataSource.addDriver(driver).then((value) {
       drivers.add(driver);
      driverStateCon.add(ContentState()) ;
    }).catchError((error){
      driverStateCon.add(ErrorState(StateRendererType.popupErrorState, error.toString()));
    });
  }
  Future getDrivers() async{
    driverStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    drivers = [] ;
    remoteDataSource.getDriver().then((value) {
      print('==================');
      print(value.length);
      drivers.addAll(value);
      if(drivers.isNotEmpty) {
        driverStateCon.add(ContentState()) ;
      }else{
        driverStateCon.add(ErrorState(StateRendererType.fullScreenErrorState, 'Not found data')) ;
      }
    }).catchError((error){
      driverStateCon.add(ErrorState(StateRendererType.popupErrorState, error.toString()));
    });
  }
  Future updateDriver(Driver driver) async{
    //driverStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    remoteDataSource.updateDriver(driver).then((value) {
       driverStateCon.add(ContentState()) ;
    }).catchError((error){
      driverStateCon.add(ErrorState(StateRendererType.popupErrorState, error.toString()));
    });
  }

  Future updateOrder(Order order)async{
       await remoteDataSource.updateOrder(order).then((value){}).catchError((error){
    });
  }
  
  Future addCarModel(CarModel carModel)async{
    remoteDataSource.addCarModelServiceProvider(carModel).then((value){
      carModelStateCon.add(ContentState()) ;
    }).catchError((error){
      carModelStateCon.add(ErrorState(StateRendererType.popupErrorState, error.toString()));
    });
  }
  Future updateCarModel(CarModel carModel)async{
    remoteDataSource.updateCarModelServiceProvider(carModel).then((value){
      carModelStateCon.add(ContentState()) ;
    }).catchError((error){
      carModelStateCon.add(ErrorState(StateRendererType.popupErrorState, error.toString()));
    });
  }

  static List<CarModel> carModel = [] ;
  Future getCarsModel()async{
    carModelStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState)) ;
    carModel = [] ;
    remoteDataSource.getCarModelServiceProvider().then((value){
      var set = <CarModel>{}..addAll(value);
      carModel = set.toList();
      if(carModel.isNotEmpty) {
        carModelStateCon.add(ContentState()) ;
      }else{
        carModelStateCon.add(ErrorState(StateRendererType.fullScreenErrorState, 'Not found data'));
      }
    }).catchError((error){
      carModelStateCon.add(ErrorState(StateRendererType.popupErrorState, error.toString())); 
    });
  }
}