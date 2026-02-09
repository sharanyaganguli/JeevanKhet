import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class Subsidy extends StatelessWidget {
  const Subsidy({Key? key}) : super(key: key);

  // Helper function to launch a URL
  Future<void> _launchURL(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);

    // --- FIX: Check if the widget is still mounted before showing a SnackBar ---
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return; // Check if the context is still valid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define colors for consistent styling
    final Color themeColor = Color(0xFF566017);
    final Color lightThemeColor = Color(0xFF969A2A);

    return Scaffold(
      backgroundColor: Colors.grey[50], // A light background for contrast
      appBar: AppBar(
        title: Text(
          '🌱 ${'subsidy.title'.tr()}',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: lightThemeColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Text ---
            Text(
              'subsidy.sub_title'.tr(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),

            // --- Reusable Subsidy Link Card ---
            _buildSubsidyCard(
              context: context,
              icon: Icons.account_balance_wallet_outlined,
              title: 'subsidy.title1'.tr(),
              subtitle: 'subsidy.desc1'.tr(),
              url: "https://agriinfra.dac.gov.in/Home/BeneficiaryRegistration",
              themeColor: themeColor,
            ),
            const SizedBox(height: 16),
            _buildSubsidyCard(
              context: context,
              icon: Icons.store_mall_directory_outlined,
              title: 'subsidy.title2'.tr(),
              subtitle: 'subsidy.desc2'.tr(),
              url: "https://www.enam.gov.in/",
              themeColor: themeColor,
            ),
            const SizedBox(height: 16),
            _buildSubsidyCard(
              context: context,
              icon: Icons.support_agent_outlined,
              title: 'subsidy.title3'.tr(),
              subtitle: 'subsidy.desc3'.tr(),
              url: "https://kisanemitra.gov.in/Home/Index",
              themeColor: themeColor,
            ),
          ],
        ),
      ),
    );
  }

  // --- Reusable Card Widget for Hyperlinks ---
  Widget _buildSubsidyCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
    required Color themeColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: () => _launchURL(url, context),
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon
              Icon(icon, size: 40, color: themeColor),
              const SizedBox(width: 16),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow Icon
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
