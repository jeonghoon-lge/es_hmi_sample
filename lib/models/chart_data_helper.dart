import 'package:flutter/material.dart';
import 'chart_data_models.dart';

/// 차트용 샘플 데이터를 생성하는 헬퍼 클래스
class ChartDataHelper {
  /// 막대 그래프용 샘플 데이터 (7일간의 전력 사용량)
  static List<BarChartDataModel> getSampleBarChartData() {
    return [
      BarChartDataModel(
        label: '1일',
        baseUsage: 40.0,
        acUsage: 30.0,
        heatingUsage: 20.0,
        etcUsage: 10.0,
      ),
      BarChartDataModel(
        label: '2일',
        baseUsage: 50.0,
        acUsage: 25.0,
        heatingUsage: 15.0,
        etcUsage: 20.0,
      ),
      BarChartDataModel(
        label: '3일',
        baseUsage: 70.0,
        acUsage: 40.0,
        heatingUsage: 25.0,
        etcUsage: 15.0,
      ),
      BarChartDataModel(
        label: '4일',
        baseUsage: 60.0,
        acUsage: 35.0,
        heatingUsage: 30.0,
        etcUsage: 15.0,
      ),
      BarChartDataModel(
        label: '5일',
        baseUsage: 30.0,
        acUsage: 15.0,
        heatingUsage: 10.0,
        etcUsage: 10.0,
      ),
      BarChartDataModel(
        label: '6일',
        baseUsage: 90.0,
        acUsage: 60.0,
        heatingUsage: 35.0,
        etcUsage: 10.0,
      ),
      BarChartDataModel(
        label: '7일',
        baseUsage: 15.0,
        acUsage: 10.0,
        heatingUsage: 5.0,
        etcUsage: 5.0,
      ),
    ];
  }

  /// 원형 그래프용 샘플 데이터 (현재 전력 사용률 17%)
  static PieChartDataModel getSamplePieChartData() {
    return PieChartDataModel(
      currentUsage: 800.0, // 현재 사용량 800kW
      totalCapacity: 4800.0, // 전체 용량 4800kW
      primaryColor: Colors.grey.shade600,
      backgroundColor: Colors.grey.shade300,
    );
  }

  /// 막대 그래프 데이터의 최대값 계산
  static double getMaxValueFromBarData(List<BarChartDataModel> data) {
    if (data.isEmpty) return 100.0;

    double maxValue = 0.0;
    for (var item in data) {
      if (item.totalUsage > maxValue) {
        maxValue = item.totalUsage;
      }
    }

    // 여유를 위해 10% 추가
    return maxValue * 1.1;
  }

  /// 차트 색상에 해당하는 범례 데이터 생성
  static List<LegendItem> getBarChartLegends() {
    const colorScheme = ChartColorScheme.defaultScheme;

    return [
      LegendItem(
        label: '기본 사용량',
        color: colorScheme.baseUsageColor,
      ),
      LegendItem(
        label: '에어컨',
        color: colorScheme.acUsageColor,
      ),
      LegendItem(
        label: '난방',
        color: colorScheme.heatingUsageColor,
      ),
      LegendItem(
        label: '기타',
        color: colorScheme.etcUsageColor,
      ),
    ];
  }

  /// 빈 막대 그래프 데이터 생성 (초기값용)
  static List<BarChartDataModel> getEmptyBarChartData(int dayCount) {
    return List.generate(dayCount, (index) {
      return BarChartDataModel(
        label: '${index + 1}일',
        baseUsage: 0.0,
        acUsage: 0.0,
        heatingUsage: 0.0,
        etcUsage: 0.0,
      );
    });
  }

  /// 빈 원형 그래프 데이터 생성 (초기값용)
  static PieChartDataModel getEmptyPieChartData() {
    return PieChartDataModel(
      currentUsage: 0.0,
      totalCapacity: 100.0,
      primaryColor: Colors.grey.shade600,
      backgroundColor: Colors.grey.shade300,
    );
  }
}

/// 범례 아이템을 위한 모델
class LegendItem {
  final String label;
  final Color color;

  const LegendItem({
    required this.label,
    required this.color,
  });
}
