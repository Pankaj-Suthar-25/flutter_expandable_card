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
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Expandable Card'),
        ),
        body: Center(
          child: ExpandedRowFlexLayoutVariant(),
        ),
      ),
    );
  }
}

class ExpandedRowFlexLayoutVariant extends StatelessWidget {
  const ExpandedRowFlexLayoutVariant({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        ExpandedCard(flex: 2, label: '2/5', startColor: Color(0xFFE53935), endColor: Color(0xFFEF9A9A), icon: Icons.favorite,),
        ExpandedCard(flex: 1, label: '1/5', startColor: Color(0xFF1E88E5), endColor: Color(0xFF90CAF9), icon: Icons.star,),
        ExpandedCard(flex: 2, label: '2/5', startColor: Color(0xFF43A047), endColor: Color(0xFFA5D9A7), icon: Icons.thumb_up,),
      ],
    );
  }
}

class ExpandedCard extends StatefulWidget {
  final int flex;
  final String label;
  final Color startColor;
  final Color endColor;
  final IconData icon;

  const ExpandedCard({
    super.key,
    required this.flex,
    required this.label,
    required this.startColor,
    required this.endColor,
    required this.icon,
  });

  @override
  State<ExpandedCard> createState() => _ExpandedCardState();
}

class _ExpandedCardState extends State<ExpandedCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [widget.startColor, widget.endColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment :Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, size: 40, color: Colors.white),
                    const SizedBox(height :8),
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
