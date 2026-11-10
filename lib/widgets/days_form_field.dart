import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/models/course.dart';

/// Tick-box day chips for the add/edit forms. A FormField, so the form's
/// validate() also checks that at least one day is picked.
class DaysFormField extends FormField<List<String>> {
  DaysFormField({
    super.key,
    required List<String> initialDays,
    required ValueChanged<List<String>> onChanged,
  }) : super(
          initialValue: initialDays,
          validator: (v) =>
              (v == null || v.isEmpty) ? 'Pick at least one day' : null,
          builder: (field) {
            final picked = field.value ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text('Days'),
                Wrap(
                  spacing: 6,
                  children: [
                    for (final d in weekdays)
                      FilterChip(
                        label: Text(d.substring(0, 3)),
                        selected: picked.contains(d),
                        onSelected: (on) {
                          // keep the days in Mon→Fri order
                          final next = weekdays
                              .where((w) => w == d ? on : picked.contains(w))
                              .toList();
                          field.didChange(next);
                          onChanged(next);
                        },
                      ),
                  ],
                ),
                if (field.hasError)
                  Text(
                    field.errorText!,
                    style: TextStyle(
                      color: Theme.of(field.context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
              ],
            );
          },
        );
}
