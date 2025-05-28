import 'package:flutter/material.dart';
import 'package:skyways/utils/utils.dart';

class SkywaysTermsScreen extends StatelessWidget {
  const SkywaysTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: themecolor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Skyways:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themecolor,
              ),
            ),
            const SizedBox(height: 10),
            ...[
              "Free cancellation on tickets if cancellation is initiated 24 hours before departure.",
              "In case of ticket cancellation within 24 hours of bus departure, the ticket will become non-refundable.",
              "Seat adjustment is applicable up to 1 hour before departure.",
              "The ticket will become non-refundable/non-transferable 1 hour before departure.",
              "Any ticket cancelled after bus departure is non-refundable and non-changeable.",
              "If a passenger having advance ticket reports at the Terminal Office after the bus departs then the ticket will not be refunded.",
              "The bus will depart as per the scheduled departure time and will stop only at Skyways’ designated stopover.",
              "Luggage weighing up to 15 KGs is allowed per ticket free of charge on the bus. Excess baggage shall be charged as per Skyways policy.",
              "Skyways shall not be responsible for any loss/damage to hand luggage.",
              "In case of luggage (other than hand luggage) is misplaced/lost from the compartment, the passengers shall be compensated in terms of weight (and not in terms of value) as per the compensation policy of Skyways (which is presently Rs. 100/- per Kg).",
              "Pets / Animals are not allowed in the bus or its luggage compartment.",
              "Chemicals, Oil Cane, Gas Cylinders (Full or Empty), Alcohol, Drugs, Weapons, Explosives, Liquids, and Perishable Items are not allowed in the bus or its luggage compartment.",
              "Any passenger who is drunk or in a condition which is not appropriate they will not be allowed to travel on the bus even if he/she has bought the ticket.",
            ].map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• ", style: TextStyle(fontSize: 18)),
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
