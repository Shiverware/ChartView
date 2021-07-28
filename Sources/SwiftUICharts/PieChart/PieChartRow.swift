//
//  PieChartRow.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct PieChartRow : View {
  var data: [PieChartData]
  var slices: [PieSlice] {
    var tempSlices:[PieSlice] = []
    var lastEndDeg:Double = 0
    let maxValue = data.map{$0.value}.reduce(0, +)
    for slice in data {
      let normalized:Double = Double(slice.value)/Double(maxValue)
      let startDeg = lastEndDeg
      let endDeg = lastEndDeg + (normalized * 360)
      lastEndDeg = endDeg
      tempSlices.append(PieSlice(startDeg: startDeg, endDeg: endDeg, value: slice.value, normalizedValue: normalized, color: slice.color))
    }
    return tempSlices
  }
  
  public var body: some View {
    GeometryReader { geometry in
      ZStack{
        ForEach(0..<self.slices.count){ i in
          PieChartCell(rect: geometry.frame(in: .local), startDeg: self.slices[i].startDeg, endDeg: self.slices[i].endDeg, index: i, color: self.slices[i].color)
            .animation(Animation.spring())
        }
      }
    }
  }
}

#if DEBUG
struct PieChartRow_Previews : PreviewProvider {
  static var previews: some View {
    Group {
      PieChartRow(data: [PieChartData(value: 56.0, title: "Zone 1", color: Color.red), PieChartData(value: 33.0, title: "Zone 2", color: Color.green), PieChartData(value: 44.0, title: "Zone 3", color: Color.blue), PieChartData(value: 30.0, title: "Zone 4", color: Color.yellow)])
        .frame(width: 100, height: 100)
      PieChartRow(data: [PieChartData(value: 0.0, title: "Zone 1", color: Color.red)])
        .frame(width: 100, height: 100)
    }
  }
}
#endif
