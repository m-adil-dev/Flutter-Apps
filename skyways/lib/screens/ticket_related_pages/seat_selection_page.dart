import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skyways/screens/helpers/seats_selection_page_helper.dart';
import 'package:skyways/screens/ticket_related_pages/review_ticket_details.dart';
import 'package:skyways/models/user_track_data.dart';
import 'package:skyways/utils/utils.dart';

void showSeatSelectionSheet(
  BuildContext context,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const SeatSelectionContent(),
  );
}

class SeatSelectionContent extends StatefulWidget {
  const SeatSelectionContent({super.key});

  @override
  State<SeatSelectionContent> createState() => _SeatSelectionContentState();
}

class _SeatSelectionContentState extends State<SeatSelectionContent> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    userTrackData.selectedSeats.clear();
    fetchReservedSeats();
  }

  Future<void> fetchReservedSeats() async {
    try {
      setState(() {
        isLoading = true;
      });

      final reserved = <int>{};

      final querySnapshot = await FirebaseFirestore.instance
          .collectionGroup('user_bookings')
          .get();

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final travelDate = data['travelDate'];

        if (travelDate == null) continue;

        if (data['fromCity'] == userTrackData.fromCity &&
            data['toCity'] == userTrackData.toCity &&
            data['departureTime'] == userTrackData.selectedBussDepartureTime &&
            data['travelDate'] == formatDate(userTrackData.travelDate)) {
          final seats = data['selectedSeats'];
          if (seats is List) {
            reserved.addAll(seats.cast<int>());
          }
        }
      }

      setState(() {
        userTrackData.reservedSeats.addAll(reserved);
      });
    } catch (e) {
      print("❌ Error fetching reserved seats: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    userTrackData.totalPrice = userTrackData.selectedSeats.length * userTrackData.price!;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.7,
      minChildSize: 0.7,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: themecolor),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: "Close",
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Choose Your Seats",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildLegend(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Available: ${userTrackData.totalSeats - userTrackData.reservedSeats.length - userTrackData.selectedSeats.length}/${userTrackData.totalSeats}",
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                      Image.asset("lib/assets/steering_wheel.png", height: 28),
                    ],
                  ),
                  const SizedBox(height: 16),
                  buildSeatGrid(context, setState),
                ],
              ),
            ),
            if (userTrackData.selectedSeats.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: themecolor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.event_seat, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  "Selected",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

Expanded(
  child: Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        userTrackData.selectedSeats.join(', '),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: const TextStyle(fontSize: 14),
      ),
    ),
  ),
),

                        ],

                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total: PKR ${userTrackData.totalPrice}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (userTrackData
                                        .selectedSeats.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Please select at least one seat.")),
                                      );
                                      return;
                                    }

                                    setState(() => isLoading = true);

                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TicketDetailsPage(),
                                      ),
                                    );

                                    setState(() => isLoading = false);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themecolor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              elevation: 4,
                            ),
                            child: const Text(
                              "Continue",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // Loading overlay
            if (isLoading)
              Container(
                color: Colors.white.withOpacity(0.7),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
