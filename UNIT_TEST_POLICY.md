# Chart Sample App Unit Test 정책 📋

## 🎯 목적
task 끝날 때마다 체계적인 unit test를 통해 코드 품질을 보장하고 회귀 버그를 방지한다.

## 🧪 테스트 프레임워크
- **Flutter Test**: 기본 테스트 프레임워크
- **flutter_test**: 위젯 테스트용 패키지
- **mockito**: 의존성 모킹용 패키지
- **provider/test**: Provider 상태 테스트용

## 📊 테스트 커버리지 목표
- **전체 코드 커버리지**: 최소 80%
- **핵심 로직 커버리지**: 최소 95%
  - Models (`lib/models/`)
  - Providers (`lib/providers/`)
  - Utils (`lib/utils/`)
- **UI 위젯 커버리지**: 최소 70%
  - Widgets (`lib/widgets/`)

## 🔄 TDD 워크플로우

### 각 Task 완료 시 필수 절차:
1. **📝 테스트 작성** (Red Phase)
   - 새로 추가된 기능에 대한 테스트 작성
   - 기존 기능 수정 시 관련 테스트 업데이트

2. **🔧 구현** (Green Phase)
   - 테스트를 통과할 최소한의 코드 작성
   - 모든 테스트가 통과하는지 확인

3. **✨ 리팩토링** (Refactor Phase)
   - 코드 품질 개선
   - 테스트가 여전히 통과하는지 확인

4. **📈 커버리지 검증**
   - `flutter test --coverage` 실행
   - 목표 커버리지 달성 확인

5. **✅ 최종 검증**
   - 모든 테스트 통과 확인
   - 성능 이슈 없는지 확인

## 📁 테스트 파일 구조
```
test/
├── models/                 # 데이터 모델 테스트
│   ├── chart_data_models_test.dart
│   └── chart_data_helper_test.dart
├── providers/              # 상태 관리 테스트
│   ├── chart_provider_test.dart
│   └── chart_provider_test_v2.dart
├── widgets/                # 위젯 테스트
│   ├── chart_area_test.dart
│   └── control_panel_test.dart
├── utils/                  # 유틸리티 테스트
└── integration/            # 통합 테스트
```

## 🧪 테스트 유형별 기준

### 1. Unit Tests (단위 테스트)
- **모든 public 메서드** 테스트
- **경계값 테스트** (null, empty, edge cases)
- **에러 케이스** 테스트
- **상태 변화** 테스트

### 2. Widget Tests (위젯 테스트)
- **렌더링** 테스트
- **사용자 상호작용** 테스트
- **상태 변화에 따른 UI 업데이트** 테스트

### 3. Provider Tests (상태 관리 테스트)
- **초기 상태** 검증
- **상태 변화** 테스트
- **notify** 호출 검증
- **비즈니스 로직** 테스트

## 🛠 테스트 실행 명령어

### 전체 테스트 실행
```bash
flutter test
```

### 커버리지 포함 테스트
```bash
flutter test --coverage
```

### 특정 파일 테스트
```bash
flutter test test/providers/chart_provider_test.dart
```

### 특정 패턴 테스트
```bash
flutter test test/models/
```

## 📋 Task 완료 시 체크리스트

### ✅ 필수 체크 항목:
- [ ] 새로운 기능에 대한 테스트 작성 완료
- [ ] 모든 테스트 통과 (`flutter test`)
- [ ] 커버리지 목표 달성 확인
- [ ] 기존 테스트 영향도 확인
- [ ] 테스트 코드 리뷰 완료

### 🎯 품질 기준:
- [ ] 테스트 이름이 명확하고 의미있음
- [ ] 각 테스트가 단일 기능만 검증
- [ ] Mock 사용이 적절함
- [ ] 테스트 실행 속도가 합리적임

## 🔧 CI/CD 통합

### GitHub Actions (향후 설정)
```yaml
- name: Run Tests
  run: flutter test --coverage
  
- name: Check Coverage
  run: |
    if [ $(lcov --summary coverage/lcov.info | grep -o 'lines......[0-9.]*%' | grep -o '[0-9.]*' | head -1 | cut -d. -f1) -lt 80 ]; then
      echo "Coverage below 80%"
      exit 1
    fi
```

## 📚 모범 사례

### 좋은 테스트 작성법:
1. **AAA 패턴** 사용 (Arrange, Act, Assert)
2. **의미있는 테스트 이름** 사용
3. **하나의 테스트는 하나의 assertion**
4. **독립적인 테스트** (다른 테스트에 의존하지 않음)
5. **반복 가능한 테스트** (매번 같은 결과)

### 테스트 이름 규칙:
```dart
test('should return valid chart data when provider is initialized')
test('should throw exception when invalid data is provided')
test('should update UI when chart type is changed')
```

## 🎯 다음 단계

1. **현재 깨진 테스트 수정** ✅ (진행 중)
2. **위젯 테스트 추가**
3. **통합 테스트 추가**
4. **커버리지 도구 설정**
5. **자동화 스크립트 작성**

---
*Last Updated: 2025년 10월 2일*
*Version: 1.0*