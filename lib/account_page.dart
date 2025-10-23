import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/teaching_flow.dart';
import 'package:my_app/values.dart'; // Assuming this holds the teaching_content map

class TeachingDetails extends StatefulWidget {
  final String title;
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

  @override
  void initState() {
    super.initState();
    // Safely access the map, providing a default empty map
    content = teaching_content[widget.title] ?? {};
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
          '🌱 JeevanKhet',
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
                        'Learning Module', // General Title
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Display the specific title from the content map
                  if (content["title"] != null)
                    Text(
                      content["title"],
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
                  if (content["image"] != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(
                          content["image"],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  // --- Section 1 ---
                  if (content["sub-title"] != null)
                    Text(content["sub-title"], style: subtitleStyle),
                  SizedBox(height: 8),
                  if (content["para1"] != null)
                    Text(content["para1"], style: bodyStyle),
                  SizedBox(height: 24),

                  // --- Section 2 ---
                  if (content["sub-title2"] != null)
                    Text(content["sub-title2"], style: subtitleStyle),
                  SizedBox(height: 8),
                  if (content["para2"] != null)
                    Text(content["para2"], style: bodyStyle),
                  SizedBox(height: 24),

                  // --- Bullet Points Section ---
                  if (content["sub-title3"] != null)
                    Text(content["sub-title3"], style: subtitleStyle),
                  SizedBox(height: 16),
                  if (content["point1"] != null)
                    _buildBulletPoint(content["point1"]),
                  if (content["point2"] != null)
                    _buildBulletPoint(content["point2"]),
                  if (content["point3"] != null)
                    _buildBulletPoint(content["point3"]),
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
                      'This is general guidance. Always consider local conditions and consult with agricultural experts.',
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
