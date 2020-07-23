//
//  ContentView.swift
//  CovidWidgetDemo
//
//  Created by araibkarim on 16/07/2020.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @ObservedObject var networkManager = NetworkManager()
    
    @State var countries: [Country] = []
    @State var isLoading: Bool = false
    @State var selectedCountryName: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    
    let viewModel = ViewModel ()
    
    

    var allCountries : Data = Data()
    let AppGroup  = "group.WoodyApps.CovidWidgetDemo"
    var body: some View {
        NavigationView() {
            VStack {
                
                if isLoading {
                    Text("Loading ...")
                } else {
                    List(countries) { country in
                        Button(action: {
                            selectedCountryName = country.Country.lowercased()
                            let iso = country.ISO2
                            
                            let userDefaults = UserDefaults(suiteName: AppGroup)
                            userDefaults?.setValue(selectedCountryName, forKey: "selectedCountryName")
                            
                            userDefaults?.setValue(iso, forKey: "selectedCountryNameIso")
                            userDefaults?.synchronize()
                             WidgetCenter.shared.reloadAllTimelines()
                        }) {
                            HStack {
                                Text(country.Country)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                                    .padding()
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    
                                
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Select Country")).foregroundColor(.black)
        }
        .onAppear(perform: loadData)
    }
    
    func loadData (){
        if let countries =  viewModel.loadData () {
            self.countries = countries
        }
       
    }
    

   
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
