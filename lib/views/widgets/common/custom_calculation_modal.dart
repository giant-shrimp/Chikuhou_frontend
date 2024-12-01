import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../settings/settings_calculation_method.dart';
import 'custom_button.dart';

class CustomModal extends StatelessWidget {
  final WidgetRef ref;
  final String title;
  final IconData headerIcon;
  final List<Map<String, String>> formulas; // 数式と説明文のリスト
  final String overview; // 概要の説明
  final List<Map<String, dynamic>> compatibleTypes; // 相性の良いタイプの説明
  final String advantages; // メリットの説明
  final String disadvantages; // デメリットの説明
  final String methodKey; // どの計算方法が選ばれたかを渡す

  const CustomModal({
    super.key,
    required this.ref,
    required this.title,
    required this.headerIcon,
    required this.formulas,
    required this.overview,
    required this.compatibleTypes,
    required this.advantages,
    required this.disadvantages,
    required this.methodKey,
  });

  Widget _buildSection(String heading, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        content,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFormulaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: formulas.map((formula) {
        final hasDescription = formula['description']?.isNotEmpty ?? false;
        final hasFormula = formula['formula']?.isNotEmpty ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasDescription)
              Text(
                formula['description'] ?? '',
                style: const TextStyle(fontSize: 14),
              ),
            if (hasDescription) const SizedBox(height: 8),
            if (hasFormula)
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Math.tex(formula['formula'] ?? ''),
                ),
              ),
            if (hasDescription || hasFormula) const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Row(
          children: [
            Expanded(
              flex: 1, // 画面左側1/6を空白に
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.transparent),
              ),
            ),
            Expanded(
              flex: 5, // 画面右側5/6をモーダルに
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      leading: Icon(headerIcon, color: Colors.white),
                      title: Text(title),
                      automaticallyImplyLeading: false,
                      backgroundColor: const Color(0xFF228B22),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSection('数式', _buildFormulaSection()),
                            _buildSection('概要', Text(overview)),
                            _buildSection(
                              '相性の良いタイプ',
                              Column(
                                children: compatibleTypes.map((type) {
                                  return Row(
                                    children: [
                                      Icon(type['icon'], color: Colors.green),
                                      const SizedBox(width: 8),
                                      Text(type['label']),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            _buildSection('メリット', Text(advantages)),
                            _buildSection('デメリット', Text(disadvantages)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: '決定',
                          onPressed: () {
                            ref.read(methodProvider.notifier).state = methodKey;
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showCustomModal(
    BuildContext context,
    WidgetRef ref, {
      required String title,
      required IconData icon,
      required List<Map<String, String>> formulas, // 数式と説明文のリストを受け取る
      required String overview,
      required List<Map<String, dynamic>> compatibleTypes,
      required String advantages,
      required String disadvantages,
      required String methodKey,
    }) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    pageBuilder: (context, animation, secondaryAnimation) => CustomModal(
      ref: ref,
      title: title,
      headerIcon: icon,
      formulas: formulas,
      overview: overview,
      compatibleTypes: compatibleTypes,
      advantages: advantages,
      disadvantages: disadvantages,
      methodKey: methodKey,
    ),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation);

      return SlideTransition(
        position: slideAnimation,
        child: child,
      );
    },
  );
}
