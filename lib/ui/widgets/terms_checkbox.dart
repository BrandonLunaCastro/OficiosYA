import 'package:flutter/material.dart';

class TermsCheckbox extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  const TermsCheckbox({super.key, required this.onChanged});

  @override
  State<TermsCheckbox> createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _checked,
            onChanged: (value) {
              setState(() => _checked = value ?? false);
              widget.onChanged(_checked);
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(text: 'Acepto los '),
                    TextSpan(
                      text: 'Términos de servicio',
                      style: TextStyle(color: Color(0xFF2B66DF), fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' y la '),
                    TextSpan(
                      text: 'Política de privacidad',
                      style: TextStyle(color: Color(0xFF2B66DF), fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' de OficiosYa.'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}