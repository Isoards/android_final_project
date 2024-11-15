import 'package:flutter/material.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  int _selectedIndex = 0;

  // 탭 선택 시 호출될 함수
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('환자/보호자 앱'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '간병인을 찾아보세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/search');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Text(
                          '간병인 찾기',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '간병인 찾기'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이 페이지'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 174, 28, 188),
        onTap: _onItemTapped,
      ),
    );
  }
}
