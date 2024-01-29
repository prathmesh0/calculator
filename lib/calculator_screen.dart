import 'package:calculator_app/button_value.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String num1 = "";
  String operand = "";
  String num2 = "";
  @override
  Widget build(BuildContext context) {
    final screenSized = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$num1$operand$num2".isEmpty ? "0" : "$num1$operand$num2",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            //button
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (val) => SizedBox(
                        width: val == Btn.n0
                            ? screenSized.width / 2
                            : (screenSized.width / 4),
                        height: screenSized.width / 5,
                        child: buildButton(val)),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getButtonColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

//#####
  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }
    appendValue(value);
  }

//###
//calaculate the results

  void calculate() {
    if (num1.isEmpty) return;
    if (operand.isEmpty) return;
    if (num2.isEmpty) return;
    final double number1 = double.parse(num1);
    final double number2 = double.parse(num2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = number1 + number2;
        break;

      case Btn.subtract:
        result = number1 - number2;
        break;

      case Btn.multiply:
        result = number1 * number2;
        break;

      case Btn.divide:
        result = number1 / number2;
        break;
      default:
    }
    setState(() {
      num1 = "$result";
      if (num1.endsWith(".0")) {
        num1 = num1.substring(0, num1.length - 2);
      }
      operand = "";
      num2 = "";
    });
  }

//###
//convert percentage
  void convertToPercentage() {
    //
    if (num1.isNotEmpty && operand.isNotEmpty && num2.isNotEmpty) {
      //calculate before conversion
      calculate();
    }
    if (operand.isNotEmpty) {
      //cannot be converted
      return;
    }
    final number = double.parse(num1);
    setState(() {
      num1 = "${(number / 100)}";
      operand = "";
      num2 = "";
    });
  }

//####
//clear output
  void clearAll() {
    setState(() {
      num1 = "";
      operand = "";
      num2 = "";
    });
  }

//####
//delete one from end
  void delete() {
    if (num2.isNotEmpty) {
      //1233 -> 123
      num2 = num2.substring(0, num2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (num1.isNotEmpty) {
      num1 = num1.substring(0, num1.length - 1);
    }

    setState(() {});
  }

  void appendValue(String value) {
    //num1 operand num2
    //2343    +    122

    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && num2.isNotEmpty) {
        calculate();
      }
      operand = value;
    } else if (num1.isEmpty || operand.isEmpty) {
      //number1 =1.3
      if (value == Btn.dot && num1.contains(Btn.dot)) return;
      if (value == Btn.dot && (num1.isEmpty || num1 == Btn.n0)) {
        value = "0.";
      }
      num1 += value;
    } else if (num2.isEmpty || operand.isNotEmpty) {
      //number1 =1.3
      if (value == Btn.dot && num2.contains(Btn.dot)) return;
      if (value == Btn.dot && (num2.isEmpty || num2 == Btn.n0)) {
        value = "0.";
      }
      num2 += value;
    }
    setState(() {});
  }

//####
  Color getButtonColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }
}
