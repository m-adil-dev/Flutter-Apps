import 'package:flutter/material.dart';
import 'package:skyways/buttons/elevatedButtons.dart';
import 'package:skyways/screens/ticket_related_pages/seat_selection_page.dart';
import 'package:skyways/models/user_track_data.dart';
import 'package:skyways/utils/utils.dart';

class BussDetalsSlidingWidget {
  static void show(
    BuildContext context,
    bool showCheckseatbutton,
    {bool isLoading = false}
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Details",
                      style: TextStyle(
                        color: themecolor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: themecolor,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${userTrackData.travelDate.day}-${userTrackData.travelDate.month}-${userTrackData.travelDate.year}",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                         ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Image.asset(LogoPath, height: 70, fit: BoxFit.cover),
                  ),
                        SizedBox(height: 10),
                        Text("${userTrackData.selectedBussDepartureTime}"),
                        SizedBox(height: 5),
                        Text("${userTrackData.fromCity}"),
                        SizedBox(height: 10),
                        Text(
                          (userTrackData.fromCity ?? '').toUpperCase(),
                          style: TextStyle(fontSize: 17),
                        ),
                        Text("${userTrackData.fromCityAddress}"),
                        SizedBox(height: 10),
                        Text("${userTrackData.selectedBussDestinationTime}"),
                        SizedBox(height: 5),
                        Text("${userTrackData.toCity}"),
                        SizedBox(height: 10),
                        Text(
                          (userTrackData.toCity ?? '').toUpperCase(),
                          style: TextStyle(fontSize: 17),
                        ),
                        Text("${userTrackData.toCityAddress}"),
                        SizedBox(height: 20),
                        Text("For refund/cancellation kindly review"),
                        SizedBox(height: 5),
                        Row(
                          spacing: 10,
                          children: [
                            Icon(Icons.directions_bus,color: themecolor,),
                            Text(
                              "Terms and Conditions",
                              style: TextStyle(
                                color: themecolor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                showCheckseatbutton? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total price"),
                            Text(
                              "${userTrackData.price} PKR",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: CustomButtons.customElevatedButtonSecondary(
                          text: "Check Seats",
                          onPressed: () {
                            showSeatSelectionSheet(context);
                          },
                          isLoading: isLoading,
                          textColor: Colors.white,
                          backgroundColor: themecolor,
                        ),
                      ),
                    ],
                  ),
                )
                :Text(""),
              ],
            ),
          ),
        );
      },
    );
  }
}