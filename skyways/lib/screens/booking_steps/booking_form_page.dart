// import 'package:flutter/material.dart';

// // themecolor
// import 'package:sky_ways/utillities.dart';

// class BookingFormPage extends StatefulWidget {
//   const BookingFormPage({Key? key}) : super(key: key);

//   @override
//   State<BookingFormPage> createState() => _BookingFormPageState();
// }

// class _BookingFormPageState extends State<BookingFormPage> {
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController cnicController = TextEditingController();

//   bool agreeToInfo = true;
//   String? selectedTitle;
//   String? selectedDate;
//   String? selectedMonth;
//   String? selectedYear;

//   final List<String> dates = List.generate(31, (index) => (index + 1).toString());
//   final List<String> months = [
//     "January", "February", "March", "April", "May", "June",
//     "July", "August", "September", "October", "November", "December"
//   ];
//   final List<String> years = List.generate(100, (index) => (DateTime.now().year - index).toString());

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
      
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               titleText('Contact Details'),
//               const SizedBox(height: 16),
//               phoneInputField(),
//               const SizedBox(height: 16),
//               emailInputField(),
//               const SizedBox(height: 8),
//               Text(
//                 "e.g. name@outlook.com",
//                 style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//               ),
//               const SizedBox(height: 10),
//               CheckboxListTile(
//                 value: agreeToInfo,
//                 onChanged: (value) {
//                   setState(() {
//                     agreeToInfo = value ?? false;
//                   });
//                 },
//                 title: const Text(
//                   "I agree to receive travel related information and deals.",
//                   style: TextStyle(fontSize: 14),
//                 ),
//                 controlAffinity: ListTileControlAffinity.leading,
//                 dense: true,
//                 contentPadding: EdgeInsets.zero,
//                 activeColor: themecolor,
//               ),
//               const Divider(height: 32),
//               titleText('Traveler details'),
//               const SizedBox(height: 16),
//               titleSelector(),
//               const SizedBox(height: 16),
//               customInput(firstNameController, "First Name & Middle Name (if any)", Icons.person_outline),
//               const SizedBox(height: 16),
//               customInput(lastNameController, "Last Name", Icons.person_outline),
//               const SizedBox(height: 16),
//               dateOfBirthSelector(),
//               const SizedBox(height: 16),
//               customInput(cnicController, "CNIC", Icons.badge_outlined),
//               const SizedBox(height: 30),
//               confirmButton(),
//             ],
//           ),
//         ),
//       );
//   }








//   Widget titleText(String title) {
//     return Text(
//       title,
//       style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//     );
//   }

