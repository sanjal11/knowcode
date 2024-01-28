import 'package:flutter/material.dart';

class PCOSTestView extends StatefulWidget {
  const PCOSTestView({Key? key}) : super(key: key);

  @override
  _PCOSTestViewState createState() => _PCOSTestViewState();
}

class _PCOSTestViewState extends State<PCOSTestView> {
  PageController _pageController = PageController();
  List<String> questions = [
    'Were you overweight according to your BMI (Body Mass Index)?',
    'Have you experienced significant or rapid weight gain and faced difficulty in losing it?',
    'Have you experienced irregular or missed periods?',
    'Difficulty in conceiving?',
    'Acne or skin tags problem?',
    'Hair thinning or hair loss problems?',
    'Dark patches on the back of your neck or underarms?',
    'Feeling of tiredness all the time?',
    'Mood Swings more often than usual?',
    'Do you exercise more than twice a week?',
    'Do you eat outside more than twice a week?',
    'Did you consume canned food more often?',
  ];

  List<bool?> answers = List<bool?>.filled(12, null);
  double? percentage;
  int answeredQuestions = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PCOS Test"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: answeredQuestions / questions.length,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/img/question_${index + 1}.png',
                  width: 500,
                  height: 200,
                ),
                SizedBox(height: 10),
                Text(
                  questions[index],
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          answers[index] = true;
                          _navigateToNextQuestion(index);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: answers[index] == true ? Colors.green : null,
                      ),
                      child: Text("Yes"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          answers[index] = false;
                          _navigateToNextQuestion(index);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: answers[index] == false ? Colors.red : null,
                      ),
                      child: Text("No"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToNextQuestion(int currentIndex) {
    if (currentIndex < questions.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      _calculatePercentage();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PCOSResultPage(percentage!, answers),
        ),
      );
    }
  }

  void _calculatePercentage() {
    int? yesCount = answers.where((answer) => answer == true).length;
    percentage = (yesCount! / questions.length) * 100;
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        answeredQuestions = (_pageController.page ?? 0).round() + 1;
      });
    });
  }
}

class PCOSResultPage extends StatelessWidget {
  final double percentage;
  final List<bool?> answers;

  const PCOSResultPage(this.percentage, this.answers);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PCOS Risk Assessment Result'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'PCOS Risk: ${percentage.toStringAsFixed(2)}%',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                _getRiskLevel(),
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              if (percentage > 50) ...[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PCOSDetailsPage(percentage),
                      ),
                    );
                  },
                  child: Text("Learn More"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getRiskLevel() {
    if (percentage < 30) {
      return 'Low Risk';
    } else if (percentage < 60) {
      return 'Moderate Risk';
    } else {
      return 'High Risk';
    }
  }
}

class PCOSDetailsPage extends StatelessWidget {
  final double percentage;

