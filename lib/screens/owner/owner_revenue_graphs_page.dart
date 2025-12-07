import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OwnerRevenueGraphsPage extends StatelessWidget {
  const OwnerRevenueGraphsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = <_RevenuePoint>[
      _RevenuePoint('Mon', 12),
      _RevenuePoint('Tue', 9.8),
      _RevenuePoint('Wed', 15),
      _RevenuePoint('Thu', 13),
      _RevenuePoint('Fri', 17),
      _RevenuePoint('Sat', 21),
      _RevenuePoint('Sun', 14),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Revenue Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'As highlighted in section 6.2.3 of the report, owners compare revenue across daily, weekly and monthly views. The sample chart demonstrates how data would render.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: data
                      .asMap()
                      .entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.value,
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(6),
                              width: 18,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                  titlesData: FlTitlesData(
                    leftTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= data.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(data[index].label),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RevenuePoint {
  _RevenuePoint(this.label, this.value);
  final String label;
  final double value;
}

