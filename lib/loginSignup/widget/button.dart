import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Regbutton extends StatelessWidget {
  final VoidCallback onTab;
  final String text;
  const Regbutton ({
    super.key,
    required this.onTab,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18.2, 0, 0, 49.1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.8),
        gradient: const LinearGradient(
          begin: Alignment(-1, -0.022),
          end: Alignment(1, 0.022),
          colors: [Color(0xFF4A3DE0), Color(0xFF6B21A6)],
          stops: [0, 1],
        ),
      ),
      child: InkWell(
        onTap: onTab,
        borderRadius: BorderRadius.circular(18.8),
        child: Container(
          width: 159.3,
          padding: const EdgeInsets.symmetric(vertical: 21.5),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 13.1,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

  }
}
