import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skyways/utils/utils.dart';
import 'package:skyways/screens/BookingsScreens/view_bookings.dart';

class BookingRequest extends StatelessWidget {
  const BookingRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings Request (Admin)'),
        backgroundColor: themecolor,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collectionGroup('user_bookings')
                .where('status', isEqualTo: 'Pending')
                .orderBy('bookingDate', descending: false)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint('Error fetching bookings: ${snapshot.error}');
            return const Center(child: Text('Something went wrong.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bookings found.'));
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
              Color statusColor = Colors.black;
              IconData statusIcon = Icons.cancel_outlined;
              final data = bookings[index].data() as Map<String, dynamic>;
              if (data['status'] == "Pending") {
                statusColor = Colors.amber;
                statusIcon = Icons.hourglass_top;
              } else if (data['status'] == "Confirmed") {
                statusIcon = Icons.check_circle;
                statusColor = Colors.green;
              }

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
                            Image.asset(
                              LogoPath,
                              height: 30,
                              width: 30,
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
                                            statusIcon != Icons.cancel_outlined
                                                ? Icon(
                                                  statusIcon,
                                                  color: statusColor,
                                                  size: 16,
                                                )
                                                : Text(""),
                                            Text(
                                              " ${data['status']}",
                                              style: TextStyle(
                                                color: statusColor,
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
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return showStatusPaymentDialog(
                                          context,
                                          false,
                                          bookings[index].reference,
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    "Confirm",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return showStatusPaymentDialog(
                                        context,
                                        true,
                                        bookings[index].reference,
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  "Reject",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
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

Widget showStatusPaymentDialog(
  BuildContext context,
  bool isreject,
  DocumentReference docRef,
) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    backgroundColor: Colors.white,
    title: Row(
      children: [
        Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
        const SizedBox(width: 8),
        Text(
          isreject ? "Reject Payment" : "Confirm Payment",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    ),
    content: Text(
      isreject
          ? "Are you sure you want to reject the payment?"
          : "Are you sure you want to confirm the payment?",
      style: const TextStyle(fontSize: 11, height: 1.4),
    ),
    actionsPadding: const EdgeInsets.only(right: 4, bottom: 8),
    actionsAlignment: MainAxisAlignment.end,
    actions: [
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          minimumSize: const Size(0, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        icon: const Icon(Icons.close, size: 13),
        label: const Text(
          "No",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 9),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          minimumSize: const Size(0, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        icon: const Icon(Icons.check_circle_outline, size: 13),
        label: const Text(
          "Yes",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 9),
        ),
        onPressed: () async {
          try {

            if (isreject) {
              await docRef.update({'status': 'Rejected'});


            DocumentSnapshot snapshot = await docRef.get();
            Map<String, dynamic> bookingData =
                snapshot.data() as Map<String, dynamic>;
              await FirebaseFirestore.instance
                  .collection('rejected_bookings')
                  .add(bookingData);

                  await docRef.delete();
            } else {
              
              await docRef.update({'status': 'Confirmed'});
            }

            Navigator.of(context).pop();
            showTopFlushbar(
              context,
              message: isreject
                  ? 'Payment has been rejected and backed up.'
                  : 'Payment has been confirmed and backed up.',
              backgroundColor: isreject ? Colors.red : Colors.green,
              icon: isreject ? Icons.cancel : Icons.check_circle_outline,
            );
          } catch (e) {
            Navigator.of(context).pop();
            showTopFlushbar(
              context,
              message: 'Failed to update status: $e',
              backgroundColor: Colors.red,
              icon: Icons.error_outline,
            );
          }
        },
      ),
    ],
  );
}

