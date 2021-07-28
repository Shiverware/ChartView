//
//  ChartCell.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct BarChartCell : View {
  var value: Double
  var index: Int = 0
  var width: Float
  var numberOfDataPoints: Int
  var cellWidth: Double {
    return Double(width)/(Double(numberOfDataPoints) * 1.5)
  }
  var accentColor: Color
  var gradient: ChartGradientColor?
  
  @State var scaleValue: Double = 0
  
  public var body: some View {
    VStack {
      // If the bar would be "empty" (i.e. right on the bottom of the legend), make it 1 pixel tall to show it is there.
      if scaleValue != 0 {
      RoundedRectangle(cornerRadius: 4)
        .fill(LinearGradient(gradient: gradient?.getGradient() ?? ChartGradientColor(start: accentColor, end: accentColor).getGradient(), startPoint: .bottom, endPoint: .top))
        .scaleEffect(CGSize(width: 1, height: self.scaleValue), anchor: .bottom)
      } else {
        Spacer()
        RoundedRectangle(cornerRadius: 4)
          .fill(LinearGradient(gradient: gradient?.getGradient() ?? ChartGradientColor(start: accentColor, end: accentColor).getGradient(), startPoint: .bottom, endPoint: .top))
          .frame(height: 1)
      }
    }
    .frame(width: CGFloat(self.cellWidth))
    .onAppear(){
      self.scaleValue = self.value
    }
    .animation(Animation.spring().delay(Double(self.index) * 0.004))
  }
}

#if DEBUG
struct ChartCell_Previews : PreviewProvider {
  static var previews: some View {
    BarChartCell(value: Double(0.75), width: 320, numberOfDataPoints: 12, accentColor: ChartColors.OrangeStart, gradient: nil)
  }
}
#endif
