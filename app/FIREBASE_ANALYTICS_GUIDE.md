# Firebase Analytics 사용 가이드

## 개요
이 문서는 Local-it Flutter 앱에서 Firebase Analytics를 사용하는 방법을 설명합니다.

## 1. 기본 설정

### 1.1 의존성 추가
`pubspec.yaml`에 다음 의존성이 이미 추가되어 있습니다:
```yaml
dependencies:
  firebase_analytics: ^11.3.3
```

### 1.2 초기화
`main.dart`에서 Firebase Analytics가 이미 초기화되어 있습니다:
```dart
// Firebase 초기화
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Analytics 수집 활성화
await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

// Navigator Observer 설정 (자동 화면 추적)
navigatorObservers: [
  FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
],
```

## 2. 이벤트 추적

### 2.1 기본 이벤트 추적
```dart
import 'package:firebase_analytics/firebase_analytics.dart';

// 기본 이벤트 로깅
FirebaseAnalytics.instance.logEvent(
  name: 'event_name',
  parameters: {
    'parameter1': 'value1',
    'parameter2': 'value2',
  },
);
```

### 2.2 화면 추적
```dart
@override
void initState() {
  super.initState();
  FirebaseAnalytics.instance.logEvent(
    name: 'screen_view',
    parameters: {
      'screen_name': 'screen_name',
      'screen_class': 'ScreenClassName',
    },
  );
}
```

### 2.3 사용자 행동 추적
현재 구현된 이벤트들:

#### 언어 선택
- **이벤트명**: `language_selected`
- **파라미터**: 
  - `selected_language`: 선택된 언어
  - `previous_language`: 이전 언어

#### 이메일 등록
- **이벤트명**: `email_dialog_opened`
- **파라미터**:
  - `language`: 언어
  - `screen`: 화면명

- **이벤트명**: `email_registration_success`
- **파라미터**:
  - `language`: 언어
  - `screen`: 화면명
  - `email_domain`: 이메일 도메인 (개인정보 보호)

- **이벤트명**: `email_registration_failed`
- **파라미터**:
  - `language`: 언어
  - `screen`: 화면명
  - `error_message`: 에러 메시지

- **이벤트명**: `email_registration_cancelled`
- **파라미터**:
  - `language`: 언어
  - `screen`: 화면명

#### 외부 링크 클릭
- **이벤트명**: `line_link_clicked`
- **파라미터**:
  - `language`: 언어
  - `screen`: 화면명

## 3. Firebase Console에서 확인

### 3.1 이벤트 확인
1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 선택
3. Analytics > Events 메뉴로 이동
4. 실시간 이벤트와 과거 이벤트 확인 가능

### 3.2 대시보드 확인
- **사용자**: 앱 사용자 수
- **이벤트**: 발생한 이벤트 수
- **화면**: 가장 많이 방문한 화면
- **언어별 사용자**: 언어 선택 통계

## 4. 추가 이벤트 추적 예시

### 4.1 사용자 속성 설정
```dart
// 사용자 언어 설정
await FirebaseAnalytics.instance.setUserProperty(
  name: 'preferred_language',
  value: 'korean',
);
```

### 4.2 커스텀 이벤트
```dart
// 버튼 클릭 추적
FirebaseAnalytics.instance.logEvent(
  name: 'button_clicked',
  parameters: {
    'button_name': 'email_submit',
    'screen': 'onboarding',
  },
);

// 앱 사용 시간 추적
FirebaseAnalytics.instance.logEvent(
  name: 'app_usage_time',
  parameters: {
    'duration_seconds': 300, // 5분
    'screen': 'onboarding',
  },
);
```

## 5. 디버깅

### 5.1 디버그 모드 활성화
```dart
// 개발 중에만 사용
FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
```

### 5.2 로그 확인
```dart
// 이벤트 전송 확인
FirebaseAnalytics.instance.logEvent(
  name: 'test_event',
  parameters: {'test': 'value'},
).then((_) {
  print('이벤트 전송 완료');
}).catchError((error) {
  print('이벤트 전송 실패: $error');
});
```

## 6. 개인정보 보호

### 6.1 민감한 정보 제외
- 이메일 주소 전체 대신 도메인만 추적
- 사용자 ID나 개인 식별 정보 제외
- 위치 정보는 필요한 경우에만 수집

### 6.2 데이터 수집 제어
```dart
// 사용자가 원하지 않는 경우 수집 중단
await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
```

## 7. 성능 최적화

### 7.1 배치 처리
```dart
// 여러 이벤트를 한 번에 처리
Future<void> logMultipleEvents() async {
  await Future.wait([
    FirebaseAnalytics.instance.logEvent(name: 'event1'),
    FirebaseAnalytics.instance.logEvent(name: 'event2'),
    FirebaseAnalytics.instance.logEvent(name: 'event3'),
  ]);
}
```

### 7.2 에러 처리
```dart
try {
  await FirebaseAnalytics.instance.logEvent(
    name: 'important_event',
    parameters: {'key': 'value'},
  );
} catch (e) {
  print('Analytics 이벤트 전송 실패: $e');
  // 앱 기능에는 영향을 주지 않도록 처리
}
```

## 8. 유용한 팁

1. **이벤트명 규칙**: `snake_case` 사용 (예: `user_registration_completed`)
2. **파라미터 제한**: 최대 25개 파라미터, 각 값은 100자 이하
3. **이벤트 수 제한**: 앱당 최대 500개 커스텀 이벤트
4. **실시간 확인**: Firebase Console에서 실시간으로 이벤트 확인 가능
5. **데이터 지연**: 일반적으로 24-48시간 후 완전한 데이터 확인 가능 