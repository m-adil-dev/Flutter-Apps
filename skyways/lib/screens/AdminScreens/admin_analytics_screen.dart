import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:skyways/utils/utils.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  double totalRevenue = 0;
  double weekRevenue = 0;
  double lastWeekRevenue = 0;
  double monthRevenue = 0;
  double lastMonthRevenue = 0;
  double yearRevenue = 0;
  double lastYearRevenue = 0;

  int totalBookings = 0;
  int totalSeats = 0;
  int maleCount = 0;
  int femaleCount = 0;

  Map<String, int> bookingsPerDay = {};
  Map<String, int> topRoutes = {};

  @override
  void initState() {
    super.initState();
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    final firestore = FirebaseFirestore.instance;
    final bookingsCollection = await firestore.collectionGroup('user_bookings').get();

    final now = DateTime.now();
    final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
    final lastWeekEnd = thisWeekStart.subtract(const Duration(seconds: 1));
    final thisMonthStart = DateTime(now.year, now.month);
    final lastMonthStart = DateTime(now.year, now.month - 1);
    final lastMonthEnd = thisMonthStart.subtract(const Duration(seconds: 1));
    final thisYearStart = DateTime(now.year);
    final lastYearStart = DateTime(now.year - 1);
    final lastYearEnd = thisYearStart.subtract(const Duration(seconds: 1));

    double week = 0, lastWeek = 0, month = 0, lastMonth = 0, year = 0, lastYear = 0;
    int bookings = 0, seats = 0, male = 0, female = 0;
    Map<String, int> dayCount = {};
    Map<String, int> routeCount = {};

    for (var doc in bookingsCollection.docs) {
      final data = doc.data();
      final price = (data['totalPrice'] ?? 0).toDouble();
      final travelDateStr = data['travelDate'];
      if (travelDateStr == null) continue;

      DateTime date;
      try {
        date = DateTime.tryParse(travelDateStr) ?? DateFormat('yyyy-MM-dd').parse(travelDateStr);
      } catch (_) {
        continue;
      }

      bookings++;
      totalRevenue += price;
      List<dynamic> selectedSeats = data['selectedSeats'] ?? [];
      seats += selectedSeats.length;

      final title = data['title'];
      if (title == "Mr") male++;
      if (title == "Mrs" || title == "Ms") female++;

      if (date.isAfter(thisWeekStart)) week += price;
      if (date.isAfter(lastWeekStart) && date.isBefore(lastWeekEnd)) lastWeek += price;
      if (date.isAfter(thisMonthStart)) month += price;
      if (date.isAfter(lastMonthStart) && date.isBefore(lastMonthEnd)) lastMonth += price;
      if (date.isAfter(thisYearStart)) year += price;
      if (date.isAfter(lastYearStart) && date.isBefore(lastYearEnd)) lastYear += price;

      String dateKey = DateFormat('yyyy-MM-dd').format(date);
      dayCount[dateKey] = (dayCount[dateKey] ?? 0) + 1;

      String route = "${data['fromCity']} → ${data['toCity']}";
      routeCount[route] = (routeCount[route] ?? 0) + 1;
    }

    setState(() {
      weekRevenue = week;
      lastWeekRevenue = lastWeek;
      monthRevenue = month;
      lastMonthRevenue = lastMonth;
      yearRevenue = year;
      lastYearRevenue = lastYear;
      totalBookings = bookings;
      totalSeats = seats;
      maleCount = male;
      femaleCount = female;
      bookingsPerDay = dayCount;
      topRoutes = routeCount;
    });
  }

  Widget buildCard(String title, String value, IconData icon, Color color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth < 270 ? double.infinity : 250,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                    const SizedBox(height: 4),
                    Text(value, style: const TextStyle(fontSize: 20)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildComparisonCard(String title, double current, double previous, Color color) {
    double diff = current - previous;
    String trend = diff >= 0 ? "↑" : "↓";
    double percentChange = previous > 0 ? (diff / previous * 100) : 100;
    return Container(
      width: 250,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
          const SizedBox(height: 8),
          Text("PKR ${current.toStringAsFixed(0)}", style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            "$trend ${percentChange.abs().toStringAsFixed(1)}% from previous",
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }

Widget buildPieChart() {
  int total = maleCount + femaleCount;
  double malePercent = total > 0 ? (maleCount / total * 100) : 0;
  double femalePercent = total > 0 ? (femaleCount / total * 100) : 0;

  return AspectRatio(
    aspectRatio: 1.5,
    child: PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: maleCount.toDouble(),
            title: 'Male ${malePercent.toStringAsFixed(1)}%',
            color: Colors.blue,
            radius: 60,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          PieChartSectionData(
            value: femaleCount.toDouble(),
            title: 'Female ${femalePercent.toStringAsFixed(1)}%',
            color: Colors.pinkAccent,
            radius: 60,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    ),
  );
}

  Widget buildBarChart(Map<String, int> data, String title, {bool topFiveOnly = false}) {
    var entries = data.entries.toList();

    if (topFiveOnly) {
      entries.sort((a, b) => b.value.compareTo(a.value));
      entries = entries.take(5).toList();
    } else {
      entries.sort((a, b) => a.key.compareTo(b.key));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("📈 $title", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: 200,
            width: entries.length * 100,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: entries
                    .map((e) => BarChartGroupData(x: entries.indexOf(e), barRods: [
                          BarChartRodData(
                            toY: e.value.toDouble(),
                            color: Colors.teal,
                            width: 24,
                          )
                        ]))
                    .toList(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (index, _) {
                        final label = entries[index.toInt()].key;
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            label.length > 12 ? '${label.substring(0, 12)}...' : label,
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                buildComparisonCard("This Week vs Last Week", weekRevenue, lastWeekRevenue, Colors.blue),
                buildComparisonCard("This Month vs Last Month", monthRevenue, lastMonthRevenue, Colors.green),
                buildComparisonCard("This Year vs Last Year", yearRevenue, lastYearRevenue, Colors.deepPurple),
                buildCard("Total Bookings", "$totalBookings", Icons.book_online, themecolor),
                buildCard("Total Revenue", "PKR ${totalRevenue.toStringAsFixed(0)}", Icons.attach_money,themecolor),
                buildCard("Total Seats", "$totalSeats", Icons.event_seat, themecolor),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("👥 Gender Distribution", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 250,
              child: buildPieChart(),
            ),
            // buildPieChart(),
            const SizedBox(height: 20),
            buildBarChart(bookingsPerDay, "Bookings Per Day (Last 7 Days)"),
            const SizedBox(height: 20),
            buildBarChart(topRoutes, "Top 5 Routes", topFiveOnly: true),
          ],
        ),

    );
  }
}