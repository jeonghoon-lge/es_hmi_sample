import 'package:flutter/material.dart';

/// 막대 그래프를 위한 데이터 모델
class BarChartDataModel {
  final String label;
  final double baseUsage;
  final double acUsage;
  final double heatingUsage;
  final double etcUsage;

  BarChartDataModel({
    required this.label,
    required this.baseUsage,
    required this.acUsage,
    required this.heatingUsage,
    required this.etcUsage,
  });

  /// 총 사용량 계산
  double get totalUsage => baseUsage + acUsage + heatingUsage + etcUsage;

  /// 복사본 생성 (값 변경을 위한 메서드)
  BarChartDataModel copyWith({
    String? label,
    double? baseUsage,
    double? acUsage,
    double? heatingUsage,
    double? etcUsage,
  }) {
    return BarChartDataModel(
      label: label ?? this.label,
      baseUsage: baseUsage ?? this.baseUsage,
      acUsage: acUsage ?? this.acUsage,
      heatingUsage: heatingUsage ?? this.heatingUsage,
      etcUsage: etcUsage ?? this.etcUsage,
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'baseUsage': baseUsage,
      'acUsage': acUsage,
      'heatingUsage': heatingUsage,
      'etcUsage': etcUsage,
    };
  }

  /// JSON에서 생성
  factory BarChartDataModel.fromJson(Map<String, dynamic> json) {
    return BarChartDataModel(
      label: json['label'] as String,
      baseUsage: (json['baseUsage'] as num).toDouble(),
      acUsage: (json['acUsage'] as num).toDouble(),
      heatingUsage: (json['heatingUsage'] as num).toDouble(),
      etcUsage: (json['etcUsage'] as num).toDouble(),
    );
  }
}

/// 원형 그래프를 위한 데이터 모델
class PieChartDataModel {
  final double currentUsage;
  final double totalCapacity;
  final Color primaryColor;
  final Color backgroundColor;

  PieChartDataModel({
    required this.currentUsage,
    required this.totalCapacity,
    required this.primaryColor,
    required this.backgroundColor,
  });

  /// 사용률 퍼센티지 계산
  double get percentage =>
      totalCapacity > 0 ? (currentUsage / totalCapacity) * 100 : 0.0;

  /// 복사본 생성 (값 변경을 위한 메서드)
  PieChartDataModel copyWith({
    double? currentUsage,
    double? totalCapacity,
    Color? primaryColor,
    Color? backgroundColor,
  }) {
    return PieChartDataModel(
      currentUsage: currentUsage ?? this.currentUsage,
      totalCapacity: totalCapacity ?? this.totalCapacity,
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  /// JSON으로 변환 (색상은 간단한 int 값으로)
  Map<String, dynamic> toJson() {
    return {
      'currentUsage': currentUsage,
      'totalCapacity': totalCapacity,
      'primaryColor': primaryColor.hashCode,
      'backgroundColor': backgroundColor.hashCode,
    };
  }

  /// JSON에서 생성 (간단한 복원 - 기본 색상 사용)
  factory PieChartDataModel.fromJson(Map<String, dynamic> json) {
    return PieChartDataModel(
      currentUsage: (json['currentUsage'] as num).toDouble(),
      totalCapacity: (json['totalCapacity'] as num).toDouble(),
      primaryColor: Colors.grey.shade600, // 기본값 사용
      backgroundColor: Colors.grey.shade300, // 기본값 사용
    );
  }
}

/// 차트 색상 설정을 위한 모델
class ChartColorScheme {
  final Color baseUsageColor;
  final Color acUsageColor;
  final Color heatingUsageColor;
  final Color etcUsageColor;

  const ChartColorScheme({
    required this.baseUsageColor,
    required this.acUsageColor,
    required this.heatingUsageColor,
    required this.etcUsageColor,
  });

  /// 기본 색상 스키마
  static const ChartColorScheme defaultScheme = ChartColorScheme(
    baseUsageColor: Colors.amber, // 기본 사용량 - 노란색
    acUsageColor: Colors.blue, // 에어컨 - 파란색
    heatingUsageColor: Colors.red, // 난방 - 빨간색
    etcUsageColor: Colors.grey, // 기타 - 회색
  );

  /// 색상 리스트 반환
  List<Color> get colors => [
        baseUsageColor,
        acUsageColor,
        heatingUsageColor,
        etcUsageColor,
      ];

  /// 복사본 생성
  ChartColorScheme copyWith({
    Color? baseUsageColor,
    Color? acUsageColor,
    Color? heatingUsageColor,
    Color? etcUsageColor,
  }) {
    return ChartColorScheme(
      baseUsageColor: baseUsageColor ?? this.baseUsageColor,
      acUsageColor: acUsageColor ?? this.acUsageColor,
      heatingUsageColor: heatingUsageColor ?? this.heatingUsageColor,
      etcUsageColor: etcUsageColor ?? this.etcUsageColor,
    );
  }
}
