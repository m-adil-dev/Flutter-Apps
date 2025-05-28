import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skyways/buttons/elevatedButtons.dart';
import 'package:skyways/screens/BookingsScreens/cancel_bookings.dart';
import 'package:skyways/screens/BookingsScreens/rejected_bookings.dart';
import 'package:skyways/screens/helpers/search_widget_helper.dart';
import 'package:skyways/screens/home_pages/home_page.dart';
import 'package:skyways/screens/home_pages/image_slider_widget.dart';
import 'package:skyways/screens/ticket_related_pages/buses_list_page.dart';
import 'package:skyways/models/user_track_data.dart';
import 'package:skyways/utils/utils.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool isLoading = false;

  void validateCities() async {
    if (userTrackData.fromCity == null || userTrackData.toCity == null) {
      showTopFlushbar(
        context,
        message: "Please select both cities.",
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
      return;
    } else if (userTrackData.fromCity == userTrackData.toCity) {
      showTopFlushbar(
        context,
        message: "The cities cannot be the same.",
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
      return;
    } else if (userTrackData.fromCityAddress == null ||
        userTrackData.toCityAddress == null) {
      showTopFlushbar(
        context,
        message: "Please select both bus stops.",
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      List<Map<String, dynamic>>? priceAndTakenTime =
          await fetchAllTicketRoutes(
            userTrackData.fromCity!,
            userTrackData.toCity!,
          );
      print(priceAndTakenTime);
      userTrackData.pricesList =
          priceAndTakenTime.map((e) => (e['price'] as num).toDouble()).toList();
      userTrackData.departureTime =
          priceAndTakenTime.map((e) => e['departure_time'].toString()).toList();
      userTrackData.destinationTime =
          priceAndTakenTime
              .map((e) => e['destination_time'].toString())
              .toList();

      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => BusesList()));
    } catch (e) {
      showTopFlushbar(
        context,
        message: "$e",
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
            width: double.infinity,
            color: themecolor,
            child: Column(
              children: [
                Text(
                  "Travel Bookings Made Easy",
                  style: TextStyle(color: Colors.white),
                ),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            openCitySearch(context, true, setState);
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText:
                                    userTrackData.fromCity ?? "Leaving From",
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  color: themecolor,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: ElevatedButton.icon(
                            onPressed: () => setState(() => swapChoices()),
                            label: Icon(
                              Icons.swap_vert_outlined,
                              color: themecolor,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(12),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            openCitySearch(context, false, setState);
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: userTrackData.toCity ?? "Going To",
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  color: themecolor,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => pickDate(context, setState),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month, color: themecolor),
                                SizedBox(width: 10),
                                Text(
                                  DateFormat(
                                    "dd MMM, yyyy",
                                  ).format(userTrackData.travelDate),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomButtons.customElevatedButton(
                          text: "Search buss",
                          onPressed: validateCities,
                          isLoading: isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ImageSliderWidget(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButtons().buildStatusCard(
                  "Bookings",
                  Icons.book_online,
                  Colors.green,
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          isStateBooking: true,
                        ),
                      ),
                    );
                  },
                ),
                CustomButtons().buildStatusCard(
                  "Cancelled",
                  Icons.cancel,
                  Colors.orange,
                  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> UserCancelBookings()));
                  },
                ),
                CustomButtons().buildStatusCard(
                  "Rejected",
                  Icons.block,
                  Colors.red,
                  () {  Navigator.push(context, MaterialPageRoute(builder: (context)=> UserRejectedBookings()));
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 120),
        ],
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> fetchAllTicketRoutes(
  String fromCity,
  String toCity,
) async {
  final firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot querySnapshot =
        await firestore
            .collection('routes_info')
            .where('from', isEqualTo: fromCity)
            .where('to', isEqualTo: toCity)
            .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      print(data);
      return {
        'price': data['price'],
        'departure_time': data['departure_time'],
        'destination_time': data['destination_time'],
        'from': data['from'],
        'to': data['to'],
      };
    }).toList();
  } catch (e, stackTrace) {
    debugPrint('🔥 Firestore query failed: $e');
    debugPrint('📌 Stack trace:\n$stackTrace');
    return [];
  }
}
