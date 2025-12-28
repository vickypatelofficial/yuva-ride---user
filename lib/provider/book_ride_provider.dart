import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yuva_ride/models/driver_profile_model.dart';
import 'package:yuva_ride/models/home/available_driver_model.dart';
import 'package:yuva_ride/models/home/calculator_price_model.dart';
import 'package:yuva_ride/models/home/contact_model.dart';
import 'package:yuva_ride/models/home/home_model.dart';
import 'package:yuva_ride/models/home/payment_coupon_model.dart';
import 'package:yuva_ride/repository/ride_repository.dart';
import 'package:yuva_ride/services/local_storage.dart';
import 'package:yuva_ride/services/map_services.dart';
import 'package:yuva_ride/services/socket_services.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/app_urls.dart';

class BookRideProvider extends ChangeNotifier {
  LocationModel? _pickupLocation;
  LocationModel? _dropLocation;

  LocationModel? get pickupLocation => _pickupLocation;
  LocationModel? get dropLocation => _dropLocation;

  void setPickupLocation(LocationModel location) {
    _pickupLocation = location;
    notifyListeners();
  }

  void setDropLocation(LocationModel location) {
    _dropLocation = location;
    notifyListeners();
  }

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  VehicleModel? _selectedVehicle;
  VehicleModel? get selectedVehicle => _selectedVehicle;
  String? _ridePrice;
  String? get ridePrice => _ridePrice;

  int selectedFare = 60;
  List<int> fareOptions = [60, 80, 100, 120];

  void setCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  void setVehicle(String id, String price) {
    _selectedVehicle = VehicleModel(price, id);
    notifyListeners();
  }

  void setVehicleNull() {
    _selectedVehicle = null;
    notifyListeners();
  }

  void setRidePrice(String value) {
    _ridePrice = value;
    notifyListeners();
  }

  bool _isFareNavigated = false;
  bool get isFareNavigated => _isFareNavigated;

  changeFareNaviagate(bool value) {
    _isFareNavigated = value;
    notifyListeners();
  }

  final RideRepository _repo = RideRepository();

  ApiResponse<CategoryModel> categoryState = ApiResponse.nothing();

  Future<void> fetchCategory() async {
    setCategory('');
    setVehicleNull();
    notifyListeners();

    categoryState = ApiResponse.loading();
    categoryState = await _repo.getCategory(
        userId: await LocalStorage.getUserId() ?? '',
        lat: "${pickupLocation?.latLng.latitude}",
        long: "${pickupLocation?.latLng.longitude}");
    notifyListeners();
  }

  ApiResponse<CalculatedPriceModel> calculateState = ApiResponse.nothing();

  Future<void> getCalculatedPrice() async {
    calculateState = ApiResponse.loading();
    notifyListeners();
    calculateState = await _repo.calculateRide(
        uid: await LocalStorage.getUserId() ?? '',
        pickupLatLon:
            "${pickupLocation?.latLng.latitude},${pickupLocation?.latLng.longitude}", // pickupLatLon,
        dropLatLon:
            "${dropLocation?.latLng.latitude},${dropLocation?.latLng.longitude}", // dropLatLon,
        serviceCategory: selectedCategory ?? '',
        dropLatLonList: [],
        couponId: selectedCoupon?.id);
    notifyListeners();
  }

  ApiResponse<AvailableDriverModel> availableDriverState =
      ApiResponse.nothing();

  Future<void> getAvailableDrivers() async {
    availableDriverState = ApiResponse.loading();
    notifyListeners();
    availableDriverState = await _repo.getAvailableDrivers(
        pickupLatLon:
            "${pickupLocation?.latLng.latitude},${pickupLocation?.latLng.longitude}", // pickupLatLon,
        dropLatLon:
            "${dropLocation?.latLng.latitude},${dropLocation?.latLng.longitude}", // dropLatLon,
        uid: await LocalStorage.getUserId() ?? '',
        vehicleId: _selectedVehicle?.id ?? '',
        serviceCategory: "taxi",
        dropLatLonList: []);
    notifyListeners();
  }

  ApiResponse rideCreateState = ApiResponse.nothing();
  var driverIds = [];

  assignDriverId(var idS) {
    driverIds = idS;
    driverIds = [225]; //static
    print('ids = $driverIds');
  }

