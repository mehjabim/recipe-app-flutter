import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  int _currentNumber = 1;
  List<double> _baseIngredientAmounts = [];

  int get currentNumber => _currentNumber;

  void setBaseIngredientAmounts(List<double> amounts) {
    _baseIngredientAmounts = amounts;
    _currentNumber = 1;
    notifyListeners();
  }

  List<String> get updateIngredientAmounts {
    return _baseIngredientAmounts
        .map<String>((amount) {
          final scaled = amount * _currentNumber;
          // Format neatly (e.g. 10 instead of 10.0 if integer)
          return scaled == scaled.roundToDouble()
              ? scaled.toInt().toString()
              : scaled.toStringAsFixed(1);
        })
        .toList();
  }

  void increaseQuantity() {
    _currentNumber++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (_currentNumber > 1) {
      _currentNumber--;
      notifyListeners();
    }
  }
}
