import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_app/flow.dart';

class Log extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LogState();
  }
}

class _LogState extends State<Log> {
  int currentScreen = 0;
  String selectedPlant = '';
  int currentQuestionIndex = 0;
  int lives = 3;
  String? selectedAnswer;
  bool isCorrectAnswer = false;
  bool showContinueButton = false;
  Timer? _buttonTimer;

  final Color themeColor = Color(0xFF566017);
  final Color lightThemeColor = Color(0xFF969A2A);

  void _startGame() {
    setState(() {
      currentScreen = 1;
    });
  }

  void _selectPlant(String plant) {
    setState(() {
      selectedPlant = plant;
      currentScreen = 2;
    });
  }

  void _restartGame() {
    _buttonTimer?.cancel();
    setState(() {
      currentScreen = 0;
      selectedPlant = '';
      currentQuestionIndex = 0;
      lives = 3;
      selectedAnswer = null;
      isCorrectAnswer = false;
      showContinueButton = false;
    });
  }

  void _startQuestions() {
    setState(() {
      currentScreen = 3;
      currentQuestionIndex = 0;
    });
  }

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;

      String? correctAnswer = game_content[0]["correct_answer"];
      if (correctAnswer != null) {
        List<String> correctAnswers = correctAnswer.split(" | ").map((e) => e.trim()).toList();
        isCorrectAnswer = correctAnswers.contains(answer);
      } else {
        isCorrectAnswer = false;
      }
      
