import 'package:flutter/material.dart';
import 'package:skyways/models/city_info.dart';
import 'package:skyways/utils/utils.dart';


class CitySearchScreen extends StatefulWidget {
  @override
  _CitySearchScreenState createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final List<CityInfo> allCities = [
    CityInfo(name: "Karachi", busStopAddress: "Sohrab Goth Terminal"),
    CityInfo(name: "Lahore", busStopAddress: "Thokar Niaz Baig Terminal"),
    CityInfo(name: "Islamabad", busStopAddress: "Pir Wadhai Terminal"),
    CityInfo(name: "Rawalpindi", busStopAddress: "Gawalmandi Terminal"),
    CityInfo(name: "Faisalabad", busStopAddress: "Railway Station Terminal"),
    CityInfo(name: "Multan", busStopAddress: "Cantt Terminal"),
    CityInfo(name: "Peshawar", busStopAddress: "General Bus Stand"),
    CityInfo(name: "Quetta", busStopAddress: "Naseerabad Terminal"),
    CityInfo(name: "Sialkot", busStopAddress: "Sialkot Bus Stand"),
    CityInfo(name: "Gujranwala", busStopAddress: "Gujranwala Bus Terminal"),
    CityInfo(name: "Sukkur", busStopAddress: "Sukkur Bus Terminal"),
    CityInfo(name: "Hyderabad", busStopAddress: "Hyderabad Bypass Terminal"),
    CityInfo(name: "Mardan", busStopAddress: "Mardan General Bus Stand"),
    CityInfo(name: "Bahawalpur", busStopAddress: "Bahawalpur General Bus Stand"),
    CityInfo(name: "Sargodha", busStopAddress: "Sargodha General Bus Stand"),
    CityInfo(name: "Sahiwal", busStopAddress: "Sahiwal Bus Terminal"),
    CityInfo(name: "Kasur", busStopAddress: "Kasur General Bus Stand"),
    CityInfo(name: "Bannu", busStopAddress: "Bannu General Bus Stand"),
  ];



  List<CityInfo> filteredCities = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredCities = allCities;
  }

  void _filterCities(String query) {
    final results = allCities
        .where((city) => city.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Sort results to show exact matches first
    if (results.isNotEmpty) {
      results.sort((a, b) {
        if (a.name.toLowerCase() == query.toLowerCase()) return -1;
        if (b.name.toLowerCase() == query.toLowerCase()) return 1;
        return a.name.compareTo(b.name);
      });
    }

    setState(() {
      searchQuery = query;
      filteredCities = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search City",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: themecolor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _filterCities,
              decoration: InputDecoration(
                hintText: "Search for a city...",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: themecolor,
                ),
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCities.length,
              itemBuilder: (context, index) {
                final city = filteredCities[index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  leading: Icon(
                    Icons.location_city,
                    color: themecolor,
                  ),
                  title: Text(
                    city.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    city.busStopAddress,
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.pop(context, city); // Return CityInfo object
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
