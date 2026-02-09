import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_app/bottom%20nav.dart';
import 'package:my_app/home.dart';
import 'package:my_app/products.dart';
import 'package:my_app/values.dart';

class Questions_ extends StatefulWidget {
  final dynamic uid;
  Questions_({Key? key, required this.uid}) : super(key:key);
  @override
  State<StatefulWidget> createState() {
    return _QuestionsState();
  }
}

class _QuestionsState extends State<Questions_> {
  final TextEditingController _cityController = TextEditingController();

  final List<String> crops = [
    "Wheat",
    "Millet",
    "Rice",
    "Legumes",
    "Cotton",
    "Sugarcane",
  ];

  Map<String, bool> selectedCrops = {};

  final List<String> soilTypes = [
    "Sandy soil",
    "Silty soil",
    "Loamy soil",
    "Peaty soil",
  ];
  String? selectedSoil;

  // Question 4: Irrigation frequency (single choice)
  final List<String> irrigationFrequency = [
    "Once a week",
    "Twice a week",
    "Once a month",
  ];
  String? selectedFrequency;

  // Question 5: Irrigation methods (multiple choice)
  final List<String> irrigationMethods = [
    "Canal irrigation",
    "Tank irrigation",
    "Wells",
    "Sprinkler irrigation",
    "Rain dependent",
  ];
  Map<String, bool> selectedIrrigation = {};

  // Question 6: Land size (single choice)
  final List<String> landSizes = [
    "<1 acre",
    "1-2 acre",
    "> 2 acre",
  ];
  String? selectedLandSize;

  // Question 7: Fertilizers (multiple choice)
  final List<String> fertilizers = [
    "Urea",
    "DAP",
    "Ammonium Sulphate",
    "Other NPK fertilizer",
    "Organic",
  ];
  Map<String, bool> selectedFertilizers = {};
// Question 8: Equipment (multiple choice)
  final List<String> equipment = [
    "Seed, drills/planters",
    "Transplanters",
    "Tractor with implements",
    "Harvesters, reapers, ATVs/RTVs/UTVs",
    "Others",
  ];
  Map<String, bool> selectedEquipment = {};

  @override
  void initState() {
    super.initState();
    // Initialize selections
    selectedCrops = {for (var crop in crops) crop: false};
    selectedIrrigation = {for (var item in irrigationMethods) item: false};
    selectedFertilizers = {for (var fert in fertilizers) fert: false};
    selectedEquipment = {for (var eq in equipment) eq: false};
    // Load existing user data
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.uid)
          .get();
      
