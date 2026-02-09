import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_app/teaching_flow.dart';
import 'package:my_app/values.dart'; // Assuming this holds the teaching_content map
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeachingDetails extends StatefulWidget {
  final String title; // This is now the card key (card1, card2, etc.) or the English title
  const TeachingDetails(this.title, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _TeachingDetailsState();
  }
}

class _TeachingDetailsState extends State<TeachingDetails> {
  // Colors from AdvicePage.dart for consistency
  final Color themeColor = Color(0xFF566017);
  final Color lightThemeColor = Color(0xFF969A2A);

  Map<String, dynamic> content = {};
  String? translationKey;
  
  // Feedback state
  String? feedbackType; // null, 'up', or 'down'
  bool showFeedbackTextBox = false;
  bool feedbackSubmitted = false; // Track if feedback was submitted
  final TextEditingController feedbackTextController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Map card keys or English titles to translation keys
    translationKey = _getTranslationKey(widget.title);
    // For fallback content, map card keys to English titles
    String? englishTitle = _getEnglishTitle(widget.title);
    content = teaching_content[englishTitle ?? widget.title] ?? {};
  }

  @override
  void dispose() {
    feedbackTextController.dispose();
    super.dispose();
  }

  Future<void> _saveFeedback(String type, {String? comment}) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      String userId = currentUser?.uid ?? 'anonymous';
      
      String pageTitle = translationKey != null 
          ? 'teaching_content.$translationKey.title'.tr()
          : widget.title;
      
      await _firestore.collection('feedback').add({
        'type': 'teaching', // 'advice' or 'teaching'
        'page_title': pageTitle,
        'content_key': widget.title,
        'feedback_type': type, // 'up' or 'down'
        'comment': comment ?? '',
        'user_id': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Silently fail - don't interrupt user experience
      print('Error saving feedback: $e');
    }
  }

  String? _getEnglishTitle(String title) {
    // Map card keys to English titles for content lookup
    switch (title) {
      case "card1":
        return "Sustainable Fertilizers";
      case "card2":
        return "Sustainable Water Usage";
      case "card3":
        return "Sustainable Seed Sowing";
      case "card4":
        return "Soil Preparation";
      case "card5":
        return "Sustainable Pesticides";
      case "card6":
        return "Excess Crop Usage";
      default:
        return null; // Return null if it's already an English title
    }
  }

  String? _getTranslationKey(String title) {
    switch (title) {
      case "card1":
        return "fertilizers";
      case "card2":
        return "water";
      case "card3":
        return "seeds";
      case "card4":
        return "soil_prep";
      case "card5":
        return "pesticides";
      case "card6":
        return "excess_crop";
      case "Sustainable Fertilizers":
        return "fertilizers";
      case "Sustainable Water Usage":
        return "water";
      case "Sustainable Seed Sowing":
        return "seeds";
      case "Soil Preparation":
        return "soil_prep";
      case "Sustainable Pesticides":
        return "pesticides";
      case "Excess Crop Usage":
        return "excess_crop";
      default:
        return null;
    }
  }

  // Helper widget to create a styled bullet point, similar to AdvicePage
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 12, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, right: 12),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: lightThemeColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define TextStyles for consistency
    const TextStyle subtitleStyle = TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF566017));
    const TextStyle bodyStyle =
    TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF4d4d4d));

    return Scaffold(
      backgroundColor: Colors.grey[50], // Match background color
      appBar: AppBar(
        title: Text(
          '🌱 ${'app_title'.tr()}',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: lightThemeColor,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header similar to AdvicePage.dart ---
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [themeColor, lightThemeColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.school_outlined, // Relevant icon
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'screen_titles.learning_module'.tr(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Display the specific title from translation or content map
                  Text(
                    translationKey != null 
                        ? 'teaching_content.$translationKey.title'.tr()
                        : (content["title"] ?? 'screen_titles.learning_module'.tr()),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.95),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // --- Main Content Card ---
            Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Image ---
                  // if (content["image"] != null)
                  //   Padding(
                  //     padding: const EdgeInsets.only(bottom: 20.0),
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(15.0),
                  //       child: Image.asset(
                  //         content["image"],
                  //         width: double.infinity,
                  //         fit: BoxFit.cover,
                  //       ),
                  //     ),
                  //   ),

                  // --- Section 1 ---
                  if (translationKey != null)
                    Text('teaching_content.$translationKey.sub-title'.tr(), style: subtitleStyle)
                  else if (content["sub-title"] != null)
                    Text(content["sub-title"], style: subtitleStyle),
                  SizedBox(height: 8),
                  if (translationKey != null)
                    Text('teaching_content.$translationKey.para1'.tr(), style: bodyStyle)
                  else if (content["para1"] != null)
                    Text(content["para1"], style: bodyStyle),
                  SizedBox(height: 24),

                  // --- Section 2 ---
                  if (translationKey != null)
                    Text('teaching_content.$translationKey.sub-title2'.tr(), style: subtitleStyle)
                  else if (content["sub-title2"] != null)
                    Text(content["sub-title2"], style: subtitleStyle),
                  SizedBox(height: 8),
                  if (translationKey != null)
                    Text('teaching_content.$translationKey.para2'.tr(), style: bodyStyle)
                  else if (content["para2"] != null)
                    Text(content["para2"], style: bodyStyle),
                  SizedBox(height: 24),

                  // --- Bullet Points Section ---
                  if (translationKey != null)
                    Text('teaching_content.$translationKey.sub-title3'.tr(), style: subtitleStyle)
                  else if (content["sub-title3"] != null)
                    Text(content["sub-title3"], style: subtitleStyle),
                  SizedBox(height: 16),
                  if (translationKey != null) ...[
                    _buildBulletPoint('teaching_content.$translationKey.point1'.tr()),
                    _buildBulletPoint('teaching_content.$translationKey.point2'.tr()),
                    _buildBulletPoint('teaching_content.$translationKey.point3'.tr()),
                    if (translationKey == "water" || translationKey == "seeds" || translationKey == "soil_prep" || translationKey == "pesticides" || translationKey == "excess_crop")
                      _buildBulletPoint('teaching_content.$translationKey.point4'.tr()),
                  ] else ...[
                    if (content["point1"] != null)
                      _buildBulletPoint(content["point1"]),
                    if (content["point2"] != null)
                      _buildBulletPoint(content["point2"]),
                    if (content["point3"] != null)
                      _buildBulletPoint(content["point3"]),
                  ],
                ],
              ),
            ),

            // --- Footer Note ---
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightThemeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: lightThemeColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: themeColor,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'advice_dialog.teaching_disclaimer'.tr(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Feedback Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: feedbackSubmitted
                  ? Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: themeColor,
                            size: 36,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'advice_dialog.thank_you_feedback'.tr(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: themeColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'advice_dialog.was_this_helpful'.tr(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            // Thumbs Up Button
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _saveFeedback('up');
                                  setState(() {
                                    feedbackType = 'up';
                                    feedbackSubmitted = true;
                                    showFeedbackTextBox = false;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '👍',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'advice_dialog.yes'.tr(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            // Thumbs Down Button
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    feedbackType = 'down';
                                    showFeedbackTextBox = true;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '👎',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'advice_dialog.no'.tr(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        // Optional feedback text box (shown when thumbs down is selected)
                        if (showFeedbackTextBox) ...[
                          SizedBox(height: 12),
                          TextField(
                            controller: feedbackTextController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'advice_dialog.tell_us_unclear'.tr(),
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: themeColor, width: 2),
                              ),
                              contentPadding: EdgeInsets.all(10),
                              isDense: true,
                            ),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _saveFeedback('down', comment: feedbackTextController.text.trim());
                                setState(() {
                                  feedbackSubmitted = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'advice_dialog.submit'.tr(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
