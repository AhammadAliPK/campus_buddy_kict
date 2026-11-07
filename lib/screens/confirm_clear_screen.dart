import 'package:flutter/material.dart';

class ConfirmClearScreen extends StatelessWidget {
  final String title;
  final String message;

  const ConfirmClearScreen({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 64,
                color: Colors.amber,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes, confirm'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No, cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
