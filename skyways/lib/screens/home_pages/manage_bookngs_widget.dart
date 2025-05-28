import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:skyways/utils/utils.dart';
import 'package:skyways/screens/BookingsScreens/view_bookings.dart';

class ManageBookingsWidget extends StatelessWidget {
  const ManageBookingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('You must be logged in to view your tickets.'),
      );
    }

    debugPrint('Current user UID: ${user.uid}');

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('bookings')
              .doc(user.uid)
              .collection('user_bookings')
              .orderBy('bookingDate', descending: true)
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
          debugPrint('No booking data found for user: ${user.uid}');
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Image.asset(
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
                      const SizedBox(height: 12),

                      // Time and City Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['departureTime'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            calculateDuration(
                              data['departureTime'],
                              data['destinationTime'],
                            ),
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            data['destinationTime'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['fromCity'],
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            data['toCity'],
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Order Status ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(children: [
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
                                      ],)
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
                                              (context) => ViewBookings(data: data),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "View",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  data['status'] == 'Confirmed' ? ElevatedButton(
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
                                        bookings[index].reference,
                                      );
                                    },
                                  );
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ): Text(""),
                                ],
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
    );
  }
}

String calculateDuration(String startTime, String endTime) {
  // Define a fixed date for both times
  final date = DateTime(2025, 1, 1); // arbitrary date

  // Parse the start and end times using DateFormat
  final format = DateFormat('hh:mm a');

  DateTime start = format.parse(startTime);
  DateTime end = format.parse(endTime);

  // Attach same date
  start = DateTime(date.year, date.month, date.day, start.hour, start.minute);
  end = DateTime(date.year, date.month, date.day, end.hour, end.minute);

  // If end is before start (e.g., crosses midnight), add one day
  if (end.isBefore(start)) {
    end = end.add(const Duration(days: 1));
  }

  final duration = end.difference(start);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  return '${hours}h ${minutes}m';
}


Widget showStatusPaymentDialog(
  BuildContext context,
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
          "Cancel",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    ),
    content: Text(
      "Are you sure you want to cancel the booking?",
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

              await docRef.update({'status': 'Cancelled'});
            DocumentSnapshot snapshot = await docRef.get();
            Map<String, dynamic> bookingData =
                snapshot.data() as Map<String, dynamic>;
              await FirebaseFirestore.instance
                  .collection('canceled_bookings')
                  .add(bookingData);

                  // await docRef.delete();
            

            Navigator.of(context).pop();
showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
      title: Row(
        children: [
          Icon(Icons.cancel_outlined, color: Colors.red.shade700, size: 26),
          const SizedBox(width: 10),
          Text(
            'Booking Cancelled',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Your booking has been cancelled and backed up successfully.',
            style: TextStyle(fontSize: 15, height: 1.4),
            textAlign: TextAlign.left,
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You will receive the refund amount within 48 hours.',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'OK',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  },
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
