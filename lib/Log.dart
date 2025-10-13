import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:my_app/flow.dart';

class Log extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LogState();
  }
}

class _LogState extends State<Log> {
  int currentScreen = 0; // 0: intro, 1: plant selection, 2: celebration, 3+: questions, 4: correct answer, 5: wrong answer
  String selectedPlant = '';
  int currentQuestionIndex = 0;
  int lives = 3;
  String? selectedAnswer;
  bool isCorrectAnswer = false;

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
    setState(() {
      currentScreen = 0;
      selectedPlant = '';
      currentQuestionIndex = 0;
      lives = 3;
      selectedAnswer = null;
      isCorrectAnswer = false;
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
      
      // Check if answer is correct
      String correctAnswer = game_content[currentQuestionIndex]["correct_answer"];
      for(String i in correctAnswer.split(" | ")) {
        isCorrectAnswer = answer == i;
      }
      
      if (!isCorrectAnswer) {
        lives--;
        currentScreen = 5; // Wrong answer screen
      } else {
        currentScreen = 4; // Correct answer screen
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < game_content.length - 1) {
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
    if (currentQuestionIndex >= game_content.length) {
      return _buildGameCompleteScreen();
    }

    var question = game_content[currentQuestionIndex];
    
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/${_getPlantDirectoryName(selectedPlant)}/question.gif'),
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
    var question = game_content[currentQuestionIndex];
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/${_getPlantDirectoryName(selectedPlant)}/${selectedAnswer}.gif'),
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
              children: [
              Container(
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
                    onTap: () {},
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
              ]
            ),
          ),
          // Continue button
          // Positioned(
          //   bottom: 50,
          //   left: 40,
          //   right: 40,
          //   child: GestureDetector(
          //     onTap: _nextQuestion,
          //     child: Container(
          //       padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          //       decoration: BoxDecoration(
          //         color: Color(0xFFB8B8B8),
          //         border: Border.all(color: Colors.black, width: 3),
          //         gradient: const LinearGradient(
          //           colors: [Color(0xFFE4E4E4), Colors.grey],
          //           begin: Alignment.topLeft,
          //           end: Alignment.bottomRight,
          //         ),
          //       ),
          //       child: Container(
          //         margin: EdgeInsets.all(4),
          //         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //         ),
          //         child: Text(
          //           currentQuestionIndex < game_content.length - 1 ? 'NEXT QUESTION' : 'FINISH GAME',
          //           textAlign: TextAlign.center,
          //           style: TextStyle(
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.black,
          //             fontFamily: 'monospace',
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildWrongAnswerScreen() {
    var question = game_content[currentQuestionIndex];
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/${_getPlantDirectoryName(selectedPlant)}/${selectedAnswer}.gif'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          appbar_first_section(),
          appbar_second_section(),

          // Answer buttons
          Positioned(
            top: 150,
            left: 40,
            right: 40,
            child: Column(
                children: [
                  Container(
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
                      onTap: () {},
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
                ]
            ),
          ),

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
                question["wrong"].toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
          // Continue button
          Positioned(
            top: 1,
            left: 40,
            right: 40,
            child: GestureDetector(
              onTap: _nextQuestion,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
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
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Text(
                    'Try Again'.toUpperCase(),
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
        ],
      ),
    );
  }
}