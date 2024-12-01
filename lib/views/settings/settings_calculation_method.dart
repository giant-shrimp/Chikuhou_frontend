import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/common/custom_calculation_modal.dart';

// 現在のステータスを管理するためのProvider
final methodProvider = StateProvider<String>((ref) => 'method_1'); //初期値:単純勾配計算
// ステータス変更用の関数
class SettingsCalculationMethod extends HookConsumerWidget {
  const SettingsCalculationMethod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMethod = ref.watch(methodProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.gradient_calculation),
        automaticallyImplyLeading: false,
      ),
      body: SettingsList(
        platform: DevicePlatform.iOS,
        sections: [
          SettingsSection(
            title: const Text(''),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.filter_1),
                title: Text(AppLocalizations.of(context)!.simple_gradient_calculation),
                description: const Text(''),
                trailing: currentMethod == 'method_1'
                    ? const Icon(Icons.done, color: Colors.blue) // method_1選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  showCustomModal(
                    context,
                    ref,
                    title: AppLocalizations.of(context)!.simple_gradient_calculation,
                    icon: Icons.filter_1,
                    formulaDescription: 'これは数式の説明です。',
                    overview: '2点間の直線距離と高度差を使って、勾配を簡単に計算します。シンプルで高速な計算が可能で、単調なルートに適しています。',
                    compatibleTypes: [
                      {'icon': Icons.directions_run_sharp, 'label': AppLocalizations.of(context)!.runner},
                      {'icon': Icons.directions_bike_sharp, 'label': AppLocalizations.of(context)!.bike}
                    ],
                    advantages: '- 計算が非常にシンプルで高速\n- 長距離や単純な勾配の評価に適している',
                    disadvantages: '- 地形が複雑で急激な変化がある場合には精度が低下しやすい\n- 曲線や非直線的なルートには対応できない',
                    methodKey: 'method_1',
                  );// カスタムモーダル表示
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.filter_2),
                title: Text(AppLocalizations.of(context)!.quadrature_by_pieces),
                description: const Text(''),
                trailing: currentMethod == 'method_2'
                    ? const Icon(Icons.done, color: Colors.blue) // method_2選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  showCustomModal(
                    context,
                    ref,
                    title: AppLocalizations.of(context)!.quadrature_by_pieces,
                    icon: Icons.filter_2,
                    formulaDescription: 'これは数式の説明です。',
                    overview: 'ルートを複数の小さな区間に分け、それぞれの勾配を求めて平均を算出する方法です。細かい勾配変化を可視化しやすく、滑らかなルート計算に向いています。',
                    compatibleTypes: [
                      {'icon': Icons.assist_walker_sharp, 'label': AppLocalizations.of(context)!.senior},
                      {'icon': Icons.directions_bike_sharp, 'label': AppLocalizations.of(context)!.bike},
                      {'icon': Icons.child_friendly_sharp, 'label': AppLocalizations.of(context)!.stroller},
                      {'icon': Icons.accessible_forward_sharp, 'label': AppLocalizations.of(context)!.wheelchair}
                    ],
                    advantages: '- ポイントごとの角度を返せるので、細かな地形の勾配変化に対応できる',
                    disadvantages: '- 曲線的な地形や不規則なルートの影響を正確に反映するには限界がある',
                    methodKey: 'method_2',
                  );// カスタムモーダル表示
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.filter_3),
                title: Text(AppLocalizations.of(context)!.linear_calculations),
                description: const Text(''),
                trailing: currentMethod == 'method_3'
                    ? const Icon(Icons.done, color: Colors.blue) // method_3選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  showCustomModal(
                    context,
                    ref,
                    title: AppLocalizations.of(context)!.linear_calculations,
                    icon: Icons.filter_3,
                    formulaDescription: 'これは数式の説明です。',
                    overview: '2点間の勾配を直線近似で計算します。計算速度が速く、正確な角度を求められるため、実用性が高い手法です。',
                    compatibleTypes: [
                      {'icon': Icons.directions_walk_sharp, 'label': AppLocalizations.of(context)!.walker},
                      {'icon': Icons.directions_run_sharp, 'label': AppLocalizations.of(context)!.runner}
                    ],
                    advantages: '- 計算がシンプルで高速\n- 正確な角度を得られるため、坂道の傾斜を精密に解析可能',
                    disadvantages: '- 小刻みな勾配の変化や局所的な不規則性を捉えるのが苦手\n- 地形が複雑で曲線的な場合、直線近似による誤差が発生',
                    methodKey: 'method_3',
                  );// カスタムモーダル表示
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.filter_4),
                title: Text(AppLocalizations.of(context)!.vector_product),
                description: const Text(''),
                trailing: currentMethod == 'method_4'
                    ? const Icon(Icons.done, color: Colors.blue) // method_4選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  showCustomModal(
                    context,
                    ref,
                    title: AppLocalizations.of(context)!.vector_product,
                    icon: Icons.filter_4,
                    formulaDescription: 'これは数式の説明です。',
                    overview: '勾配をベクトルを使って計算し、方向と角度の情報を効率的に取得します。特に坂道の角度や方向を詳細に分析したい場合に適しています。',
                    compatibleTypes: [
                      {'icon': Icons.directions_bike_sharp, 'label': AppLocalizations.of(context)!.bike},
                      {'icon': Icons.accessible_forward_sharp, 'label': AppLocalizations.of(context)!.wheelchair}
                    ],
                    advantages: '- ベクトルを用いるため、計算が効率的\n- 必要な角度情報を直接得られるため、勾配が重要な用途で適している\n- 直線的な区間での計算に特化しており、リアルタイム処理にも対応可能',
                    disadvantages: '- 勾配が非常に小さい場合、計算精度が低下しやすい\n- 曲線的な地形や複雑な勾配変化を捉えるには適していない',
                    methodKey: 'method_4',
                  );// カスタムモーダル表示
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.filter_5),
                title: Text(AppLocalizations.of(context)!.taylor_expansion),
                description: const Text(''),
                trailing: currentMethod == 'method_5'
                    ? const Icon(Icons.done, color: Colors.blue) // method_5選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  showCustomModal(
                    context,
                    ref,
                    title: AppLocalizations.of(context)!.taylor_expansion,
                    icon: Icons.filter_5,
                    formulaDescription: 'これは数式の説明です。',
                    overview: 'ハヴァーサイン式を使って小さな角度での計算精度を高めつつ、テイラー展開で計算負荷を軽減します。広範囲の距離計算には適しませんが、精度が求められる場面で有効です。',
                    compatibleTypes: [
                      {'icon': Icons.directions_run_sharp, 'label': AppLocalizations.of(context)!.runner},
                      {'icon': Icons.assist_walker_sharp, 'label': AppLocalizations.of(context)!.senior},
                      {'icon': Icons.directions_bike_sharp, 'label': AppLocalizations.of(context)!.bike}
                    ],
                    advantages: '- テイラー展開を利用することで、ハヴァーサイン式の計算負荷が軽減される\n- ハヴァーサイン式を用いるため、小さな角度での精度が高い\n- 三角関数の丸め誤差を効果的に回避できる',
                    disadvantages: '- 広い範囲（数百 km 以上）での計算には精度が低下する\n- 地形やルートが複雑な場合、結果が近似的になりやすい',
                    methodKey: 'method_5',
                  );// カスタムモーダル表示
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.filter_6),
                title: Text(AppLocalizations.of(context)!.simpson_act),
                description: const Text(''),
                trailing: currentMethod == 'method_6'
                    ? const Icon(Icons.done, color: Colors.blue) // method_6選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  showCustomModal(
                    context,
                    ref,
                    title: AppLocalizations.of(context)!.simpson_act,
                    icon: Icons.filter_6,
                    formulaDescription: 'これは数式の説明です。',
                    overview: 'ルートの勾配を少ない区間分割で高精度に近似する積分法です。特に滑らかな関数や緩やかな地形の解析に向いています。',
                    compatibleTypes: [
                      {'icon': Icons.assist_walker_sharp, 'label': AppLocalizations.of(context)!.senior},
                      {'icon': Icons.directions_bike_sharp, 'label': AppLocalizations.of(context)!.bike},
                      {'icon': Icons.child_friendly_sharp, 'label': AppLocalizations.of(context)!.stroller}
                    ],
                    advantages: '- 少ない区間分割で高い精度を得られる\n- 滑らかな関数に適応しやすく、緩やかな地形の解析に向いている\n- 計算効率が良好',
                    disadvantages: '- 急激な勾配変化がある場合には精度が低下\n- 区間分割が不十分だと、詳細な地形解析には向かない',
                    methodKey: 'method_6',
                  );// カスタムモーダル表示
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.filter_7),
                title: const Text('フーリエ変換'),
                description: const Text(''),
                trailing: currentMethod == 'method_7'
                    ? const Icon(Icons.done, color: Colors.blue) // method_7選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  showCustomModal(
                    context,
                    ref,
                    title: 'フーリエ変換',
                    icon: Icons.filter_7,
                    formulaDescription: 'これは数式の説明です。',
                    overview: '急激な地形や勾配変化の大きなルートに対応するため、局所的な勾配や変化率を詳細に解析する手法を活用。特に、区分的な計算や補間技術を用いることで、地形の急激な変化を正確に捉え、適切なルートを提案します。',
                    compatibleTypes: [
                      {'icon': Icons.directions_run_sharp, 'label': AppLocalizations.of(context)!.runner},
                      {'icon': Icons.directions_bike_sharp, 'label': AppLocalizations.of(context)!.bike}
                    ],
                    advantages: '- 急激な勾配変化を周波数空間で効率的に検出。\n- 高頻度成分を利用して特異点を解析可能。',
                    disadvantages: '- 初期データの変換と逆変換が必要で、実装が複雑。\n- 高頻度成分が多い場合、ノイズとして扱われることがある。',
                    methodKey: 'method_7',
                  );// カスタムモーダル表示
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.filter_8),
                title: const Text('ヘルムホルツ分解'),
                description: const Text(''),
                trailing: currentMethod == 'method_8'
                    ? const Icon(Icons.done, color: Colors.blue) // method_8選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  showCustomModal(
                    context,
                    ref,
                    title: 'ヘルムホルツ分解',
                    icon: Icons.filter_8,
                    formulaDescription: 'これは数式の説明です。',
                    overview: 'ヘルムホルツ分解は、任意のベクトル場Fをポテンシャル場 (勾配成分)と回転場 (循環成分)に分ける理論です。この分解により、地形の滑らかさや、回転場が与える影響を個別に評価できます。ポテンシャル場に基づいて、最もエネルギー効率の良いルートを計算します。',
                    compatibleTypes: [
                      {'icon': Icons.directions_walk_sharp, 'label': AppLocalizations.of(context)!.walker},
                      {'icon': Icons.directions_run_sharp, 'label': AppLocalizations.of(context)!.runner},
                      {'icon': Icons.directions_bike_sharp, 'label': AppLocalizations.of(context)!.bike}
                    ],
                    advantages: '- 勾配成分と循環成分を分離するため、純粋に「登りやすい」ルートを計算できる\n- 地形や障害物の影響を局所的に反映しつつ、滑らかなルートを選択可能\n- サイクリストやランナー向けに、物理的エネルギー消費の少ないルートを提供できる',
                    disadvantages: '- 回転場の影響が強い場所では、ポテンシャル場のみに基づくルート計算が現実と乖離する可能性がある\n- 計算コストが高いため、処理速度が遅くなる可能性がある',
                    methodKey: 'method_8',
                  );// カスタムモーダル表示
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.filter_9),
                title: const Text('リーマン計量'),
                description: const Text(''),
                trailing: currentMethod == 'method_9'
                    ? const Icon(Icons.done, color: Colors.blue) // method_9選択時にチェックマーク
                    : null,
                onPressed: (context) {
                  showCustomModal(
                    context,
                    ref,
                    title: 'リーマン計量',
                    icon: Icons.filter_9,
                    formulaDescription: 'これは数式の説明です。',
                    overview: 'リーマン計量は、空間や地形の曲がり具合や、局所的な伸縮を考慮した距離や勾配を計算する手法です。これに基づくルート計算では、地形が平坦でない場合でも、実際の移動距離やエネルギー消費量をリアルに反映したルートを提供できます。',
                    compatibleTypes: [
                      {'icon': Icons.assist_walker_sharp, 'label': AppLocalizations.of(context)!.senior},
                      {'icon': Icons.child_friendly_sharp, 'label': AppLocalizations.of(context)!.stroller},
                      {'icon': Icons.accessible_forward_sharp, 'label': AppLocalizations.of(context)!.wheelchair}
                    ],
                    advantages: '- 曲面や変形した空間を正確にモデリングできる\n- 障害物や地形の凹凸を考慮した実際的なルート提案が可能\n- 車いすやベビーカー利用者に適した、最もスムーズなルートが計算可能',
                    disadvantages: '- 計量テンソルの取得には複雑な計算や高精度なデータが必要\n- 高次元空間や複雑な地形では計算コストが増加',
                    methodKey: 'method_9',
                  );// カスタムモーダル表示
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
