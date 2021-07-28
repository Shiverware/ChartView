//
//  LineView.swift
//  LineChart
//
//  Created by András Samu on 2019. 09. 02..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct LineChartView: View {
  @ObservedObject var data: ChartData
  
  public var title: String?
  public var subtitle: String?
  public var style: ChartStyle
  public var darkModeStyle: ChartStyle
  public var valueSpecifier: String
  public var legendSpecifier: String
  public var showLegend: Bool
  
  @Environment(\.colorScheme) var colorScheme: ColorScheme
  @State private var dragLocation: CGPoint = .zero
  @State private var indicatorLocation: CGPoint = .zero
  @State private var closestPoint: CGPoint = .zero
  @State private var opacity: Double = 0
  @State private var currentDataNumber: Double = 0
  @State private var hideHorizontalLines: Bool = false
  
  public init(data: [Double],
              title: String? = nil,
              subtitle: String? = nil,
              showLegend: Bool = true,
              style: ChartStyle = Styles.lineChartStyleOne,
              valueSpecifier: String = "%.1f",
              legendSpecifier: String = "%.2f") {
    
    self.data = ChartData(points: data)
    self.title = title
    self.subtitle = subtitle
    self.showLegend = showLegend
    self.style = style
    self.valueSpecifier = valueSpecifier
    self.legendSpecifier = legendSpecifier
    self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
  }
  
  public var body: some View {
    GeometryReader{ geometry in
      VStack(alignment: .leading, spacing: 8) {
        if let title = self.title {
          Text(title)
            .font(.title)
            .bold()
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
                data: self.data,
                frame: .constant(reader.frame(in: .local)),
                hideHorizontalLines: self.$hideHorizontalLines,
                specifier: legendSpecifier
              )
                .transition(.opacity)
                .animation(Animation.easeOut(duration: 1).delay(1))
            }
            
            Line(
              data: self.data,
              frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width - 30, height: reader.frame(in: .local).height + 25)),
              touchLocation: self.$indicatorLocation,
              showIndicator: self.$hideHorizontalLines,
              minDataValue: .constant(nil),
              maxDataValue: .constant(nil),
              showBackground: true,
              gradient: self.style.gradientColor
            )
              .padding(.leading, showLegend ? 35 : 0)
          }
        }
        .frame(width: geometry.frame(in: .local).size.width)
        .padding(.vertical, 10) // So top/bottom legend numbers can't get cut off
        .background(
          self.colorScheme == .dark ? self.darkModeStyle.backgroundColor : self.style.backgroundColor
        )
        .clipped()
      }
    }
  }
  
  func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
    let points = self.data.onlyPoints()
    let stepWidth: CGFloat = width / CGFloat(points.count-1)
    let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
    
    let index:Int = Int(floor((toPoint.x-15)/stepWidth))
    if (index >= 0 && index < points.count){
      self.currentDataNumber = points[index]
      return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
    }
    return .zero
  }
}

struct LineView_Previews: PreviewProvider {
  static let chartStyle = ChartStyle(
    backgroundColor: Color.white,
    accentColor: Color.green,
    gradientColor: .init(start: Color.purple, end: Color.blue),
    textColor: Color.black,
    legendTextColor: Color.gray,
    dropShadowColor: Color.black.opacity(0.3)
  )
  
  static var previews: some View {
    
    Group {
      VStack {
        Spacer()
        
        LineChartView(data: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], style: LineView_Previews.chartStyle)
          .frame(width: 300.0, height: 300.0)
          .background(Color.yellow)
        
        Spacer()
      }
      .background(Color.gray)
      .previewLayout(.fixed(width: 375, height: 600))
      
      LineChartView(data: [282.502, 284.495, 283.51, 285.019, 285.197, 286.118, 288.737, 288.455, 289.391, 287.691, 285.878, 286.46, 286.252, 284.652, 284.129, 284.188], title: "Full chart", style: Styles.lineChartStyleOne)
    }
  }
}