//   Widget phoneInputField() {
//     return Row(
//       children: [
//         Container(
//           height: 56,
//           decoration: BoxDecoration(
//             border: Border.all(color: themecolor),
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(8),
//               bottomLeft: Radius.circular(8),
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Row(
//             children: const [
//               Text("🇵🇰 "),
//               SizedBox(width: 4),
//               Text("+92"),
//               Icon(Icons.arrow_drop_down),
//             ],
//           ),
//         ),
//         Expanded(
//           child: TextField(
//             controller: mobileController,
//             keyboardType: TextInputType.phone,
//             decoration: InputDecoration(
//               hintText: "e.g. 3312345678",
//               hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
//               prefixIcon: Icon(Icons.phone_android, color: themecolor),
//               contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
//               border: OutlineInputBorder(
//                 borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(8),
//                   bottomRight: Radius.circular(8),
//                 ),
//                 borderSide: BorderSide(color: themecolor),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(8),
//                   bottomRight: Radius.circular(8),
//                 ),
//                 borderSide: BorderSide(color: themecolor, width: 2),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget emailInputField() {
//     return TextField(
//       controller: emailController,
//       decoration: InputDecoration(
//         hintText: "Enter your email",
//         prefixIcon: Icon(Icons.email_outlined, color: themecolor),
//         suffixIcon: Icon(Icons.info_outline, size: 20, color: Colors.grey[600]),
//         hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: themecolor),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: themecolor, width: 2),
//         ),
//       ),
//     );
//   }

//   Widget titleSelector() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         buildRadio("Mr"),
//         buildRadio("Mrs"),
//         buildRadio("Ms"),
//       ],
//     );
//   }

//   Widget buildRadio(String value) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             selectedTitle = value;
//           });
//         },
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           margin: const EdgeInsets.symmetric(horizontal: 4),
//           decoration: BoxDecoration(
//             border: Border.all(color: themecolor),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             children: [
//               Icon(
//                 selectedTitle == value ? Icons.radio_button_checked : Icons.radio_button_off,
//                 color: selectedTitle == value ? themecolor : Colors.grey,
//               ),
//               const SizedBox(height: 4),
//               Text(value),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget customInput(TextEditingController controller, String hint, IconData icon) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hint,
//         prefixIcon: Icon(icon, color: themecolor),
//         hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: themecolor),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: themecolor, width: 2),
//         ),
//       ),
//     );
//   }

//   Widget dateOfBirthSelector() {
//     return Row(
//       children: [
//         Expanded(child: buildDropdown(dates, selectedDate, (value) => setState(() => selectedDate = value), "Date")),
//         const SizedBox(width: 8),
//         Expanded(child: buildDropdown(months, selectedMonth, (value) => setState(() => selectedMonth = value), "Month")),
//         const SizedBox(width: 8),
//         Expanded(child: buildDropdown(years, selectedYear, (value) => setState(() => selectedYear = value), "Year")),
//       ],
//     );
//   }

//   Widget buildDropdown(List<String> items, String? selectedItem, ValueChanged<String?> onChanged, String hint) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         border: Border.all(color: themecolor),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownButton<String>(
//         value: selectedItem,
//         hint: Text(hint),
//         isExpanded: true,
//         underline: const SizedBox(),
//         items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }

//   Widget confirmButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: themecolor,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         onPressed: () {
//           // Confirm button pressed
//         },
//         child: const Text(
//           "Confirm",
//           style: TextStyle(fontSize: 18,color: Colors.white),
//         ),
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:skyways/models/user_track_data.dart';
import 'package:skyways/screens/booking_steps/payment_proof.dart';
import 'package:skyways/utils/utils.dart';
class BookingFormPage extends StatefulWidget {


  const BookingFormPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();

  bool agreeToInfo = true;

void setdata (){
  
}
  final List<String> dates = List.generate(31, (index) => (index + 1).toString());
  final List<String> months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];
  final List<String> years = List.generate(100, (index) => (DateTime.now().year - index).toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        foregroundColor: Colors.white,

        backgroundColor: themecolor,
        title: const Text("Booking Form", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildSectionCard("📞 Contact Details", [
                  phoneInputField(),
                  const SizedBox(height: 16),
                  emailInputField(),
                  const SizedBox(height: 4),
                  Text("e.g. name@outlook.com", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    value: agreeToInfo,
                    onChanged: (value) {
                      setState(() => agreeToInfo = value ?? false);
                    },
                    title: const Text("I agree to receive travel related information and deals."),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: themecolor,
                  ),
                ]),
                const SizedBox(height: 20),
                buildSectionCard("🧍 Traveler Details", [
                  titleSelector(),
                  const SizedBox(height: 16),
                  customInput(firstNameController, "First Name & Middle Name (if any)", Icons.person_outline),
                  const SizedBox(height: 16),
                  customInput(lastNameController, "Last Name", Icons.person_outline),
                  const SizedBox(height: 16),
                  dateOfBirthSelector(),
                  const SizedBox(height: 16),
                  customInput(cnicController, "CNIC", Icons.badge_outlined),
                ]),
                const SizedBox(height: 30),
                confirmButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionCard(String title, List<Widget> children) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget phoneInputField() {
    return Row(
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: themecolor),
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
          ),
          child: Row(children: const [Text("🇵🇰 +92"), SizedBox(width: 4), Icon(Icons.arrow_drop_down)]),
        ),
        Expanded(
          child: TextFormField(
            controller: mobileController,
            keyboardType: TextInputType.phone,
            validator: (value) => value == null || value.isEmpty ? "Required" : null,
            decoration: inputDecoration("e.g. 3312345678", Icons.phone_android),
          ),
        ),
      ],
    );
  }

  Widget emailInputField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => value == null || value.isEmpty ? "Required" : null,
      decoration: inputDecoration("Enter your email", Icons.email_outlined)
          .copyWith(suffixIcon: Icon(Icons.info_outline, size: 20, color: Colors.grey[600])),
    );
  }

  InputDecoration inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: themecolor),
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: themecolor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: themecolor, width: 2)),
    );
  }

  Widget titleSelector() {
    return Row(
      children: ["Mr", "Mrs", "Ms"].map((value) => Expanded(child: buildRadio(value))).toList(),
    );
  }

  Widget buildRadio(String value) {
    return GestureDetector(
      onTap: () => setState(() => bookingFormData.selectedTitle = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: bookingFormData.selectedTitle == value ? themecolor.withOpacity(0.1) : Colors.white,
          border: Border.all(color: themecolor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(bookingFormData.selectedTitle == value ? Icons.radio_button_checked : Icons.radio_button_off,
                color: bookingFormData.selectedTitle == value ? themecolor : Colors.grey),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget customInput(TextEditingController controller, String hint, IconData icon) {
    return TextFormField(
      controller: controller,
      validator: (value) => value == null || value.isEmpty ? "Required" : null,
      decoration: inputDecoration(hint, icon),
    );
  }

  Widget dateOfBirthSelector() {
    return Row(
      children: [
        Expanded(child: buildDropdown(dates, bookingFormData.selectedDate, (val) => setState(() => bookingFormData.selectedDate = val), "Date")),
        const SizedBox(width: 8),
        Expanded(child: buildDropdown(months, bookingFormData.selectedMonth, (val) => setState(() => bookingFormData.selectedMonth = val), "Month")),
        const SizedBox(width: 8),
        Expanded(child: buildDropdown(years, bookingFormData.selectedYear, (val) => setState(() => bookingFormData.selectedYear = val), "Year")),
      ],
    );
  }

  Widget buildDropdown(List<String> items, String? selectedItem, ValueChanged<String?> onChanged, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: themecolor),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownButton<String>(
        value: selectedItem,
        hint: Text(hint),
        isExpanded: true,
        underline: const SizedBox(),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget confirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        style: ElevatedButton.styleFrom(
          backgroundColor: themecolor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate() &&
              bookingFormData.selectedTitle != null &&
              bookingFormData.selectedDate != null &&
              bookingFormData.selectedMonth != null &&
              bookingFormData.selectedYear != null) {
            bookingFormData.mobile = mobileController.text.trim();
            bookingFormData.email = emailController.text.trim();
            bookingFormData.firstName = firstNameController.text.trim();
            bookingFormData.lastName = lastNameController.text.trim();
            bookingFormData.cnic = cnicController.text.trim();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UploadPaymentPage(),
),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please complete all required fields."), backgroundColor: Colors.red),
            );
          }
        },
        label: const Text("Confirm", style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
