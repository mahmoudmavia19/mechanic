import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mechanic/models/car_services.dart';
import 'package:mechanic/models/order.dart';
import 'package:mechanic/models/service_provider.dart';
import 'package:mechanic/models/user.dart';
import 'package:mechanic/models/vehicle.dart';
import 'package:mechanic/utils/api.dart';
import 'package:mechanic/utils/constants.dart';
import 'package:mechanic/utils/state_renderer/state_renderer.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import '../models/car_make.dart';
import '../models/car_model.dart';

class Controller {
  RemoteDataSource remoteDataSource = RemoteDataSource();
  StreamController<FlowState> registerStateCon = StreamController<FlowState>() ;
  StreamController<FlowState> loginStateCon = StreamController<FlowState>() ;
  StreamController<FlowState> profileStateCon = StreamController<FlowState>() ;
  StreamController<FlowState> updateProfileStateCon = StreamController<FlowState>() ;
  StreamController<bool> checkLogin = StreamController<bool>() ;
  StreamController<FlowState> addCarStateCo = StreamController<FlowState>() ;
  StreamController<FlowState> getCarStateCo = StreamController<FlowState>() ;
  StreamController<FlowState> getOrderHistoryStateCo = StreamController<FlowState>() ;
  StreamController<FlowState> sendReportStateCo = StreamController<FlowState>() ;
  StreamController<FlowState> serviceProviderStateCon = StreamController<FlowState>() ;
  StreamController<List<ServiceProvider>> serviceProviderListCon = StreamController<List<ServiceProvider>>() ;
  StreamController<FlowState> makeOrderState = StreamController<FlowState>() ;
  StreamController<FlowState> changePasswordState = StreamController<FlowState>() ;
  StreamController<bool> modelsLoadingState = StreamController<bool>() ;
  StreamController<FlowState> serviceStateCon = StreamController<FlowState>() ;
  StreamController<FlowState> adsStateCon = StreamController<FlowState>() ;


  static User? user ;
  static List<Car>? cars;
  static List<Car>? myCarsMake;
  List<Order>? orders;
  List<CarMake> carMakes = [] ;
  List<CarModel> carModels = [] ;
  void createNewAccount(User user,password){
    registerStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    remoteDataSource.createUserWithEmailAndPassword(user, password).then((value){
      if(value!=null){
        checkLogin.add(true);
       Controller.user= value ;
      }else {
        registerStateCon.add(ErrorState(StateRendererType.popupErrorState,'Error Happen !!'));
      }
    }).catchError((error){
      registerStateCon.add(ErrorState(StateRendererType.popupErrorState,error.toString().replaceRange(0, error.toString().indexOf(']')+1, '')));

    });
  }

  void login(email,password){
    loginStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    remoteDataSource.signInWithEmailAndPassword(email, password).then((value){
      if(value!=null){
        user = value ;
         checkLogin.add(true);
      }else {
        loginStateCon.add(ErrorState(StateRendererType.popupErrorState,'This account is not user may be driver or service provider'));
      }
    }).catchError((error){
      loginStateCon.add(ErrorState(StateRendererType.popupErrorState,error.toString().replaceRange(0, error.toString().indexOf(']')+1, '')));
    });

  }
  logout(){
    user = null ;
    cars = [] ;
    myCarsMake = [] ;
    remoteDataSource.signOut();
    checkLogin.add(false) ;
  }
  checkIsLogin(){
    checkLogin.add(false) ;
    remoteDataSource.checkLogin('users').then((value){
      checkLogin.add(value) ;
    });
  }
  Future getProfileData()async{
    profileStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    await  remoteDataSource.getProfileData().then((value) {
      value.listen((event)async {
          user = User.fromJson(event.data()!);
           await getOrderHistoryInfo();
          profileStateCon.add(ContentState());
      });
      }).catchError((error){
      profileStateCon.add(ErrorState(StateRendererType.fullScreenErrorState, 'You don\'t have any order')) ;});
  }

  Future updateProfileData(User user)async{
    updateProfileStateCon.add(LoadingState(stateRendererType: StateRendererType.popupLoadingState));
      await  remoteDataSource.updateProfileData(user).then((value) {
        Controller.user = value;
        updateProfileStateCon.add(SuccessState(StateRendererType.popupSuccessState, 'successful updated !'));
      }).catchError((error){
        updateProfileStateCon.add(ErrorState(StateRendererType.popupErrorState, error.toString()));
      });
  }

