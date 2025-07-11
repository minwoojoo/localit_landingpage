import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingKoreanScreen extends StatefulWidget {
  const OnboardingKoreanScreen({super.key});

  @override
  State<OnboardingKoreanScreen> createState() => _OnboardingKoreanScreenState();
}

class _OnboardingKoreanScreenState extends State<OnboardingKoreanScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

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
                              '현지인과 관심사가 맞는 친구를 매칭해,\n진짜 친구와 함께하는 듯한 여행을 시작해보세요!',
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
                              '1일 가이드로 현지 먹거리와 카페를 함께 즐기며,\n짧은 시간이더라도 \'현지 감성 가득한 여행\'을 경험할 수 있어요.',
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
                              '여행 계획은 부담 없이 채팅으로 상담하고,\n준비는 앱 하나로 간편하게 시작하세요!',
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
                                        "은 「목적지를 정하는 여행」이 아니라,\n'사람을 통해 여행을 시작하는' 서비스입니다.\n당신과 잘 맞는 현지인이, 당신만을 위한 여행을 제안해 드려요.",
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
                      // 마지막 안내
                      const Text(
                        '현지를 잘 아는 사람과 함께,\n조금 특별한 로컬 여행을 체험해보세요 ✨',
                        style: TextStyle(
                            fontSize: 14, color: Colors.black87, height: 1.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  // 이메일 등록 안내
                  const Text(
                    '이메일을 등록하면, 정식 서비스 오픈 소식을 가장 먼저 받아볼 수 있어요!',
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
                        '✉️ 【이메일 주소를 입력해주세요】',
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('이메일 주소 입력'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('이메일을 등록하면, 정식 서비스 오픈 소식을 가장 먼저 받아볼 수 있어요!'),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: '이메일 주소',
                  border: OutlineInputBorder(),
                  hintText: 'example@email.com',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveEmail,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('등록'),
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
        const SnackBar(content: Text('이메일 주소를 입력해주세요')),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유효한 이메일 주소를 입력해주세요')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('emails').add({
        'email': email,
        'language': 'korean',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.of(context).pop(); // 다이얼로그 닫기
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ 등록이 완료되었습니다!\n🎁 곧 특별한 혜택을 보내드릴게요!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: $e'),
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
