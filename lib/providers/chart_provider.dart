import 'package:flutter/material.dart';
import '../models/chart_data_models.dart';
import '../models/chart_data_helper.dart';

/// 차트 데이터와 UI 상태를 관리하는 Provider 클래스
class ChartProvider extends ChangeNotifier {
  // Private fields
  List<BarChartDataModel> _barChartData = [];
  PieChartDataModel _pieChartData = ChartDataHelper.getEmptyPieChartData();
  bool _isBarChart = true;
  ChartColorScheme _colorScheme = ChartColorScheme.defaultScheme;
  bool _isLoading = false;

  // Getters
  List<BarChartDataModel> get barChartData => List.unmodifiable(_barChartData);
  PieChartDataModel get pieChartData => _pieChartData;
  bool get isBarChart => _isBarChart;
  bool get isPieChart => !_isBarChart;
  ChartColorScheme get colorScheme => _colorScheme;
  bool get isLoading => _isLoading;

  /// 차트 데이터 총 개수
  int get barChartDataCount => _barChartData.length;

  /// 막대 그래프 최대값 계산
  double get maxBarChartValue =>
      ChartDataHelper.getMaxValueFromBarData(_barChartData);

  /// 범례 데이터
  List<LegendItem> get legends => ChartDataHelper.getBarChartLegends();

  /// 초기 데이터 로드
  void initializeData() {
    _setLoading(true);

    try {
      _barChartData = ChartDataHelper.getSampleBarChartData();
      _pieChartData = ChartDataHelper.getSamplePieChartData();

      debugPrint(
          'ChartProvider: 데이터 초기화 완료 - Bar: ${_barChartData.length}개, Pie: ${_pieChartData.currentUsage}/${_pieChartData.totalCapacity}');
    } catch (e) {
      debugPrint('ChartProvider: 데이터 초기화 오류 - $e');
      _barChartData = ChartDataHelper.getEmptyBarChartData(7);
      _pieChartData = ChartDataHelper.getEmptyPieChartData();
    } finally {
      _setLoading(false);
    }
  }

  /// 막대 그래프 특정 인덱스의 특정 카테고리 데이터 업데이트
  void updateBarDataCategory(int index, String category, double value) {
    if (index < 0 || index >= _barChartData.length) {
      debugPrint('ChartProvider: 잘못된 인덱스 - $index');
      return;
    }

    if (value < 0) {
      debugPrint('ChartProvider: 음수 값은 허용되지 않음 - $value');
      return;
    }

    final currentData = _barChartData[index];
    BarChartDataModel updatedData;

    switch (category.toLowerCase()) {
      case 'base':
      case 'baseusage':
        updatedData = currentData.copyWith(baseUsage: value);
        break;
      case 'ac':
      case 'acusage':
        updatedData = currentData.copyWith(acUsage: value);
        break;
      case 'heating':
      case 'heatingusage':
        updatedData = currentData.copyWith(heatingUsage: value);
        break;
      case 'etc':
      case 'etcusage':
        updatedData = currentData.copyWith(etcUsage: value);
        break;
      default:
        debugPrint('ChartProvider: 알 수 없는 카테고리 - $category');
        return;
    }

    _barChartData[index] = updatedData;
    notifyListeners();

    debugPrint(
        'ChartProvider: 막대 그래프 데이터 업데이트 - 인덱스: $index, 카테고리: $category, 값: $value');
  }

  /// 막대 그래프 전체 데이터 업데이트
  void updateBarData(
    int index, {
    double? baseUsage,
    double? acUsage,
    double? heatingUsage,
    double? etcUsage,
  }) {
    if (index < 0 || index >= _barChartData.length) {
      debugPrint('ChartProvider: 잘못된 인덱스 - $index');
      return;
    }

    final currentData = _barChartData[index];
    final updatedData = currentData.copyWith(
      baseUsage: baseUsage,
      acUsage: acUsage,
      heatingUsage: heatingUsage,
      etcUsage: etcUsage,
    );

    _barChartData[index] = updatedData;
    notifyListeners();

    debugPrint('ChartProvider: 막대 그래프 전체 데이터 업데이트 - 인덱스: $index');
  }

  /// 원형 그래프 현재 사용량 업데이트
  void updatePieCurrentUsage(double currentUsage) {
    if (currentUsage < 0) {
      debugPrint('ChartProvider: 음수 사용량은 허용되지 않음 - $currentUsage');
      return;
    }

    if (currentUsage > _pieChartData.totalCapacity) {
      debugPrint(
          'ChartProvider: 사용량이 총 용량을 초과함 - $currentUsage > ${_pieChartData.totalCapacity}');
      return; // 업데이트를 거부
    }

    _pieChartData = _pieChartData.copyWith(currentUsage: currentUsage);
    notifyListeners();

    debugPrint('ChartProvider: 원형 그래프 현재 사용량 업데이트 - $currentUsage');
  }

  /// 원형 그래프 총 용량 업데이트
  void updatePieTotalCapacity(double totalCapacity) {
    if (totalCapacity <= 0) {
      debugPrint('ChartProvider: 총 용량은 0보다 커야 함 - $totalCapacity');
      return;
    }

    _pieChartData = _pieChartData.copyWith(totalCapacity: totalCapacity);
    notifyListeners();

    debugPrint('ChartProvider: 원형 그래프 총 용량 업데이트 - $totalCapacity');
  }

