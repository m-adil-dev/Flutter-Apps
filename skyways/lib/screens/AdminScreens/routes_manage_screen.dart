import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skyways/utils/utils.dart';

class RoutesManagerScreen extends StatefulWidget {
  @override
  State<RoutesManagerScreen> createState() => _RoutesManagerScreenState();
}

class _RoutesManagerScreenState extends State<RoutesManagerScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController searchFromCtrl = TextEditingController();
  final TextEditingController searchToCtrl = TextEditingController();
  final TextEditingController fromCtrl = TextEditingController();
  final TextEditingController toCtrl = TextEditingController();
  final TextEditingController depTimeCtrl = TextEditingController();
  final TextEditingController destTimeCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();

  String _fromQuery = '';
  String _toQuery = '';

  void _searchRoutes() {
    setState(() {
      _fromQuery = searchFromCtrl.text.trim().toLowerCase();
      _toQuery = searchToCtrl.text.trim().toLowerCase();
    });
  }

  void _clearControllers() {
    fromCtrl.clear();
    toCtrl.clear();
    depTimeCtrl.clear();
    destTimeCtrl.clear();
    priceCtrl.clear();
  }

  Future<void> _addOrUpdateRoute({String? docId}) async {
    final data = {
      'from': fromCtrl.text.trim(),
      'to': toCtrl.text.trim(),
      'departure_time': depTimeCtrl.text.trim(),
      'destination_time': destTimeCtrl.text.trim(),
      'price': int.tryParse(priceCtrl.text.trim()) ?? 0,
    };

    if (docId == null) {
      await _firestore.collection('routes_info').add(data);
      showTopFlushbar(
        context,
        message: "Route added successfully",
        backgroundColor: Colors.green, // or your `themecolor`
        icon: Icons.check,
      );
    } else {
      await _firestore.collection('routes_info').doc(docId).update(data);
      showTopFlushbar(
        context,
        message: "Route updated successfully",
        backgroundColor: Colors.green, // or your `themecolor`
        icon: Icons.check,
      );
    }

    _clearControllers();
    Navigator.pop(context);
  }

  Future<void> _deleteRoute(String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Route"),
        content: const Text("Are you sure you want to delete this route?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );

    if (confirm == true) {
      await _firestore.collection('routes_info').doc(docId).delete();
showTopFlushbar(
  context,
  message: "Route deleted",
  backgroundColor: Colors.red, // or your `themecolor`
  icon: Icons.delete,
);

    }
  }

  void _showRouteDialog({DocumentSnapshot? doc}) {
    if (doc != null) {
      fromCtrl.text = doc['from'];
      toCtrl.text = doc['to'];
      depTimeCtrl.text = doc['departure_time'];
      destTimeCtrl.text = doc['destination_time'];
      priceCtrl.text = doc['price'].toString();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth <= 350;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Text(doc == null ? 'Add New Route' : 'Edit Route', style: TextStyle(color: themecolor)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(fromCtrl, 'From'),
              _buildTextField(toCtrl, 'To'),
              _buildTextField(depTimeCtrl, 'Departure Time (e.g. 08:00 AM)'),
              _buildTextField(destTimeCtrl, 'Destination Time (e.g. 11:00 AM)'),
              _buildTextField(priceCtrl, 'Price', TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: themecolor))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: themecolor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: () => _addOrUpdateRoute(docId: doc?.id),
            child: Text(doc == null ? 'Add' : 'Update',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, [TextInputType type = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        style: TextStyle(color: themecolor, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: themecolor.withOpacity(0.7)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: themecolor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: themecolor.withOpacity(0.5)),
          ),
          filled: true,
          fillColor: themecolor.withOpacity(0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth <= 350;
    final fieldWidth =  screenWidth;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: themecolor,
        foregroundColor: Colors.white,
        title: const Text("Route Manager"),
        centerTitle: true,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Add Route",
            onPressed: () => _showRouteDialog(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                SizedBox(width: fieldWidth, child: _buildTextField(searchFromCtrl, 'From City')),
                SizedBox(width: fieldWidth, child: _buildTextField(searchToCtrl, 'To City')),
SizedBox(
  width: MediaQuery.of(context).size.width, // Full width
  child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: themecolor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
    ),
    onPressed: _searchRoutes,
    icon: const Icon(Icons.search, color: Colors.white),
    label: const Text(
      "Search",
      style: TextStyle(color: Colors.white),
    ),
  ),
),

              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('routes_info')
                .orderBy('from', descending: true)
                .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final docs = snapshot.data!.docs.where((doc) {
                    final from = doc['from'].toString().toLowerCase();
                    final to = doc['to'].toString().toLowerCase();

                    final matchesFrom = _fromQuery.isEmpty || from.contains(_fromQuery);
                    final matchesTo = _toQuery.isEmpty || to.contains(_toQuery);

                    return matchesFrom && matchesTo;
                  }).toList();

                  if (docs.isEmpty) {
                    return Center(child: Text("No matching routes found.", style: TextStyle(color: themecolor.withOpacity(0.7))));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (_, index) {
                      final doc = docs[index];
return Card(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  margin: const EdgeInsets.symmetric(vertical: 6),
  elevation: 3,
  color: Colors.white,
  child: Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: themecolor,
              radius: 14,
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: themecolor, size: 18),
                  onPressed: () => _showRouteDialog(doc: doc),
                  tooltip: "Edit",
                  padding: EdgeInsets.zero,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 18),
                  onPressed: () => _deleteRoute(doc.id),
                  tooltip: "Delete",
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text('${doc['from']} ➝ ${doc['to']}',style: TextStyle(fontSize: 14,color: themecolor,fontWeight: FontWeight.bold,),overflow: TextOverflow.ellipsis,),
        const SizedBox(height: 4),
        Text("Departure: ${doc['departure_time']}", style: const TextStyle(fontSize: 12)),
        Text("Arrival: ${doc['destination_time']}", style: const TextStyle(fontSize: 12)),
        Text("Price: Rs. ${doc['price']}", style: const TextStyle(fontSize: 12)),
      ],
    ),
  ),
);

                  
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
