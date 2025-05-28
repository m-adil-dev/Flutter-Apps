import 'package:flutter/material.dart';
import 'package:skyways/utils/utils.dart';

class BookingDetails{
  static void show(
    BuildContext context,
    final data,
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
                          "${data['travelDate']}",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                         ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Image.asset(LogoPath, height: 70, fit: BoxFit.cover),
                  ),
                        SizedBox(height: 10),
                        Text("${data['departureTime']}"),
                        SizedBox(height: 5),
                        Text("${data['fromCity']}"),
                        SizedBox(height: 10),
                        Text(
                          (data['fromCity'] ?? '').toUpperCase(),
                          style: TextStyle(fontSize: 17),
                        ),
                        Text("${data['fromBusStop']}"),
                        SizedBox(height: 10),
                        Text("${data['destinationTime']}"),
                        SizedBox(height: 5),
                        Text("${data['toCity']}"),
                        SizedBox(height: 10),
                        Text(
                          (data['toCity'] ?? '').toUpperCase(),
                          style: TextStyle(fontSize: 17),
                        ),
                        Text("${data['toBusStop']}"),
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

              ],
            ),
          ),
        );
      },
    );
  }
}