import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';

class BmiSummaryScreen extends StatefulWidget {
   int? composite;
   int? score;

  BmiSummaryScreen({Key? key, @required this.composite,@required this.score}) : super(key: key);



  @override
  _BmiSummaryScreenState createState() => _BmiSummaryScreenState();
}

class _BmiSummaryScreenState extends State<BmiSummaryScreen> {
  final double bmi = 19.5;
  final double ponderal = 12.2;
  final double minWeight = 47.4;
  final double maxWeight = 64.0;
  final List<Map<String, dynamic>> scoreRanges = [
    {'range': '113 - 150', 'score': 5},
    {'range': '93 - 112', 'score': 4},
    {'range': '77 - 92', 'score': 3},
    {'range': '65 - 76', 'score': 2},
    {'range': '0 - 64', 'score': 1},
  ];
  Color _containerColor = Colors.red;
  void initState(){
    super.initState();
    _updateContainerColor(widget.score!);
  }
  void _updateContainerColor(int condition) {
    setState(() {

      if (condition >= 113 && condition <=150) {
        _containerColor= Colors.green;

        // return 5;
      } else if (condition >= 93 && condition <=112) {
        _containerColor= Colors.greenAccent;

      } else if (condition >= 77 && condition <=92) {
        _containerColor= Colors.yellow;

      } else if (condition >= 65 && condition <=76) {
        _containerColor= Colors.orange;

      } else {
        _containerColor= Colors.red;

      }

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Summary'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Card(
                elevation: 0.3,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Total Composite Score",
                          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(height: 20,),
                        Center(
                          child: Text(
                            widget.score.toString()+"/150",
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 50,),
                        Text(
                          "Predicted AP® Score",
                          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(height: 20,),
                        Center(
                          child: Container(
                            width: 50,
                            decoration: BoxDecoration(
                              color: _containerColor,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                widget.composite!.toString(),
                                style: TextStyle(color: Colors.white, fontSize: 30),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30,),
                        Text("Description:"),
                        Table(
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          border: TableBorder.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Composite Score Range',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'AP Score',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ...scoreRanges.map((range) => TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(range['range']),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(range['score'].toString()),
                                  ),
                                ),
                              ],
                            )).toList(),
                          ],
                        ),
                    SizedBox(height: 20,),





                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child:      ElevatedButton.icon(onPressed: (){
              LaunchReview.launch(
                androidAppId: "com.bariskode.ap_psych_calculator"
              );
            }, icon: Icon(Icons.star), label: Text("Rate This App")),
          )
        ],
      ),
    );
  }
}
