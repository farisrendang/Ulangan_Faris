import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system, // Switch between light and dark mode based on system settings
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = '';
  String result = '';

  void onPressed(String text) {
    setState(() {
      if (text == 'C') {
        expression = '';
        result = '';
      } else if (text == 'Back') {
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
        }
      } else if (text == '=') {
        try {
          Parser parser = Parser();
          Expression exp = parser.parse(expression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          result = eval.toString();
        } catch (e) {
          result = 'Error';
        }
      } else {
        expression += text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alamak😱😱😱')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    expression,
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                  Text(
                    result,
                    style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          _buildButtonGrid(),
        ],
      ),
    );
  }

  Widget _buildButtonGrid() {
    List<String> buttons = [
      '7', '8', '9', ':',
      '4', '5', '6', 'X',
      '1', '2', '3', '-',
      '.', '0', 'Back', '+',
      'C', '=', '%', '√'
    ];

    return Expanded(
      flex: 2,
      child: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 7,
          mainAxisSpacing: 7,
          childAspectRatio: 1.55, // Ni tombol
        ),
        itemCount: buttons.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () => _onButtonPressed(buttons[index]),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(10), // Buat Padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              buttons[index],
              style: TextStyle(fontSize: 20), // Font tombol
            ),
          );
        },
      ),
    );
  }

  void _onButtonPressed(String text) {
    setState(() {
      if (text == 'C') {
        expression = '';
        result = '';
      } else if (text == 'Back') {
        expression = expression.isNotEmpty
            ? expression.substring(0, expression.length - 1)
            : '';
      } else if (text == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          result = exp.evaluate(EvaluationType.REAL, cm).toString();
        } catch (e) {
          result = 'Error';
        }
      } else if (text == '%') {
        if (expression.isNotEmpty) {
          try {
            Parser p = Parser();
            Expression exp = p.parse(expression + '/100');
            ContextModel cm = ContextModel();
            result = exp.evaluate(EvaluationType.REAL, cm).toString();
          } catch (e) {
            result = 'Error';
          }
        }
      } else if (text == '√') {
        if (expression.isNotEmpty) {
          try {
            Parser p = Parser();
            Expression exp = p.parse('sqrt($expression)');
            ContextModel cm = ContextModel();
            result = exp.evaluate(EvaluationType.REAL, cm).toString();
          } catch (e) {
            result = 'Error';
          }
        }
      } else {
        expression += text;
      }
    });
  }
}