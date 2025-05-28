  import 'package:flutter/material.dart';
import 'package:skyways/models/user_track_data.dart';
import 'package:skyways/utils/utils.dart';

Widget buildLegend() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: [
        legendItem(themecolor, "Reserved"),
        legendItem(Colors.green, "Selected"),
        legendItem(Colors.white, "Available", border: true),
      ],
    );
  }

  Widget legendItem(Color color, String label, {bool border = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            border: border ? Border.all(color: Colors.grey) : null,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget buildSeatGrid(BuildContext context, setState) {
    List<Widget> rows = [];
    int seatNumber = 1;

    for (int i = 0; i < 11; i++) {
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            seatBox(seatNumber++, context, setState),
            seatBox(seatNumber++, context, setState),
              const SizedBox(width: 24),
            seatBox(seatNumber++, context, setState),
            seatBox(seatNumber++, context, setState),
            ],
          ),
        ),
      );
    }

    rows.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) => seatBox(seatNumber++, context, setState)),
        ),
      ),
    );

    return Column(children: rows);
  }


Widget seatBox(int seatNumber, BuildContext context, setState) {
  final isReserved = userTrackData.reservedSeats.contains(seatNumber);

  return GestureDetector(
    onTap: () => onSeatTap(seatNumber, context, setState),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: seatColor(seatNumber),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(1, 2),
              )
            ],
            border: Border.all(
              color: isReserved ? themecolor : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: isReserved
                ? const Icon(Icons.lock, color: Colors.white, size: 18)
                : Text(
                    "$seatNumber",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    ),
  );
}


  void onSeatTap(int seatNumber, BuildContext context, setState) {
    if (userTrackData.reservedSeats.contains(seatNumber)) return;

    setState(() {
      if (userTrackData.selectedSeats.contains(seatNumber)) {
        userTrackData.selectedSeats.remove(seatNumber);
      } else if (userTrackData.selectedSeats.length < userTrackData.maxSeats) {
        userTrackData.selectedSeats.add(seatNumber);
      } else {
showTopFlushbar(
  context,
  message: "You can book a maximum of 4 seats at a time.",
  backgroundColor: Colors.red,
  icon: Icons.warning,
);

      }
    });
  }

  Color seatColor(int seatNumber) {
    if (userTrackData.reservedSeats.contains(seatNumber)) return themecolor;
    if (userTrackData.selectedSeats.contains(seatNumber)) return Colors.green;
    return Colors.white;
  }