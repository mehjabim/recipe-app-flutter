import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../Utils/constants.dart';

class QuantityIncrementDecrement extends StatelessWidget {
  final int currentNumber;
  final VoidCallback onAdd;
  final VoidCallback onRemov;

  const QuantityIncrementDecrement({
    super.key,
    required this.currentNumber,
    required this.onAdd,
    required this.onRemov,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: kprimaryColor.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: kBorderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onRemov,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: kbackgroundColor,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Iconsax.minus, size: 16, color: kTextPrimaryColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              '$currentNumber',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kTextPrimaryColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: kprimaryColor,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Iconsax.add, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