  Future<void> createRide({
    // required String paymentId,
    required int tip,
  }) async {
    driverProfileState = ApiResponse.loading();
    rideCreateState = ApiResponse.loading();
    notifyListeners();

    // getting available driver list
    // if (availableDriverState.data?.driverIds.isEmpty ?? true) {
    //   await getAvailableDrivers();
    // }

    /// calculating time
    final result = await MapService.getDistanceAndTime(
        pickupLocation!.latLng, dropLocation!.latLng);
    String totalKm = result['distance_km'].toString();
    String totalMinute = result['duration_min'].toString();
    String totalHour = '';
    try {
      totalHour = (double.tryParse(totalMinute)! / 60).toString();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    String userId = await LocalStorage.getUserId() ?? '';
    // var driverIds = driverIds; // availableDriverState.data?.driverIds ?? [];
    rideCreateState = await _repo.createRide(
      uid: userId,
      driverIds: driverIds,
      vehicleId: _selectedVehicle?.id ?? '',
      price: _selectedVehicle?.price ?? "",
      totalKm: totalKm,
      totalHour: totalHour,
      totalMinute: totalMinute,
      pickup:
          "${pickupLocation?.latLng.latitude},${pickupLocation?.latLng.longitude}", // pickupLatLon,
      drop:
          "${dropLocation?.latLng.latitude},${dropLocation?.latLng.longitude}", // dropLatLon,
      pickupAdd: {
        "title": pickupLocation?.title ?? "",
        "subt": pickupLocation?.subtitle ?? ""
      },
      dropAdd: {
        "title": dropLocation?.title ?? "",
        "subt": dropLocation?.subtitle ?? ""
      },

      couponId: selectedCoupon?.id ?? '',
      tip: tip, paymentId: selectedPayment?.id ?? '',
      mRole: '1',
      serviceCategory: _selectedCategory ?? '',
      // bookFor:(selectedContact?.isSelf ==null)?'my_self':( (selectedContact!.isSelf)?),
      // otherName: other,
      // otherPhone: ,
    );
    if (isStatusSuccess(rideCreateState.status)) {
      try {
        saveActiveRideRequestId(rideCreateState.data?['id']?.toString() ?? '');
        emitCreateBooking(
            requestId: rideCreateState.data?['id']?.toString() ?? '',
            driverIds: driverIds, // availableDriverState.data?.driverIds ?? [],
            customerId: userId,
            tip: tip.toString());
      } catch (e, s) {
        print(e.toString());
        print(s.toString());
      }
    }
    notifyListeners();
  }

  SelectPaymentModel? _selectedPayment;
  SelectPaymentModel? get selectedPayment => _selectedPayment;
  SelectCoupenModel? _selectedCoupon;
  SelectCoupenModel? get selectedCoupon => _selectedCoupon;

  void setCoupon(String text, String id) {
    _selectedCoupon = SelectCoupenModel(text, id);
    notifyListeners();
  }

  void setPayment(String text, String id) {
    _selectedPayment = SelectPaymentModel(text, id);
    notifyListeners();
  }

  ApiResponse<PaymentCouponModel> paymentCouponState = ApiResponse.nothing();
  Future<void> getPaymentCoupon() async {
    paymentCouponState = ApiResponse.loading();
    notifyListeners();
    paymentCouponState = await _repo.getPaymentCoupon();
    notifyListeners();
  }

  ApiResponse<List<SavedContactModel>> contactState = ApiResponse.nothing();

  SelectContactModel? _selectedContact;

  SelectContactModel? get selectedContact => _selectedContact;

  /// FETCH
  Future<void> fetchContacts(String uid) async {
    contactState = ApiResponse.loading();
    notifyListeners();
    contactState = await _repo.getContacts(uid: uid);
    notifyListeners();
  }

  /// SELECT
  void selectContact(
      {String? name,
      String? cId,
      String? id,
      String? countryCode,
      String? phone,
      bool? isSelf = true}) {
    _selectedContact = SelectContactModel(
        isSelf: isSelf ?? true,
        name: name,
        phone: phone,
        id: id,
        cId: cId,
        countryCode: countryCode);
    notifyListeners();
  }

  /// ADD
  Future<void> addContact({
    required String uid,
    required String name,
    required String phone,
    required String countryCode,
  }) async {
    await _repo.addContact(
      uid: uid,
      name: name,
      phone: phone,
      countryCode: countryCode,
    );
    await fetchContacts(uid);
  }

  /// DELETE
  Future<void> deleteContact({
    required String uid,
    required String contactId,
  }) async {
    await _repo.deleteContact(uid: uid, contactId: contactId);
    await fetchContacts(uid);
  }

  // Get Driver Profile
  ApiResponse<DriverProfileModel?> driverProfileState = ApiResponse.loading();
  Future<void> getDriverProfile({required String driverId}) async {
    driverProfileState = ApiResponse.loading();
    notifyListeners();
    driverProfileState = await _repo.getDriverProfile(driverId: driverId);
    notifyListeners();
  }

  String activeRideRequestId = '';
  String getActiveRideRequestId(){
    return activeRideRequestId;
  }

  void saveActiveRideRequestId(String id){
     activeRideRequestId = id;
  }
  
  //Cancel Ride
  ApiResponse cancelRideState = ApiResponse.nothing();
  Future<void> cancelRide(
      {required String cancelId,
      required String requestId,
      required String lat,
      required String lng}) async {
    cancelRideState = ApiResponse.loading();
    notifyListeners();
    cancelRideState = await _repo.cancelRide(
        userId: await LocalStorage.getUserId() ?? "",
        cancelId: cancelId,
        lat: lat,
        lng: lng,
        requestId: requestId);
    if (isStatusSuccess(cancelRideState.status))
    {
      _socket.emit('Vehicle_Ride_Cancel', {
        'uid': await LocalStorage.getUserId(),
        'driverid': driverIds,
      });
    }

    notifyListeners();
  }

  final SocketService _socket = SocketService();
  bool isConnected = false;

  Future<void> init() async {
    final uid = await LocalStorage.getUserId() ?? '';

    // 1️⃣ Connect socket
    _socket.connect(
      socketUrl: AppUrl.socketUrl,
    );

    // 2️⃣ Join customer room AFTER connect
    _socket.on('connect', (_) {
      _socket.emit('join_customer_room', {
        'customer_id': uid,
      });
    });

    // 3️⃣ Listen USER-SIDE events
    _listenUserEvents(uid);

    isConnected = true;
    notifyListeners();
  }

  void _listenUserEvents(String uid) {
    // 🚗 Drivers bidding on request
    _socket.on('Vehicle_Bidding$uid', (data) {
      print('📥 Vehicle bidding update');
      print(data);
    });

    // ✅ Driver accepted ride
    _socket.on('acceptvehrequest$uid', (data) {
      print('✅ Driver accepted ride');
      print(data);
      getDriverProfile(driverId: data['u_id']?.toString() ?? '');
    });

    // ❌ Ride cancelled
    _socket.on('Vehicle_Ride_Cancel', (data) {
      print('❌ Ride cancelled');
    });

    // 📍 Live driver location (new tracking system)
    _socket.on('driver_location_update', (data) {
      print('📍 Driver location update');
    });
  }

  emitCreateBooking({
    required String requestId,
    required List driverIds,
    required String customerId,
    required String tip,
  }) {
    var data = {
      'requestid': requestId,
      'driverid': driverIds,
      'c_id': customerId,
      'tip': tip
    };
    print('=====vehiclerequest====== ');
    print(data);
    _socket.emit('vehiclerequest', data);
  }

  void disposeSocket() {
    _socket.off('Vehicle_Bidding');
    _socket.off('acceptvehrequest');
    _socket.off('Vehicle_Ride_Cancel');
    _socket.off('driver_location_update');
    _socket.disconnect();
  }
}

//{uid: 108, driverid: [190], vehicle_id: 1, price: 2.1, tot_km: 2.073, tot_hour: 0.10444444444444444, tot_minute: 6.266666666666667, payment_id: 9, m_role: 1, coupon_id: , bidd_auto_status: 0, pickup: 17.43890460161263,78.39838989078999, drop: 17.433035608604673,78.39860815554857, droplist: , pickupadd: {title: Hyderabad, subt: Madhapur}, dropadd: {title: Hyderabad, subt: Jubilee Hills}, droplistadd: [], tip: 80, service_category: taxi}

class LocationModel {
  LocationModel(this.latLng, this.address,
      {required this.title, required this.subtitle});
  final LatLng latLng;
  final String address;
  final String title;
  final String subtitle;
}

class VehicleModel {
  VehicleModel(this.price, this.id);
  final String price;
  final String id;
}

class SelectCoupenModel {
  SelectCoupenModel(this.title, this.id);
  final String title;
  final String id;
}

class SelectPaymentModel {
  SelectPaymentModel(this.title, this.id);
  final String title;
  final String id;
}

class SelectContactModel {
  SelectContactModel(
      {this.name,
      this.phone,
      this.cId,
      this.id,
      this.countryCode,
      required this.isSelf});
  final bool isSelf;
  final String? name;
  final String? phone;
  final String? cId;
  final String? id;
  final String? countryCode;
}
