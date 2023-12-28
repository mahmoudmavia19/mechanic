
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mechanic/driver/controller/driver_controller.dart';
import 'package:mechanic/models/car_make.dart';
import 'package:mechanic/models/car_model.dart';
import 'package:mechanic/models/car_services.dart';
import 'package:mechanic/models/driver_model.dart';
import 'package:mechanic/models/vehicle.dart';
import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/service_provider/controller/service_provider_controller.dart';
import 'package:mechanic/utils/constants.dart';
import '../models/service_provider.dart';
import '../models/user.dart' as user;
import '../models/order.dart' as order;

abstract class BaseRemoteDataSource {
  Future<user.User?> signInWithEmailAndPassword(String email, String password);
  Future<user.User?> createUserWithEmailAndPassword(user.User user, String password);
  Future<void> signOut();
  Future<bool> checkLogin(userType);
  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getProfileData();
  Future<user.User?> updateProfileData(user.User? user);
  Future<void> addCarInfo(Car car);
  Future<List<Car>> getCarInfo();
  Future<void> deleteCarInfo(String carSerial);
  Future<void> sendReportToSupervisor(String text);
  Future<List<ServiceProvider>> getServiceProviders();
  Future<void> makeOrder(order.Order order);
  Future<void> cancelCurrentOrder(curOrderId);
  Future<void> removeOrderFromHistory(String orderId);

  Future<void> changePassword(newPassword);
  Future<user.User> getUser(userID);


  Future<List<CarMake>?> getCarMakes();
  Future<List<CarModel>?> getCarModels(String make);
  Future<List<order.Order>?> getOrderHistoryModels();
  Future<List<String>?> getAds();

  // -------------- Service Provider ------------------

