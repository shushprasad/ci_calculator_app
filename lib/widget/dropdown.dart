import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final String labelText;
  final String selectedValue;
  final Map<String, dynamic> values;
  final ValueChanged<String?>? onChanged;

  const DropdownWidget({
    required this.labelText,
    required this.selectedValue,
    required this.values,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4), 
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black), 
            borderRadius: BorderRadius.circular(5), 
          ),
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: const InputDecoration(
              border: InputBorder.none, 
            ),
            items: values.keys.map<DropdownMenuItem<String>>((key) {
              return DropdownMenuItem<String>(
                value: key,
                child: Text(
                  values[key],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
