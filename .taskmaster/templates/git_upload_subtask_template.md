# Git Upload Subtask Template 📤

## 🔧 표준 Git Upload Subtask 구조

모든 개발 task에 Unit Test 다음 마지막 subtask로 추가해야 하는 **Git Upload 및 버전 관리** 단계입니다.

### 📝 Subtask Title Template:
```
Git Upload 및 버전 관리 - [기능명]
```

### 📋 Subtask Description Template:
```
이 task의 모든 변경사항을 Git repository에 commit하고 push합니다.

업로드 범위:
- [구현된 기능 파일들]
- [테스트 파일들]
- [문서 업데이트]
- [설정 파일 변경사항]

커밋 정보:
- 브랜치: feature/[task-id]-[기능명]
- 커밋 메시지: feat(task-[id]): [기능 요약]
- 태그: task-[id]-completed (선택적)
```

### 🎯 Subtask Details Template:
```
Git Upload 및 버전 관리 절차:

1. 브랜치 생성 및 전환
   - git checkout -b feature/task-[id]-[기능명]
   - 예: git checkout -b feature/task-1-unit-testing-policy

2. 변경사항 확인 및 정리
   - git status로 변경된 파일 확인
   - 불필요한 파일 .gitignore 추가
   - git add . 또는 선택적 add

3. 커밋 작성
   - 커밋 메시지 형식: feat(task-[id]): [기능 요약]
   - 예: feat(task-1): Establish unit testing policy with subtask templates
   - 상세 설명 포함 (선택적)

4. 원격 저장소 업로드
   - git push origin feature/task-[id]-[기능명]
   - 첫 번째 push: git push -u origin feature/task-[id]-[기능명]

5. Pull Request 생성 (선택적)
   - GitHub에서 PR 생성
   - 리뷰 요청 (팀 환경인 경우)

6. 메인 브랜치 병합 (승인 후)
   - git checkout main/master
   - git merge feature/task-[id]-[기능명]
   - git push origin main/master

7. 정리 작업
   - 로컬 브랜치 삭제: git branch -d feature/task-[id]-[기능명]
   - 원격 브랜치 삭제: git push origin --delete feature/task-[id]-[기능명]
```

### ✅ **Success Strategy Template:**
```
이 subtask의 완료는 다음을 통해 검증됩니다:

1. 커밋 확인
   - git log로 커밋이 올바르게 생성되었는지 확인
   - 커밋 메시지가 컨벤션을 따르는지 확인
   - 모든 변경사항이 포함되었는지 확인

2. 원격 저장소 확인
   - GitHub repository에서 변경사항 확인
   - 브랜치가 올바르게 생성되었는지 확인
   - 파일 내용이 정확히 업로드되었는지 확인

3. 이력 관리
   - git log --oneline으로 깔끔한 커밋 이력 확인
   - 태그가 있다면 올바르게 생성되었는지 확인

4. 동기화 상태
   - git status가 "working tree clean" 상태
   - 로컬과 원격이 동기화된 상태
```

---

## 🚀 **Git Commit Message Convention**

### 타입별 커밋 메시지:
- `feat(task-[id]): ` - 새로운 기능 추가
- `fix(task-[id]): ` - 버그 수정
- `docs(task-[id]): ` - 문서 업데이트
- `test(task-[id]): ` - 테스트 코드 추가/수정
- `refactor(task-[id]): ` - 코드 리팩토링
- `style(task-[id]): ` - 코드 스타일 변경
- `chore(task-[id]): ` - 빌드/설정 관련 변경

### 예시:
```bash
feat(task-1): Establish unit testing policy with subtask templates

- Created comprehensive unit testing policy document
- Added unit test subtask template for all future tasks
- Updated Taskmaster configuration
- Includes TDD workflow and coverage goals

Closes: #1
```

---

## 🔄 **브랜치 전략**

### 브랜치 명명 규칙:
- `feature/task-[id]-[간단한-설명]`
- `bugfix/task-[id]-[버그-설명]`
- `docs/task-[id]-[문서-설명]`

### 예시:
- `feature/task-1-unit-testing-policy`
- `feature/task-2-chart-widget-implementation`
- `bugfix/task-3-provider-state-issue`

---

## 🎯 **사용법**

### 새로운 Task 생성 시:
1. 일반적인 개발 subtask들 추가
2. Unit Test subtask 추가
3. **마지막 subtask**로 Git Upload subtask 추가
4. [task-id], [기능명] 등을 실제 값으로 치환

### 기존 Task에 추가 시:
```bash
task-master add-subtask --parent=[TASK_ID] --title="Git Upload 및 버전 관리 - [기능명]" --description="[위 템플릿 사용]"
```

---
*Template Version: 1.0*
*Created: 2025년 10월 2일*