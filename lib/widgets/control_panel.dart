import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chart_provider.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartProvider>(
      builder: (context, chartProvider, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 패널 타이틀
                Text(
                  '컨트롤 패널',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 16),

                // 차트 타입 전환 섹션
                _buildSectionCard(
                  context,
                  title: '차트 타입',
                  icon: Icons.swap_horiz,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildChartTypeButton(
                              context,
                              chartProvider,
                              isBarChart: true,
                              icon: Icons.bar_chart,
                              label: '막대 그래프',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildChartTypeButton(
                              context,
                              chartProvider,
                              isBarChart: false,
                              icon: Icons.pie_chart,
                              label: '원형 그래프',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 데이터 조작 섹션
                _buildSectionCard(
                  context,
                  title: '데이터 조작',
                  icon: Icons.tune,
                  child: Column(
                    children: [
                      if (chartProvider.isBarChart) ...[
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
                          onTap: () =>
                              _showAddDataDialog(context, chartProvider),
                        ),
                      ] else ...[
                        _buildSliderControl(
                          context,
                          chartProvider,
                          label: '현재 사용량',
                          value: chartProvider.pieChartData.currentUsage,
                          max: chartProvider.pieChartData.totalCapacity,
                          onChanged: (value) =>
                              chartProvider.updatePieCurrentUsage(value),
                        ),
                        const SizedBox(height: 12),
                        _buildSliderControl(
                          context,
                          chartProvider,
                          label: '총 용량',
                          value: chartProvider.pieChartData.totalCapacity,
                          max: 500.0,
                          onChanged: (value) =>
                              chartProvider.updatePieTotalCapacity(value),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 디버그 섹션
                _buildSectionCard(
                  context,
                  title: '디버그',
                  icon: Icons.bug_report,
                  child: Column(
                    children: [
                      _buildDataControlButton(
                        context,
                        icon: Icons.terminal,
                        label: '상태 로그 출력',
                        onTap: () {
                          chartProvider.debugPrintState();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('콘솔에 상태가 출력되었습니다'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // 앱 정보
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Flutter Chart Sample v1.0',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
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
    required bool isBarChart,
    required IconData icon,
    required String label,
  }) {
    final isSelected = chartProvider.isBarChart == isBarChart;

    return GestureDetector(
      onTap: () => chartProvider.setChartType(isBarChart),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade600,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade600,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderControl(
    BuildContext context,
    ChartProvider chartProvider, {
    required String label,
    required double value,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              value.toStringAsFixed(1),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).primaryColor,
            inactiveTrackColor:
                Theme.of(context).primaryColor.withValues(alpha: 0.3),
            thumbColor: Theme.of(context).primaryColor,
            overlayColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            trackHeight: 4,
          ),
          child: Slider(
            value: value.clamp(0, max),
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void _showAddDataDialog(BuildContext context, ChartProvider chartProvider) {
    // 간단한 다이얼로그 - 실제 구현은 나중에
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('데이터 추가 기능은 차트 구현 후 추가됩니다'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
