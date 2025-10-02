# Unit Test Subtask Template 📋

## 🧪 표준 Unit Test Subtask 구조

모든 개발 task에 마지막 subtask로 추가해야 하는 **Unit Test 작성 및 실행** 단계입니다.

### 📝 Subtask Title Template:
```
Unit Test 작성 및 실행 - [기능명]
```

### 📋 Subtask Description Template:
```
이 기능에 대한 포괄적인 unit test를 작성하고 실행합니다.

테스트 범위:
- [구현된 주요 기능 1]
- [구현된 주요 기능 2] 
- [에러 케이스 처리]
- [경계값 테스트]

테스트 파일 위치:
- test/[모듈명]/[기능명]_test.dart

커버리지 목표:
- 최소 80% 코드 커버리지
- 모든 public 메서드 테스트
- 에러 케이스 테스트 포함
```

### 🎯 Subtask Details Template:
```
Unit Test 구현 절차:

1. 테스트 파일 생성/업데이트
   - 테스트 파일 경로: test/[모듈]/[파일명]_test.dart
   - 기존 테스트가 있다면 추가 테스트 케이스 작성

2. 테스트 케이스 작성
   - setUp() 메서드로 테스트 환경 초기화
   - 각 public 메서드에 대한 테스트
   - 에러 케이스 및 경계값 테스트
   - Mock 객체 사용 (필요한 경우)

3. 테스트 실행 및 검증
   - flutter test 명령어로 테스트 실행
   - 모든 테스트 통과 확인
   - flutter test --coverage로 커버리지 측정

4. 테스트 품질 검토
   - 테스트 코드 가독성 확인
   - 테스트 케이스 완성도 점검
   - AAA 패턴 (Arrange, Act, Assert) 준수

5. 최종 검증
   - 전체 테스트 스위트 실행하여 회귀 없음 확인
   - 커버리지 목표 달성 확인
```

### ✅ **Test Strategy Template:**
```
이 subtask의 완료는 다음을 통해 검증됩니다:

1. 테스트 실행 결과
   - 모든 새로운 테스트 케이스 통과
   - 기존 테스트에 회귀 없음
   - flutter test 명령어 성공

2. 커버리지 측정
   - flutter test --coverage 실행
   - 목표 커버리지 달성 확인
   - coverage/lcov.info 파일 생성

3. 코드 품질
   - 테스트 코드가 명확하고 이해하기 쉬움
   - 테스트 케이스가 기능을 충분히 커버
   - Mock 사용이 적절함

4. 문서화
   - 테스트 케이스에 적절한 설명 포함
   - 복잡한 테스트 로직에 주석 추가
```

---

## 🚀 **사용법**

### 새로운 Task 생성 시:
1. 일반적인 개발 subtask들 추가
2. **마지막 subtask**로 위 템플릿 사용
3. [기능명], [모듈명] 등을 실제 값으로 치환
4. 의존성을 이전 subtask들로 설정

### 기존 Task에 추가 시:
```bash
task-master add-subtask --parent=[TASK_ID] --title="Unit Test 작성 및 실행 - [기능명]" --description="[위 템플릿 사용]"
```

---
*Template Version: 1.0*
*Created: 2025년 10월 2일*