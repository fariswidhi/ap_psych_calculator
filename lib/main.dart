import 'dart:io';

import 'package:ap_psych_calculator/SplashScreen.dart';
import 'package:ap_psych_calculator/result_page.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // RequestConfiguration.Builder().setTestDeviceIds(Arrays.asList("7234A3EE42DA488749E20B22148E9DBC"));
  MobileAds.instance.initialize();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AP Psychology Score Calculator',
      home: SplashScreen(),
    );
  }
}


const String testDevice = '';

class ScoreCalculatorScreen extends StatefulWidget {
  @override
  _ScoreCalculatorScreenState createState() => _ScoreCalculatorScreenState();
}

class _ScoreCalculatorScreenState extends State<ScoreCalculatorScreen> {
  late BannerAd bannerAd;
  bool isLoaded = false;

  int ok =0;
  double multipleChoiceScore = 0;
  double frq1Score = 0;
  double frq2Score = 0;
  int _currentSliderValue = 1;
  TextEditingController sliderController = TextEditingController();
  TextEditingController textNumberController = new TextEditingController();
  int result= 0;


  void initState(){
    super.initState();
    MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: [testDevice]));
    // _createRewardedAd();
    // _createInterstitialAd();
    // _createRewardedInterstitialAd();
    initBannerAd();
  }

  void dispose(){
    super.dispose();

    bannerAd.dispose();
  }

  void initBannerAd(){
    print("object");
    final adUnitId = Platform.isAndroid
        ? 'ca-app-pub-1640940280828869/6480348447'
        : 'ca-app-pub-3940256099942544/2934735716';

    print(adUnitId);
    bannerAd =  BannerAd(
        size: AdSize.banner, adUnitId: adUnitId,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            print(ad);
            print("SAKSES");
            setState(() {
              isLoaded=true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print(error);
            print("ERROR");
          },
        ),
        request:  AdRequest()
    )      ..load();


    // print("ass");
    // print(bannerAd.responseInfo.responseExtras);

  }

  int calculateCompositeScore() {
    double multiplierMultipleChoice = 1.08;
    double multiplierFRQ = 3.57;
    double weightedFRQ = (frq1Score.round() + frq2Score.round()) * multiplierFRQ;
    double result = weightedFRQ + multipleChoiceScore;
    print(weightedFRQ);

    // print(frq1Score.round() );
    return result.round();
  }

  int calculateAPExamScore() {
    int compositeScore = calculateCompositeScore();
    if (compositeScore >= 113 && compositeScore <=150) {
      return 5;
    } else if (compositeScore >= 93 && compositeScore <=112) {
      return 4;
    } else if (compositeScore >= 77 && compositeScore <=92) {
      return 3;
    } else if (compositeScore >= 65 && compositeScore <=76) {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    int compositeScore = calculateCompositeScore();
    int apExamScore = calculateAPExamScore();

    return Scaffold(
        // bottomNavigationBar: isLoaded ? SizedBox(
        //   height: bannerAd.size.height.toDouble(),
        //   width: MediaQuery.of(context).size.width,
        //   child: AdWidget(ad: bannerAd),
        // ) : const SizedBox(),
      appBar: AppBar(
        title: Text('AP Psychology Score Calculator'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('How many correct on multiple choice?'),
                              TextField(
                                  keyboardType: TextInputType.number,
                                  controller: textNumberController,

                                  onChanged: (value) {
                                  if(int.parse(value) >= 0 && int.parse(value) <= 100){
                                    setState(() {
                                      multipleChoiceScore=double.parse(value);
                                    });
                                    textNumberController.text =value;

                                  }
                                  else{
                                    // setState(() {
                                    //   multipleChoiceScore=0;
                                    // });
                                    textNumberController.text = "0";
                                  }

                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter correct on multiple choice (0 - 100)',
                                ),
                              ),

                              SizedBox(height: 30.0),
                              Text('How many correct on FRQ 1?'),

                              SfSlider(
                                // tooltipShape: const SfRectangularTooltipShape(),
                                min: 0,
                                max: 7,

                                value: frq1Score,
                                interval: 1,
                                showDividers: true,
                                showLabels: true,
                                tooltipTextFormatterCallback:
                                    (dynamic actualValue, String formattedText) {
                                  return actualValue.toStringAsFixed(0);
                                },

                                // showLabels: true,
                                // showTicks: false,



                                // dividerShape: _DividerShape(),
                                shouldAlwaysShowTooltip: false,
                                onChanged: (value) {
                                  setState(() {
                                    frq1Score = value;

                                  });
                                },
                              ),

                              SizedBox(height: 16.0),
                              Text('How many correct on FRQ 2?'),

                              SfSlider(
                                // tooltipShape: const SfRectangularTooltipShape(),
                                min: 0,
                                max: 7,

                                value: frq2Score,
                                interval: 1,
                                showDividers: true,
                                shouldAlwaysShowTooltip: false,
                                showLabels: true,

                                tooltipTextFormatterCallback:
                                    (dynamic actualValue, String formattedText) {
                                  return actualValue.toStringAsFixed(0);
                                },

                                // showLabels: true,
                                // showTicks: false,



                                // dividerShape: _DividerShape(),
                                onChanged: (value) {
                                  setState(() {
                                    frq2Score = value;

                                  });
                                },
                              ),

                              SizedBox(height: 50,),
                              Center(
                                  child:

                                  SizedBox(
                                    width: MediaQuery.of(context).size.width* 0.5,
                                    child:       ElevatedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(18.0),
                                                  side: BorderSide(color: Colors.red)
                                              )
                                          )
                                      ),
                                      // style: raisedButtonStyle,
                                      onPressed: () {
                                        calculateCompositeScore();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>  BmiSummaryScreen(score: compositeScore,composite: apExamScore,)),
                                        );

                                      },
                                      child: Text('Calculate'),
                                    ),
                                  )


                              )
                              ,
                              SizedBox(height: 32.0),
                              // Text(
                              //   'AP Psychology Estimation Score Calculator',
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              // SizedBox(height: 16.0),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text('Composite Score:'),
                              //     Text(
                              //       compositeScore.toString(),
                              //       style: TextStyle(
                              //         fontSize: 24.0,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(height: 16.0),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text('AP Exam Score:'),
                              //     Text(
                              //       apExamScore.toString(),
                              //       style: TextStyle(
                              //         fontSize: 48.0,
                              //         fontWeight: FontWeight.bold,
                              //         color: Colors.green,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}