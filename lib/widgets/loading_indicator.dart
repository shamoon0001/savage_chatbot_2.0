// lib/widgets/loading_indicator.dart
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Ensure you've added this to pubspec.yaml

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingIndicator({super.key, this.size = 50.0, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitChasingDots( // You can choose other SpinKit animations
        color: color ?? Theme.of(context).colorScheme.primary,
        size: size,
      ),
    );
  }
}

// A simple linear loading indicator for specific places
class LinearLoadingIndicator extends StatelessWidget {
  const LinearLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
    );
  }
}
