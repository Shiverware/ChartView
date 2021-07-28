//
//  ChartView.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct BarChartView : View {
  @Environment(\.colorScheme) var colorScheme: ColorScheme
  private var data: ChartData
  public var title: String?
  public var subtitle: String?
  public var style: ChartStyle
  public var darkModeStyle: ChartStyle
  public var dropShadow: Bool
  public var valueSpecifier:String
  public var legendSpecifier: String
  public var showLegend: Bool
  public var animatedToBack: Bool
  
  public init(data: ChartData,
              title: String? = nil,
              subtitle: String? = nil,
              showLegend: Bool = true,
              style: ChartStyle = Styles.barChartStyleOrangeLight,
              dropShadow: Bool = true,
              valueSpecifier: String = "%.1f",
              legendSpecifier: String = "%.2f",
              animatedToBack: Bool = false){
    self.data = data
    self.title = title
    self.subtitle = subtitle
    self.showLegend = showLegend
    self.style = style
    self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.barChartStyleOrangeDark
    self.dropShadow = dropShadow
    self.valueSpecifier = valueSpecifier
    self.legendSpecifier = legendSpecifier
    self.animatedToBack = animatedToBack
  }
  
  var minValue: Double {
    return 0 //data.points.map({ $0.1 }).min() ?? 0
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      if let title = self.title {
        Text(title)
          .font(.headline)
          .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.textColor : self.style.textColor)
      }
      
      if let legend = self.subtitle {
        Text(legend)
          .font(.callout)
          .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.legendTextColor : self.style.legendTextColor)
      }
      
      ZStack {
        GeometryReader { reader in
          if self.showLegend {
            Legend(
              data: data,
              frame: .constant(reader.frame(in: .local)),
              hideHorizontalLines: .constant(false),
              specifier: legendSpecifier
            )
              .transition(.opacity)
              .animation(Animation.easeOut(duration: 1).delay(1))
          }
          
          BarChartRow(
            data: data.onlyPoints(), // map({ $0.1 - abs(self.minValue) }),
            accentColor: self.colorScheme == .dark ? self.darkModeStyle.accentColor : self.style.accentColor,
            gradient: self.colorScheme == .dark ? self.darkModeStyle.gradientColor : self.style.gradientColor
          )
          .padding(.leading, showLegend ? 35 : 0)
        }
      }
      .padding(.vertical, 10) // So top/bottom legend numbers can't get cut off
      .background(
        Rectangle()
          .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.backgroundColor : self.style.backgroundColor)
      )
    }
  }
}

#if DEBUG
struct ChartView_Previews : PreviewProvider {
  static let testData = ChartData(values: [
    ("1",1),
    ("2",2),
    ("3",3),
    ("4",4),
    ("5",5)
  ])
  
  static var previews: some View {
    Group {
      VStack {
        Spacer()
        
        BarChartView(data: ChartView_Previews.testData,
                     title: nil,
                     subtitle: nil,
                     valueSpecifier: "%.2f")
          .frame(width: 300.0, height: 300.0)
        
        Spacer()
      }
    }
    .background(Color.gray)
    .previewLayout(.fixed(width: 375, height: 600))
  }
}
#endif
