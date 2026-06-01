import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditableField extends StatelessWidget {
  final String label;
  final String value;
  final bool isEditing;
  final TextEditingController controller;
  final VoidCallback onEdit;
  final VoidCallback onSave;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double titleSize;

  const EditableField({
    super.key,
    required this.label,
    required this.value,
    required this.isEditing,
    required this.controller,
    required this.onEdit,
    required this.onSave,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    required this.titleSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: isEditing
              ? TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  style: TextStyle(fontSize: titleSize),
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: TextStyle(fontSize: titleSize * 0.75),
                  ),
                )
              : Text(value, style: TextStyle(fontSize: titleSize)),
        ),
        IconButton(
          icon: Icon(
            isEditing ? Icons.check : Icons.edit,
            color: const Color.fromARGB(255, 15, 11, 218),
          ),
          onPressed: isEditing ? onSave : onEdit,
        ),
      ],
    );
  }
}