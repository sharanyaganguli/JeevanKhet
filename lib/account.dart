import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/questions.dart';
import 'package:my_app/login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

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
        appBar: AppBar(title: Text('screen_titles.account'.tr())),
        body: Center(child: Text('account_page.no_user_logged_in'.tr())),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('account_page.title'.tr(), style: TextStyle(fontWeight: FontWeight.w700)),
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
            return Center(child: Text('account_page.loading_error'.tr(namedArgs: {'error': snapshot.error.toString()})));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('account_page.no_user_details'.tr()));
          }

          var userData = snapshot.data!.data();
          String name = userData?['name'] ?? 'account_page.not_applicable'.tr();
          String email = currentUser.email ?? 'account_page.not_applicable'.tr(); // Keep email for the header
          String phone = userData?['phone'] ?? 'account_page.not_applicable'.tr();
          String city = userData?['city'] ?? 'account_page.not_applicable'.tr();

          // Farm Preferences
          List<dynamic> cropsRaw = userData?['crops'] ?? [];
          List<dynamic> fertilizersRaw = userData?['fertilizers'] ?? [];
          String soilTypeRaw = userData?['soil_type']?.toString() ?? '';
          String landSizeRaw = userData?['land_size']?.toString() ?? '';
          String irrigationFrequencyRaw = userData?['irrigation_frequency']?.toString() ?? '';
          
          // Translate values based on current locale
          List<dynamic> crops = cropsRaw.map((crop) => _translateCrop(crop.toString())).toList();
          List<dynamic> fertilizers = fertilizersRaw.map((fert) => _translateFertilizer(fert.toString())).toList();
          String soilType = soilTypeRaw.isEmpty ? 'account_page.not_applicable'.tr() : _translateSoilType(soilTypeRaw);
          String landSize = landSizeRaw.isEmpty ? 'account_page.not_applicable'.tr() : _translateLandSize(landSizeRaw);
          String irrigationFrequency = irrigationFrequencyRaw.isEmpty ? 'account_page.not_applicable'.tr() : _translateIrrigationFrequency(irrigationFrequencyRaw);

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
                        title: 'account_page.account_information'.tr(),
                        children: [
                          _buildDetailRow('account_page.name'.tr(), name),
                          _buildDetailRow('account_page.phone'.tr(), phone),
                          _buildDetailRow('account_page.city_town'.tr(), city),
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildInfoCard(
                        icon: Icons.agriculture_outlined,
                        title: 'account_page.farm_preferences'.tr(),
                        children: [
                          // This already displays the selected value next to the label
                          _buildDetailRow('account_page.soil_type'.tr(), soilType),
                          _buildDetailRow('account_page.land_size'.tr(), landSize),
                          _buildDetailRow('account_page.irrigation'.tr(), irrigationFrequency),
                          _buildListRow('account_page.crops'.tr(), crops),
                          _buildListRow('account_page.fertilizers'.tr(), fertilizers),
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
                        label: Text('account_page.edit_preferences_button'.tr(), style: TextStyle(fontSize: 16, color: Colors.white)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Questions_(uid: currentUser.uid)),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      _buildInfoCard(
                        icon: Icons.language,
                        title: 'screen_titles.language_settings'.tr(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.translate, color: themeColor, size: 20),
                                    SizedBox(width: 12),
                                    Text('screen_titles.change_language'.tr(), style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('HI', style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                                    SizedBox(width: 8),
                                    Switch(
                                      value: context.locale.languageCode == 'en',
                                      onChanged: (bool value) async {
                                        final newLocale = value ? Locale('en') : Locale('hi');
                                        await context.setLocale(newLocale);
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                      activeColor: themeColor,
                                    ),
                                    SizedBox(width: 8),
                                    Text('EN', style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildInfoCard(
                        icon: Icons.info_outline,
                        title: '',
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.privacy_tip_outlined, color: themeColor),
                            title: Text('screen_titles.privacy_policy'.tr(), style: TextStyle(fontSize: 16)),
                            trailing: Icon(Icons.chevron_right, color: Colors.grey),
                            onTap: () {
                              _openPrivacyPolicy();
                            },
                          ),
                          Divider(height: 1),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.delete_outline, color: themeColor),
                            title: Text('screen_titles.delete_account'.tr(), style: TextStyle(fontSize: 16)),
                            trailing: Icon(Icons.chevron_right, color: Colors.grey),
                            onTap: () {
                              _showDeleteAccountDialog(context);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: Icon(Icons.logout, color: Colors.red),
                        label: Text('screen_titles.logout'.tr().toUpperCase(), style: TextStyle(fontSize: 16, color: Colors.white)),
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          );
        },
      ),
    );
  }

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
          if (title.isNotEmpty) ...[
            Row(
              children: [
                Icon(icon, color: themeColor, size: 24),
                SizedBox(width: 8),
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeColor)),
              ],
            ),
            Divider(height: 24, thickness: 1, color: Colors.grey[200]),
          ],
          ...children,
        ],
      ),
    );
  }

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
            Text('account_page.no_items_selected'.tr(namedArgs: {'item': label.toLowerCase()}), style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[500]))
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('screen_titles.logout'.tr()),
          content: Text('screen_titles.logout_confirmation'.tr()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('screen_titles.cancel'.tr(), style: TextStyle(color: Colors.grey[600])),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _logout();
              },
              child: Text('screen_titles.logout'.tr(), style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      // Navigate to login screen and clear navigation stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openPrivacyPolicy() async {
    try {
      final Uri url = Uri.parse('https://janhavikarande07.github.io/JeevanKhet_Privacy_Policy/');
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open privacy policy link. Please check your internet connection.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('screen_titles.delete_account'.tr(), style: TextStyle(color: themeColor, fontWeight: FontWeight.bold)),
          content: Text(
            'screen_titles.delete_account_confirmation'.tr(),
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('screen_titles.cancel'.tr(), style: TextStyle(color: Colors.grey[600])),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteAccount();
              },
              child: Text('screen_titles.delete_account'.tr(), style: TextStyle(color: themeColor, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator(color: themeColor)),
      );

      // Delete all user data from Firestore
      await _firestore.collection('Users').doc(currentUser.uid).delete();

      // Delete user account from Firebase Auth (this deletes all auth-related data)
      await currentUser.delete();

      // Close loading indicator
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Navigate to login screen and clear all navigation stack
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
          (route) => false,
        );
      }
    } catch (e) {
      // Close loading indicator if still open
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting account: ${e.toString()}'),
            backgroundColor: themeColor,
          ),
        );
      }
    }
  }

  // Helper functions to translate stored English values to current locale
  String _translateCrop(String crop) {
    if (crop.isEmpty) return crop;
    switch (crop) {
      case "Wheat": return 'questions_page.q1_options.wheat'.tr();
      case "Millet": return 'questions_page.q1_options.millet'.tr();
      case "Rice": return 'questions_page.q1_options.rice'.tr();
      case "Legumes": return 'questions_page.q1_options.legumes'.tr();
      case "Cotton": return 'questions_page.q1_options.cotton'.tr();
      case "Sugarcane": return 'questions_page.q1_options.sugarcane'.tr();
      default: return crop;
    }
  }

  String _translateFertilizer(String fert) {
    if (fert.isEmpty) return fert;
    switch (fert) {
      case "Urea": return 'questions_page.q6_options.urea'.tr();
      case "DAP": return 'questions_page.q6_options.dap'.tr();
      case "Ammonium Sulphate": return 'questions_page.q6_options.ammonium_sulphate'.tr();
      case "Other NPK fertilizer": return 'questions_page.q6_options.other_npk'.tr();
      case "Organic": return 'questions_page.q6_options.organic'.tr();
      default: return fert;
    }
  }

  String _translateSoilType(String soil) {
    if (soil.isEmpty) return soil;
    switch (soil) {
      case "Sandy soil": return 'questions_page.q2_options.sandy'.tr();
      case "Silty soil": return 'questions_page.q2_options.silty'.tr();
      case "Loamy soil": return 'questions_page.q2_options.loamy'.tr();
      case "Peaty soil": return 'questions_page.q2_options.peaty'.tr();
      default: return soil;
    }
  }

  String _translateLandSize(String size) {
    if (size.isEmpty) return size;
    switch (size) {
      case "<1 acre": return 'questions_page.q5_options.less_than_1'.tr();
      case "1-2 acre": return 'questions_page.q5_options.1_to_2'.tr();
      case "> 2 acre": return 'questions_page.q5_options.more_than_2'.tr();
      default: return size;
    }
  }

  String _translateIrrigationFrequency(String freq) {
    if (freq.isEmpty) return freq;
    switch (freq) {
      case "Once a week": return 'questions_page.q3_options.once_week'.tr();
      case "Twice a week": return 'questions_page.q3_options.twice_week'.tr();
      case "Once a month": return 'questions_page.q3_options.once_month'.tr();
      default: return freq;
    }
  }
}
