import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:challecara/l10n/app_localizations.dart';
import 'package:challecara/models/calorie_entry_model.dart';
import 'package:challecara/viewmodels/calorie_count_viewmodel.dart';

class CalorieCountScreen extends StatelessWidget {
  const CalorieCountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalorieCountViewModel(),
      child: const _CalorieCountView(),
    );
  }
}

class _CalorieCountView extends StatefulWidget {
  const _CalorieCountView();

  @override
  State<_CalorieCountView> createState() => _CalorieCountViewState();
}

class _CalorieCountViewState extends State<_CalorieCountView> {
  final _formKey = GlobalKey<FormState>();
  final _weight = TextEditingController(text: '60');
  final _minutes = TextEditingController(text: '30');
  ExerciseType _type = ExerciseType.walk;

  @override
  void dispose() {
    _weight.dispose();
    _minutes.dispose();
    super.dispose();
  }

  void _submit(CalorieCountViewModel vm) {
    if (!_formKey.currentState!.validate()) return;
    vm.submit(
      weightKg: double.parse(_weight.text),
      minutes: int.parse(_minutes.text),
      type: _type,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CalorieCountViewModel>();
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.calorie_count),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _numberField(_weight, '体重 (kg)', allowDecimal: true),
              const SizedBox(height: 12),
              _numberField(_minutes, '運動時間 (分)'),
              const SizedBox(height: 12),
              DropdownButtonFormField<ExerciseType>(
                value: _type,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '運動種別',
                ),
                items: ExerciseType.values
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text('${t.label} (${t.mets} METs)'),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _type = v ?? ExerciseType.walk),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _submit(vm),
                icon: const Icon(Icons.local_fire_department),
                label: const Text('計算する'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 24),

              if (vm.latest != null) _ResultCard(entry: vm.latest!),

              if (vm.history.length > 1) ...[
                const SizedBox(height: 16),
                const Text('履歴',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...vm.history.skip(1).take(10).map(
                      (e) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.history),
                        title: Text(
                            '${e.type.label} ${e.minutes}分 / ${e.weightKg}kg'),
                        trailing: Text('${e.kcal.toStringAsFixed(1)} kcal'),
                      ),
                    ),
                TextButton(
                  onPressed: vm.clear,
                  child: const Text('履歴をクリア'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _numberField(
    TextEditingController c,
    String label, {
    bool allowDecimal = false,
  }) {
    return TextFormField(
      controller: c,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: [
        allowDecimal
            ? FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
            : FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return '入力してください';
        final n = double.tryParse(v);
        if (n == null || n <= 0) return '正の数値で入力してください';
        return null;
      },
    );
  }
}

class _ResultCard extends StatelessWidget {
  final CalorieEntry entry;
  const _ResultCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final ratio = (entry.kcal / 400).clamp(0.0, 1.0);
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${entry.kcal.toStringAsFixed(1)} kcal',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800),
            ),
            const SizedBox(height: 8),
            Text('${entry.type.label} ${entry.minutes}分 / ${entry.weightKg}kg'),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 12,
                backgroundColor: Colors.green.shade100,
                valueColor: AlwaysStoppedAnimation(Colors.green.shade600),
              ),
            ),
            const SizedBox(height: 4),
            const Text('目安: 400 kcal を 100%',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
