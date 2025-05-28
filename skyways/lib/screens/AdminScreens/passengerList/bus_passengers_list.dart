import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:skyways/screens/AdminScreens/passengerList/PassengerListScreen.dart';
import 'package:skyways/utils/utils.dart';

class AdminBookingSearchScreen extends StatefulWidget {
  @override
  _AdminBookingSearchScreenState createState() =>
      _AdminBookingSearchScreenState();
}

class _AdminBookingSearchScreenState extends State<AdminBookingSearchScreen> {

  final _fromCityController = TextEditingController();
  final _toCityController = TextEditingController();
  DateTime? _selectedDate;

  List<Map<String, dynamic>> _routes = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchTodayRoutes();
  }

  Future<void> _fetchTodayRoutes() async {
    setState(() => _loading = true);
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collectionGroup('user_bookings')
          .where('travelDate', isEqualTo: todayStr)
          .get();

      final allBookings =
          snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      final uniqueRoutes = <String, Map<String, dynamic>>{};

      for (var booking in allBookings) {
        final key =
            "${booking['fromCity']}_${booking['toCity']}_${booking['departureTime']}";
        if (!uniqueRoutes.containsKey(key)) {
          uniqueRoutes[key] = {
            'fromCity': booking['fromCity'],
            'toCity': booking['toCity'],
            'departureTime': booking['departureTime'],
            'destinationTime': booking['destinationTime'],
            'travelDate': booking['travelDate'],
          };
        }
      }

      setState(() {
        _routes = uniqueRoutes.values.toList();
        _loading = false;
      });
    } catch (e) {
      print('Error fetching today\'s routes: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> _searchRoutes() async {
    setState(() => _loading = true);

    final fromCity = _fromCityController.text.trim();
    final toCity = _toCityController.text.trim();
    final formattedDate =
        _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : null;

    try {
      Query query =
          FirebaseFirestore.instance.collectionGroup('user_bookings');

      if (formattedDate != null) {
        query = query.where('travelDate', isEqualTo: formattedDate);
      }
      if (fromCity.isNotEmpty) {
        query = query.where('fromCity', isEqualTo: fromCity);
      }
      if (toCity.isNotEmpty) {
        query = query.where('toCity', isEqualTo: toCity);
      }

      QuerySnapshot snapshot = await query.get();
      final results = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      setState(() {
        _routes = results;
        _loading = false;
      });
    } catch (e) {
      print('Search error: $e');
      setState(() => _loading = false);
    }
  }

  void _openPassengerList(Map<String, dynamic> route) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassengerListScreen(
          route: route,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _fromCityController.text.isNotEmpty ||
        _toCityController.text.isNotEmpty ||
        _selectedDate != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Passenger List'),
        backgroundColor: themecolor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInputField(
              controller: _fromCityController,
              label: 'From City',
              icon: Icons.location_on_outlined,
            ),
            _buildInputField(
              controller: _toCityController,
              label: 'To City',
              icon: Icons.flag_outlined,
            ),
            ListTile(
              tileColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: Text(
                _selectedDate == null
                    ? 'Select Travel Date'
                    : 'Travel Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                style: TextStyle(color: Colors.black87),
              ),
              trailing: Icon(Icons.calendar_today, color: themecolor),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _searchRoutes,
              icon: Icon(Icons.search,color: Colors.white,),
              label: Text('Search',style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: themecolor,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            _loading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isSearching)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            'Showing all routes for today',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (_routes.isEmpty)
                        Center(child: Text('No routes found')),
                      ..._routes.map((route) {
                        final departureTime = route['departureTime'] ?? 'N/A';
                        final destinationTime = route['destinationTime'] ?? 'N/A';

                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 6,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          color: Colors.white,
                          child: ListTile(
                            leading: Icon(Icons.directions_bus, color: themecolor),
                            title: Text('${route['fromCity']} → ${route['toCity']}',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date: ${route['travelDate']}'),
                                Text('Departure: $departureTime'),
                                Text('Destination: $destinationTime'),
                                SizedBox(height: 10,),
Row(
    mainAxisAlignment: MainAxisAlignment.end,
  children: [
    ElevatedButton(
      onPressed: () { _openPassengerList(route);},
      style: ElevatedButton.styleFrom(
        backgroundColor: themecolor,
      ),
      child: Text(
        'View Passengers',
        style: TextStyle(color: Colors.white,),
      ),
    ),
  ],
)

                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: themecolor),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
