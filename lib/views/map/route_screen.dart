import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/map/route_viewmodel.dart';

class RouteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _originController = TextEditingController();
    final TextEditingController _destinationController =
        TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            '経路',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // 出発地点と目的地の入力フォーム
          TextField(
            controller: _originController,
            decoration: const InputDecoration(
              labelText: 'ここから',
              suffixIcon: Icon(Icons.arrow_forward_ios),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _destinationController,
            decoration: const InputDecoration(
              labelText: 'ここまで',
              suffixIcon: Icon(Icons.arrow_forward_ios),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final viewModel = context.read<RouteViewModel>();
              await viewModel.fetchRoute(
                _originController.text,
                _destinationController.text,
              );

              // 経路検索が完了したらモーダルを閉じる
              if (viewModel.route != null) {
                Navigator.pop(context);
              }
            },
            child: const Text('経路を検索'),
          ),
          const SizedBox(height: 16),
          Consumer<RouteViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.errorMessage != null) {
                return Text(viewModel.errorMessage!);
              } else if (viewModel.route != null) {
                return Text(
                    '所要時間: ${viewModel.route!.duration}, 距離: ${viewModel.route!.distance}');
              } else {
                return const Text('検索してください。');
              }
            },
          ),
        ],
      ),
    );
  }
}
