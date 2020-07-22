//
//  CovidWidget.swift
//  CovidWidget
//
//  Created by araibkarim on 16/07/2020.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct CovidWidget: Widget {
    private let kind: String = "CovidWidget"
   
    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectCountryIntent.self, provider: Provider(), placeholder: PlaceholderView()) { entry in
            
      
            CovidWidgetEntryView(entry: entry)
          
        }
        .configurationDisplayName("Covid Widget")
        .description("Shows covid stats per country.")
    }
}



struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry
    let AppGroup  = "group.WoodyApps.CovidWidgetDemo"
    let networkManager = NetworkManager()
    public func snapshot(for configuration: SelectCountryIntent, with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let data = covidStats(total: "0", country: "N.A", new: "0", iso: "")
       
        let entry = Entry(date: Date(), configuration: configuration, data: data)
        completion(entry)
    }

    public func timeline(for configuration: SelectCountryIntent, with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
       
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!

        let userDefaults = UserDefaults(suiteName: AppGroup)
        var countryName = userDefaults?.string(forKey: "selectedCountryName") ?? "pakistan"
        
        var iso = userDefaults?.string(forKey: "selectedCountryNameIso") ?? "PK"
        if let name = configuration.parameter?.name {
           countryName = name
            userDefaults?.setValue(countryName, forKey: "selectedCountryName")
            userDefaults?.synchronize()
        }
        
        if let isoSelection = configuration.parameter?.iso {
            iso = isoSelection
        }
       
        networkManager.getStatsBasedOnCountry(name : countryName) {
            result in
            
            switch result{
            case .failure(let error):
                
                let timeline = Timeline(entries: [emptyEntry(configuration: configuration)], policy: .after(refreshDate))
                completion(timeline)
            case .success(let response):
                
                if response.count ==  2 {
                    let lastDayStats = response[0]
                    let todayStats = response[1]
                    
                    let totalcases = todayStats.Cases
                    let newCases = todayStats.Cases -  lastDayStats.Cases
                    
                    let data = covidStats(total: "\(totalcases)", country: lastDayStats.Country, new: "\(newCases)", iso: iso)
                   
                    let entry = Entry(date: Date(), configuration: configuration, data: data)
                    
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                }else {
                    //incorrect json
                    print("incorrect json")
                    let timeline = Timeline(entries: [emptyEntry(configuration: configuration)], policy: .after(refreshDate))
                    completion(timeline)
                }
            }
        }
        
        
    }
    
    func emptyEntry (configuration: SelectCountryIntent) -> Entry{
        let data = covidStats(total: "0", country: "N.A", new: "0", iso: "")
       
        let entry = Entry(date: Date(), configuration: configuration, data: data)
       return entry
    }
}

struct covidStats {
    let total : String
    let country : String
    let new : String
    let iso : String
}
struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let configuration: SelectCountryIntent
    public let data: covidStats
   
    var relevance: TimelineEntryRelevance? {
        
        return TimelineEntryRelevance(score: 100) // 0 - not important | 100 - very important
    }
}

struct PlaceholderView : View {
    let grey =  UIColor(rgb: 0x2C3E50)
   
    var body: some View {
        HStack {
            Text("Loading...")
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
            .padding()
        .background(Color(grey))
        
    }
}

struct CovidWidgetEntryView : View {
    let entry: SimpleEntry
    
    var body: some View {
       let grey =  UIColor(rgb: 0x2C3E50)
        let green =  UIColor(rgb: 0x2ECC71)
        let red =  UIColor(rgb: 0xE74C3C)
        let textColor =  UIColor(rgb: 0x9598A1)
        
        
        
        let viewToReturn = VStack(alignment: .leading, spacing: 4) {
            
            
            HStack (alignment: .bottom) {
               
                Text("Covid Stats")
                    .font(.system(size: 12, weight: .semibold, design:.rounded))
                    .foregroundColor(Color (green))
               
            }
            Divider()
            HStack (alignment: .bottom) {
               
                Text("" + entry.data.country + " " + flag(country: entry.data.iso))
                    .font(.system(size: 15, weight: .semibold, design:.rounded))
                    .foregroundColor(.white)
               
            }
          
           
                
            
            VStack(alignment: .leading, spacing: 4){
                
                Text("Total: " + entry.data.total)
                   .font(.system(size: 13, weight: .semibold, design:.rounded))
                    .foregroundColor(Color (textColor))
                    .bold()
               
                Text("New: " +  entry.data.new)
                   .font(.system(size: 15, weight: .semibold, design:.rounded))
                    .foregroundColor(Color(red))
               
               
            }
            HStack(spacing: 4) {
                Spacer()
                Image("covid")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .leading)
                
            }
           

        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
            .padding()
        .background(Color(grey))
        return AnyView(viewToReturn)
    }
    func flag(country:String) -> String {
        if country == "" {
            return ""
        }
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}


struct CovidWidget_Previews: PreviewProvider {
    static var previews: some View {
        let data = covidStats(total: "0", country: "N.A", new: "0", iso: "")
       
       
        CovidWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: SelectCountryIntent(), data: data))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
