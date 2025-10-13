import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class Soiladvisor extends StatefulWidget {
  final String query;
  final String title;

  const Soiladvisor({
    Key? key,
    required this.query,
    required this.title,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SoilAdvisorState();
  }
}

class _SoilAdvisorState extends State<Soiladvisor> {
  final Color themeColor = Color(0xFF566017);
  final Color lightThemeColor = Color(0xFF969A2A);
  
  String? responseText;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getResponse(widget.query);
  }

  void getResponse(String query) async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      Gemini.init(
        apiKey: "AIzaSyAcXDXPZbCCypVbvy_TBNxTLtD6hXyH6GE",
        enableDebugging: true,
      );

      final response = await Gemini.instance.prompt(parts: [
        Part.text(query),
      ]);

      setState(() {
        responseText = response?.output ?? 'No response received';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Failed to fetch advice: $e';
        isLoading = false;
      });
    }
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                  strokeWidth: 3,
                ),
                SizedBox(height: 20),
                Text(
                  'Generating advice...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: themeColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please wait',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            SizedBox(height: 20),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              errorMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => getResponse(widget.query),
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _parseInlineMarkdown(String text) {
    List<TextSpan> spans = [];
    RegExp boldPattern = RegExp(r'\*\*(.*?)\*\*');
    
    int lastIndex = 0;
    for (Match match in boldPattern.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.grey[800],
          ),
        ));
      }

      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(
          fontSize: 16,
          height: 1.6,
          fontWeight: FontWeight.bold,
          color: Colors.grey[900],
        ),
      ));
      
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Colors.grey[800],
        ),
      ));
    }
    
    return spans;
  }

  List<Widget> _formatResponseText(String text) {
    List<Widget> widgets = [];

    List<String> lines = text.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      
      if (line.isEmpty) {
        widgets.add(SizedBox(height: 8));
        continue;
      }

      if (line.startsWith('**') && line.endsWith('**') && !line.substring(2, line.length - 2).contains('**')) {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              line.replaceAll('**', ''),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
          ),
        );
      } else if (line.startsWith('#')) {
        int hashCount = line.indexOf(' ');
        String headingText = line.substring(hashCount).trim();
        widgets.add(
          Padding(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              headingText,
              style: TextStyle(
                fontSize: hashCount == 1 ? 22 : 20,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
          ),
        );
      } else if (line.contains(':') && line.split(':')[0].length < 50 && 
                 line == line.toUpperCase() || 
                 (line.endsWith(':') && !line.contains('.'))) {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(top: 12, bottom: 6),
            child: Row(
              children: [
                Icon(Icons.arrow_right, color: lightThemeColor, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: _parseInlineMarkdown(line),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: themeColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (line.startsWith('*') && !line.startsWith('**') || 
                 line.startsWith('-') || 
                 line.startsWith('•') || 
                 RegExp(r'^\d+\.').hasMatch(line)) {

        String bulletText = line.substring(1).trim();
        if (RegExp(r'^\d+\.').hasMatch(line)) {
          bulletText = line.replaceFirst(RegExp(r'^\d+\.\s*'), '');
        }
        

        if (bulletText.isEmpty || RegExp(r'^-+$').hasMatch(bulletText)) {
          widgets.add(SizedBox(height: 12));
          continue;
        }
        
        widgets.add(
          Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8, top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 6, right: 12),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: lightThemeColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: _parseInlineMarkdown(bulletText),
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: RichText(
              text: TextSpan(
                children: _parseInlineMarkdown(line),
              ),
            ),
          ),
        );
      }
    }
    
    return widgets;
  }

  Widget _buildContentView() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            padding: EdgeInsets.all(24),
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
                        Icons.lightbulb_outline,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Expert Advice',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

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
                Row(
                  children: [
                    Icon(
                      Icons.eco,
                      color: lightThemeColor,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Recommendations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: lightThemeColor.withOpacity(0.3),
                  thickness: 1,
                  height: 24,
                ),
                SizedBox(height: 8),
                ...(_formatResponseText(responseText ?? '')),
              ],
            ),
          ),

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
                    'This advice is AI-generated. Please consult with local agricultural experts for specific guidance.',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
      body: isLoading
          ? _buildLoadingView()
          : hasError
              ? _buildErrorView()
              : _buildContentView(),
    );
  }
}
