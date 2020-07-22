//
//  IntentHandler.swift
//  SelectCountry
//
//  Created by araibkarim on 21/07/2020.
//

import Intents
import SwiftUI
// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, SelectCountryIntentHandling{
    
    func resolveParameter(for intent: SelectCountryIntent, with completion: @escaping (CountriesResolutionResult) -> Void) {
        
    }
    
    func provideParameterOptionsCollection(for intent: SelectCountryIntent, with completion: @escaping (INObjectCollection<Countries>?, Error?) -> Void) {
        
        let viewModel =  ViewModel ()
        if let data  =  viewModel.loadData(){
            
            
            let countries: [Countries] = data.map { country in
                let countryEntry = Countries(
                    identifier: country.Country,
                    display: country.Country
                )
                countryEntry.name = country.Country.lowercased()
                countryEntry.iso =  country.ISO2
                return countryEntry
            }
            
            // Create a collection with the array of characters.
            let collection = INObjectCollection(items: countries)
            
            // Call the completion handler, passing the collection.
            completion(collection, nil)
        }
    }
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    // MARK: - INSendMessageIntentHandling
    
    // Implement resolution methods to provide additional information about your intent (optional).
    func resolveRecipients(for intent: INSendMessageIntent, with completion: @escaping ([INSendMessageRecipientResolutionResult]) -> Void) {
        if let recipients = intent.recipients {
            
            // If no recipients were provided we'll need to prompt for a value.
            if recipients.count == 0 {
                completion([INSendMessageRecipientResolutionResult.needsValue()])
                return
            }
            
            var resolutionResults = [INSendMessageRecipientResolutionResult]()
            for recipient in recipients {
                let matchingContacts = [recipient] // Implement your contact matching logic here to create an array of matching contacts
                switch matchingContacts.count {
                case 2  ... Int.max:
                    // We need Siri's help to ask user to pick one from the matches.
                    resolutionResults += [INSendMessageRecipientResolutionResult.disambiguation(with: matchingContacts)]
                    
                case 1:
                    // We have exactly one matching contact
                    resolutionResults += [INSendMessageRecipientResolutionResult.success(with: recipient)]
                    
                case 0:
                    // We have no contacts matching the description provided
                    resolutionResults += [INSendMessageRecipientResolutionResult.unsupported()]
                    
                default:
                    break
                    
                }
            }
            completion(resolutionResults)
        }
    }
    
    func resolveContent(for intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let text = intent.content, !text.isEmpty {
            completion(INStringResolutionResult.success(with: text))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    
    
}
