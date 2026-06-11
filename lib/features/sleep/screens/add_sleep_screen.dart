import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/l10n_extension.dart';
import '../../../database/app_database.dart';
import '../../baby/providers/baby_provider.dart';

class AddSleepScreen extends ConsumerStatefulWidget {
  const AddSleepScreen({super.key});

  @override
  ConsumerState<AddSleepScreen> createState() => _AddSleepScreenState();
}

class _AddSleepScreenState extends ConsumerState<AddSleepScreen> {
  final _notesController = TextEditingController();
  Timer? _durationTimer;

  DateTime _startTime = DateTime.now();
  DateTime? _endTime;
  bool _isOngoing = false; // start timer without an end time
  bool _isSaving = false;

  @override
  void dispose() {
    _durationTimer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickStart() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startTime,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startTime),
    );
    if (time == null) return;
    setState(() => _startTime = DateTime(
          date.year, date.month, date.day, time.hour, time.minute,
        ));
  }

  Future<void> _pickEnd() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endTime ?? DateTime.now(),
      firstDate: _startTime,
      lastDate: DateTime.now(),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_endTime ?? DateTime.now()),
    );
    if (time == null) return;
    setState(() => _endTime = DateTime(
          date.year, date.month, date.day, time.hour, time.minute,
        ));
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  void _stopDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = null;
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}min';
  }

  Future<void> _save() async {
    _durationTimer?.cancel();
    final l10n = context.l10n;
    final baby = ref.read(selectedBabyProvider);
    if (baby == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectBabyFirst)),
      );
      return;
    }

    if (!_isOngoing && _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.endTimeRequired)),
      );
      return;
    }

    if (!_isOngoing && _endTime != null && _endTime!.isBefore(_startTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.endAfterStart)),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final db = ref.read(databaseProvider);

      // Only one active session is allowed at a time.
      if (_isOngoing) {
        final active = await db.sleepDao.getActiveSleep(baby.id);
        if (active != null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.activeSleepExists)),
            );
            setState(() => _isSaving = false);
          }
          return;
        }
      }

      await db.sleepDao.insertSleep(
        SleepEntriesCompanion.insert(
          id: const Uuid().v4(),
          babyId: baby.id,
          startTime: _startTime,
          endTime: _isOngoing ? const Value.absent() : Value(_endTime!),
          notes: _notesController.text.isNotEmpty
              ? Value(_notesController.text.trim())
              : const Value.absent(),
        ),
      );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorLabel('$e'))),
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
    const color = Color(0xFF7C83FD);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addSleepTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ongoing toggle
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: _isOngoing
                      ? color.withValues(alpha: 0.08)
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _isOngoing
                        ? color
                        : theme.dividerTheme.color ?? const Color(0xFFE8E8E8),
                  ),
                ),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _isOngoing,
                  activeThumbColor: color,
                  title: Text(l10n.ongoingSleepLabel,
                      style: theme.textTheme.titleMedium),
                  subtitle: Text(l10n.ongoingSleepSubtitle),
                  onChanged: (v) {
                    setState(() {
                      _isOngoing = v;
                      if (v) {
                        _endTime = null;
                      }
                    });
                    if (v) {
                      _startDurationTimer();
                    } else {
                      _stopDurationTimer();
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Start time
              Text(l10n.startTimeLabel, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickStart,
                borderRadius: BorderRadius.circular(14),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.play_arrow_rounded),
                  ),
                  child: Text(_fmt(_startTime), style: theme.textTheme.bodyLarge),
                ),
              ),
              if (_isOngoing) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.ongoingDurationLabel(
                      _formatDuration(DateTime.now().difference(_startTime))),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: color, fontWeight: FontWeight.w600),
                ),
              ],
              const SizedBox(height: 24),

              // End time
              if (!_isOngoing) ...[
                Text(l10n.endTimeLabel, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickEnd,
                  borderRadius: BorderRadius.circular(14),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.stop_rounded),
                    ),
                    child: Text(
                      _endTime != null ? _fmt(_endTime!) : l10n.selectEndTime,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: _endTime == null
                            ? theme.colorScheme.outline
                            : null,
                      ),
                    ),
                  ),
                ),
                if (_endTime != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.durationValue(
                        _formatDuration(_endTime!.difference(_startTime))),
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: color, fontWeight: FontWeight.w600),
                  ),
                ],
                const SizedBox(height: 24),
              ],

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
                    : Text(_isOngoing ? l10n.startRecording : l10n.saveSleep),
              ),
            ],
          ),
        ),
      ),
    );
  }
}