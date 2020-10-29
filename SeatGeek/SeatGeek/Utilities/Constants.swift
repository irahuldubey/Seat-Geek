//
//  Constants.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/25/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Segue Identifiers
struct SegueIdentifiers {
  static let detail = "DetailViewControllerSegue"
}

//MARK: - Reuse Identifiers
struct ReuseIdentifiers {
  static let searchResultsCell = "cellIdentifier"
}

//MARK: - Message Strings
struct Message {
  static let alert = "Search Result Error"
  static let detailsAlert = "Unable to fetch event details"
  static let ok = "OK"
  static let beginSearch = "Let's begin search"
  static let noResult = "No Result Found"
  static let searchPlaceholder = "Search for seat geek event"
  static let errorMessage = "Could not load Characters"
}

//MARK: - Navigationitem Identifers
struct NavigationItemIdentifier {
  static let clear = "Clear"
}
