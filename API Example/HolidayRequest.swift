//
//  HolidayRequest.swift
//  API Example
//
//  Created by Developer on 12/9/19.
//  Copyright © 2019 TheoryThree Interactive. All rights reserved.
//

import Foundation


enum HolidayError: Error{
    case noDataAvailable
    case canNoteProcessData
}


struct HolidayRequest{
    let resourceURL:URL
    
    init(countryCode:String){
        let year = Calendar.current.component(.year, from: Date())
        let resourceString = "\(BASE_URL)holidays?api_key=\(API_KEY)&year=\(year)&country=\(countryCode)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    
    func getHolidays(completion: @escaping(Result< [Holiday], HolidayError> ) -> Void){
        let dataTask = URLSession.shared.dataTask(with: resourceURL){(data, response,error) in
            
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200{
                    print("everything is ok")
                    
                }
                
                if httpResponse.statusCode == 201{
                    print("one row was created")
                }
                
                if httpResponse.statusCode >= 400 && httpResponse.statusCode < 500 {
                    print("error on the client side")
                }
                
                if httpResponse.statusCode >= 500  {
                    print("error on the server side")
                }
                
            }
            
            
            guard let jsonData = data else {
                completion(.failure(HolidayError.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let holidayResponse = try decoder.decode(HolidayResponse.self, from: jsonData)
                let holidays = holidayResponse.response.holidays
                completion(.success(holidays))
                
                guard let userDefault = (UserDefaults.standard.string(forKey: "token")) else {return}
                print(" *********** \(userDefault)")
            }catch{
                completion(.failure(HolidayError.canNoteProcessData))
            }
        }
        dataTask.resume()
    }
    
    let tokenIdentifier = "TokenIdentifier"
    func storeAccessToken(token: String) {
        UserDefaults.standard.set(token, forKey: tokenIdentifier)
    }
    
    func checkUserLogin() {
        if UserDefaults.standard.value(forKey: tokenIdentifier) != nil {
            print("User is Login")
            
        }
        else {
            print("User need to login")
        }
    }
    
}
