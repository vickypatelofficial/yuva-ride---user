import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:yuva_ride/main.dart';
import 'package:yuva_ride/models/driver_profile_model.dart';
import 'package:yuva_ride/models/home/active_ride_model.dart';
import 'package:yuva_ride/models/home/available_driver_model.dart';
import 'package:yuva_ride/models/home/calculator_price_model.dart';
import 'package:yuva_ride/models/home/cancel_ride_reason_model.dart';
import 'package:yuva_ride/models/home/contact_model.dart';
import 'package:yuva_ride/models/home/home_model.dart';
import 'package:yuva_ride/models/home/payment_coupon_model.dart';
import 'package:yuva_ride/models/location_item_model.dart';
import 'package:yuva_ride/models/ride_detail_model.dart';
import 'package:yuva_ride/models/ride_list_response.dart';
import 'package:yuva_ride/repository/ride_repository.dart';
import 'package:yuva_ride/services/local_storage.dart';
import 'package:yuva_ride/services/map_services.dart';
import 'package:yuva_ride/services/razor_pay_services.dart';
import 'package:yuva_ride/services/socket_services.dart';
import 'package:yuva_ride/services/status.dart';
import 'package:yuva_ride/utils/app_urls.dart';
import 'package:yuva_ride/utils/globle_func.dart';
import 'package:yuva_ride/view/screens/home/home_screen.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/partener_on_the_way_screen.dart';
import 'package:yuva_ride/view/screens/ride_booking/after_booking/ride_completed_screen.dart';

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
    print('++++++++++++');
    print(_selectedCategory);
    notifyListeners();
  }

  void setVehicle(String id, String price, String discountPrice) {
    _selectedVehicle = VehicleModel(price, id, discountPrice);
    print(price);
    print(id);
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
    if (isStatusSuccess(categoryState.status)) {
      return;
    }
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
      serviceCategory: 'all', // selectedCategory ?? '',
      dropLatLonList: [],
      couponId: selectedCoupon?.id, couponCode: selectedCoupon?.couponCode,
    );
    _selectedVehicle = VehicleModel('', '', '');
    if (isStatusSuccess(calculateState.status)) {
      _selectedCoupon = SelectCoupenModel(calculateState.data?.couponTitle,
          calculateState.data?.couponId, calculateState.data?.couponCode);
    }
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
    // driverIds = [225]; //static
    print('ids = $driverIds');
  }

  Future<void> createRide({
    // required String paymentId,
    required int tip,
  }) async {
    driverProfileState = ApiResponse.loading();
    rideCreateState = ApiResponse.loading();
    rideDetailState = ApiResponse.loading();
    mapService.clearMap();
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
      couponId: selectedCoupon?.id,
      tip: tip, paymentId: selectedPayment?.id ?? '',
      mRole: '1',
      serviceCategory: _selectedCategory ?? '',
      bookFor:
          (selectedContact?.isSelf == null || selectedContact?.isSelf == true)
              ? 'self'
              : 'other',

      otherName:
          (((selectedContact?.isSelf == null || selectedContact?.isSelf == true)
                      ? 'self'
                      : 'other') ==
                  'other')
              ? selectedContact?.name
              : null,
      otherPhone:
          (((selectedContact?.isSelf == null || selectedContact?.isSelf == true)
                      ? 'self'
                      : 'other') ==
                  'other')
              ? selectedContact?.phone
              : null,
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

  SelectPaymentModel? _selectedPayment = SelectPaymentModel('Cash', "9");
  SelectPaymentModel? get selectedPayment => _selectedPayment;
  SelectCoupenModel? _selectedCoupon;
  SelectCoupenModel? get selectedCoupon => _selectedCoupon;

  void setCoupon(String? text, int? id, String? couponCode) {
    _selectedCoupon = SelectCoupenModel(text, id, couponCode);
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

  SelectContactModel? _selectedContact = SelectContactModel(isSelf: true);

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

  String? driverCurrentId;
  ApiResponse<DriverProfileModel?> driverProfileState = ApiResponse.loading();
  Future<void> getDriverProfile({required String driverId}) async {
    driverProfileState = ApiResponse.loading();
    notifyListeners();
    driverProfileState = await _repo.getDriverProfile(driverId: driverId);
    notifyListeners();
  }

  String activeRideRequestId = '';
  String getActiveRideRequestId() {
    return activeRideRequestId;
  }

  void saveActiveRideRequestId(String id) {
    activeRideRequestId = id;
  }

  ApiResponse removeRideRequestState = ApiResponse.nothing();
  Future<void> removeRideRequest(String requestId) async {
    removeRideRequestState = ApiResponse.loading();
    notifyListeners();
    removeRideRequestState =
        await _repo.removeRideRequest(requestId: requestId);
    if (isStatusSuccess(removeRideRequestState.status)) {
      _socket.emit("RequestTimeOut", {
        "request_id":
            requestId, // Mandatory: The ID of the ride request to remove
        "uid":
            await LocalStorage.getUserId() ?? '', // Mandatory: The Customer ID
        "message": "Time out" // Optional: Just for logging
      });
    }
    notifyListeners();
  }

  //Cancel Ride
  ApiResponse cancelRideState = ApiResponse.nothing();
  Future<void> cancelRide(
      {required String cancelId, required String requestId}) async {
    cancelRideState = ApiResponse.loading();
    notifyListeners();
    LatLng? currentLocation = await MapService.getCurrentLatLng();
    cancelRideState = await _repo.cancelRide(
        userId: await LocalStorage.getUserId() ?? "",
        cancelId: cancelId,
        lat: currentLocation?.latitude.toString() ?? '',
        lng: currentLocation?.longitude.toString() ?? '',
        requestId: requestId);

    if (isStatusSuccess(cancelRideState.status)) {
      // when not accepted then will not emit\
      if (rideDetailState.data?.requestData?.status != '0') {
        _socket.emit('Vehicle_Ride_Cancel', {
          'uid': await LocalStorage.getUserId(),
          'driverid': driverIds,
        });
      }
    }
    notifyListeners();
  }

  ApiResponse<CancelRideReasonModel> cancelRideReasonState =
      ApiResponse.nothing();
  Future<void> cancelRideReason() async {
    if (isStatusSuccess(cancelRideReasonState.status)) {
      return;
    }
    cancelRideReasonState = ApiResponse.loading();
    notifyListeners();
    cancelRideReasonState = await _repo.cancelRideReason();
    notifyListeners();
  }

  ApiResponse<RideDetailModel> rideDetailState = ApiResponse.loading();
  Future<void> rideDetail({required String requestId}) async {
    final data = await _repo.getRideDetail(
      requestId: requestId,
    );
    if (data.data != null) {
      rideDetailState = data;
    }
    notifyListeners();
  }

  /// active ride
  ApiResponse<ActiveRideModel> activeRideState = ApiResponse.loading();
  Future<void> fetchUserActiveRide() async {
    activeRideState = ApiResponse.loading();
    notifyListeners();
    activeRideState = await _repo.getUserActiveRide();
    notifyListeners();
  }

  ApiResponse<RideListResponse> rideListState = ApiResponse.loading();

  Future<void> fetchRideList(String status) async {
    rideListState = ApiResponse.loading();
    notifyListeners();

    final data = await _repo.getRideList(status: status);
    rideListState = data;

    notifyListeners();
  }

  ApiResponse<List<LocationItem>> locationState = ApiResponse.nothing();

  Future<void> loadLocations() async {
    locationState = ApiResponse.loading();
    notifyListeners();
    final response = await _repo.fetchLocations();
    locationState = response;
    notifyListeners();
  }

  final RazorpayService _razorpayService = RazorpayService();

  ApiResponse paymentState = ApiResponse.nothing();

  String? _razorpayBackendOrderId;

  void initRazorpay() {
    _razorpayService.onSuccess = _onPaymentSuccess;
    _razorpayService.onError = _onPaymentError;
  }

  String? orderId;
  String? driverId;

  Future<void> createRazorpayOrder({
    required String rideOrderId, // taxi order id
    required String amount,
  }) async {
    initRazorpay();
    paymentState = ApiResponse.loading();
    notifyListeners();

    final uid = await LocalStorage.getUserId() ?? '';

    final response =
        await _repo.createRazorpayOrder(uid: uid, orderId: rideOrderId);

    if (isStatusSuccess(response.status)) {
      joinCustomerRoom();
      _razorpayBackendOrderId = response.data['razorpay_order_id']?.toString();
      _razorpayService.openCheckout(
          key: "rzp_test_Rn3pWJq83UqioO",
          amount: (parseToDouble(amount) * 100).toInt(),
          name: rideDetailState.data?.requestData?.customerName ?? '',
          orderId: _razorpayBackendOrderId!,
          phone: rideDetailState.data?.requestData?.phone ?? '',
          email: "test@gmail.com");
    }

    paymentState = response;
    notifyListeners();
  }

  emitPaymentSuccess() {
    // _socket.emit('online_payment_success', {
    //   "order_id": "694",
    //   "cart_id": "756",
    //   "payment_status": 'completed',
    //   "total_amount": "18.5",
    //   "driver_earning": "6",
    //   "payment_method": "9",
    //   "completed_at": DateTime.now().toString()
    // });
    // _socket.emit('online_payment_success', {
    //   "message": "Payment successful! Thank you.",
    // });
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    final uid = await LocalStorage.getUserId() ?? '';

    paymentState = ApiResponse.loading();
    notifyListeners();
    paymentState = await _repo.completeOnlinePayment(
      uid: uid,
      orderId: orderId ?? '', // taxi order id
      paymentMethod: "3", // online
      razorpayPaymentId: response.paymentId ?? '',
      razorpayOrderId: response.orderId ?? '',
      razorpaySignature: response.signature ?? '',
      paymentStatus: "success",
    );
    showModalBottomSheet(
      context: navigatorKey.currentContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final text = Theme.of(context).textTheme;
        return paymentSuccessBottomSheet(
            context, text, context.read<BookRideProvider>());
      },
    );
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const RideCompletedScreen()),
      );
    });

    notifyListeners();
  }

  void _onPaymentError(PaymentFailureResponse response) {
    paymentState = ApiResponse.error("Payment Failed");
    notifyListeners();
  }

  /////Map Section
  final MapService mapService = MapService();
  Future<void> initMapFeatures({bool fitBoundOnly = false}) async {
    final driverLocation = LatLng(
        rideDetailState.data?.driverToCustomer?.driverLocation?.latitude ??
            17.438911,
        rideDetailState.data?.driverToCustomer?.driverLocation?.longitude ??
            78.3983894);
    final pickupLocation = MapService.parseLatLngSafe(
            rideDetailState.data?.requestData?.picLatLong) ??
        const LatLng(17.438911, 78.3983894);

    if (kDebugMode) {
      debugPrint('🔹 initMapFeatures - Driver: $driverLocation');
      debugPrint('🔹 initMapFeatures - Pickup: $pickupLocation');
    }

    if (!fitBoundOnly) {
      print('map icon loading');
      await mapService.loadMapIcons(
          startLocationIcon: 'assets/images/bike.png',
          endLocationIcon: 'assets/images/green_marker.png');
      print('map  setPickupDropMarkers');
      mapService.setPickupDropMarkers(
          pickup: driverLocation, drop: pickupLocation);
      print('creating route');
      await mapService.createRoutePolyline([driverLocation, pickupLocation]);
    }

    await Future.delayed(const Duration(milliseconds: 200));
    await mapService.fitToPickupDrop(driverLocation, pickupLocation);
    notifyListeners();
  }

  Future<void> arrivedPickup({bool fitBoundOnly = false}) async {
    print('=======enter in map features========');
    if (!fitBoundOnly) {
      mapService.clearMap();
      await mapService.loadPickup(icon: 'assets/images/green_marker.png');
      await mapService.setPickupMarker(
          pickup: MapService.parseLatLngSafe(
              rideDetailState.data?.requestData?.picLatLong)!);
    }
    await mapService.moveCameraToTap(MapService.parseLatLngSafe(
        rideDetailState.data?.requestData?.picLatLong)!);
    notifyListeners();
  }

  Future<void> pickuDropMapFeatures({bool fitBoundOnly = false}) async {
    final startLocation = MapService.parseLatLngSafe(
            rideDetailState.data?.requestData?.picLatLong) ??
        const LatLng(17.438911, 78.3983894);
    final endLocation = MapService.parseLatLngSafe(
            rideDetailState.data?.requestData?.dropLatLong) ??
        const LatLng(17.438911, 78.3983894);
    print('🔹 checkActiveRide: Start: $startLocation, End: $endLocation');
    print('start location -  $startLocation');
    print('end location - $endLocation');
    print('=======loading icons========');
    if (!fitBoundOnly) {
      mapService.clearMap();
      // notifyListeners();
      // return;
      await mapService.loadMapIcons();
      print('setting dropdown and other markers');
      mapService.setPickupDropMarkers(pickup: startLocation, drop: endLocation);

      await mapService.addMarker(
        markerId: 'driver',
        position: startLocation,
        iconPath: 'assets/images/bike.png',
        iconSize: 90,
      );
      // final points = await mapService.getRoutePolyline(
      //     pickupLatLng, dropLatLng, AppConstants.googleApiKey);
      print('creating route polyline');
      await mapService.createRoutePolyline([startLocation, endLocation]);
    }

    await Future.delayed(const Duration(milliseconds: 200));
    await mapService.fitToPickupDrop(startLocation, endLocation);
    notifyListeners();
  }

  Future<void> setDropFeature({bool fitBoundOnly = false}) async {
    final latLng = MapService.parseLatLngSafe(
            rideDetailState.data?.requestData?.dropLatLong) ??
        const LatLng(17.438911, 78.3983894);
    if (!fitBoundOnly) {
      mapService.clearMap();
      mapService.polylines.clear();
      mapService.setDropMarker(drop: latLng);
    }
    mapService.moveCamera(latLng);
    notifyListeners();
  }

  @override
  void dispose() {
    mapService.mapController = null; //
    super.dispose();
  }

  /////Socket Section

  final SocketService _socket = SocketService();
  bool isConnected = false;
  String? _otp;
  String? get otp => _otp;

  saveOtp(String otp) {
    _otp = otp;
    notifyListeners();
  }

  Future<void> initSocket() async {
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
    _socket.on('acceptvehrequest$uid', (data) async {
      print('✅ Driver accepted ride');
      print(data);
      await getDriverProfile(driverId: data['u_id']?.toString() ?? '');
      driverCurrentId = data['u_id']?.toString();
      await rideDetail(requestId: data['request_id']?.toString() ?? '');

      print('map is creating');
      initMapFeatures();
    });

    _socket.on('Vehicle_D_IAmHere', (data) {
      //{u_id: 225, c_id: 108, request_id: 677, otp: 2887}
      print("++++++ /Vehicle_D_IAmHere/ ++++ :---$data");
      print("Vehicle_D_IAmHere is of type: ${data.runtimeType}");
      print("Vehicle_D_IAmHere keys: ${data.keys}");
      print("Vehicle_D_IAmHere id: ${data["c_id"]}");
      saveOtp(data["otp"]?.toString() ?? '');
      if ((data["otp"]?.toString() ?? '').isNotEmpty) {
        showCustomToast(title: 'Driver Arrived at pickup location');
      }
      driverId = data["u_id"]?.toString() ?? '';
      try {
        rideDetail(
          requestId: data["request_id"]?.toString() ?? '',
        );
      } catch (e) {
        print(e.toString());
      }
      arrivedPickup();
    });

    _socket.on('Vehicle_Ride_Start_End$uid', (data) async {
      print('✅ Driver Vehicle_Ride_Start ride');

      // get ride detail
      await rideDetail(requestId: rideDetailState.data?.requestTableId ?? '');
      // map animations
      if (rideDetailState.data?.requestData?.status == '5') {
        pickuDropMapFeatures();
      } else if (rideDetailState.data?.requestData?.status == '7') {
        setDropFeature();
        if (navigatorKey.currentContext != null) {
          showRideEndNotifyDialog(navigatorKey.currentContext!);
        }
      }
    });
    _socket.on('RequestTimeOut', (data) async {
      print('✅ Driver Vehicle_Ride_Start ride');
      Future.delayed(const Duration(seconds: 1), () {
        showAddMoreTipDialog(context: navigatorKey.currentContext!);
      });
      Navigator.maybePop(navigatorKey.currentContext!);
    });

    // ❌ Ride cancelled
    _socket.on('Vehicle_Ride_Cancel', (data) {
      print('❌ Ride cancelled');
      final context = navigatorKey.currentContext!;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (_) => false);
    });

    _socket.on('Ride_Complete_Notify', (data) {
      print('++++++++++++++print data Ride_Complete_Notify++++++++++++++');
      print(data);
      orderId = data['order_id'].toString();
      if (data?['payment_method_id']?.toString() == '9') {
        showModalBottomSheet(
          context: navigatorKey.currentContext!,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            final text = Theme.of(context).textTheme;
            return paymentSuccessBottomSheet(
                context, text, context.read<BookRideProvider>());
          },
        );
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(navigatorKey.currentContext!);
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => const RideCompletedScreen()),
          );
        });
      } else {
        showPaymentDialog(navigatorKey.currentContext!,
            price: data?['amount_to_pay']?.toString() ?? '', onYes: () {
          createRazorpayOrder(
            rideOrderId: data['order_id'].toString(),
            amount: data['tatal_amount'].toString(),
          );
        }, onNo: () {});
      }

      // rideDetail(requestId:  data['request_id'].toString(), driverId: rideDetailState.data?.re);
      print('Ride_Complete_Notify');
    });

    // 📍 Live driver location (new tracking system)
    _socket.on('driver_location_update', (data) {
      print('📍 Driver location update');
    });
  }

  joinCustomerRoom() async {
    _socket.joinCustomerRoom((await LocalStorage.getUserId()) ?? '');
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
  VehicleModel(this.price, this.id, this.discountPrice);
  final String price;
  final String discountPrice;
  final String id;
}

class SelectCoupenModel {
  SelectCoupenModel(this.title, this.id, this.couponCode);
  final String? title;
  final int? id;
  final String? couponCode;
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

double parseToDouble(dynamic value, {double defaultValue = 0.0}) {
  if (value == null) return defaultValue;

  if (value is double) return value;
  if (value is int) return value.toDouble();

  if (value is String) {
    final cleaned = value
        .trim()
        .replaceAll(RegExp(r'[^0-9.-]'), ''); // removes ₹, commas, text

    if (cleaned.isEmpty) return defaultValue;

    return double.tryParse(cleaned) ?? defaultValue;
  }

  return defaultValue;
}
