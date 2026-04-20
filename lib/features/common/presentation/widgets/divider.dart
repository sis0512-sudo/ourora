import 'package:flutter/material.dart';
import 'package:ourora/config/theme.dart';

class Divider extends StatelessWidget {
  const Divider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: double.maxFinite, height: 1, color: AppTheme.textGray);
  }
}
