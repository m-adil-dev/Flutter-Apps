import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skyways/utils/utils.dart';
import 'package:skyways/screens/BookingsScreens/view_bookings.dart';

class UserRejectedBookings extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  UserRejectedBookings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejected bookings'),
        backgroundColor: themecolor,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream:
        
            FirebaseFirestore.instance
                .collection('rejected_bookings')
                .where('userId', isEqualTo: currentUser?.uid) // Replace this with the correct user id source
                .orderBy('bookingDate', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
              debugPrint('Firestore query error: ${snapshot.error}');
            return const Center(child: Text('Something went wrong.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Rejected bookings found'));
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),

            itemCount: bookings.length + 1,
            itemBuilder: (context, index) {
              // Add a SizedBox after the last booking card
              if (index == bookings.length) {
                return const SizedBox(height: 120);
              }
              final data = bookings[index].data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.directions_bus,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Bus",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              data['travelDate'],
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(200),
                              child: Image.network(
                                LogoPath,
                                height: 30,
                                width: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Sky Ways",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        const Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Payment Details",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),

                            _buildInfoRow("Sender Name", data['senderName']),
                            _buildInfoRow(
                              "Account Number",
                              data['senderAccountNumber'],
                            ),
                            _buildInfoRow(
                              "Total Amount",
                              "Rs ${data['totalPrice']}",
                            ),
                            _buildInfoRow(
                              "Number of Seats",
                              "${(data['selectedSeats'] as List).length}",
                            ),
                            _buildInfoRow(
                              "Payment Method",
                              data['paymentMethod'],
                            ),
                            _buildInfoRow(
                              "Transaction ID",
                              data['transactionId'],
                            ),

                            const SizedBox(height: 16),
                            const Text(
                              "Payment Proof:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                data['paymentProofUrl'],
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const Text('Image failed to load'),
                              ),
                            ),
                          ],
                        ),

                        const Divider(),

                        // Order Row
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "Order ID ",
                                style: TextStyle(color: Colors.grey),
                                children: [
                                  TextSpan(
                                    text: data['orderId'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.grey.shade100,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Order Status ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.cancel_outlined,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              " ${data['status']}",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themecolor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                ViewBookings(data: data),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "View",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),     
                              ],
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(width: 8),
        Expanded(child: Text(value)),
      ],
    ),
  );
}


