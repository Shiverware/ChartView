//
//  PieChartView.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct PieChartData: Identifiable {
  public var id = UUID()
  public var value: Double
  public var title: String
  public var color: Color
  
  public init (value: Double, title: String, color: Color) {
    self.value = value
    self.title = title
    self.color = color
  }
}

public struct PieChartView : View {
  public var data: [PieChartData]
  public var title: String?
  public var legend: String?
  public var style: ChartStyle
  public var dropShadow: Bool
  public var valueSpecifier:String
  
  public init(data: [PieChartData], title: String? = nil, legend: String? = nil, style: ChartStyle = Styles.pieChartStyleOne, dropShadow: Bool = true, valueSpecifier: String = "%.1f"){
    self.data = data
    self.title = title
    self.legend = legend
    self.style = style
    self.dropShadow = dropShadow
    self.valueSpecifier = valueSpecifier
  }
  
  public var body: some View {
    ZStack{
      VStack(alignment: .leading) {
        if let title = self.title {
          Text(title)
            .font(.headline)
            .foregroundColor(self.style.textColor)
        }
        if let legend = self.legend {
          Text(legend)
            .font(.headline)
            .foregroundColor(self.style.legendTextColor)
        }
        
        HStack {
          PieChartRow(data: data)
            .padding(self.legend != nil ? 0 : 12)
            .offset(y: self.legend != nil ? 0 : -10)
          
          VStack {
            ForEach(self.data) { data in
              HStack {
                Circle()
                  .fill(data.color)
                  .frame(width: 10, height: 10)
                
                Text(data.title)
              }
            }
          }
        }
      }
    }
  }
}

#if DEBUG
struct PieChartView_Previews : PreviewProvider {
  static var previews: some View {
    let pieChartData = [PieChartData(value: 56.0, title: "Zone 1", color: Color.red), PieChartData(value: 33.0, title: "Zone 2", color: Color.green), PieChartData(value: 44.0, title: "Zone 3", color: Color.blue), PieChartData(value: 30.0, title: "Zone 4", color: Color.yellow)]
    
    PieChartView(data: pieChartData, title: "Title", legend: "Legend")
  }
}
#endif
