import 'package:flutter/material.dart';
import 'package:skyways/screens/helpers/busses_list_helper.dart';
import 'package:skyways/models/user_track_data.dart';
import 'package:skyways/utils/utils.dart';

class BusesList extends StatelessWidget {
  const BusesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String>? departureTimes = userTrackData.departureTime;
    final List<String>? destinationTimes = userTrackData.destinationTime;
    final List<double>? pricesList = userTrackData.pricesList;

    final bool hasNoBuses = departureTimes == null || departureTimes.isEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: themecolor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(userTrackData.fromCity ?? '', style: TextStyle(color: themecolor)),
                Icon(Icons.arrow_right_alt_outlined, color: themecolor),
                Text(userTrackData.toCity ?? '', style: TextStyle(color: themecolor)),
              ],
            ),
            Row(
              children: [
                Text(
                  "${userTrackData.travelDate.day}-${userTrackData.travelDate.month}-${userTrackData.travelDate.year}",
                  style: TextStyle(color: themecolor),
                ),
              ],
            ),
          ],
        ),
      ),
      body: hasNoBuses
          ? Center(
              child: Text(
                "No bus found for this route",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Select your Bus",
                      style: TextStyle(
                        color: themecolor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 10),
                    ...List.generate(departureTimes.length, (index) {
                      return buildBusCard(
                        context,
                        departureTimes[index],
                        pricesList![index],
                        destinationTimes![index],
                      );
                    }),
                  ],
                ),
              ),
            ),
    );
  }
}
