import 'package:flutter/material.dart';
import 'package:skyways/screens/ticket_related_pages/city_search_screen.dart';
import 'package:skyways/models/city_info.dart';
import 'package:skyways/models/user_track_data.dart';

Future<void> openCitySearch(BuildContext context, bool isFromCity,setState) async {
  final CityInfo? city = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CitySearchScreen()),
  );

  if (city != null) {
    setState(() {
      if (isFromCity) {
        userTrackData.fromCity = city.name;
        userTrackData.fromCityAddress = city.busStopAddress;
      } else {
        userTrackData.toCity = city.name;
        userTrackData.toCityAddress = city.busStopAddress;
      }
    });
  }
}

  void swapChoices() {
    String? temp = userTrackData.fromCity;
    userTrackData.fromCity = userTrackData.toCity;
    userTrackData.toCity = temp;

    String? tempStop = userTrackData.fromCityAddress;
    userTrackData.fromCityAddress = userTrackData.toCityAddress;
    userTrackData.toCityAddress = tempStop;

  }

  Future<void> pickDate(BuildContext context ,setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: userTrackData.travelDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2060),
    );
    if (picked != null && picked != userTrackData.travelDate) {
      setState(() {
        userTrackData.travelDate = picked;
      });
    }
  }
