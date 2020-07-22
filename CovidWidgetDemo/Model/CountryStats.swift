//
//  CountryStats.swift
//  CovidWidgetDemo
//
//  Created by araibkarim on 22/07/2020.
//

import Foundation

struct CountryStats : Decodable {
    let Country : String
    let CountryCode : String
    let Province : String
    let City : String
    let CityCode : String
    let Lat : String
    let Lon : String
    let Cases : Int
    let Status : String
    let Date : String
}
