//
//  GetReviewsClient.swift
//  CovidWidgetDemo
//
//  Created by araibkarim on 16/07/2020.
//
import Foundation

final class NetworkManager : ObservableObject{
    var isLoading  = false
    private lazy var baseURL: URL = {
        return URL(string: "https://api.covid19api.com/")!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    
    func getStatsBasedOnCountry(name: String , completion: @escaping (Result<[CountryStats], DataResponseError>) -> ()) {
        
        
        if(isLoading){
            return
        }
        let request  = GetStatsRequest.build()
        
       
        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path + name + "/status/confirmed"))
        
        let parameters = ["to" : "2020-07-21", "from":"2020-07-20" ]
      //  print(urlRequest.url?.absoluteString)
        let encodedURLRequest = urlRequest.encode(with: parameters)
        isLoading = true
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            if error != nil {
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.hasSuccessStatusCode,
                    let _ = data
                else {
                    completion(.failure(DataResponseError.network))
                    return
                }
            }
            self.isLoading = false
            let str = String(decoding: data!, as: UTF8.self)
            print(str)
            // successful
            do {
                let countryStatsArray = try JSONDecoder().decode([CountryStats].self, from: data!)
               
                
                
                completion(.success(countryStatsArray))
                
                
            } catch let jsonError {
                //error
                print(jsonError)
                completion(.failure(DataResponseError.decoding))
            }
            
        }).resume()
    }
}