  Future getCarMakes()async {
    addCarStateCo.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState)) ;

     await remoteDataSource.getCarMakes().then((value){
      carMakes = value??[] ;
      getCarModels(carMakes.first.makeId!) ;
      addCarStateCo.add(ContentState());
    }).catchError((error){
      print(error.toString());
      addCarStateCo.add(ErrorState(StateRendererType.fullScreenErrorState, error.toString()));
     });

  }
  Future getCarModels(String make)async{
    modelsLoadingState.add(true);
   await remoteDataSource.getCarModels(make).then((value) {

     carModels = Set<CarModel>.from(value!).toList() ;
     modelsLoadingState.add(false);
   }).catchError((error){
     addCarStateCo.add(ErrorState(StateRendererType.fullScreenErrorState, error.toString()));
   });

  }

  Future addCarInfo(Car car) async{
    addCarStateCo.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState)) ;
    await remoteDataSource.addCarInfo(car).then((value){
      addCarStateCo.add(SuccessState(StateRendererType.fullScreenSuccessState, 'success add')) ;
    }).catchError((error){
      addCarStateCo.add(ErrorState(StateRendererType.popupErrorState, error.toString()));
    });
  }

  Future getCarInfo()async{
    getCarStateCo.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState)) ;
       await remoteDataSource.getCarInfo().then((value){
         print(value.length);
         cars = value;
         getCarStateCo.add(ContentState());
         if(cars!.isEmpty)
           {
             getCarStateCo.add(ErrorState(StateRendererType.fullScreenErrorState, 'Please add your Car Information')) ;
           }
       }).catchError((error){
         print(error.toString());
         getCarStateCo.add(ErrorState(StateRendererType.fullScreenErrorState, 'Please add your Car Information')) ;
       });
  }

  Future getOrderHistoryInfo()async{
    getOrderHistoryStateCo.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState)) ;
    await remoteDataSource.getOrderHistoryModels().then((value){
       orders = value;
      getOrderHistoryStateCo.add(ContentState());
      if(orders!.isEmpty)
      {
        getOrderHistoryStateCo.add(ErrorState(StateRendererType.fullScreenErrorState, 'You don\'t have any orders')) ;
      }
      if(user!.currentOrder==null){
         for(var item in orders!){
           if(item.status==orderStatus[0]){
             item.status= 'canceled';
             updateOrder(item);
           }
         }
       }

    }).catchError((error){
      print(error.toString());
      getOrderHistoryStateCo.add(ErrorState(StateRendererType.fullScreenErrorState, 'You don\'t have any orders')) ;    });
  }
  Future removeOrderFromHistory(String orderId)async{
    getOrderHistoryStateCo.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState)) ;
    await remoteDataSource.removeOrderFromHistory(orderId).then((value){
      getOrderHistoryInfo();
    }).catchError((error){
      print(error.toString());
      getOrderHistoryStateCo.add(ErrorState(StateRendererType.fullScreenErrorState, 'Error Happen !!')) ;    });
  }
  Future deleteCarInfo(String carSerial)async{
    getCarStateCo.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState)) ;

    await remoteDataSource.deleteCarInfo(carSerial).then((value){
      getCarStateCo.add(SuccessState(StateRendererType.popupSuccessState, 'Deleted Successfully!'));
      getCarInfo();
    }).catchError((error){
      getCarStateCo.add(ErrorState(StateRendererType.fullScreenErrorState, 'Please add Car Information')) ;
    });
  }
  Future sendReportToSupervisor(text)async{
    sendReportStateCo.add(LoadingState(stateRendererType: StateRendererType.fullScreenSuccessState));
   await remoteDataSource.sendReportToSupervisor(text).then((value){
      sendReportStateCo.add(SuccessState(StateRendererType.fullScreenSuccessState, 'Successful send !')) ;
    }).catchError((error){
      sendReportStateCo.add(ErrorState(StateRendererType.popupErrorState, error.toString()));
   });
  }
  List<ServiceProvider> providers = [] ;
   Future getServiceProviders()async{
    serviceProviderStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    providers = [];
    await remoteDataSource.getServiceProviders().then((value) {
     // serviceProviderListCon.add(value);
      providers.addAll(value.where((element) => !element.blocked && element.workshop.status == 'Available'));
      if(providers.isNotEmpty) {
        serviceProviderStateCon.add(ContentState());
      }else{
        serviceProviderStateCon.add(ErrorState(StateRendererType.fullScreenErrorState, 'Not found shops for your car make'));
      }
    }).catchError((error){
      serviceProviderStateCon.add(ErrorState(StateRendererType.fullScreenErrorState, error.toString())) ;
    });
  }

  Future filterProviders(make) async{
     print('my car make $make');


     if(make=='all'){
       serviceProviderListCon.add(providers);
      }else {
     print(make);
     List<ServiceProvider> temp = [];
        for(var provider in providerModels.keys){
         print(providerModels[provider]!.contains(make));
          if(providerModels[provider]!.contains(make)){
            temp.addAll(providers.where((element) => element.id==provider));
          }
       }
       serviceProviderListCon.add(temp);
        if(temp.isEmpty){
          serviceProviderStateCon.add(ErrorState(StateRendererType.fullScreenErrorState, 'Not found shops for your car make'));
        }
      }
  }


  Map<String,List<String?>?> providerModels = {};
  Future getCarModelProvider()async{
    for(var provider in providers){
      print(provider.name);
     var model =   await remoteDataSource.getCarModelProvider(provider.id);
      providerModels[provider.id] = model.where((element) => !element.hidden).map((e) => e.modelMakeId).toList();
    }
   }

   Future<Order?> getOrder(String uid)async{
    Order? order =  await remoteDataSource.getOrder(user!.uid,uid);
    return order;
   }
   List<Order?> currentOrders = [] ;
   Future getCurrentOrders()async{
    for(var orderId in user!.currentOrder!){
      Order? order =await getOrder(orderId);
    }
   }
  Future makeOrder(Order order)async{
    makeOrderState.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    try{
      remoteDataSource.makeOrder(order).then((value){
        makeOrderState.add(SuccessState(StateRendererType.fullScreenSuccessState, 'successfully reserved')) ;
      }).catchError((error){
        makeOrderState.add(ErrorState(StateRendererType.popupErrorState, error.toString())) ;
      });
    }catch(ex){
      makeOrderState.add(ErrorState(StateRendererType.popupErrorState, ex.toString())) ;
    }
  }
  Future updateOrder(Order order)async{
     remoteDataSource.updateOrder(order).then((value){
     }).catchError((error){
     });
  }

  Future rateOrder(Order order)async{
   await remoteDataSource.updateOrder(order).then((value){
    }).catchError((error){});
    if(order.type==serviceTypes[1]) {
      if(order.serviceProvider.rate==null){
        order.driver!.rate = {user!.uid:order.rate};
      }else {
        order.driver!.rate?.addAll({user!.uid:order.rate});
      }
     await  remoteDataSource.updateDriver(order.driver!);
    }else {
      if(order.serviceProvider.rate==null){
        order.serviceProvider.rate = {user!.uid:order.rate};
      }else {
        order.serviceProvider.rate?.addAll({user!.uid:order.rate});
      }
    await  remoteDataSource.updateProfileDataServiceProvider(order.serviceProvider);
    }

  }

  Future cancelCurrentOrder(orderId)async{
    profileStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    remoteDataSource.cancelCurrentOrder(orderId).then((value){
      profileStateCon.add(ContentState());
    }).catchError((error){
      profileStateCon.add(ErrorState(StateRendererType.popupErrorState, error.toString()));
    });
  }


  void changePassword(currentPassword,newPassword,confirmNewPassword) async {
    changePasswordState.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    if (newPassword != confirmNewPassword) {
      changePasswordState.add(ErrorState(StateRendererType.popupErrorState, 'The password not matched'));
    }else {
      try {
      auth.User? user = auth.FirebaseAuth.instance.currentUser;
      auth.AuthCredential credential = auth.EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      // Password changed successfully
      changePasswordState.add(SuccessState(StateRendererType.fullScreenSuccessState, 'Password is Changed !'));
    } on auth.FirebaseAuthException catch (e) {
      changePasswordState.add(ErrorState(StateRendererType.popupErrorState, e.message.toString()));
    } catch (e) {
      changePasswordState.add(ErrorState(StateRendererType.popupErrorState,'Error !!'));
    }
    }
  }

  Future<List<CarService>> getCarServices(providerId,type)async{
    makeOrderState.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    List<CarService> services = [] ;
    await remoteDataSource.getCarServices(providerId).then((value){
      services.addAll(value.where((element) => !element.hidden && (element.type==type||element.type=='all')));
      if(services.isNotEmpty) {
        makeOrderState.add(ContentState());
      }else {
        makeOrderState.add(ErrorState(StateRendererType.fullScreenErrorState, 'The service provider has not added services yet !'));
      }

    }).catchError((error){
      makeOrderState.add(ErrorState(StateRendererType.fullScreenErrorState, 'The service provider has not added services yet !'));
    });
    return services ;
  }

  static List<String> ads = [] ;
  Future getAds()async{
    adsStateCon.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState)) ;
    ads = [] ;
    return  await remoteDataSource.getAds().then((value){
      ads.addAll(value!);
      if(ads.isNotEmpty) {
        adsStateCon.add(ContentState());
      }else {
        adsStateCon.add(ErrorState(StateRendererType.fullScreenErrorState, 'Not Found !'));
      }
    }).catchError((error){
      adsStateCon.add(ErrorState(StateRendererType.fullScreenErrorState, 'Not Found !'));
    });
  }

}