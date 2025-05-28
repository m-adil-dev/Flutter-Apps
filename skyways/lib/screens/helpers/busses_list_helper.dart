import 'package:flutter/material.dart';
import 'package:skyways/buttons/elevatedButtons.dart';
import 'package:skyways/screens/ticket_related_pages/buss_detals_sliding_widget.dart';
import 'package:skyways/screens/ticket_related_pages/seat_selection_page.dart';
import 'package:skyways/models/user_track_data.dart';
import 'package:skyways/utils/utils.dart';

Widget buildBusCard(
  BuildContext context,
  String departureTime,
  double price,
  String arrivalTime, {
  bool isLoading = false,
}) {
  return Card(
    color: Colors.white,
    elevation: 3,
    margin: const EdgeInsets.only(bottom: 20),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: Image.asset(LogoPath, height: 70, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                departureTime,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "   -   ",
                style: TextStyle(
                  color: themecolor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset("lib/assets/bus.png", height: 15),
              Text(
                "   -   ",
                style: TextStyle(
                  color: themecolor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                arrivalTime,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              "${userTrackData.fromCity} - ${userTrackData.toCity}",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),

          // Departure Stop
          buildStopRow("Departure Bus Stop:", userTrackData.fromCityAddress!),

          const SizedBox(height: 20),

          // Arrival Stop
          buildStopRow("Destination Bus Stop:", userTrackData.toCityAddress!),

          const SizedBox(height: 20),
          Row(
            children: [
              const Text("Luxury", style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 10),
              const Icon(Icons.headphones, color: Colors.grey, size: 18),
              const Icon(Icons.monitor, color: Colors.grey, size: 18),
              const SizedBox(width: 10),
              const Text(
                "Refundable",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Price & Buttons
          Row(
            children: [
              // Price
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total price",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "RS. ${price}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Buttons
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButtons.customElevatedButtonSecondary(
                        text: "Details",
                        onPressed: () {
                          userTrackData.selectedBussDepartureTime =
                              departureTime;
                          userTrackData.selectedBussDestinationTime =
                              arrivalTime;
                          userTrackData.price =
                              price;
                              print(userTrackData.price);
                          BussDetalsSlidingWidget.show(context, true);
                        },
                        isLoading: isLoading,
                        textColor: themecolor,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButtons.customElevatedButtonSecondary(
                        text: "Check Seats",
                        onPressed: () {
                          userTrackData.selectedBussDepartureTime = departureTime;
                          userTrackData.selectedBussDestinationTime = arrivalTime;
                          userTrackData.price = price;
                          showSeatSelectionSheet(context);
                          

                        },
                        isLoading: isLoading,
                        textColor: Colors.white,
                        backgroundColor: themecolor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildStopRow(String title, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(Icons.directions_bus, color: themecolor),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: themecolor),
          ),
        ],
      ),
      const SizedBox(height: 6),
      Card(
        elevation: 4,
        color: const Color.fromARGB(255, 255, 235, 217),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(Icons.location_on, color: themecolor),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