      if (!isCorrectAnswer) {
        lives--;
        if (lives <= 0) {
          _restartGame();
        } else {
          setState(() {
            currentScreen = 5;
            showContinueButton = false;
          });
          _buttonTimer?.cancel();
          _buttonTimer = Timer(Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                showContinueButton = true;
              });
            }
          });
        }
      } else {
        // Show correct answer screen with answer's GIF background
        setState(() {
          currentScreen = 4; // Correct answer screen
          showContinueButton = false;
        });
        // Start timer to show button after 5 seconds
        _buttonTimer?.cancel();
        _buttonTimer = Timer(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              showContinueButton = true;
            });
          }
        });
      }
    });
  }

  void _nextQuestion() {
    // Only show first question, so after correct answer, go to completion
    if (currentScreen == 4 && currentQuestionIndex == 0) {
      setState(() {
        currentScreen = 6; // Completion screen
      });
    } else if (currentQuestionIndex < game_content.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        currentScreen = 3; // Back to question screen
      });
    } else {
      // Game completed
      _restartGame();
    }
  }

  Widget appbar_first_section(){
    return Positioned(
      top: 20,
      left: 20,
      child: Row(
        children: [
          Image.asset("assets/game_symbol.png", width: 30,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            // decoration: BoxDecoration(
            //   color: Colors.black.withOpacity(0.8),
            //   borderRadius: BorderRadius.circular(8),
            // ),
            child: Text(
              'JEEVAN\nKHET',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                height: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appbar_second_section(){
    return Positioned(
      top: 20,
      right: 20,
      child: Row(
        children: List.generate(3, (index) =>
            Container(
              margin: EdgeInsets.only(left: 4),
              child: Image.asset(
                "assets/lives.png", 
                width: 30,
                color: index < lives ? null : Colors.grey,
                colorBlendMode: index < lives ? BlendMode.srcIn : BlendMode.srcIn,
              ),
            ),
        ),
      ),
    );
  }

  Widget _buildIntroScreen() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/game_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          appbar_first_section(),
          appbar_second_section(),

          Positioned(
            top: 120,
            left: 60,
            right: 60,
            child: Container(
              child: Center(
                child: Image.asset(
                  'assets/hi.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          Positioned(
            top: 250,
            left: 40,
            right: 40,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFBFBFBF),
                // borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 3),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE4E4E4), Colors.grey],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                  'THE\n PLANT LIFE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'NTBrickSans',
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 420,
            left: 40,
            right: 40,
            child: GestureDetector(
              onTap: _startGame,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFB8B8B8),
                  // borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 3),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE4E4E4), Colors.grey],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(4),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'LET\'S START',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'NTBrickSans',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantSelectionScreen() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/game_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          appbar_first_section(),
          appbar_second_section(),

          Positioned(
            top: 100,
            left: 80,
            right: 80,
            child: Container(
              child: Center(
                child: Image.asset(
                  'assets/pick_plant.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          Positioned(
            top: 200,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildPlantCard('green_tree.png', 'GREEN TREE', Color(
                          0xFFc7e5ac)),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildPlantCard('cherry_blossom.png', 'CHERRY BLOSSOM', Color(
                          0xFF7e455b)),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildPlantCard('autumn_tree.png', 'AUTUMN TREE', Color(0xFF834322)),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildPlantCard('palm_tree.png', 'PALM TREE', Color(0xFF533f0d)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantCard(String imagePath, String name, Color bgColor) {
    return GestureDetector(
      onTap: () => _selectPlant(name),
      child: Container(
        height: 200,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Image.asset(
                  'assets/$imagePath',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  name.replaceAll(" ", "\n"),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrationScreen() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/game_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          appbar_first_section(),
          appbar_second_section(),

          Positioned(
            top: 120,
            left: 60,
            right: 60,
            child: Container(
              child: Center(
                child: Image.asset(
                  'assets/hooray.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          Positioned(
            top: 250,
            left: 60,
            right: 60,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                // border: Border.all(color: Colors.black, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Color(0xFF90EE90),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/${_getPlantImagePath(selectedPlant)}',
                        // width: 170,
                        // height: 170,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      selectedPlant,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 600,
            left: 40,
            right: 40,
            child: GestureDetector(
              onTap: _startQuestions,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFB8B8B8),
                  // borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 3),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE4E4E4), Colors.grey],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(4),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'CONTINUE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'NTBrickSans',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPlantImagePath(String plantName) {
    switch (plantName) {
      case 'GREEN TREE':
        return 'green_tree.png';
      case 'CHERRY BLOSSOM':
        return 'cherry_blossom.png';
      case 'AUTUMN TREE':
        return 'autumn_tree.png';
      case 'PALM TREE':
        return 'palm_tree.png';
      default:
        return 'green_tree.png';
    }
  }

  String _getPlantDirectoryName(String plantName) {
    switch (plantName) {
      case 'GREEN TREE':
        return 'green_tree';
      case 'CHERRY BLOSSOM':
        return 'cherry_blossom';
      case 'AUTUMN TREE':
        return 'autumn_tree';
      case 'PALM TREE':
        return 'palm_tree';
      default:
        return 'green_tree';
    }
  }

  Widget _buildQuestionScreen() {
    // Only show first question
    if (currentQuestionIndex >= 1) {
      return _buildCompletionScreen();
    }

    var question = game_content[0]; // Always show first question
    String questionGifPath = 'assets/${_getPlantDirectoryName(selectedPlant)}/question.gif';
    
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(questionGifPath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          appbar_first_section(),
          appbar_second_section(),

          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.circular(12),
              //   border: Border.all(color: Colors.black, width: 3),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.black.withOpacity(0.3),
              //       blurRadius: 10,
              //       offset: Offset(5, 5),
              //     ),
              //   ],
              // ),
              child: Text(
                question["question"].toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'NTBrickSans',
                ),
              ),
            ),
          ),

          // Answer buttons
          Positioned(
            top: 250,
            left: 40,
            right: 40,
            child: Column(
              children: question["options"].map<Widget>((option) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 35),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE4E4E4), Color(0xFF518751)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () => _selectAnswer(option),
                    child: Container(
                      margin: EdgeInsets.all(3),
                      // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFF9ADC9A),
                        // borderRadius: BorderRadius.circular(12),
                        // border: Border.all(color: Colors.black, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            offset: Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        option.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildQuestionPlant() {
    return Center(
      child: Image.asset(
        'assets/${_getPlantImagePath(selectedPlant)}',
        width: 120,
        height: 120,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildCorrectAnswerScreen() {
    var question = game_content[0]; // Always use first question
    // Use the selected answer's GIF file name as background
    String answerGifPath = 'assets/${_getPlantDirectoryName(selectedPlant)}/${selectedAnswer ?? "final"}.gif';
    
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(answerGifPath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          appbar_first_section(),
          appbar_second_section(),

          // Show the answer text from the list (before the container)
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                question["answer"] ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),

          // Show the selected answer container (drip irrigation container)
          Positioned(
            top: 280,
            left: 40,
            right: 40,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 35),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE4E4E4), Color(0xFF518751)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(3),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF9ADC9A),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: Text(
                  selectedAnswer!.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ),

          // Continue button - show after 5 seconds, positioned after the container
          if (showContinueButton)
            Positioned(
              top: 380,
              left: 40,
              right: 40,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    currentScreen = 6; // Go to completion screen with last.png
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFB8B8B8),
                    border: Border.all(color: Colors.black, width: 3),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE4E4E4), Colors.grey],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(4),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Text(
                      'CONTINUE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWrongAnswerScreen() {
    var question = game_content[0]; // Always use first question
    // Use the selected answer's GIF file name for wrong answers too
    String answerGifPath = 'assets/${_getPlantDirectoryName(selectedPlant)}/${selectedAnswer ?? "final"}.gif';
    
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(answerGifPath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          appbar_first_section(),
          appbar_second_section(),

          // Show the wrong text from the list (before the container)
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                question["wrong"] ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),

          // Show the selected answer container
          Positioned(
            top: 280,
            left: 40,
            right: 40,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 35),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE4E4E4), Color(0xFF518751)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(3),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF9ADC9A),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: Text(
                  selectedAnswer!.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ),

          // Try Again button - show after 5 seconds, positioned after the container
          if (showContinueButton)
            Positioned(
              top: 380,
              left: 40,
              right: 40,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    currentScreen = 3; // Go back to question screen
                    selectedAnswer = null;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFB8B8B8),
                    border: Border.all(color: Colors.black, width: 3),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE4E4E4), Colors.grey],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(4),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Text(
                      'TRY AGAIN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/${_getPlantDirectoryName(selectedPlant)}/final.gif'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          appbar_first_section(),
          appbar_second_section(),
          
          // Message saying more challenges will come soon
          Positioned(
            top: 100,
            left: 40,
            right: 40,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                'More challenges coming soon!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCompleteScreen() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/game_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          appbar_first_section(),
          appbar_second_section(),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'GAME COMPLETE!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'monospace',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'You completed all questions!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'monospace',
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: _restartGame,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          decoration: BoxDecoration(
                            color: Color(0xFF90EE90),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black, width: 3),
                          ),
                          child: Text(
                            'PLAY AGAIN',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text(translate('Sustainability Game'),
      //       style: TextStyle(fontWeight: FontWeight.w700)),
      //   backgroundColor: Color(0xFF969A2A),
      //   centerTitle: true,
      // ),
      body: Stack(
        children: [
          if (currentScreen == 0) _buildIntroScreen(),
          if (currentScreen == 1) _buildPlantSelectionScreen(),
          if (currentScreen == 2) _buildCelebrationScreen(),
          if (currentScreen == 3) _buildQuestionScreen(),
          if (currentScreen == 4) _buildCorrectAnswerScreen(),
          if (currentScreen == 5) _buildWrongAnswerScreen(),
          if (currentScreen == 6) _buildCompletionScreen(),
        ],
      ),
    );
  }
}