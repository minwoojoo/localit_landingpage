import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screen/onboarding_korean_screen.dart';
import 'screen/onboarding_japanese_screen.dart';
import 'screen/onboarding_chinese_screen.dart';
import 'screen/onboarding_english_screen.dart';
import 'screen/onboarding_taiwanese_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase 초기화 에러: $e');
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
