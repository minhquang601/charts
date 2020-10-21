// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// Example of an ordinal combo chart with two series rendered as bars, and a
/// third rendered as a line.
// EXCLUDE_FROM_GALLERY_DOCS_START
import 'dart:math';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_common/common.dart' as common
    show ChartBehavior, SelectNearest, SelectionModelType, SelectionTrigger;

class OrdinalComboBarLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final charts.CallbackTapChart callbackTapChart;

  OrdinalComboBarLineChart(this.seriesList, {this.animate, this.callbackTapChart});

  factory OrdinalComboBarLineChart.withSampleData() {
    return new OrdinalComboBarLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  // EXCLUDE_FROM_GALLERY_DOCS_START
  // This section is excluded from being copied to the gallery.
  // It is used for creating random series data to demonstrate animation in
  // the example app only.
  factory OrdinalComboBarLineChart.withRandomData() {
    return new OrdinalComboBarLineChart(_createRandomData());
  }

  /// Create random data.
  static List<charts.Series<OrdinalSales1, String>> _createRandomData() {
    final random = new Random();

    final desktopSalesData = [
      new OrdinalSales1('2014', random.nextInt(100)),
      new OrdinalSales1('2015', random.nextInt(100)),
      new OrdinalSales1('2016', random.nextInt(100)),
      new OrdinalSales1('2017', random.nextInt(100)),
    ];
    final mobileSalesData = [
      new OrdinalSales1('2014', random.nextInt(100)),
      new OrdinalSales1('2015', random.nextInt(100)),
      new OrdinalSales1('2016', random.nextInt(100)),
      new OrdinalSales1('2017', random.nextInt(100)),
    ];

    return [
      new charts.Series<OrdinalSales1, String>(
          id: 'Desktop',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (OrdinalSales1 sales, _) => sales.year,
          measureFn: (OrdinalSales1 sales, _) => sales.sales,
          data: desktopSalesData),
      new charts.Series<OrdinalSales1, String>(
        id: 'Mobile',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (OrdinalSales1 sales, _) => sales.year,
        measureFn: (OrdinalSales1 sales, _) => sales.sales,
        data: mobileSalesData,
      )
        // Configure our custom line renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customLine'),
    ];
  }
  // EXCLUDE_FROM_GALLERY_DOCS_END

  @override
  Widget build(BuildContext context) {
    return new charts.OrdinalComboChart(seriesList,
        animate: animate,
        // Configure the default renderer as a bar renderer.
        defaultRenderer: new charts.BarRendererConfig(
            groupingType: charts.BarGroupingType.grouped),
        // Custom renderer configuration for the line series. This will be used for
        // any series that does not define a rendererIdKey.
        customSeriesRenderers: [
          new charts.LineRendererConfig(
              // ID used to link series to this renderer.
              customRendererId: 'customLine',
              includePoints: true)
        ],
        behaviors: [
          // Optional - Configures a [LinePointHighlighter] behavior with a
          // vertical follow line. A vertical follow line is included by
          // default, but is shown here as an example configuration.
          //
          // By default, the line has default dash pattern of [1,3]. This can be
          // set by providing a [dashPattern] or it can be turned off by passing in
          // an empty list. An empty list is necessary because passing in a null
          // value will be treated the same as not passing in a value at all.
          new charts.LinePointHighlighter(
            // callbackTapChart: callbackTapChart,
            callbackTapChart: (index,datas) {
              print((datas[0].point.datum as OrdinalSales1).sales);
              print((datas[0].point.datum as OrdinalSales1).year);
            },
          ),
          charts.SelectNearest(
            eventTrigger: charts.SelectionTrigger.tap,
          ),
        ]);
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales1, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales1('2014', 5),
      new OrdinalSales1('2015', 25),
      new OrdinalSales1('2016', 100),
      new OrdinalSales1('2017', 75),
    ];

    final mobileSalesData = [
      new OrdinalSales1('2014', 10),
      new OrdinalSales1('2015', 50),
      new OrdinalSales1('2016', 200),
      new OrdinalSales1('2017', 150),
    ];

    return [
      new charts.Series<OrdinalSales1, String>(
          id: 'Desktop',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (OrdinalSales1 sales, _) => sales.year,
          measureFn: (OrdinalSales1 sales, _) => sales.sales,
          data: desktopSalesData),
      new charts.Series<OrdinalSales1, String>(
          id: 'Mobile ',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (OrdinalSales1 sales, _) => sales.year,
          measureFn: (OrdinalSales1 sales, _) => sales.sales,
          data: mobileSalesData)
        // Configure our custom line renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customLine'),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales1 {
  final String year;
  final int sales;

  OrdinalSales1(this.year, this.sales);
}
