import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp()); // Aquí se ejecuta la clase MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const CalculadoraScreen(),
    );
  }
}

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({Key? key}) : super(key: key);

  @override
  _CalculadoraScreenState createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> with SingleTickerProviderStateMixin {
  String _output = "0";
  String _operand = "";
  double _num1 = 0;
  double _num2 = 0;

  late AnimationController _animationController;
  late Animation<Color?> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _glowAnimation = ColorTween(
      begin: Colors.white.withOpacity(0.3),
      end: Colors.white.withOpacity(0.7),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _num1 = 0;
        _num2 = 0;
        _operand = "";
      } else if (buttonText == "DEL") {
        if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = "0";
        }
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "x" || buttonText == "/") {
        _num1 = double.parse(_output);
        _operand = buttonText;
        _output = "0";
      } else if (buttonText == "=") {
        _num2 = double.parse(_output);
        if (_operand == "+") {
          _output = (_num1 + _num2).toString();
        } else if (_operand == "-") {
          _output = (_num1 - _num2).toString();
        } else if (_operand == "x") {
          _output = (_num1 * _num2).toString();
        } else if (_operand == "/") {
          _output = (_num2 != 0) ? (_num1 / _num2).toString() : "Error";
        }
        _num1 = 0;
        _num2 = 0;
        _operand = "";
      } else {
        _output = (_output == "0") ? buttonText : _output + buttonText;
      }
    });
  }

  Widget _buildButton(Widget child, Color color, String operation, {bool isNumber = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: () => _onButtonPressed(operation),
          child: AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) => Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: _glowAnimation.value!,
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: child,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Juan'),
        backgroundColor: Colors.teal[800],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color.fromARGB(255, 246, 243, 248), Colors.teal[700]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.teal[50]!.withOpacity(0.9),
                    border: Border.all(color: const Color.fromARGB(255, 1, 5, 5), width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(20),
                  child: Text(
                    _output,
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
              ),
              Divider(height: 1, color: Colors.teal[800]),
              _buildRow(["7", "8", "9", "/"], Icons.horizontal_rule),
              Divider(color: Colors.teal[800]),
              _buildRow(["4", "5", "6", "x"], Icons.clear),
              Divider(color: Colors.teal[800]),
              _buildRow(["1", "2", "3", "-"], Icons.remove),
              Divider(color: Colors.teal[800]),
              _buildRow(["C", "0", "=", "+"], Icons.add),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> symbols, IconData icon) {
    return Row(
      children: symbols.map((symbol) {
        return _buildButton(
          symbol == "C"
              ? const Icon(Icons.delete, color: Colors.white, size: 28)
              : symbol == "="
                  ? const Text("=", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white))
                  : (symbol == "/" || symbol == "x" || symbol == "-" || symbol == "+")
                      ? Icon(icon, color: Colors.white, size: 28)
                      : Text(symbol, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          symbol == "C" || symbol == "=" ? Colors.blue[400]! : Colors.red[400]!,
          symbol,
          isNumber: RegExp(r'^[0-9]$').hasMatch(symbol),
        );
      }).toList(),
    );
  }
}