      if (doc.exists && mounted) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            // Load city
            if (data['city'] != null) {
              _cityController.text = data['city'].toString();
            }
            // Load other preferences if needed
            if (data['soil_type'] != null) {
              selectedSoil = data['soil_type'].toString();
            }
            if (data['irrigation_frequency'] != null) {
              selectedFrequency = data['irrigation_frequency'].toString();
            }
            if (data['land_size'] != null) {
              selectedLandSize = data['land_size'].toString();
            }
            // Load crops
            if (data['crops'] != null && data['crops'] is List) {
              List<dynamic> savedCrops = data['crops'];
              for (var crop in savedCrops) {
                if (selectedCrops.containsKey(crop)) {
                  selectedCrops[crop] = true;
                }
              }
            }
            // Load fertilizers
            if (data['fertilizers'] != null && data['fertilizers'] is List) {
              List<dynamic> savedFertilizers = data['fertilizers'];
              for (var fert in savedFertilizers) {
                if (selectedFertilizers.containsKey(fert)) {
                  selectedFertilizers[fert] = true;
                }
              }
            }
            // Load equipment
            if (data['equipments'] != null && data['equipments'] is List) {
              List<dynamic> savedEquipment = data['equipments'];
              for (var eq in savedEquipment) {
                if (selectedEquipment.containsKey(eq)) {
                  selectedEquipment[eq] = true;
                }
              }
            }
          });
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'questions_page.app_title'.tr(),
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Color(0xFF969A2A),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                'questions_page.page_intro'.tr(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Question 2: Crops
              Text(
                'questions_page.q1_title'.tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),

              // Checkboxes
              Wrap(
                spacing: 10,
                runSpacing: 5,
                children: crops.map((crop) {
                  String cropKey = _getCropTranslationKey(crop);
                  return SizedBox(
                    width: 150, // adjust width so two checkboxes per row
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(cropKey.isNotEmpty ? cropKey.tr() : crop),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: selectedCrops[crop],
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          selectedCrops[crop] = value ?? false;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 20),

              // Q3: Soil type (single choice - radio buttons)
              Text('questions_page.q2_title'.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Column(
                children: soilTypes.map((soil) {
                  String soilKey = _getSoilTranslationKey(soil);
                  return RadioListTile<String>(
                    title: Text(soilKey.isNotEmpty ? soilKey.tr() : soil),
                    value: soil,
                    groupValue: selectedSoil,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        selectedSoil = value;
                      });
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 20),

              // Q4: Irrigation frequency
              Text('questions_page.q3_title'.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Column(
                children: irrigationFrequency.map((freq) {
                  String freqKey = _getIrrigationFreqTranslationKey(freq);
                  return RadioListTile<String>(
                    title: Text(freqKey.isNotEmpty ? freqKey.tr() : freq),
                    value: freq,
                    groupValue: selectedFrequency,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        selectedFrequency = value;
                      });
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 20),

              // Q5: Irrigation methods (multiple choice)
              Text('questions_page.q4_title'.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Column(
                children: irrigationMethods.map((method) {
                  String methodKey = _getIrrigationMethodTranslationKey(method);
                  return CheckboxListTile(
                    title: Text(methodKey.isNotEmpty ? methodKey.tr() : method),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: selectedIrrigation[method],
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        selectedIrrigation[method] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 20),

              // Q6: Land size
              Text('questions_page.q5_title'.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Column(
                children: landSizes.map((size) {
                  String sizeKey = _getLandSizeTranslationKey(size);
                  return RadioListTile<String>(
                    title: Text(sizeKey.isNotEmpty ? sizeKey.tr() : size),
                    value: size,
                    groupValue: selectedLandSize,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        selectedLandSize = value;
                      });
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 20),

              // Q7: Fertilizers (multiple choice)
              Text('questions_page.q6_title'.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Column(
                children: fertilizers.map((fert) {
                  String fertKey = _getFertilizerTranslationKey(fert);
                  return CheckboxListTile(
                    title: Text(fertKey.isNotEmpty ? fertKey.tr() : fert),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: selectedFertilizers[fert],
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        selectedFertilizers[fert] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 20),

              // Q8: Equipment (multiple choice)
              Text('questions_page.q7_title'.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Column(
                children: equipment.map((eq) {
                  String eqKey = _getEquipmentTranslationKey(eq);
                  return CheckboxListTile(
                    title: Text(eqKey.isNotEmpty ? eqKey.tr() : eq),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: selectedEquipment[eq],
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        selectedEquipment[eq] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 20),

              // City/Town (mandatory)
              Text('questions_page.city_town_label'.tr(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  hintText: 'questions_page.city_town_hint'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  errorText: _cityController.text.isEmpty && _cityController.text.isNotEmpty 
                      ? 'questions_page.city_town_required'.tr() 
                      : null,
                ),
              ),

              SizedBox(height: 30),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(Icons.check_circle_outline, color: Colors.white),
                  label: Text(
                    'questions_page.submit_button'.tr(),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () async {
                    try{
                    // Validate city/town is mandatory
                    String city = _cityController.text.trim();
                    if (city.isEmpty) {
                      showError(context, 'questions_page.please_enter_city'.tr());
                      return;
                    }

                    List<String> selected_crops = selectedCrops.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .toList();
                    List<String> selected_fertilizers = selectedFertilizers.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .toList();
                    List<String> selected_equipments = selectedEquipment.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .toList();

                    print(selected_equipments);
                    print(selected_fertilizers);
                    print(selected_crops);

                    // Document should already exist (created in login.dart for Google users or register.dart for email users)
                    // Just update it
                    await FirebaseFirestore.instance.collection("Users").doc(widget.uid).update({
                      "crops": selected_crops,
                      "soil_type": selectedSoil ?? "",
                      "irrigation_frequency": selectedFrequency ?? "",
                      "irrigation_method": "",
                      "land_size": selectedLandSize ?? "",
                      "fertilizers": selected_fertilizers,
                      "equipments": selected_equipments,
                      "city": city,
                    });
                    
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNav()));

                    } on FirebaseException catch (_) {
                      showError(context, 'questions_page.error_generic'.tr());
                    }
                  },
                ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods to map English values to translation keys
  String _getCropTranslationKey(String crop) {
    switch (crop) {
      case "Wheat": return 'questions_page.q1_options.wheat';
      case "Millet": return 'questions_page.q1_options.millet';
      case "Rice": return 'questions_page.q1_options.rice';
      case "Legumes": return 'questions_page.q1_options.legumes';
      case "Cotton": return 'questions_page.q1_options.cotton';
      case "Sugarcane": return 'questions_page.q1_options.sugarcane';
      default: return '';
    }
  }

  String _getSoilTranslationKey(String soil) {
    switch (soil) {
      case "Sandy soil": return 'questions_page.q2_options.sandy';
      case "Silty soil": return 'questions_page.q2_options.silty';
      case "Loamy soil": return 'questions_page.q2_options.loamy';
      case "Peaty soil": return 'questions_page.q2_options.peaty';
      default: return '';
    }
  }

  String _getIrrigationFreqTranslationKey(String freq) {
    switch (freq) {
      case "Once a week": return 'questions_page.q3_options.once_week';
      case "Twice a week": return 'questions_page.q3_options.twice_week';
      case "Once a month": return 'questions_page.q3_options.once_month';
      default: return '';
    }
  }

  String _getIrrigationMethodTranslationKey(String method) {
    switch (method) {
      case "Canal irrigation": return 'questions_page.q4_options.canal';
      case "Tank irrigation": return 'questions_page.q4_options.tank';
      case "Wells": return 'questions_page.q4_options.wells';
      case "Sprinkler irrigation": return 'questions_page.q4_options.sprinkler';
      case "Rain dependent": return 'questions_page.q4_options.rain_dependent';
      default: return '';
    }
  }

  String _getLandSizeTranslationKey(String size) {
    switch (size) {
      case "<1 acre": return 'questions_page.q5_options.less_than_1';
      case "1-2 acre": return 'questions_page.q5_options.1_to_2';
      case "> 2 acre": return 'questions_page.q5_options.more_than_2';
      default: return '';
    }
  }

  String _getFertilizerTranslationKey(String fert) {
    switch (fert) {
      case "Urea": return 'questions_page.q6_options.urea';
      case "DAP": return 'questions_page.q6_options.dap';
      case "Ammonium Sulphate": return 'questions_page.q6_options.ammonium_sulphate';
      case "Other NPK fertilizer": return 'questions_page.q6_options.other_npk';
      case "Organic": return 'questions_page.q6_options.organic';
      default: return '';
    }
  }

  String _getEquipmentTranslationKey(String eq) {
    switch (eq) {
      case "Seed, drills/planters": return 'questions_page.q7_options.seed_drills';
      case "Transplanters": return 'questions_page.q7_options.transplanters';
      case "Tractor with implements": return 'questions_page.q7_options.tractor';
      case "Harvesters, reapers, ATVs/RTVs/UTVs": return 'questions_page.q7_options.harvesters';
      case "Others": return 'questions_page.q7_options.others';
      default: return '';
    }
  }

  void showError(BuildContext context, String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'questions_page.error_title'.tr(),
        message: message,
        contentType: ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
  }