  const PCOSDetailsPage(this.percentage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        // Centering the button in the AppBar
        actions: [
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NearestGynecologistPage(percentage),
                  ),
                );
              },
              child: Text("Find Nearest Gynecologists"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Polycystic Ovary Syndrome (PCOS)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'PCOS is a hormonal disorder common among women of reproductive age. It may cause infrequent or prolonged menstrual periods, excess hair growth, acne, and obesity. PCOS can also result in difficulty getting pregnant.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Common Symptoms:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '- Irregular menstrual cycles\n- Excessive hair growth\n- Acne\n- Weight gain\n- Thinning hair or hair loss\n- Dark patches on the skin\n- Fatigue\n- Mood swings',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Management and Treatment:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'The management of PCOS may involve lifestyle modifications, such as maintaining a healthy diet, regular exercise, and weight management. Medications may also be prescribed to regulate menstrual cycles, manage symptoms, and improve fertility.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class NearestGynecologistPage extends StatefulWidget {
  final double percentage;

  const NearestGynecologistPage(this.percentage);

  @override
  _NearestGynecologistPageState createState() =>
      _NearestGynecologistPageState();
}

class _NearestGynecologistPageState extends State<NearestGynecologistPage> {
  List<Map<String, dynamic>> gynecologists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate fetching data (replace this with your actual API call)
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        gynecologists = [
          {
            'name': 'Dr. Shabnam Singh',
            'specialization': 'M.S.(GYNECOLOGY), M.B.B.S, Women’s Care ',
            'address':
                'Women’s Care Clinic, 107 Sundaram building, Sion Cir, E',
            'contact': ' 098203 00842',
            'rating': '4.5',
            'reviews': '120',
            'workingHours': '9 AM - 5 PM',
            'services': [
              'Prenatal care',
              'Family planning',
              'Menopause management'
            ],
            'languages': ['English', 'Hindi'],
            'image': 'assets/img/doctor_profile1.png',
          },
          {
            'name': 'Dr. Tanushree Pandey Padgaonka',
            'specialization': 'IVF & PCOS Treatment',
            'address': ' Lions Club Hopsital, Sion (W)',
            'contact': '077770 82378',
            'rating': '4.2',
            'reviews': '90',
            'workingHours': '10 AM - 6 PM',
            'services': [
              'Maternity care',
              'Contraception counseling',
              'Gynecological surgery'
            ],
            'languages': ['English', 'Marathi'],
            'image': 'assets/img/doctor_profile2.png',
          },
          {
            'name': 'Dr. Tanushree Pandey Padgaonka',
            'specialization': 'IVF & PCOS Treatment',
            'address': ' Lions Club Hopsital, Sion (W)',
            'contact': '077770 82378',
            'rating': '4.2',
            'reviews': '90',
            'workingHours': '10 AM - 6 PM',
            'services': [
              'Maternity care',
              'Contraception counseling',
              'Gynecological surgery'
            ],
            'languages': ['English', 'Marathi'],
            'image': 'assets/img/doctor_profile2.png',
          },
          {
            'name': 'Dr. Patel',
            'specialization': 'Reproductive Endocrinology',
            'address': '789 Pine St, Villageland',
            'contact': '567-890-1234',
            'rating': '4.8',
            'reviews': '150',
            'workingHours': '8 AM - 4 PM',
            'services': [
              'Fertility treatments',
              'Hormone therapy',
              'Polycystic ovary syndrome'
            ],
            'languages': ['English', 'Hindi'],
            'image': 'assets/img/doctor_profile3.png',
          },
          {
            'name': 'Dr. Garcia',
            'specialization': 'Gynecologic Oncology',
            'address':
                'Surgical Nursing Home D3/D2, Vijay Nagar, Marol Maroshi Rd',
            'contact': '234-567-8901',
            'rating': '4.9',
            'reviews': '180',
            'workingHours': '8:30 AM - 5:30 PM',
            'services': [
              'Cancer screenings',
              'Robotic surgery',
              'Chemotherapy'
            ],
            'languages': ['English', 'Spanish'],
            'image': 'assets/img/doctor_profile4.png',
          },
          // Add more doctors with a similar structure
        ];
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearest Gynecologists'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : gynecologists.isNotEmpty
              ? ListView.builder(
                  itemCount: gynecologists.length,
                  itemBuilder: (context, index) {
                    final gynecologist = gynecologists[index];
                    return Card(
                      elevation: 2.0,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage(gynecologist['image'] ?? ''),
                        ),
                        title: Text(
                          gynecologist['name'] ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(gynecologist['specialization'] ?? ''),
                            Text(gynecologist['address'] ?? ''),
                            Text('Contact: ${gynecologist['contact'] ?? ''}'),
                            Text(
                                'Rating: ${gynecologist['rating'] ?? ''} (${gynecologist['reviews'] ?? ''} reviews)'),
                            Text(
                                'Working Hours: ${gynecologist['workingHours'] ?? ''}'),
                            SizedBox(height: 8),
                            Text('Services:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            ...(gynecologist['services'] ?? [])
                                .map((service) => Text('- $service')),
                            SizedBox(height: 8),
                            Text('Languages spoken:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            ...(gynecologist['languages'] ?? [])
                                .map((language) => Text('- $language')),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                // Add logic for booking appointment
                                // You can navigate to a new page or show a dialog for booking
                              },
                              child: Text('Book Appointment'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(child: Text('No doctors found nearby')),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PCOSTestView(),
  ));
}
