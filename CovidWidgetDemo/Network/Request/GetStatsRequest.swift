//
//  ReviewRequest.swift
//  CovidWidgetDemo
//
//  Created by araibkarim on 16/07/2020.
//

import Foundation


struct GetStatsRequest {
  var path: String {
    return "total/country/"
  }
  
  let parameters: Parameters
  private init(parameters: Parameters) {
    self.parameters = parameters
  }
}

extension GetStatsRequest {
  static func build() -> GetStatsRequest {
     //can add any default parameters here.
     let parameters : Parameters = Parameters()
     return GetStatsRequest(parameters: parameters)
  }
}
