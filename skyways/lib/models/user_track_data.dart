class UserTrackData {
  String? fromCity;
  String? toCity;
  String? fromCityAddress;
  String? toCityAddress;
  DateTime travelDate = DateTime.now();
  String? selectedBussDepartureTime;
  String? selectedBussDestinationTime;
  double? totalPrice ; 


  List<String> departureTime= [];
  List<String> destinationTime= [];
  Set<int> selectedSeats = {};
  Set<int> reservedSeats = {};
  int totalSeats = 49;
  int maxSeats = 4;
  double? price;
  List<double> pricesList = [];
}

class BookingFormData {
String? mobile;
String? email;
String? firstName;
String? lastName;
String? cnic;

String? selectedTitle;
String? selectedDate;
String? selectedMonth;
String? selectedYear;
}

BookingFormData bookingFormData = BookingFormData();


UserTrackData userTrackData = UserTrackData();
