import 'package:flutter/material.dart';
import 'package:ci_calculator_app/widget/dropdown.dart';
import 'package:ci_calculator_app/widget/json.dart';
import 'dart:math';

class CompoundInterestCalculator extends StatefulWidget {
  const CompoundInterestCalculator({super.key});

  @override
  _CompoundInterestCalculatorState createState() =>
      _CompoundInterestCalculatorState();
}

class _CompoundInterestCalculatorState
    extends State<CompoundInterestCalculator> {
  // Initial values
  String selectedRate = "1";
  String principalAmount = "";
  String selectedCompounds = "1";
  String selectedYears = "1";

  // Function to calculate compound interest
  double calculateCompoundInterest() {
    // Check if principalAmount is empty or null
    if (principalAmount.isEmpty) {
      return 0.0; // Or any default value you prefer
    }

    double principal = double.parse(principalAmount);
    double rate = double.parse(config["rateOfInterest"]["values"][selectedRate]
            .replaceAll("%", "")) /
        100;
    int compounds = int.parse(selectedCompounds);
    int years = int.parse(selectedYears);

    double amount =
        principal * pow((1 + rate / compounds), (compounds * years));

    return amount;
  }

  // Function to validate principal amount
  String? validatePrincipalAmount(String? value) {
    double amount = double.tryParse(value!) ?? 0.0;
    double minAmount = config["principalAmount"]["minAmount"][selectedRate];
    double maxAmount = config["principalAmount"]["maxAmount"];

    if (amount < minAmount || amount > maxAmount) {
      return config["principalAmount"]["errorMsg"];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compound Interest Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Rate of Interest
            DropdownWidget(
              labelText: "Rate of Interest",
              selectedValue: selectedRate,
              values: config["rateOfInterest"]["values"],
              onChanged: (String? value) {
                setState(() {
                  selectedRate = value!;
                  principalAmount = ""; // Clear principal amount on rate change
                });
              },
            ),
            const SizedBox(height: 20.0),

            // Principal Amount
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: config["principalAmount"]["hintText"],
                  hintStyle: TextStyle(
                    color: config["principalAmount"]["textColor"],
                    fontSize: config["principalAmount"]["textSize"],
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: config["principalAmount"]["textColor"],
                  fontSize: config["principalAmount"]["textSize"],
                ),
                onChanged: (value) {
                  setState(() {
                    principalAmount = value;
                  });
                },
                validator: validatePrincipalAmount,
              ),
            ),

            const SizedBox(height: 20.0),
            // No. of Times to Compound in a Year
            DropdownWidget(
              labelText: "No. of Times to Compound in a Year",
              selectedValue: selectedCompounds,
              values: config["compoundsPerYear"]["values"],
              onChanged: (String? value) {
                if (value != null) {
                  int newCompounds = int.parse(value);
                  int selectedYearsValue = int.parse(selectedYears);
                  if (selectedYearsValue > newCompounds * 10) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: const Text(
                              "The selected number of years may conflict with the new compound frequency value."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    setState(() {
                      selectedCompounds = value;
                      config["years"]["values"] = config["years"]
                          ["generateYears"](int.parse(selectedCompounds));
                    });
                  }
                }
              },
            ),

            const SizedBox(height: 20.0),

            // No. of Years
            DropdownWidget(
              labelText: "No. of Years",
              selectedValue: selectedYears,
              values: config["years"]["values"],
              onChanged: updateSelectedYears,
            ),
            const SizedBox(height: 20.0),
            Text(
              "Compound Interest: ${calculateCompoundInterest().toStringAsFixed(2)}",
              style: TextStyle(
                color: config["output"]["textColor"],
                fontSize: config["output"]["textSize"],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CompoundInterestCalculator
  void updateSelectedYears(String? value) {
    setState(() {
      selectedYears = value ?? "";
    });
  }
}
