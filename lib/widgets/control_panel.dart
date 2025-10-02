import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chart_provider.dart';
import '../models/chart_data_models.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartProvider>(
      builder: (context, chartProvider, child) {
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPanelTitle(context),
                const SizedBox(height: 16),
                _buildChartTypeSection(context, chartProvider),
                const SizedBox(height: 16),
                _buildDataControlSection(context, chartProvider),
                const SizedBox(height: 16),
                _buildColorControlSection(context, chartProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 패널 타이틀
  Widget _buildPanelTitle(BuildContext context) {
    return Text(
      '컨트롤 패널',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  /// 차트 타입 선택 섹션
  Widget _buildChartTypeSection(
      BuildContext context, ChartProvider chartProvider) {
    return _buildSectionCard(
      context,
      title: '차트 타입',
      icon: Icons.swap_horiz,
      child: Row(
        children: [
          Expanded(
            child: _buildChartTypeButton(
              context,
              chartProvider,
              chartType: ChartType.bar,
              icon: ChartType.bar.icon,
              label: ChartType.bar.displayName,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildChartTypeButton(
              context,
              chartProvider,
              chartType: ChartType.pie,
              icon: ChartType.pie.icon,
              label: ChartType.pie.displayName,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildChartTypeButton(
              context,
              chartProvider,
              chartType: ChartType.line,
              icon: ChartType.line.icon,
              label: ChartType.line.displayName,
            ),
          ),
        ],
      ),
    );
  }

  /// 데이터 조작 섹션
  Widget _buildDataControlSection(
      BuildContext context, ChartProvider chartProvider) {
    return _buildSectionCard(
      context,
      title: '데이터 조작',
      icon: Icons.tune,
      child: Column(
        children: [
          _buildDataControlButton(
            context,
            icon: Icons.refresh,
            label: '데이터 초기화',
            onTap: () => chartProvider.initializeData(),
          ),
          const SizedBox(height: 8),
          _buildDataControlButton(
            context,
            icon: Icons.add,
            label: '샘플 데이터 추가',
            onTap: () => _showAddDataDialog(context, chartProvider),
          ),
        ],
      ),
    );
  }

  /// 색상 설정 섹션
  Widget _buildColorControlSection(
      BuildContext context, ChartProvider chartProvider) {
    return _buildSectionCard(
      context,
      title: '색상 설정',
      icon: Icons.palette,
      child: Column(
        children: [
          _buildColorPicker(
            context,
            '기본 색상',
            chartProvider.colorScheme.baseUsageColor,
            (color) => chartProvider.updateColor('base', color),
          ),
          const SizedBox(height: 8),
          _buildColorPicker(
            context,
            '에어컨 색상',
            chartProvider.colorScheme.acUsageColor,
            (color) => chartProvider.updateColor('ac', color),
          ),
          const SizedBox(height: 8),
          _buildColorPicker(
            context,
            '난방 색상',
            chartProvider.colorScheme.heatingUsageColor,
            (color) => chartProvider.updateColor('heating', color),
          ),
          const SizedBox(height: 8),
          _buildColorPicker(
            context,
            '기타 색상',
            chartProvider.colorScheme.etcUsageColor,
            (color) => chartProvider.updateColor('etc', color),
          ),
        ],
      ),
    );
  }

  /// 섹션 카드 빌더
  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildChartTypeButton(
    BuildContext context,
    ChartProvider chartProvider, {
    required ChartType chartType,
    required IconData icon,
    required String label,
  }) {
    final isSelected = chartProvider.currentChartType == chartType;
    return InkWell(
      onTap: () => chartProvider.setChartType(chartType),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade600,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade600,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataControlButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade600),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker(
    BuildContext context,
    String label,
    Color currentColor,
    ValueChanged<Color> onColorChanged,
  ) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: currentColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.palette),
          onPressed: () =>
              _showColorPicker(context, currentColor, onColorChanged),
        ),
      ],
    );
  }

  void _showColorPicker(
    BuildContext context,
    Color currentColor,
    ValueChanged<Color> onColorChanged,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('색상 선택'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: currentColor,
              onColorChanged: onColorChanged,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showAddDataDialog(BuildContext context, ChartProvider chartProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('데이터 추가'),
          content: const Text('새로운 샘플 데이터를 추가하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                chartProvider.addSampleData();
                Navigator.of(context).pop();
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }
}

class BlockPicker extends StatelessWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  const BlockPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    return Wrap(
      children: colors.map((color) {
        return GestureDetector(
          onTap: () => onColorChanged(color),
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: pickerColor == color
                  ? Border.all(color: Colors.black, width: 3)
                  : Border.all(color: Colors.grey.shade300),
            ),
          ),
        );
      }).toList(),
    );
  }
}
