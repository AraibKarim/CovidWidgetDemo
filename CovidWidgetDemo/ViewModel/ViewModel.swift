//
//  ViewModel.swift
//  CovidWidgetDemo
//
//  Created by Araib on 23/07/2020.
//

import Foundation

class ViewModel {
    func loadData () -> [Country]?{
        guard let dataFromFile = self.readLocalFile (forName: "countries") else {
           
            return nil
        }
        
        if let countries = parse(jsonData: dataFromFile) {
             return countries
        }else{
            return nil
        }
    }
    

    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    private func parse(jsonData: Data)  -> [Country]?{
        do {
            let countriesData = try JSONDecoder().decode([[String : String]].self, from: jsonData)
            var allCountries = [Country] ()
            for dictionary in countriesData {
                let countryName = dictionary["Country"] ??  ""
                let Slug = dictionary["Slug"] ?? ""
                let ISO2 = dictionary["ISO2"] ?? ""
                let country = Country(Country:  countryName, Slug: Slug, ISO2: ISO2)
                
                
                allCountries.append(country)
            }
            allCountries.sort { country1, country2 -> Bool in
                country1.Country < country2.Country
            }
            
            return allCountries
           
        } catch {
            print("decode error")
            return nil
        }
    }
}
