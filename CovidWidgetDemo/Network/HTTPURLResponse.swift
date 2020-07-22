//
//  HTTPURLResponse.swift
//  CovidWidgetDemo
//
//  Created by araibkarim on 16/07/2020.
//

import Foundation




extension HTTPURLResponse {
  var hasSuccessStatusCode: Bool {
    return 200...299 ~= statusCode
  }
}
