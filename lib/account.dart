import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/questions.dart'; // Make sure this path is correct

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // UI Styling
  final Color themeColor = Color(0xFF566017);
  final Color lightThemeColor = Color(0xFF969A2A);

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Account")),
        body: Center(child: Text("No user logged in.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('🌱 My Account', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: lightThemeColor,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('Users').doc(currentUser.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: themeColor));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Could not find user details."));
          }

          var userData = snapshot.data!.data();
          String name = userData?['name'] ?? 'N/A';
          String email = currentUser.email ?? 'N/A'; // Keep email for the header
          String phone = userData?['phone'] ?? 'N/A';

          // Farm Preferences
          List<dynamic> crops = userData?['crops'] ?? [];
          List<dynamic> fertilizers = userData?['fertilizers'] ?? [];
          String soilType = userData?['soil_type'] ?? 'N/A';
          String landSize = userData?['land_size'] ?? 'N/A';
          String irrigationFrequency = userData?['irrigation_frequency'] ?? 'N/A';

          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                // Header still shows name and email for context
                _buildHeader(name, email),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // *** CHANGE: Simplified this card ***
                      _buildInfoCard(
                        icon: Icons.person_outline,
                        title: 'Account Information',
                        children: [
                          _buildDetailRow('Name', name),
                          _buildDetailRow('Phone', phone),
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildInfoCard(
                        icon: Icons.agriculture_outlined,
                        title: 'My Farm Preferences',
                        children: [
                          // This already displays the selected value next to the label
                          _buildDetailRow('Soil Type', soilType),
                          _buildDetailRow('Land Size', landSize),
                          _buildDetailRow('Irrigation', irrigationFrequency),
                          _buildListRow('Crops', crops),
                          _buildListRow('Fertilizers', fertilizers),
                        ],
                      ),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: Icon(Icons.edit, color: Colors.white),
                        label: Text("EDIT PREFERENCES", style: TextStyle(fontSize: 16, color: Colors.white)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Questions_(uid: currentUser.uid)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Reusable UI Widgets ---

  Widget _buildHeader(String name, String email) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [themeColor, lightThemeColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: themeColor),
          ),
          SizedBox(height: 12),
          Text(name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 4),
          // Email is still useful in the header for user identification
          Text(email, style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9))),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: Offset(0, 5))],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: themeColor, size: 24),
              SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeColor)),
            ],
          ),
          Divider(height: 24, thickness: 1, color: Colors.grey[200]),
          ...children,
        ],
      ),
    );
  }

  // *** CHANGE: Removed optional 'onChange' parameter as it's no longer used ***
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          SizedBox(width: 16), // Added for spacing
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListRow(String label, List<dynamic> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          SizedBox(height: 8),
          if (items.isEmpty)
            Text("No ${label.toLowerCase()} selected yet.", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[500]))
          else
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              alignment: WrapAlignment.end,
              children: items.map((item) => Chip(
                label: Text(item.toString(), style: TextStyle(color: themeColor, fontWeight: FontWeight.w500)),
                backgroundColor: lightThemeColor.withOpacity(0.2),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              )).toList(),
            ),
        ],
      ),
    );
  }
}
