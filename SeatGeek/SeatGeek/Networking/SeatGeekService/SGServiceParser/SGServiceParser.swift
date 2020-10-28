//
//  SGServiceParser.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/25/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

final class SGServiceParser {
    
    private static var jsonDecoder: JSONDecoder = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }()
    
    static func parseSWServiceError(from error: Error) -> SGServiceError {
        let nsError = error as NSError
        return SGServiceError.init(with: nsError.code, errorDescription: nsError.localizedDescription)
    }
    
    static func parseEventsJSON(data: Data) -> SGResponse? {
        do {
            let responseEvents = try SGServiceParser.jsonDecoder.decode(SGResponse.self, from: data)
            return responseEvents
        } catch {
            print(error)
            return nil
        }
    }
    
    static func parseEventJSON(data: Data) -> SGEvent? {
           do {
               let responseEvents = try SGServiceParser.jsonDecoder.decode(SGEvent.self, from: data)
               return responseEvents
           } catch {
               print(error)
               return nil
           }
       }
}
