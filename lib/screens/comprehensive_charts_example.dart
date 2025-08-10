import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class ComprehensiveChartsExample extends StatefulWidget {
  const ComprehensiveChartsExample({super.key});

  @override
  State<ComprehensiveChartsExample> createState() => _ComprehensiveChartsExampleState();
}

class _ComprehensiveChartsExampleState extends State<ComprehensiveChartsExample>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late PageController _pageController;
  
  int _selectedTab = 0;
  bool _showAllData = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Interactive Charts',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _animationController.reset();
              _animationController.forward();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedTab = index;
                    });
                  },
                  children: [
                    _buildBarChartTab(),
                    _buildLineChartTab(),
                    _buildPieChartTab(),
                    _buildDonutChartTab(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Bar Chart', 'Line Chart', 'Pie Chart', 'Donut Chart'];
    
    return Container(
      height: 60,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == _selectedTab;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    tab,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBarChartTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildChartCard(
            'Monthly Revenue',
            'Revenue growth over the past 12 months',
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => Colors.blue.withValues(alpha: 0.8),
                      tooltipRoundedRadius: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '\$${rod.toY.round()}k\n',
                          GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: _getMonthName(group.x.toInt()),
                              style: GoogleFonts.poppins(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _getMonthName(value.toInt()),
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}k',
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withValues(alpha: 0.2),
                        strokeWidth: 1,
                      );
                    },
                    drawVerticalLine: false,
                  ),
                  barGroups: _getBarChartData(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildChartCard(
            'Weekly Performance',
            'This week vs last week comparison',
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 50,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          return Text(
                            days[value.toInt()],
                            style: GoogleFonts.poppins(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups: _getWeeklyBarChartData(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChartTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildChartCard(
            'Stock Price Trend',
            'Apple Inc. (AAPL) - Last 30 days',
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 20,
                    verticalInterval: 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withValues(alpha: 0.2),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withValues(alpha: 0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'Day ${value.toInt()}',
                            style: GoogleFonts.poppins(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}',
                            style: GoogleFonts.poppins(fontSize: 12),
                          );
                        },
                        reservedSize: 42,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 30,
                  minY: 140,
                  maxY: 200,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getLineChartData(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.blue.withValues(alpha: 0.5)],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: false,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: Colors.blue,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue.withValues(alpha: 0.3),
                            Colors.blue.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => Colors.blue.withValues(alpha: 0.8),
                      tooltipRoundedRadius: 8,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          return LineTooltipItem(
                            '\$${barSpot.y.toStringAsFixed(2)}',
                            GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildChartCard(
            'Multi-line Comparison',
            'Revenue vs Profit comparison',
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('Q${value.toInt() + 1}', style: GoogleFonts.poppins(fontSize: 12));
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    // Revenue line
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 30),
                        const FlSpot(1, 40),
                        const FlSpot(2, 35),
                        const FlSpot(3, 50),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                    // Profit line
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 15),
                        const FlSpot(1, 25),
                        const FlSpot(2, 20),
                        const FlSpot(3, 35),
                      ],
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildChartCard(
            'Market Share',
            'Technology companies market distribution',
            SizedBox(
              height: 400,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            // Handle touch events
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 4,
                        centerSpaceRadius: 0,
                        sections: _getPieChartData(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem('Apple', Colors.blue, '35%'),
                        _buildLegendItem('Google', Colors.red, '28%'),
                        _buildLegendItem('Microsoft', Colors.green, '20%'),
                        _buildLegendItem('Amazon', Colors.orange, '12%'),
                        _buildLegendItem('Others', Colors.purple, '5%'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildChartCard(
            'Revenue Distribution',
            'Q4 2024 revenue breakdown by department',
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(enabled: true),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: _getRevenuePieChartData(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChartTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildChartCard(
            'Performance Metrics',
            'System performance distribution',
            SizedBox(
              height: 400,
              child: Stack(
                children: [
                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(enabled: true),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 6,
                      centerSpaceRadius: 80,
                      sections: _getDonutChartData(),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '85%',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            'Overall\nPerformance',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildChartCard(
            'User Engagement',
            'Daily active users by platform',
            SizedBox(
              height: 350,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      // Handle touch
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 4,
                  centerSpaceRadius: 60,
                  sections: _getEngagementDonutData(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, String subtitle, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          chart,
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _getBarChartData() {
    final values = [65, 45, 80, 55, 75, 60, 85, 70, 90, 65, 55, 80];
    
    return values.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value * _animation.value,
            color: Colors.blue,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 100,
              color: Colors.grey.withValues(alpha: 0.1),
            ),
          ),
        ],
      );
    }).toList();
  }

  List<BarChartGroupData> _getWeeklyBarChartData() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(toY: 25, color: Colors.blue, width: 12),
          BarChartRodData(toY: 30, color: Colors.orange, width: 12),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(toY: 35, color: Colors.blue, width: 12),
          BarChartRodData(toY: 28, color: Colors.orange, width: 12),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(toY: 40, color: Colors.blue, width: 12),
          BarChartRodData(toY: 35, color: Colors.orange, width: 12),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(toY: 30, color: Colors.blue, width: 12),
          BarChartRodData(toY: 32, color: Colors.orange, width: 12),
        ],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [
          BarChartRodData(toY: 45, color: Colors.blue, width: 12),
          BarChartRodData(toY: 40, color: Colors.orange, width: 12),
        ],
      ),
      BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(toY: 20, color: Colors.blue, width: 12),
          BarChartRodData(toY: 25, color: Colors.orange, width: 12),
        ],
      ),
      BarChartGroupData(
        x: 6,
        barRods: [
          BarChartRodData(toY: 15, color: Colors.blue, width: 12),
          BarChartRodData(toY: 20, color: Colors.orange, width: 12),
        ],
      ),
    ];
  }

  List<FlSpot> _getLineChartData() {
    final random = math.Random(42); // Fixed seed for consistent data
    final basePrice = 175.0;
    
    return List.generate(31, (index) {
      final variation = (random.nextDouble() - 0.5) * 20;
      final trend = index * 0.5; // Slight upward trend
      return FlSpot(index.toDouble(), basePrice + variation + trend);
    });
  }

  List<PieChartSectionData> _getPieChartData() {
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: 35,
        title: '35%',
        radius: 100,
        titleStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: 28,
        title: '28%',
        radius: 100,
        titleStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 20,
        title: '20%',
        radius: 100,
        titleStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: 12,
        title: '12%',
        radius: 100,
        titleStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.purple,
        value: 5,
        title: '5%',
        radius: 100,
        titleStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  List<PieChartSectionData> _getRevenuePieChartData() {
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: 40,
        title: 'Sales\n40%',
        radius: 60,
        titleStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
        titlePositionPercentageOffset: 0.6,
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 30,
        title: 'Marketing\n30%',
        radius: 60,
        titleStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
        titlePositionPercentageOffset: 0.6,
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: 20,
        title: 'Support\n20%',
        radius: 60,
        titleStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
        titlePositionPercentageOffset: 0.6,
      ),
      PieChartSectionData(
        color: Colors.red,
        value: 10,
        title: 'Others\n10%',
        radius: 60,
        titleStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
        titlePositionPercentageOffset: 0.6,
      ),
    ];
  }

  List<PieChartSectionData> _getDonutChartData() {
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: 30,
        title: '',
        radius: 30,
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 25,
        title: '',
        radius: 30,
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: 20,
        title: '',
        radius: 30,
      ),
      PieChartSectionData(
        color: Colors.red,
        value: 15,
        title: '',
        radius: 30,
      ),
      PieChartSectionData(
        color: Colors.purple,
        value: 10,
        title: '',
        radius: 30,
      ),
    ];
  }

  List<PieChartSectionData> _getEngagementDonutData() {
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: 45,
        title: 'Mobile\n45%',
        radius: 50,
        titleStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 35,
        title: 'Web\n35%',
        radius: 50,
        titleStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: 20,
        title: 'Desktop\n20%',
        radius: 50,
        titleStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
      ),
    ];
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month % 12];
  }
}