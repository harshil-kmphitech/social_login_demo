import 'package:flutter/material.dart';

class AppEdgeInsets extends EdgeInsets {
  const AppEdgeInsets.all8() : super.all(8);
  const AppEdgeInsets.all10() : super.all(10);
  const AppEdgeInsets.all12() : super.all(12);
  const AppEdgeInsets.all14() : super.all(14);
  const AppEdgeInsets.all16() : super.all(16);
  const AppEdgeInsets.all18() : super.all(18);
  const AppEdgeInsets.all20() : super.all(20);

  const AppEdgeInsets.h16() : super.symmetric(horizontal: 16);

  const AppEdgeInsets.v16() : super.symmetric(horizontal: 16);
}
