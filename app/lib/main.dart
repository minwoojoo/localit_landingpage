import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
import 'screen/onboarding_korean_screen.dart';
import 'screen/onboarding_japanese_screen.dart';
import 'screen/onboarding_chinese_screen.dart';
import 'screen/onboarding_english_screen.dart';
import 'screen/onboarding_taiwanese_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 개발 환경 감지 (localhost 또는 개발 서버)
  bool isDevelopment = false;
  if (kIsWeb) {
    // 웹 환경에서 localhost 감지
    final uri = Uri.base;
    isDevelopment = uri.host == 'localhost' ||
        uri.host == '127.0.0.1' ||
        uri.host.contains('dev') ||
        uri.port != 443; // HTTPS가 아닌 경우 (개발 환경)
  }

  try {
    print('🔥 Firebase 초기화 시작...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase 초기화 완료');

    // 개발 환경에서는 Analytics 비활성화
    if (isDevelopment) {
      print('🚫 개발 환경 감지: Firebase Analytics 비활성화');
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
    } else {
      print('📊 Firebase Analytics 초기화 시작...');
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      print('✅ Firebase Analytics 초기화 완료');

      // 테스트 이벤트 전송 (프로덕션 환경에서만)
      print('🧪 테스트 이벤트 전송 중...');
      await FirebaseAnalytics.instance.logEvent(
        name: 'app_started',
        parameters: {
          'platform': 'web',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      print('✅ 테스트 이벤트 전송 완료');
    }
  } catch (e) {
    print('❌ Firebase 초기화 에러: $e');
    // Firebase 초기화 실패해도 앱은 계속 실행
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local-it',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LanguageSelectionScreen(),
      // Firebase Analytics 설정
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
    );
  }
}

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = '일본어'; // 기본값을 일본어로 설정

  // 개발 환경 감지 함수
  bool _isDevelopment() {
    if (kIsWeb) {
      final uri = Uri.base;
      return uri.host == 'localhost' ||
          uri.host == '127.0.0.1' ||
          uri.host.contains('dev') ||
          uri.port != 443;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 언어 선택 드롭다운
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 언어 선택 안내 텍스트
                  Row(
                    children: [
                      const Text(
                        'choose your language 👉',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedLanguage,
                      underline: Container(), // 기본 밑줄 제거
                      items: const [
                        DropdownMenuItem(
                          value: '일본어',
                          child:
                              Text('🇯🇵 日本語', style: TextStyle(fontSize: 14)),
                        ),
                        DropdownMenuItem(
                          value: '한국어',
                          child:
                              Text('🇰🇷 한국어', style: TextStyle(fontSize: 14)),
                        ),
                        DropdownMenuItem(
                          value: '중국어',
                          child:
                              Text('🇨🇳 中文', style: TextStyle(fontSize: 14)),
                        ),
                        DropdownMenuItem(
                          value: 'English',
                          child: Text('🇺🇸 English',
                              style: TextStyle(fontSize: 14)),
                        ),
                        DropdownMenuItem(
                          value: '대만어',
                          child:
                              Text('🇹🇼 繁體中文', style: TextStyle(fontSize: 14)),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          // 언어별 개별 이벤트 추적
                          print('🌍 언어 선택: $selectedLanguage → $newValue');

                          // 개발 환경이 아닌 경우에만 이벤트 전송
                          if (!_isDevelopment()) {
                            if (newValue == '일본어') {
                              FirebaseAnalytics.instance.logEvent(
                                name: 'japanese_selected',
                                parameters: {
                                  'selected_language': newValue,
                                  'previous_language': selectedLanguage,
                                },
                              ).then((_) {
                                print('✅ japanese_selected 이벤트 전송 완료');
                              }).catchError((error) {
                                print('❌ japanese_selected 이벤트 전송 실패: $error');
                              });
                            } else if (newValue == '한국어') {
                              FirebaseAnalytics.instance.logEvent(
                                name: 'korean_selected',
                                parameters: {
                                  'selected_language': newValue,
                                  'previous_language': selectedLanguage,
                                },
                              ).then((_) {
                                print('✅ korean_selected 이벤트 전송 완료');
                              }).catchError((error) {
                                print('❌ korean_selected 이벤트 전송 실패: $error');
                              });
                            } else if (newValue == '중국어') {
                              FirebaseAnalytics.instance.logEvent(
                                name: 'chinese_selected',
                                parameters: {
                                  'selected_language': newValue,
                                  'previous_language': selectedLanguage,
                                },
                              ).then((_) {
                                print('✅ chinese_selected 이벤트 전송 완료');
                              }).catchError((error) {
                                print('❌ chinese_selected 이벤트 전송 실패: $error');
                              });
                            } else if (newValue == 'English') {
                              FirebaseAnalytics.instance.logEvent(
                                name: 'english_selected',
                                parameters: {
                                  'selected_language': newValue,
                                  'previous_language': selectedLanguage,
                                },
                              ).then((_) {
                                print('✅ english_selected 이벤트 전송 완료');
                              }).catchError((error) {
                                print('❌ english_selected 이벤트 전송 실패: $error');
                              });
                            } else if (newValue == '대만어') {
                              FirebaseAnalytics.instance.logEvent(
                                name: 'taiwanese_selected',
                                parameters: {
                                  'selected_language': newValue,
                                  'previous_language': selectedLanguage,
                                },
                              ).then((_) {
                                print('✅ taiwanese_selected 이벤트 전송 완료');
                              }).catchError((error) {
                                print('❌ taiwanese_selected 이벤트 전송 실패: $error');
                              });
                            }
                          } else {
                            print('🚫 개발 환경: Firebase Analytics 이벤트 전송 건너뜀');
                          }

                          setState(() {
                            selectedLanguage = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            // 선택된 언어에 따른 화면 표시
            Expanded(
              child: selectedLanguage == '일본어'
                  ? const OnboardingJapaneseScreen()
                  : selectedLanguage == '한국어'
                      ? const OnboardingKoreanScreen()
                      : selectedLanguage == '중국어'
                          ? const OnboardingChineseScreen()
                          : selectedLanguage == 'English'
                              ? const OnboardingEnglishScreen()
                              : const OnboardingTaiwaneseScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
