import 'package:flutter/material.dart';

IconData specialtyIcon(String specialty) {
  switch (specialty) {
    case 'Cardiology':
      return Icons.favorite_outline;
    case 'Neurology':
      return Icons.psychology_outlined;
    case 'Pediatrics':
      return Icons.child_care_outlined;
    case 'Orthopedic':
      return Icons.accessibility_new_outlined;
    case 'Dermatology':
      return Icons.spa_outlined;
    case 'ENT':
      return Icons.hearing_outlined;
    case 'Ophthalmology':
      return Icons.visibility_outlined;
    case 'Gynecology':
      return Icons.pregnant_woman_outlined;
    case 'General':
    default:
      return Icons.medical_services_outlined;
  }
}
