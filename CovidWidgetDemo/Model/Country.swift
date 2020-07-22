//
//  Country.swift
//  CovidWidgetDemo
//
//  Created by araibkarim on 16/07/2020.
//
import Foundation


struct CountryList: Decodable {
    var results: [Country]
}

struct Country: Decodable, Identifiable {
    var id = UUID()
    var Country: String
    var Slug : String
    var ISO2 : String
    init(Country:  String, Slug: String, ISO2: String) {
        self.Country =  Country;
        self.Slug = Slug
        self.ISO2 = ISO2
    }
}

