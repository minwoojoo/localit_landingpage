import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class OnboardingJapaneseScreen extends StatefulWidget {
  const OnboardingJapaneseScreen({super.key});

  @override
  State<OnboardingJapaneseScreen> createState() =>
      _OnboardingJapaneseScreenState();
}

class _OnboardingJapaneseScreenState extends State<OnboardingJapaneseScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

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
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 370, // 이미지의 카드 폭에 맞춤
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 로고
                  Image.asset(
                    'assets/logo.png',
                    height: 80,
                  ),
                  const SizedBox(height: 24),
                  // 안내 문구들
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. 현지인 매칭 안내
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('🧑‍🤝‍🧑 ', style: TextStyle(fontSize: 20)),
                          Expanded(
                            child: Text(
                              '意気がピッタリ合う韓国人の相手とマッチングしてまるで親友と一緒のような旅を始めよう！',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // 2. 하루 가이드 안내
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('🗺️ ', style: TextStyle(fontSize: 20)),
                          Expanded(
                            child: Text(
                              '1日ガイドで、グルメやカフェを一緒に楽しんで、\n短い時間でも"ローカル感たっぷりの旅"を過ごしてみよう！',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // 3. 일정 설계 안내
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('💬 ', style: TextStyle(fontSize: 20)),
                          Expanded(
                            child: Text(
                              '旅のプランはチャットで気軽に相談。\n準備はアプリひとつでかんたんにスタート！',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // 4. Local-it 안내
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🟩 대신 녹색 정사각형
                          Container(
                            width: 16,
                            height: 16,
                            margin: const EdgeInsets.only(right: 8, top: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Local-it',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: 14),
                                  ),
                                  TextSpan(
                                    text:
                                        "は「行き先を探す」のではなく、\n「人を通じて旅を始める」サービスです。\nあなたと気が合う現地の人が、あなたのための旅を提案してくれます。",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      // 체크 안내
                      const Text(
                        '👇 気になったら今すぐチェック！',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      // LINE 안내
                      GestureDetector(
                        onTap: () async {
                          // 개발 환경이 아닌 경우에만 이벤트 전송
                          if (!_isDevelopment()) {
                            FirebaseAnalytics.instance.logEvent(
                              name: 'line_link_clicked',
                              parameters: {
                                'language': 'japanese',
                                'screen': 'onboarding_japanese',
                              },
                            );
                          }

                          final Uri url =
                              Uri.parse('https://line.me/ti/p/Mp5RBh9JzM');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        child: const Text(
                          '📱 今すぐLINEでチェックしてね！',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 마지막 안내
                      const Text(
                        '地元を知る人と一緒に、\nちょっと特別なローカルな旅を体験してみよう ✨',
                        style: TextStyle(
                            fontSize: 14, color: Colors.black87, height: 1.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  // 이메일 등록 안내
                  const Text(
                    'メールアドレスを登録しておけば、サービスが始まったらすぐにお知らせするよ！',
                    style: TextStyle(
                        fontSize: 14, color: Colors.black87, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // 이메일 입력
                  GestureDetector(
                    onTap: _showEmailDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: const Text(
                        '✉️【メールアドレスを入力してください】',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEmailDialog() {
    _emailController.clear();

    // 개발 환경이 아닌 경우에만 이벤트 전송
    if (!_isDevelopment()) {
      FirebaseAnalytics.instance.logEvent(
        name: 'email_dialog_opened',
        parameters: {
          'language': 'japanese',
          'screen': 'onboarding_japanese',
        },
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('メールアドレス入力'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('メールアドレスを登録しておけば、サービスが始まったらすぐにお知らせするよ！'),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'メールアドレス',
                  border: OutlineInputBorder(),
                  hintText: 'example@email.com',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // 개발 환경이 아닌 경우에만 이벤트 전송
                if (!_isDevelopment()) {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'email_registration_cancelled',
                    parameters: {
                      'language': 'japanese',
                      'screen': 'onboarding_japanese',
                    },
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveEmail,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('登録'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('メールアドレスを入力してください')),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('有効なメールアドレスを入力してください')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('emails').add({
        'email': email,
        'language': 'japanese',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 개발 환경이 아닌 경우에만 이벤트 전송
      if (!_isDevelopment()) {
        FirebaseAnalytics.instance.logEvent(
          name: 'email_registration_success',
          parameters: {
            'language': 'japanese',
            'screen': 'onboarding_japanese',
            'email_domain': email.split('@').last, // 이메일 도메인 추적 (개인정보 보호)
          },
        );
      }

      if (mounted) {
        Navigator.of(context).pop(); // 다이얼로그 닫기
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ 登録が完了しました！\n🎁 ベータテスター特典をお楽しみに！'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // 개발 환경이 아닌 경우에만 이벤트 전송
      if (!_isDevelopment()) {
        FirebaseAnalytics.instance.logEvent(
          name: 'email_registration_failed',
          parameters: {
            'language': 'japanese',
            'screen': 'onboarding_japanese',
            'error_message': e.toString(),
          },
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラーが発生しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
