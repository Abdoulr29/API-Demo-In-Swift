//
//  Holiday.swift
//  API Example
//
//  Created by Developer on 12/9/19.
//  Copyright © 2019 TheoryThree Interactive. All rights reserved.
//

import Foundation



struct HolidayResponse: Decodable{
    var response: Holidays
}

struct Holidays: Decodable{
    var holidays: [Holiday]
}

struct Holiday: Decodable{
    var name: String
    var date: DateInfo
}

struct DateInfo: Decodable{
    var iso:String
}
