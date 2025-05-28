import 'package:flutter/material.dart';
import 'package:skyways/models/user_track_data.dart';
import 'package:skyways/screens/booking_steps/booking_form_page.dart';
import 'package:skyways/screens/ticket_related_pages/buss_detals_sliding_widget.dart';
import 'package:skyways/utils/utils.dart';

class TicketDetailsPage extends StatelessWidget {
  const TicketDetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7fafc),
      appBar: AppBar(
        title: const Text('Ticket Details'),
        backgroundColor: Colors.white,
        foregroundColor: themecolor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTicketCard(context),
            const SizedBox(height: 20),
            const Text(
              "For refund/cancellation kindly review",
              style: TextStyle(fontSize: 14),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.directions_bus, size: 18, color: themecolor),
              label: Text(
                "Terms and Conditions",
                style: TextStyle(
                  color: themecolor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildTicketCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                LogoPath,
                height: 40,
                width: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              const Text(
                "Sky ways",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(userTrackData.selectedBussDepartureTime!, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                "   - ",
                style: TextStyle(color: themecolor, fontWeight: FontWeight.bold),
              ),
              Image.asset("lib/assets/bus.png", height: 15),
              Text(
                " -   ",
                style: TextStyle(color: themecolor, fontWeight: FontWeight.bold),
              ),
              Text(userTrackData.selectedBussDestinationTime!, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 5),
          Text("${userTrackData.fromCity} - ${userTrackData.toCity}"),
          const SizedBox(height: 5),
          Row(
            children: [
              Flexible(
                child: Text(
                  userTrackData.fromCityAddress!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(width: 5),
              Icon(Icons.arrow_right_alt_rounded, color: themecolor),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  userTrackData.toCityAddress!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Row(
            children: [
              Text("Luxury", style: TextStyle(color: Colors.grey)),
              SizedBox(width: 10),
              Icon(Icons.headphones, color: Colors.grey, size: 18),
              Icon(Icons.monitor, color: Colors.grey, size: 18),
              SizedBox(width: 10),
              Text(
                "Refundable",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
Row(
  children: [
    const Text(
      "Selected Seats:",
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    const SizedBox(width: 8),
    
    // 👇 Wrap scrollable part with Flexible
    Flexible(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: userTrackData.selectedSeats.map((seat) => Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "S - $seat",
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          )).toList(),
        ),
      ),
    ),
  ],
),
   
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                BussDetalsSlidingWidget.show(
                  context,
                  false,
                  );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                maximumSize: const Size(105, 35),
                minimumSize: const Size(105, 35),
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  side: BorderSide(color: themecolor, width: 1.5),
                ),
              ),
              child: Text(
                "Details",
                style: TextStyle(color: themecolor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Review Details", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  "PKR ${userTrackData.totalPrice}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ElevatedButton(
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BookingFormPage() ),
  );
},

            style: ElevatedButton.styleFrom(
              backgroundColor: themecolor,
              maximumSize: const Size(105, 35),
              minimumSize: const Size(105, 35),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
            child: const Text(
              "Continue",
              style: TextStyle(color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }
}