  Future<void> addCarService(String providerId,CarService service);
  Future<List<CarService>> getCarServices(providerId);
  Future<void> updateCarService(String providerId,CarService service);
  Future<List<order.Order>> newOrders();
  Future<List<order.Order>> allOrdersForProvider();
  Future<void> addDriver(Driver driver);
  Future<void> updateDriver(Driver driver);
  Future<List<Driver>> getDriver();
  Future<void> addCarModelServiceProvider(CarModel carModel);
  Future<void> updateCarModelServiceProvider(CarModel carModel);
  Future<List<CarModel>> getCarModelServiceProvider();

}
enum UiState {loading,loaded,success,error}
class RemoteDataSource extends BaseRemoteDataSource{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<user.User?> createUserWithEmailAndPassword(user.User user, String password)  async {
      // Create a Firebase user with email and password
    try{
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
          email:user.email, password: password);
      user.uid= userCredential.user!.uid;
      // Add user data to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set(user.toJson());
      return user;
    }catch (error){
      print(error.toString()) ;
      return null ;
    }

  }

  @override
  Future<user.User?> signInWithEmailAndPassword(String email, String password)async{
    final UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(
        email:email.trim(), password: password.trim());
    // Add user data to Firestore
   var result =  await _firestore.collection('users').doc(userCredential.user!.uid).get();
   print(result.data());
   if(result.data()!=null) {
     print('------------------------');
     var us =  user.User.fromJson(result.data()!);
     print("user ${us.toJson()}");
     return us ;
   }else {
     print('error');
     return null;
   }

  }

  Future<ServiceProvider?> signInServiceProvider(String email, String password)async{
    final UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(
        email:email.trim(), password: password.trim());
     var result =  await _firestore.collection('ServiceProvider').doc(userCredential.user!.uid).get();
     if(result.data()!=null) {
       return ServiceProvider.fromJson(result.data()!);
     }else {
       return null;
     }
  }

  Future<Driver?> signInDriver(String email, String password)async{
    final UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(
        email:email.trim(), password: password.trim());
    for (var element in (await _firestore.collection('ServiceProvider').get()).docs) { 
   var get =await  _firestore.collection('ServiceProvider').doc(element.id).collection('Drivers').doc(userCredential.user!.uid).get();
   if(get.exists)
     {
       return Driver.fromJson(get.data()!);
     }
    }
    return null ;
  }


  @override
  Future<void> signOut() async{
    return await _firebaseAuth.signOut();
  }

  @override
  Future<bool> checkLogin(userType) async{
     return false;  //(await _firestore.collection(userType).doc(Controller.user!.uid).get()).exists;
  }

  @override
  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getProfileData() async{
   return  _firestore.collection('users').doc(Controller.user!.uid).snapshots() ;
  }

  @override
  Future<user.User?> updateProfileData(user.User? user) async{
    await _firestore.collection('users').doc(Controller.user?.uid).update(user!.toJson());
    return user ;
  }
  Future<ServiceProvider?> updateProfileDataServiceProvider(ServiceProvider? user) async{
    await _firestore.collection('ServiceProvider').doc(user!.id).update(user.toJson());
    return user ;
  }

  @override
  Future<void> addCarInfo(Car car) async{
    if(car.serialNumber!.isNotEmpty) {
      return await _firestore.collection('users').doc(Controller.user?.uid).collection('cars')
         .doc(car.serialNumber).set(car.toJson());
    }else {
     var response =  await _firestore.collection('users').doc(Controller.user?.uid).collection('cars')
          .add(car.toJson());
     car.serialNumber = response.id;
     return await _firestore.collection('users').doc(Controller.user?.uid).collection('cars')
         .doc(car.serialNumber).set(car.toJson());

    }
  }
  @override
  Future<List<Car>> getCarInfo()async {
    return (await _firestore.collection('users').doc(Controller.user?.uid).collection('cars').get()).docs.map((e) => Car.fromJson(e.data())).toList();
  }
  @override
  Future<void> deleteCarInfo(String carSerial)async{
    return await _firestore.collection('users').doc(Controller.user?.uid).collection('cars')
        .doc(carSerial).delete();
    }

  @override
  Future<void> sendReportToSupervisor(String text) async{
    await _firestore.collection('reports').doc(Controller.user?.uid).collection('reports').add(
        {
          'report' : text
        });
  }

  @override
  Future<List<ServiceProvider>> getServiceProviders() async {
    try {
      CollectionReference serviceProvidersCollection = _firestore.collection('ServiceProvider');

      QuerySnapshot querySnapshot = await serviceProvidersCollection.get();

      List<ServiceProvider> providers = [];

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        ServiceProvider serviceProvider = ServiceProvider.fromJson(data);

        providers.add(serviceProvider);
      }

      return providers;
    } catch (e) {
      print('Error fetching service providers: $e');
      return []; // Return an empty list or handle the error as needed
    }
  }

  @override
  Future<void> changePassword(newPassword)async {
      try {
        User? user = _firebaseAuth.currentUser;

        if (user != null) {
          await user.updatePassword(newPassword);
          // Password changed successfully.
        } else {
          // No user is currently signed in.
          print('No user is signed in.');
        }
      } catch (e) {
        // An error occurred while changing the password.
        print('Error changing password: $e');
      }

  }

  Future<order.Order?> getOrder(String user,String uid)async{
   var response = await _firestore.collection('users').doc(user)
       .collection('orders').doc(uid).get();
   print('enter irder : ${response.id}');
   return order.Order.fromJson(response.data()) ;

  }

  @override
  Future<void> makeOrder(order.Order order)  async{

     var response = await  _firestore.collection('users').doc(Controller.user!.uid)
            .collection('orders').add(order.toJson()) ;
   var data = order.toJson()..addAll({
     'id' : response.id
   });
      await  _firestore.collection('users').doc(Controller.user?.uid)
         .collection('orders').doc(response.id).update(data);
     print(response.id);
        await _firestore.collection('users').doc(Controller.user!.uid).update(
          {
            'currentOrder':FieldValue.arrayUnion([response.id])
          });

  }

  @override
  Future<void> cancelCurrentOrder(curOrderId) async{
    await _firestore.collection('users').doc(Controller.user!.uid).collection('orders').
    doc(curOrderId).update(
        {
          'status': 'canceled'
        });
     await _firestore.collection('users').doc(Controller.user!.uid).update(
        {
           'currentOrder':  FieldValue.arrayRemove([curOrderId])
        });
  }
  Future<void> updateOrder(order.Order order) async{
    await _firestore.collection('users').doc(order.user).collection('orders').doc(order.id).set(order.toJson());
    if(order.status==orderStatus[2]) {
       await _firestore.collection('users').doc(order.user).update(
          {
            'currentOrder': FieldValue.arrayRemove([order.id])
          });
    }
  }

  @override
  Future<List<CarMake>?> getCarMakes()async{

    List<CarMake> makesName = [] ;

      final makes = [
        {
          "make_id": "honda",
          "make_display": "Honda",
          "make_is_common": "1",
          "make_country": "Japan"
        },
        {
          "make_id": "hyundai",
          "make_display": "Hyundai",
          "make_is_common": "1",
          "make_country": "South Korea"
        },
        {
          "make_id": "lexus",
          "make_display": "Lexus",
          "make_is_common": "1",
          "make_country": "Japan"
        },
        {
          "make_id": "toyota",
          "make_display": "Toyota",
          "make_is_common": "1",
          "make_country": "Japan"
        },
      ];

      print('Car Makes:');

      for (var make in makes) {

        makesName.add(CarMake.fromJson(make));
      }

    return makesName ;
  }
  final map = {
    'toyota':
      [
        {
          "model_name": "Fortuner",
          "model_make_id": "toyota"
        },
        {
          "model_name": "Corolla",
          "model_make_id": "toyota"
        },
        {
          "model_name": "Camry",
          "model_make_id": "toyota"
        },
      ]
    ,
    'hyundai':
      [
        {
          "model_name": "Sonata",
          "model_make_id": "hyundai"
        },
        {
          "model_name": "Accent",
          "model_make_id": "hyundai"
        },
        {
          "model_name": "Elantra",
          "model_make_id": "hyundai"
        },
      ]
     ,
    'lexus':
      [
        {
          "model_name": "RX",
          "model_make_id": "lexus"
        },
        {
          "model_name": "IS",
          "model_make_id": "lexus"
        },
        {
          "model_name": "LX",
          "model_make_id": "lexus"
        },
      ]
     ,
    'honda' :
      [
        {
          "model_name": "Civic",
          "model_make_id": "honda"
        },
        {
          "model_name": "Accord",
          "model_make_id": "honda"
        },
        {
          "model_name": "Odyssey",
          "model_make_id": "honda"
        },
      ]
    ,
  } ;

  @override
  Future<List<CarModel>?> getCarModels(String make)async {
     List<CarModel> carModels = [] ;
      final models = map[make];
       for (var model in models!) {
         carModels.add(CarModel.fromJson(model)) ;
      }
       return carModels ;
  }

  @override
  Future<List<order.Order>?> getOrderHistoryModels() async{
    var response =  await _firestore.collection('users').doc(Controller.user!.uid).collection('orders').orderBy('orderDateTime',descending: true).get() ;
    return response.docs.map((e) {
      order.Order orderCon = order.Order.fromJson(e.data());
      return orderCon;
    }).toList();
  }

  @override
  Future<void> removeOrderFromHistory(String orderId) async{
  await _firestore.collection('users').doc(Controller.user!.uid).collection('orders')
      .doc(orderId).delete() ;
  }

  @override
  Future<void> addCarService(String providerId,CarService service) async{
    await _firestore.collection('ServiceProvider').doc(providerId).collection('Services')
        .doc(service.uid).set(service.toJson());
  }

  @override
  Future<List<CarService>> getCarServices(providerId) async{
    return ( await _firestore.collection('ServiceProvider').doc(providerId).collection('Services').get()).docs.map((e) => CarService.fromJson(e.data())).toList();
  }

  @override
  Future<void> updateCarService(String providerId,CarService service) async{
    print("user : $providerId}");
      await _firestore.collection('ServiceProvider').doc(providerId).collection('Services')
        .doc(service.uid).update(service.toJson());
  }

  @override
  Future<List<order.Order>> allOrdersForProvider() async{
    List<order.Order> orders = [] ;
    for (var element in (await _firestore.collection('users').get()).docs) {
     for (var item in (await _firestore.collection('users').doc(element.id).collection('orders').get()).docs) {
       var or = order.Order.fromJson(item.data());
       if(or.serviceProvider.id==ServiceProviderController.spUser!.id){
         orders.add(or);
       }
     }
    }
    print('all orders is ${orders.length}');
    return orders;
  }
  Future<List<order.Order>> allOrdersForDriver() async{
    List<order.Order> orders = [] ;
    for (var element in (await _firestore.collection('users').get()).docs) {
      for (var item in (await _firestore.collection('users').doc(element.id).collection('orders').get()).docs) {
        var or = order.Order.fromJson(item.data());
        print("driver id ${DriverController.driver!.uid}");
        if(or.driver!=null && or.driver!.uid==_firebaseAuth.currentUser!.uid){
          orders.add(or);
        }
      }
    }
    orders.sort((a, b) => a.orderDateTime.compareTo(b.orderDateTime),);
     return orders;
  }

  @override
  Future<List<order.Order>> newOrders() async{
    List<order.Order> orders = [] ;
    for (var element in (await _firestore.collection('users').get()).docs) {
      try {
        var userCon = user.User.fromJson(
            (await _firestore.collection('users').doc(element.id).get())
                .data()!);
        print('user id : ${userCon.uid} order count : ${userCon.currentOrder
            ?.length}');
        if (userCon.currentOrder!.isNotEmpty) {
          print('enter');
          for (var orderId in userCon.currentOrder!) {
            print('order details : $orderId');

            var item = await getOrder(userCon.uid,orderId);
            if (item?.serviceProvider.id ==
                ServiceProviderController.spUser!.id) {
              orders.add(item!);
            }
          }
        }
      }catch(ex){
        print(ex.toString());
      }
    }
    return orders;
  }

  @override
  Future<void> addDriver(Driver driver) async{
   await _firebaseAuth.createUserWithEmailAndPassword(email: driver.email.trim(), password: driver.password.trim()).then((value)async{
     driver.uid = value.user!.uid;
     await _firestore.collection('ServiceProvider').doc(driver.spId).collection('Drivers').doc(value.user!.uid).set(driver.toJson());
   }).catchError((error){
     print(error.toString());
   });
  }

  @override
  Future<List<Driver>> getDriver() async{
    return  (await _firestore.collection('ServiceProvider').doc(ServiceProviderController.spUser!.id).collection('Drivers')
         .get()).docs.map((e) => Driver.fromJson(e.data())).toList();

  }

  @override
  Future<void> updateDriver(Driver driver) async{
    await _firestore.collection('ServiceProvider').doc(driver.spId).collection('Drivers').doc(driver.uid).set(driver.toJson());
    }

  @override
  Future<void> addCarModelServiceProvider(CarModel carModel) async{
  var data =   await _firestore.collection('ServiceProvider').doc(ServiceProviderController.spUser!.id)
        .collection('CarModels').add(carModel.toJson());
    carModel.uid = data.id;
    await updateCarModelServiceProvider(carModel);

  }

  @override
  Future<List<CarModel>> getCarModelServiceProvider() async{
    return (await _firestore.collection('ServiceProvider').doc(ServiceProviderController.spUser!.id)
        .collection('CarModels').get()).docs.map((e) => CarModel.fromJson(e.data())).toList();
  }

  Future<List<CarModel>> getCarModelProvider(spID) async{
    return (await _firestore.collection('ServiceProvider').doc(spID)
        .collection('CarModels').get()).docs.map((e) => CarModel.fromJson(e.data())).toList();
  }

  @override
  Future<void> updateCarModelServiceProvider(CarModel carModel) async{
    await _firestore.collection('ServiceProvider').doc(ServiceProviderController.spUser!.id)
        .collection('CarModels').doc(carModel.uid).set(carModel.toJson());
  }

  @override
  Future<user.User> getUser(userID) async{
  return user.User.fromJson((await _firestore.collection('users').doc(userID).get()).data()!);
  }

  @override
  Future<List<String>?> getAds() async{
    return (await _firestore.collection('ads').get()).docs.map((e) => e.data()['imgurl'] as String ).toList();
  }


}