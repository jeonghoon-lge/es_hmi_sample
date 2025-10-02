import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chart_provider.dart';

class ChartArea extends StatelessWidget {
  const ChartArea({super.key});

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
                // 차트 타이틀과 타입 표시
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      chartProvider.isBarChart ? '막대 그래프' : '원형 그래프',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: chartProvider.isBarChart
                            ? Colors.blue.withValues(alpha: 0.1)
                            : Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            chartProvider.isBarChart
                                ? Icons.bar_chart
                                : Icons.pie_chart,
                            size: 16,
                            color: chartProvider.isBarChart
                                ? Colors.blue
                                : Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            chartProvider.isBarChart ? 'BAR' : 'PIE',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: chartProvider.isBarChart
                                  ? Colors.blue
                                  : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 차트 콘텐츠 영역
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            chartProvider.isBarChart
                                ? Icons.bar_chart_outlined
                                : Icons.pie_chart_outline,
                            size: 80,
                            color: Colors.grey.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${chartProvider.isBarChart ? '막대' : '원형'} 차트가 여기에 표시됩니다',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.grey,
                                    ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            chartProvider.isBarChart
                                ? '${chartProvider.barChartData.length}개 항목'
                                : '${chartProvider.pieChartData.percentage.toStringAsFixed(1)}% 사용량',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 차트 요약 정보
                if (chartProvider.isBarChart) ...[
                  _buildBarChartSummary(context, chartProvider),
                ] else ...[
                  _buildPieChartSummary(context, chartProvider),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBarChartSummary(
      BuildContext context, ChartProvider chartProvider) {
    final data = chartProvider.barChartData;
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 20,
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '총 ${data.length}일 데이터 • 최대값: ${data.map((d) => d.totalUsage).reduce((a, b) => a > b ? a : b).toStringAsFixed(1)}kWh',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue.shade700,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartSummary(
      BuildContext context, ChartProvider chartProvider) {
    final data = chartProvider.pieChartData;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 20,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '사용량: ${data.currentUsage.toStringAsFixed(1)}/${data.totalCapacity.toStringAsFixed(1)} (${data.percentage.toStringAsFixed(1)}%)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green.shade700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