  /// 원형 그래프 데이터 전체 업데이트
  void updatePieData({
    double? currentUsage,
    double? totalCapacity,
    Color? primaryColor,
    Color? backgroundColor,
  }) {
    // 유효성 검사
    if (currentUsage != null && currentUsage < 0) {
      debugPrint('ChartProvider: 음수 사용량은 허용되지 않음 - $currentUsage');
      return;
    }

    if (totalCapacity != null && totalCapacity <= 0) {
      debugPrint('ChartProvider: 총 용량은 0보다 커야 함 - $totalCapacity');
      return;
    }

    _pieChartData = _pieChartData.copyWith(
      currentUsage: currentUsage,
      totalCapacity: totalCapacity,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
    );
    notifyListeners();

    debugPrint('ChartProvider: 원형 그래프 전체 데이터 업데이트');
  }

  /// 차트 타입 전환 (막대 ↔ 원형)
  void toggleChartType() {
    _isBarChart = !_isBarChart;
    notifyListeners();

    debugPrint(
        'ChartProvider: 차트 타입 전환 - ${_isBarChart ? "막대 그래프" : "원형 그래프"}');
  }

  /// 특정 차트 타입으로 설정
  void setChartType(bool isBarChart) {
    if (_isBarChart != isBarChart) {
      _isBarChart = isBarChart;
      notifyListeners();

      debugPrint(
          'ChartProvider: 차트 타입 설정 - ${_isBarChart ? "막대 그래프" : "원형 그래프"}');
    }
  }

  /// 색상 스키마 업데이트
  void updateColorScheme(ChartColorScheme newColorScheme) {
    _colorScheme = newColorScheme;
    notifyListeners();

    debugPrint('ChartProvider: 색상 스키마 업데이트');
  }

  /// 특정 색상 업데이트
  void updateColor(String colorType, Color color) {
    switch (colorType.toLowerCase()) {
      case 'base':
        _colorScheme = _colorScheme.copyWith(baseUsageColor: color);
        break;
      case 'ac':
        _colorScheme = _colorScheme.copyWith(acUsageColor: color);
        break;
      case 'heating':
        _colorScheme = _colorScheme.copyWith(heatingUsageColor: color);
        break;
      case 'etc':
        _colorScheme = _colorScheme.copyWith(etcUsageColor: color);
        break;
      default:
        debugPrint('ChartProvider: 알 수 없는 색상 타입 - $colorType');
        return;
    }

    notifyListeners();
    debugPrint('ChartProvider: $colorType 색상 업데이트');
  }

  /// 모든 데이터 초기화
  void resetData() {
    _setLoading(true);

    try {
      _barChartData = ChartDataHelper.getSampleBarChartData();
      _pieChartData = ChartDataHelper.getSamplePieChartData();
      _colorScheme = ChartColorScheme.defaultScheme;
      _isBarChart = true;

      debugPrint('ChartProvider: 모든 데이터 초기화 완료');
    } finally {
      _setLoading(false);
    }
  }

  /// 빈 데이터로 초기화
  void resetToEmpty() {
    _setLoading(true);

    try {
      _barChartData = ChartDataHelper.getEmptyBarChartData(7);
      _pieChartData = ChartDataHelper.getEmptyPieChartData();
      _colorScheme = ChartColorScheme.defaultScheme;
      _isBarChart = true;

      debugPrint('ChartProvider: 빈 데이터로 초기화 완료');
    } finally {
      _setLoading(false);
    }
  }

  /// 로딩 상태 설정 (private)
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// 막대 그래프에 새로운 날짜 데이터 추가
  void addBarChartData(String label) {
    final newData = BarChartDataModel(
      label: label,
      baseUsage: 0.0,
      acUsage: 0.0,
      heatingUsage: 0.0,
      etcUsage: 0.0,
    );

    _barChartData.add(newData);
    notifyListeners();

    debugPrint('ChartProvider: 새로운 막대 그래프 데이터 추가 - $label');
  }

  /// 샘플 데이터 추가
  void addSampleData() {
    final sampleData = ChartDataHelper.getSampleBarChartData();
    if (sampleData.isNotEmpty) {
      final newData = sampleData.first.copyWith(
        label: '${DateTime.now().month}/${DateTime.now().day}',
      );
      _barChartData.add(newData);
      notifyListeners();
      debugPrint('ChartProvider: 샘플 데이터 추가 - ${newData.label}');
    }
  }

  /// 막대 그래프 데이터 제거
  void removeBarChartData(int index) {
    if (index >= 0 && index < _barChartData.length) {
      final removedLabel = _barChartData[index].label;
      _barChartData.removeAt(index);
      notifyListeners();

      debugPrint('ChartProvider: 막대 그래프 데이터 제거 - $removedLabel');
    }
  }

  /// 디버그 정보 출력
  void debugPrintState() {
    debugPrint('=== ChartProvider 상태 ===');
    debugPrint('차트 타입: ${_isBarChart ? "막대 그래프" : "원형 그래프"}');
    debugPrint('로딩 중: $_isLoading');
    debugPrint('막대 그래프 데이터 수: ${_barChartData.length}');
    debugPrint(
        '원형 그래프: ${_pieChartData.currentUsage}/${_pieChartData.totalCapacity} (${_pieChartData.percentage.toStringAsFixed(1)}%)');
    debugPrint('========================');
  }
}
