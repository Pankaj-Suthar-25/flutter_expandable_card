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
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Layout Variant')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => _navigateTo(context, const SimpleLayoutScreen()),
              child: const Text('Simple Layout'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateTo(context, const CardLayoutScreen()),
              child: const Text('Card Layout'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateTo(context, const InteractiveLayoutScreen()),
              child: const Text('Interactive Layout')
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleLayoutScreen extends StatelessWidget {
  const SimpleLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Layout'),
      ),
      body: const Center(child: ExpandedRowFlexLayout()),
    );
  }
}

class CardLayoutScreen extends StatelessWidget {
  const CardLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Layout'),
      ),
      body: const Center(child: ExpandedRowFlexLayoutVariant()),
    );
  }
}

class InteractiveLayoutScreen extends StatelessWidget {
  const InteractiveLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Layout')
      ),
      body: const Center(child: InteractiveFlexPanelsLayout()),
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

class InteractiveFlexPanelsLayout extends StatefulWidget {
  const InteractiveFlexPanelsLayout({super.key});

  @override
  State<InteractiveFlexPanelsLayout> createState() => _InteractiveFlexPanelsLayout();
}

class _InteractiveFlexPanelsLayout extends State<InteractiveFlexPanelsLayout> with TickerProviderStateMixin {
  int? selectedIndex;
  static const int totalFlex = 5;
  static const List<int> baseFlexes = [2, 1, 2];
  static const int expandedFlex = 4;
  static const int shrunkFlex = 1;

  void onPanelTap(int index) {
    setState(() {
      if (selectedIndex == index) {
        selectedIndex = null;
      } else {
        selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        final bool isSelected = selectedIndex == index;
        final int flex = selectedIndex == null
            ? baseFlexes[index] : (isSelected ? expandedFlex : shrunkFlex);

        return Expanded(
          flex: flex,
          child: AnimatedFlexPanel(
            key: ValueKey(index),
            flex: flex,
            colorStart: _gradientColors[index][0],
            colorEnd: _gradientColors[index][1],
            icon: _icons[index],
            label: _labels[index],
            isSelected: isSelected,
            onTap: () => onPanelTap(index),
          ),
        );
      }),
    );
  }
}

const List<List<Color>> _gradientColors = [
  [Color(0xFFff416c), Color(0xFFff4b2b)],
  [Color(0xFF1e3c72), Color(0xFF2a5298)],
  [Color(0xFF11998e), Color(0xFF38ef7d)],
];

const List<IconData> _icons = [
  Icons.favorite,
  Icons.lightbulb,
  Icons.nature,
];

const List<String> _labels = [
  'Love 2/5',
  'Idea 1/5',
  'Nature 2/5'
];

class AnimatedFlexPanel extends StatelessWidget {
  final int flex;
  final Color colorStart;
  final Color colorEnd;
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AnimatedFlexPanel({
    super.key, required this.flex, required this.colorStart, required this.colorEnd , required this.icon, required this.label,
      required this.isSelected, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [colorStart, colorEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // ignore: deprecated_member_use
        boxShadow: isSelected ? [BoxShadow(color: colorEnd.withOpacity(0.6),blurRadius: 15, offset: const Offset(0,8),)] : [],
      ),
    width: double.infinity,
      height: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: isSelected ? 60: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSelected ? 26 : 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              if (isSelected)
                Padding(
                padding: const EdgeInsets.only(top: 15),
      child: Text('Tap again to reset',
      // ignore: deprecated_member_use
      style: TextStyle(color: Colors.white.withOpacity(0.75),fontSize: 14,
      fontStyle: FontStyle.italic,)),
                )

            ],
          ),
        ),
      ),
    );
  }
}