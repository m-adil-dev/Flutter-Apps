import 'package:flutter/material.dart';
import 'package:skyways/screens/BookingsScreens/booking_details.dart';
import 'package:skyways/utils/utils.dart';

class ViewBookings extends StatelessWidget {
  final data;
  const ViewBookings({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: themecolor,
        title: Text('Booking Details', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(),
            const SizedBox(height: 16),
            _buildBusInfoCard(context),
            const SizedBox(height: 16),
            _buildPriceSummary(),
            const SizedBox(height: 16),
            _buildTravelerInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ID', style: TextStyle(color: Colors.grey)),
                if(data["orderId"] != null)
                  Text(data['orderId'], style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Booking Date', style: TextStyle(color: Colors.grey)),
                Text(
                  data["bookingDate"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusInfoCard(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.asset(
                    LogoPath,
                    height: 30,
                    width: 30, // Optional: keep square image
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Text('Sky Ways', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${data['departureTime']}  ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "- ",
                  style: TextStyle(
                    color: themecolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset("lib/assets/bus.png", height: 15),
                Text(
                  " -",
                  style: TextStyle(
                    color: themecolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    '   ${data['destinationTime']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${data['fromCity']} ',
                    style: TextStyle(color: themecolor),
                  ),
                ),
                Icon(Icons.arrow_right_alt_outlined, color: themecolor),
                Expanded(child: Text('    ${data['toCity']}', style: TextStyle(color: themecolor))),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${data['fromBusStop']}  ',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.arrow_right_alt_outlined, color: themecolor),
                Expanded(
                  child: Text(
                    '    ${data['toBusStop']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Luxury '),
                Icon(Icons.headphones_outlined, color: themecolor, size: 18),
                Icon(Icons.monitor, color: themecolor, size: 18),
                SizedBox(width: 8),
                const Text(
                  "Refundable",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Selected Seats'),
                SizedBox(width: 10),

                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          (data['selectedSeats'] as List<dynamic>)
                              .map<Widget>(
                                (seat) => Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "S - $seat",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                          backgroundColor: themecolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                onPressed: () {
                  BookingDetails.show(
                     context,
                    data,
                  );
                },
                child: const Text('Details',style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themecolor,
              ),
            ),
            Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Seat Price',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text('PKR ${data['totalPrice']/data['selectedSeats'].length}'),
              ],
            ),
            Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total  Seats',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text('${data['selectedSeats'].length}'),
              ],
            ),
            Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Ammount', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                  'PKR ${data['totalPrice']}',
                  style: TextStyle(
                    fontSize: 18,
                    color: themecolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelerInfo(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: SizedBox(
    width: MediaQuery.of(context).size.width,   
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Travelers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Full Name',
                    style: TextStyle(
                      color: themecolor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('  ${data['title']} ${data['firstName']}  ${data['lastName']}'),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Date of Birth',
                    style: TextStyle(
                      color: themecolor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(data['dateOfBirth']),
                ],
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.phone, color: themecolor),
                  Text(' ${data['mobile']}'),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.email, color: themecolor),
                  Text(' ${data['email']}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
