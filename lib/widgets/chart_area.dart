import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/chart_provider.dart';
import '../models/chart_data_models.dart';
import 'stacked_bar_chart.dart';

class ChartArea extends StatelessWidget {
  const ChartArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartProvider>(
      builder: (context, chartProvider, child) {
        return _buildChartContainer(context, chartProvider);
      },
    );
  }

  /// 차트 컨테이너 빌드
  Widget _buildChartContainer(
      BuildContext context, ChartProvider chartProvider) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: double.infinity,
      decoration: _buildContainerDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChartHeader(context, chartProvider),
            const SizedBox(height: 16),
            _buildChartContent(context, chartProvider),
            const SizedBox(height: 16),
            _buildChartSummary(context, chartProvider),
          ],
        ),
      ),
    );
  }

  /// 컨테이너 장식 스타일
  BoxDecoration _buildContainerDecoration(BuildContext context) {
    return BoxDecoration(
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
    );
  }

  /// 차트 헤더 (제목과 타입 표시)
  Widget _buildChartHeader(BuildContext context, ChartProvider chartProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildChartTitle(context, chartProvider),
        _buildChartTypeIndicator(context, chartProvider),
      ],
    );
  }

  /// 차트 제목
  Widget _buildChartTitle(BuildContext context, ChartProvider chartProvider) {
    return Text(
      chartProvider.currentChartType.displayName,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  /// 차트 타입 표시기
  Widget _buildChartTypeIndicator(
      BuildContext context, ChartProvider chartProvider) {
    final chartType = chartProvider.currentChartType;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: chartType.indicatorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            chartType.icon,
            size: 16,
            color: chartType.indicatorColor,
          ),
          const SizedBox(width: 4),
          Text(
            chartType.name.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: chartType.indicatorColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 차트 콘텐츠 영역
  Widget _buildChartContent(BuildContext context, ChartProvider chartProvider) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: _buildChartContentDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildAnimatedChart(chartProvider),
        ),
      ),
    );
  }

  /// 차트 콘텐츠 영역 장식
  BoxDecoration _buildChartContentDecoration() {
    return BoxDecoration(
      color: Colors.grey.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Colors.grey.withValues(alpha: 0.2),
        width: 1,
      ),
    );
  }

  /// 애니메이션이 적용된 차트
  Widget _buildAnimatedChart(ChartProvider chartProvider) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
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
        key: ValueKey(chartProvider.currentChartType),
        child: _buildChart(chartProvider),
      ),
    );
  }

  /// 차트 선택 및 빌드
  Widget _buildChart(ChartProvider chartProvider) {
    switch (chartProvider.currentChartType) {
      case ChartType.bar:
        return _buildBarChart(chartProvider);
      case ChartType.pie:
        return _buildPieChart(chartProvider);
      case ChartType.line:
        return _buildLineChart(chartProvider);
      case ChartType.stackedBar:
        return _buildStackedBarChart(chartProvider);
    }
  }

  /// 차트 요약 정보
  Widget _buildChartSummary(BuildContext context, ChartProvider chartProvider) {
    switch (chartProvider.currentChartType) {
      case ChartType.bar:
        return _buildBarChartSummary(context, chartProvider);
      case ChartType.pie:
        return _buildPieChartSummary(context, chartProvider);
      case ChartType.line:
        return _buildLineChartSummary(context, chartProvider);
      case ChartType.stackedBar:
        return _buildStackedBarChartSummary(context, chartProvider);
    }
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
      return _buildEmptyBarChart();
    }

    final maxValue = _calculateMaxValue(data);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue * 1.2, // 여유 공간을 위해 20% 추가
        barTouchData: _buildBarTouchData(chartProvider, data),
        titlesData: _buildBarChartTitles(data),
        borderData: FlBorderData(show: false),
        barGroups: _buildBarGroups(chartProvider, data, maxValue),
        gridData: _buildBarChartGrid(maxValue),
      ),
    );
  }

  /// 빈 막대 차트 위젯
  Widget _buildEmptyBarChart() {
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

  /// 빈 차트 위젯 (공통)
  Widget _buildEmptyChart(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            size: 80,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// 최대값 계산
  double _calculateMaxValue(List<BarChartDataModel> data) {
    return data.map((d) => d.totalUsage).reduce((a, b) => a > b ? a : b);
  }

  /// 막대 차트 터치 데이터 구성
  BarTouchData _buildBarTouchData(
      ChartProvider chartProvider, List<BarChartDataModel> data) {
    return BarTouchData(
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
    );
  }

  /// 막대 차트 제목 데이터 구성
  FlTitlesData _buildBarChartTitles(List<BarChartDataModel> data) {
    return FlTitlesData(
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
    );
  }

  /// 막대 그룹 데이터 구성
  List<BarChartGroupData> _buildBarGroups(ChartProvider chartProvider,
      List<BarChartDataModel> data, double maxValue) {
    return data.asMap().entries.map((entry) {
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
    }).toList();
  }

  /// 막대 차트 그리드 데이터 구성
  FlGridData _buildBarChartGrid(double maxValue) {
    return FlGridData(
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
            sections: _buildPieChartSections(data),
            pieTouchData: _buildPieChartTouchData(),
          ),
        ),
        _buildPieChartCenterText(data),
      ],
    );
  }

  /// 파이 차트 섹션 데이터 구성
  List<PieChartSectionData> _buildPieChartSections(PieChartDataModel data) {
    return [
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
        badgeWidget: _buildPieChartBadge(
          icon: Icons.electrical_services,
          color: Colors.blue.shade800,
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
        badgeWidget: _buildPieChartBadge(
          icon: Icons.battery_charging_full,
          color: Colors.grey.shade500,
        ),
        badgePositionPercentageOffset: 1.3,
      ),
    ];
  }

  /// 파이 차트 배지 위젯
  Widget _buildPieChartBadge({required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 16,
      ),
    );
  }

  /// 파이 차트 터치 데이터 구성
  PieTouchData _buildPieChartTouchData() {
    return PieTouchData(
      enabled: true,
      touchCallback: (FlTouchEvent event, pieTouchResponse) {
        // 터치 이벤트 처리 (향후 확장 가능)
      },
    );
  }

  /// 파이 차트 중앙 텍스트
  Widget _buildPieChartCenterText(PieChartDataModel data) {
    return Positioned.fill(
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
    );
  }

  /// 라인 차트 빌드
  Widget _buildLineChart(ChartProvider chartProvider) {
    final data = chartProvider.lineChartData;
    if (data.isEmpty || data.every((series) => series.dataPoints.isEmpty)) {
      return _buildEmptyChart('라인 차트 데이터가 없습니다.');
    }

    // 모든 시리즈의 데이터포인트를 하나로 합치기 (첫 번째 시리즈만 사용)
    final firstSeries = data.first;
    final dataPoints = firstSeries.dataPoints;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
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
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < dataPoints.length) {
                  final timestamp = dataPoints[index].timestamp;
                  if (timestamp != null) {
                    return Text(
                      '${timestamp.month}/${timestamp.day}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    );
                  }
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        minX: 0,
        maxX: dataPoints.isNotEmpty ? (dataPoints.length - 1).toDouble() : 0,
        minY: 0,
        maxY: dataPoints.isNotEmpty
            ? dataPoints.map((e) => e.value).reduce((a, b) => a > b ? a : b) + 1
            : 10,
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
                .toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                chartProvider.colorScheme.baseUsageColor,
                chartProvider.colorScheme.baseUsageColor.withValues(alpha: 0.3),
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: chartProvider.colorScheme.baseUsageColor,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  chartProvider.colorScheme.baseUsageColor
                      .withValues(alpha: 0.3),
                  chartProvider.colorScheme.baseUsageColor
                      .withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final index = barSpot.x.toInt();
                if (index >= 0 && index < dataPoints.length) {
                  final point = dataPoints[index];
                  final timestamp = point.timestamp;
                  if (timestamp != null) {
                    return LineTooltipItem(
                      '${timestamp.month}/${timestamp.day}\n${point.value.toStringAsFixed(1)} kWh',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                }
                return null;
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  /// 라인 차트 요약 정보
  Widget _buildLineChartSummary(
      BuildContext context, ChartProvider chartProvider) {
    final data = chartProvider.lineChartData;
    if (data.isEmpty || data.every((series) => series.dataPoints.isEmpty)) {
      return const SizedBox.shrink();
    }

    // 첫 번째 시리즈의 데이터포인트를 사용
    final firstSeries = data.first;
    final dataPoints = firstSeries.dataPoints;

    final maxValue =
        dataPoints.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final minValue =
        dataPoints.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final avgValue = dataPoints.map((e) => e.value).reduce((a, b) => a + b) /
        dataPoints.length;
    final latestValue = dataPoints.last.value;

    return Container(
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
          Text(
            '라인 차트 요약',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                context,
                '최신값',
                latestValue.toStringAsFixed(1),
                Icons.timeline,
                chartProvider.colorScheme.baseUsageColor,
              ),
              _buildSummaryItem(
                context,
                '최대값',
                maxValue.toStringAsFixed(1),
                Icons.trending_up,
                Colors.red,
              ),
              _buildSummaryItem(
                context,
                '평균값',
                avgValue.toStringAsFixed(1),
                Icons.show_chart,
                Colors.orange,
              ),
              _buildSummaryItem(
                context,
                '최소값',
                minValue.toStringAsFixed(1),
                Icons.trending_down,
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 요약 정보 아이템
  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          'kWh',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  /// 스택형 막대 차트 빌드
  Widget _buildStackedBarChart(ChartProvider chartProvider) {
    return StackedBarChart(
      data: chartProvider.stackedBarChartData,
      title: '월별 에너지 사용량',
      xAxisTitle: '월',
      yAxisTitle: '사용량 (kWh)',
      maxY: chartProvider.maxStackedBarChartValue * 1.1,
      showLegend: true,
      showTooltip: true,
      enableInteraction: true,
      animationDuration: const Duration(milliseconds: 1000),
    );
  }

  /// 스택형 막대 차트 요약 정보
  Widget _buildStackedBarChartSummary(
      BuildContext context, ChartProvider chartProvider) {
    final data = chartProvider.stackedBarChartData;
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    // 전체 기간 총 사용량 계산
    final totalUsage = data.fold(0.0, (sum, item) => sum + item.totalUsage);
    final averageUsage = totalUsage / data.length;

    // 최대/최소 사용량 계산
    final maxUsage =
        data.map((item) => item.totalUsage).reduce((a, b) => a > b ? a : b);
    final minUsage =
        data.map((item) => item.totalUsage).reduce((a, b) => a < b ? a : b);

    // 카테고리별 총 사용량 계산
    final Map<String, double> categoryTotals = {};
    for (var item in data) {
      item.values.forEach((key, value) {
        categoryTotals[key] = (categoryTotals[key] ?? 0.0) + value;
      });
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.stacked_bar_chart,
                size: 16,
                color: Colors.purple.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                '스택형 차트 요약',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStackedSummaryItem(
                '총 사용량',
                '${totalUsage.toStringAsFixed(1)} kWh',
                Colors.purple.shade600,
              ),
              _buildStackedSummaryItem(
                '평균 사용량',
                '${averageUsage.toStringAsFixed(1)} kWh',
                Colors.blue.shade600,
              ),
              _buildStackedSummaryItem(
                '최대 사용량',
                '${maxUsage.toStringAsFixed(1)} kWh',
                Colors.red.shade600,
              ),
              _buildStackedSummaryItem(
                '최소 사용량',
                '${minUsage.toStringAsFixed(1)} kWh',
                Colors.green.shade600,
              ),
            ],
          ),
          if (categoryTotals.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Text(
              '카테고리별 총 사용량',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: categoryTotals.entries
                  .map((entry) => _buildCategoryTotal(entry.key, entry.value))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// 스택형 차트 요약 아이템
  Widget _buildStackedSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// 카테고리별 총합 표시
  Widget _buildCategoryTotal(String category, double total) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _getCategoryColor(category),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$category: ${total.toStringAsFixed(1)}kWh',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 카테고리별 색상 반환
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Base':
        return Colors.blue;
      case 'AC':
        return Colors.red;
      case 'Heating':
        return Colors.orange;
      case 'Other':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
