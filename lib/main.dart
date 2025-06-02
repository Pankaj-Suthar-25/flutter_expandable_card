import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      title: 'Flutter Expandable Card',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Expandable Card'),
        ),
        body: Center(
          child: ExpandedRowFlexLayout(),
        ),
      ),
    );
  }
}

class ExpandedRowFlexLayout extends StatelessWidget {
  const ExpandedRowFlexLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildExpandedContainer(Colors.red, '2/5', 2),
        _buildExpandedContainer(Colors.blue, '1/5', 1),
        _buildExpandedContainer(Colors.green, '2/5', 2),
      ],
    );
  }

  Expanded _buildExpandedContainer(Color color, String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        color: color,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
