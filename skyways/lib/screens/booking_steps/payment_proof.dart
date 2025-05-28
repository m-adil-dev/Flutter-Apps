import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:skyways/models/user_track_data.dart';
import 'package:skyways/screens/booking_steps/succes_booking.dart';
import 'package:skyways/utils/utils.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class UploadPaymentPage extends StatefulWidget {
  const UploadPaymentPage({Key? key}) : super(key: key);
  @override
  State<UploadPaymentPage> createState() => _UploadPaymentPageState();
}

class _UploadPaymentPageState extends State<UploadPaymentPage> {
  final _formKey = GlobalKey<FormState>();

  String? _paymentMethod;
  Uint8List? _paymentImageBytes;
  final TextEditingController _senderNameController = TextEditingController();
  final TextEditingController _senderAccountNumberController =
      TextEditingController();
  final TextEditingController _transactionIdController =
      TextEditingController();
  bool _isSubmitting = false;

  final Color _themeColor = themecolor;
  final Color _whiteColor = Colors.white;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _paymentImageBytes = bytes;
      });
    }
  }

Future<void> _submitPaymentProof() async {
  DateTime now = DateTime.now();
  String bookingDate =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  String bookingTime =
      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

  if (_paymentMethod == null || _paymentImageBytes == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please complete all fields.')),
    );
    return;
  }

  if (_formKey.currentState!.validate()) {
    setState(() => _isSubmitting = true);

    final imageUrl = await uploadImageToCloudinary(_paymentImageBytes!);
    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image upload failed.')),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in.')),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.runTransaction((transaction) async {
        final counterRef = firestore.collection('order_meta').doc('counter');
        final counterSnapshot = await transaction.get(counterRef);

        int lastOrderId = counterSnapshot.exists
            ? counterSnapshot['lastOrderId'] ?? 0
            : 0;
        int newOrderId = lastOrderId + 1;
        String formattedOrderId = 'ORD${newOrderId.toString().padLeft(4, '0')}';

        // Update order counter
        transaction.set(counterRef, {'lastOrderId': newOrderId}, SetOptions(merge: true));

        // Booking document reference
        final bookingDocRef = firestore
            .collection('bookings')
            .doc(user.uid)
            .collection('user_bookings')
            .doc();

        // Set booking data
        transaction.set(bookingDocRef, {
          'orderId': formattedOrderId,
          'userId': user.uid,
          'totalPrice': userTrackData.totalPrice,
          'selectedSeats': userTrackData.selectedSeats.toList(),
          'fromCity': userTrackData.fromCity,
          'toCity': userTrackData.toCity,
          'fromBusStop': userTrackData.fromCityAddress,
          'toBusStop': userTrackData.toCityAddress,
          'travelDate': formatDate(userTrackData.travelDate),
          'departureTime': userTrackData.selectedBussDepartureTime,
          'destinationTime': userTrackData.selectedBussDestinationTime,
          'mobile': bookingFormData.mobile,
          'email': bookingFormData.email,
          'firstName': bookingFormData.firstName,
          'lastName': bookingFormData.lastName,
          'cnic': bookingFormData.cnic,
          'title': bookingFormData.selectedTitle,
          'dateOfBirth':
              "${bookingFormData.selectedDate}-${bookingFormData.selectedMonth}-${bookingFormData.selectedYear}",
          'paymentMethod': _paymentMethod,
          'senderName': _senderNameController.text,
          'senderAccountNumber': _senderAccountNumberController.text,
          'transactionId': _transactionIdController.text,
          'paymentProofUrl': imageUrl,
          'bookingDate': bookingDate,
          'bookingTime': bookingTime,
          'status': "Pending",
        });
      }); 

      setState(() {
        _isSubmitting = false;
        _senderNameController.clear();
        _senderAccountNumberController.clear();
        _transactionIdController.clear();
        _paymentImageBytes = null;
        _paymentMethod = null;
      });

      showTopFlushbar(
        context,
        message: 'Payment proof submitted successfully!',
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );

      bookingFormData = BookingFormData();
      userTrackData = UserTrackData();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BookingSuccessScreen()),
      );
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit booking: $e')),
      );
    }
  }
}

  @override
  void dispose() {
    _senderNameController.dispose();
    _senderAccountNumberController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeColor,
        title: const Text('Upload Payment Proof'),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.payment_outlined,
                            color: Color.fromARGB(255, 104, 46, 19),
                            size: 28,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Payment Details',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 104, 46, 19),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Send your payment to the following account:',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 20),
                      Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              image: const DecorationImage(
                                image: AssetImage(
                                  'lib/assets/easypaisa_logo.png',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Easypaisa',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '0316-1302748',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              image: const DecorationImage(
                                image: AssetImage(
                                  'lib/assets/jazzcash_logo.png',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'JazzCash',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '0316-1302748',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      const Text(
                        'Account Holder: Sky Ways Services',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: _whiteColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPaymentMethodOption(
                      'Easypaisa',
                      'lib/assets/easypaisa_logo.png',
                    ),
                    _buildPaymentMethodOption(
                      'JazzCash',
                      'lib/assets/jazzcash_logo.png',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildInputField(
                _senderNameController,
                'Sender Name',
                'Please enter sender name',
              ),
              const SizedBox(height: 20),
              _buildInputField(
                _senderAccountNumberController,
                'Sender Account Number',
                'Please enter sender account number',
              ),
              const SizedBox(height: 20),
              _buildInputField(
                _transactionIdController,
                'Transaction ID',
                'Please enter transaction ID',
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _pickImage,
                child: DottedBorderContainer(
                  child:
                      _paymentImageBytes != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              _paymentImageBytes!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 250,
                            ),
                          )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 50,
                                color: Color.fromARGB(255, 104, 46, 19),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Tap to upload payment screenshot',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitPaymentProof,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _themeColor,
                    foregroundColor: _whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 5,
                  ),
                  child:
                      _isSubmitting
                          ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _whiteColor,
                            ),
                          )
                          : Text('Submit Payment Proof'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label,
    String errorMessage,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: _whiteColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
          validator:
              (value) => value == null || value.isEmpty ? errorMessage : null,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(String method, String assetPath) {
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = method),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              _paymentMethod == method
                  ? const Color.fromARGB(255, 163, 163, 163)
                  : _whiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Image.asset(assetPath, height: 40),
      ),
    );
  }
}

class DottedBorderContainer extends StatelessWidget {
  final Widget child;

  const DottedBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromARGB(255, 104, 46, 19),
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(15), child: child),
    );
  }
}

Future<String?> uploadImageToCloudinary(Uint8List imageBytes) async {
  const String cloudName = 'dzf4hurzf';
  const String uploadPreset = 'gvrtknvp';
  const String folder = 'paymentProof'; // specify your folder name

  final uri = Uri.parse(
    "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
  );
  final request =
      http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..fields['folder'] =
            folder // tell Cloudinary to upload into this folder
        ..files.add(
          http.MultipartFile.fromBytes(
            'file',
            imageBytes,
            filename: 'payment.jpg',
          ),
        );

  final response = await request.send();
  final resBody = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    final data = jsonDecode(resBody);
    return data['secure_url'];
  } else {
    print("Cloudinary upload failed: $resBody");
    return null;
  }
}
