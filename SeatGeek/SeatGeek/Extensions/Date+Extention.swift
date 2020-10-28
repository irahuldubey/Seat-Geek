//
//  Date+Extention.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/26/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

extension Date {
    
    static func formatDateDisplayValueFrom(string :String) -> Date? {
        guard !string.isEmpty else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: string) {
            return date
        }
        return nil
    }
    
    func formatInDayMonthYearValue() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm a"
        return dateFormatter.string(from: self)
    }
}
