import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/l10n_extension.dart';
import '../../../database/app_database.dart';
import '../../baby/providers/baby_provider.dart';

class AddWeightScreen extends ConsumerStatefulWidget {
  const AddWeightScreen({super.key});

  @override
  ConsumerState<AddWeightScreen> createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends ConsumerState<AddWeightScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _measuredAt = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _measuredAt,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      helpText: context.l10n.measurementDateLabel,
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_measuredAt),
    );
    if (time == null) return;

    setState(() {
      _measuredAt = DateTime(
        date.year, date.month, date.day, time.hour, time.minute,
      );
    });
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final baby = ref.read(selectedBabyProvider);
    if (baby == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectBabyFirst)),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final weightKg =
        double.parse(_weightController.text.trim().replaceAll(',', '.'));

    setState(() => _isSaving = true);

    try {
      final db = ref.read(databaseProvider);
      await db.weightDao.insertWeight(
        WeightEntriesCompanion.insert(
          id: const Uuid().v4(),
          babyId: baby.id,
          weightGrams: weightKg * 1000,
          measuredAt: _measuredAt,
          notes: _notesController.text.trim().isNotEmpty
              ? Value(_notesController.text.trim())
              : const Value.absent(),
        ),
      );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.saveError('$e'))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _fmt(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/${dt.year}  '
      '${dt.hour.toString().padLeft(2, '0')}:'
      '${dt.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addWeightTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weight
                Text(l10n.weightKgLabel, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _weightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                  ],
                  decoration: InputDecoration(
                    hintText: l10n.weightHint,
                    suffixText: 'kg',
                    prefixIcon: const Icon(Icons.monitor_weight_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.enterWeight;
                    }
                    final parsed =
                        double.tryParse(value.trim().replaceAll(',', '.'));
                    if (parsed == null || parsed <= 0) {
                      return l10n.invalidWeight;
                    }
                    if (parsed > 30) {
                      return l10n.weightTooHigh;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Date & time
                Text(l10n.measurementDateLabel,
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickDateTime,
                  borderRadius: BorderRadius.circular(14),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.event_outlined),
                    ),
                    child:
                        Text(_fmt(_measuredAt), style: theme.textTheme.bodyLarge),
                  ),
                ),
                const SizedBox(height: 24),

                // Notes
                Text(l10n.notesLabel, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(hintText: l10n.notesHint),
                ),
                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.saveWeight),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
