import 'package:flutter/material.dart';

class TernaryWidget extends StatelessWidget {
  const TernaryWidget({
    Key? key,
    required this.condition,
    required this.whenTrue,
    this.whenFalse = const SizedBox(),
  }) : super(key: key);

  final bool condition;
  final Widget whenTrue;
  final Widget? whenFalse;

  @override
  Widget build(BuildContext context) => condition ? whenTrue : whenFalse!;
}
