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

struct CustomColors {
    static let searchBarBackgroundColor = UIColor(red: 15.0/255.0, green: 36.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    static let searchBarTextBackgroundColor = UIColor(red: 31.0/255.0, green: 54.0/255.0, blue: 70.0/255.0, alpha: 1.0)
}

