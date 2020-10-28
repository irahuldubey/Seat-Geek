//
//  SGAlertAction.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/25/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation
import UIKit

protocol SGAlertAction {
  func displayAlert(with title: String, message: String, actions: [UIAlertAction]?)
}

extension SGAlertAction where Self: UIViewController {
  func displayAlert(with title: String, message: String, actions: [UIAlertAction]? = nil) {
    guard presentedViewController == nil else {
      return
    }
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    actions?.forEach { action in
      alertController.addAction(action)
    } 
    present(alertController, animated: true)
  }
}
