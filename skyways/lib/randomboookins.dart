import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;
final counterRef = firestore.collection('order_meta').doc('counter');

// Cities list
final List<String> cities = [
  "Lahore", "Karachi", "Islamabad", "Rawalpindi", "Faisalabad",
  "Multan", "Peshawar", "Quetta", "Hyderabad", "Sialkot"
];

final List<String> titles = ["Mr", "Mrs", "Ms"];
final List<String> paymentMethods = ["Easypaisa", "JazzCash"];

final random = Random();

Future<void> insertRandomBookings() async {
  final now = DateTime.now();
  int bookingsPerDoc = 500;

  for (int i = 0; i < 1000; i++) {
    await firestore.runTransaction((transaction) async {
      // Get and increment counter
      final counterSnapshot = await transaction.get(counterRef);
      int lastOrderId = counterSnapshot.exists ? counterSnapshot['lastOrderId'] ?? 0 : 0;
      int newOrderId = lastOrderId + 1;
      String formattedOrderId = 'ORD${newOrderId.toString().padLeft(4, '0')}';

      // Select distinct cities
      String fromCity = cities[random.nextInt(cities.length)];
      String toCity;
      do {
        toCity = cities[random.nextInt(cities.length)];
      } while (toCity == fromCity);

      // Travel date (within 7 days)
      DateTime travelDate = now.add(Duration(days: random.nextInt(7)));
      String travelDateFormatted = "${travelDate.year}-${travelDate.month.toString().padLeft(2, '0')}-${travelDate.day.toString().padLeft(2, '0')}";

      int seatCount = random.nextInt(5) + 1;
      List<int> selectedSeats = List.generate(seatCount, (_) => (random.nextInt(49) + 1));

      // Distribute bookings across 2 top-level documents
      String docId = 'group_${(i ~/ bookingsPerDoc) + 1}';
      final bookingRef = firestore
          .collection('bookings')
          .doc(docId)
          .collection('user_bookings')
          .doc();

      transaction.set(counterRef, {'lastOrderId': newOrderId}, SetOptions(merge: true));

      transaction.set(bookingRef, {
        'orderId': formattedOrderId,
        'userId': '${random.nextInt(1000).toString().padLeft(4, '0')}',
        'totalPrice': seatCount * 1000,
        'selectedSeats': selectedSeats,
        'fromCity': fromCity,
        'toCity': toCity,
        'fromBusStop': '$fromCity Terminal',
        'toBusStop': '$toCity Terminal',
        'travelDate': travelDateFormatted,
        'departureTime': "08:00 AM", // Fixed
        'destinationTime': "11:00 AM", // Fixed
        'mobile': '0300123${random.nextInt(9999).toString().padLeft(4, '0')}',
        'email': 'user$i@example.com',
        'firstName': 'First$i',
        'lastName': 'Last$i',
        'cnic': '35202-123456${random.nextInt(99).toString().padLeft(2, '0')}-${random.nextInt(9)}',
        'title': titles[random.nextInt(titles.length)],
        'dateOfBirth': '01-01-1990',
        'paymentMethod': paymentMethods[random.nextInt(paymentMethods.length)],
        'senderName': 'Sender$i',
        'senderAccountNumber': '03001234567',
        'transactionId': 'TXN$i',
        'paymentProofUrl': 'https://cdn.pixabay.com/photo/2023/07/19/12/16/car-8136751_960_720.jpg',
        'bookingDate': "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
        'bookingTime': "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
        'status': "Pending",
      });
    });

    print("Inserted booking ${i + 1}/1000");

    await Future.delayed(Duration(milliseconds: 10)); // To avoid write limits
  }
}
