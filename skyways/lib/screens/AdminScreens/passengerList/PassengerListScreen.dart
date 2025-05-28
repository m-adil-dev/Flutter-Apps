import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:skyways/utils/utils.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PassengerListScreen extends StatelessWidget {
  final Map<String, dynamic> route;

  const PassengerListScreen({required this.route});

Future<void> _downloadCSV(List<QueryDocumentSnapshot> docs, BuildContext context) async {
  final routeInfo = '''
Route Information:
From           : ${route['fromCity']}
To             : ${route['toCity']}
Departure Time : ${route['departureTime']}
Travel Date    : ${route['travelDate']}

Passenger List:
''';

  List<List<String>> rows = [
    [
      'Full Name',
      'CNIC',
      'Date of Birth',
      'Phone',
      'Seat(s)',
      'Amount',
      'From',
      'To',
      'Travel Date',
      'Departure Time',
    ]
  ];

  for (var doc in docs) {
    final data = doc.data() as Map<String, dynamic>;
    final fullName = '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}';
    final cnic = data['cnic'] ?? 'N/A';
    final dob = data['dateOfBirth'] ?? 'N/A';
    final phone = data['mobile'] ?? 'N/A';
    final seats = data['selectedSeats']?.join(", ") ?? 'N/A';
    final amount = data['totalPrice']?.toString() ?? 'N/A';
    final from = data['fromCity'] ?? 'N/A';
    final to = data['toCity'] ?? 'N/A';
    final travelDate = data['travelDate'] ?? 'N/A';
    final depTime = data['departureTime'] ?? 'N/A';

    rows.add([fullName, cnic, dob, phone, seats, amount, from, to, travelDate, depTime]);
  }

  // Convert the table rows to CSV
  final csvTable = const ListToCsvConverter().convert(rows);

  // Combine the readable route info and the table
  final finalCsv = '$routeInfo$csvTable';

  final filename =
      "passenger_list_${route['fromCity']}_${route['toCity']}_${route['travelDate']}.csv"
          .replaceAll(" ", "_")
          .replaceAll("/", "-");

  // Ask for permission
  final status = await Permission.storage.request();
  if (!status.isGranted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Storage permission denied.')),
    );
    return;
  }

  // Save to public Downloads folder
  final directory = Directory('/storage/emulated/0/Download');
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  final file = File('${directory.path}/$filename');
  await file.writeAsString(finalCsv);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('CSV saved to Downloads: $filename')),
  );
}

  @override
  Widget build(BuildContext context) {
    final bookingsQuery = FirebaseFirestore.instance
        .collectionGroup('user_bookings')
        .where('fromCity', isEqualTo: route['fromCity'])
        .where('toCity', isEqualTo: route['toCity'])
        .where('departureTime', isEqualTo: route['departureTime'])
        .where('travelDate', isEqualTo: route['travelDate']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger List'),
        backgroundColor: themecolor,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FutureBuilder<QuerySnapshot>(
        future: bookingsQuery.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return SizedBox.shrink();

          return FloatingActionButton.extended(
            backgroundColor: themecolor,
            icon: Icon(Icons.download, color: Colors.white),
            label: Text("Download List", style: TextStyle(color: Colors.white)),
            tooltip: "Download passenger list as CSV",
            onPressed: () => _downloadCSV(snapshot.data!.docs, context),
          );
        },
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: bookingsQuery.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return Center(child: Text('No passengers found'));

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: docs.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: themecolor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: themecolor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${route['fromCity']} → ${route['toCity']}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themecolor),
                      ),
                      SizedBox(height: 6),
                      Text("Departure Time: ${route['departureTime'] ?? 'N/A'}"),
                      Text("Destination Time: ${route['destinationTime'] ?? 'N/A'}"),
                      Text("Travel Date: ${route['travelDate'] ?? 'N/A'}"),
                    ],
                  ),
                );
              }

              final data = docs[index - 1].data() as Map<String, dynamic>;

              final fullName = '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}';
              final cnic = data['cnic'] ?? 'N/A';
              final dob = data['dateOfBirth'] ?? 'N/A';
              final phone = data['mobile'] ?? 'N/A';
              final seats = data['selectedSeats']?.join(", ") ?? 'N/A';
              final amount = data['totalPrice']?.toString() ?? 'N/A';
              final from = data['fromCity'] ?? 'N/A';
              final to = data['toCity'] ?? 'N/A';
              final travelDate = data['travelDate'] ?? 'N/A';
              final departureTime = data['departureTime'] ?? 'N/A';
              final destinationTime = data['destinationTime'] ?? 'N/A';

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullName,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      _infoRow(Icons.badge, 'CNIC: $cnic'),
                      _infoRow(Icons.cake, 'DOB: $dob'),
                      _infoRow(Icons.phone, 'Phone: $phone'),
                      _infoRow(Icons.event_seat, 'Seat(s): $seats'),
                      _infoRow(Icons.attach_money, 'Amount: PKR $amount'),
                      _infoRow(Icons.route, 'Route: $from → $to'),
                      _infoRow(Icons.date_range, 'Travel Date: $travelDate'),
                      _infoRow(Icons.schedule, 'Departure Time: $departureTime'),
                      _infoRow(Icons.access_time_filled, 'Destination Time: $destinationTime'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: themecolor),
        SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}
