//
//  EventModel.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/25/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

// Model what is needed for the UI
public struct EventModel {
    let identifier: String
    let title: String
    let shortTitle: String
    let location: String
    let date: String
    let imageUrl: String
    let isFavorite: Bool
}
