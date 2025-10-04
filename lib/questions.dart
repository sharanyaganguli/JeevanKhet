import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController _nameController = TextEditingController();

  // Crops list
  final List<String> crops = [
    "Wheat",
    "Millet",
    "Rice",
    "Legumes",
    "Cotton",
    "Sugarcane",
  ];

  Map<String, bool> selectedCrops = {};

  // Question 3: Soil type (single choice)
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'JeevanKhet',
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
                "Help us get to know your farm better! Share your techniques and we'll tailor the app just for you.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Question 2: Crops
              Text(
                "1. What crop do you grow?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),

              // Checkboxes
              Wrap(
                spacing: 10,
                runSpacing: 5,
                children: crops.map((crop) {
                  return SizedBox(
                    width: 150, // adjust width so two checkboxes per row
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(crop),
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
              Text("2. What type of soil do you have?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Column(
                children: soilTypes.map((soil) {
                  return RadioListTile<String>(
                    title: Text(soil),
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
              Text("3. Do you irrigate, and if so, how often?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Column(
                children: irrigationFrequency.map((freq) {
                  return RadioListTile<String>(
                    title: Text(freq),
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
              Text("4. What irrigation methods are available to you?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Column(
                children: irrigationMethods.map((method) {
                  return CheckboxListTile(
                    title: Text(method),
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
              Text("5. How large is your land size? (in acres)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Column(
                children: landSizes.map((size) {
                  return RadioListTile<String>(
                    title: Text(size),
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
              Text("6. Which fertilizer do you apply?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Column(
                children: fertilizers.map((fert) {
                  return CheckboxListTile(
                    title: Text(fert),
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
              Text("7. What equipment do you have available?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Column(
                children: equipment.map((eq) {
                  return CheckboxListTile(
                    title: Text(eq),
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
                    "SUBMIT",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () async {
                    try{


                    String name = _nameController.text.trim();
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

                    await FirebaseFirestore.instance.collection("Users").doc(widget.uid).
                    update(
                    {"crops": selected_crops,
                    "soil_type": selectedSoil,
                    "irrigation_frequency": selectedFrequency,
                    "irrigation_method": "",
                    "land_size": selectedLandSize,
                    "fertilizers":selected_fertilizers,
                    "equipments": selected_equipments,}
                    );
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNav()));

                    } on FirebaseException catch (_) {
                      showError(context, "Something went wrong, try again");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void showError(BuildContext context, String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Error!',
        message: message,
        contentType: ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
  }
