import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/chart_provider.dart';

class ChartArea extends StatelessWidget {
  const ChartArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartProvider>(
      builder: (context, chartProvider, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.1),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          key: ValueKey(chartProvider.isBarChart),
                          child: chartProvider.isBarChart
                              ? _buildBarChart(chartProvider)
                              : _buildPieChart(chartProvider),
                        ),
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

  Widget _buildBarChart(ChartProvider chartProvider) {
    final data = chartProvider.barChartData;

    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_outlined,
              size: 80,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              '데이터가 없습니다',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // 최대값 계산
    final maxValue =
        data.map((d) => d.totalUsage).reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue * 1.2, // 여유 공간을 위해 20% 추가
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final item = data[group.x.toInt()];
              String categoryName = '';
              Color categoryColor = Colors.white;

              // 막대별 카테고리 결정
              if (rodIndex == 0) {
                categoryName = '기본 사용량';
                categoryColor = chartProvider.colorScheme.baseUsageColor;
              } else if (rodIndex == 1) {
                categoryName = '에어컨';
                categoryColor = chartProvider.colorScheme.acUsageColor;
              } else if (rodIndex == 2) {
                categoryName = '난방';
                categoryColor = chartProvider.colorScheme.heatingUsageColor;
              } else {
                categoryName = '기타';
                categoryColor = chartProvider.colorScheme.etcUsageColor;
              }

              return BarTooltipItem(
                '${item.label}\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '$categoryName\n',
                    style: TextStyle(
                      color: categoryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '${rod.toY.toStringAsFixed(1)}kWh',
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      data[index].label,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  '${value.toInt()}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: item.baseUsage,
                color: chartProvider.colorScheme.baseUsageColor,
                width: 16,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
                rodStackItems: [],
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxValue * 1.1,
                  color: Colors.grey.withValues(alpha: 0.1),
                ),
              ),
              BarChartRodData(
                toY: item.baseUsage + item.acUsage,
                color: chartProvider.colorScheme.acUsageColor,
                width: 16,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
              BarChartRodData(
                toY: item.baseUsage + item.acUsage + item.heatingUsage,
                color: chartProvider.colorScheme.heatingUsageColor,
                width: 16,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
              BarChartRodData(
                toY: item.totalUsage,
                color: chartProvider.colorScheme.etcUsageColor,
                width: 16,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          );
        }).toList(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval:
              maxValue > 0 ? maxValue / 5 : 1.0, // Prevent zero interval
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPieChart(ChartProvider chartProvider) {
    final data = chartProvider.pieChartData;

    return Stack(
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 4,
            centerSpaceRadius: 80,
            startDegreeOffset: -90,
            sections: [
              PieChartSectionData(
                color: Colors.blue.shade600,
                value: data.currentUsage,
                title: '${data.percentage.toStringAsFixed(1)}%',
                radius: 60,
                titleStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                badgeWidget: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade800,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.electrical_services,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                badgePositionPercentageOffset: 1.3,
              ),
              PieChartSectionData(
                color: Colors.grey.shade300,
                value: data.totalCapacity - data.currentUsage,
                title: '${(100 - data.percentage).toStringAsFixed(1)}%',
                radius: 50,
                titleStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
                badgeWidget: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.battery_charging_full,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                badgePositionPercentageOffset: 1.3,
              ),
            ],
            pieTouchData: PieTouchData(
              enabled: true,
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                // 터치 이벤트 처리 (향후 확장 가능)
              },
            ),
          ),
        ),
        // 중앙 텍스트
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '전력 사용량',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.currentUsage.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                '/ ${data.totalCapacity.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                ),
              ),
              Text(
                'kWh',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
