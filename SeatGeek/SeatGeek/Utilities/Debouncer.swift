//
//  Debouncer.swift
//  SeatGeek
//
//  Created by Rahul Dubey on 10/25/20.
//  Copyright © 2020 com.seatgeek.org. All rights reserved.
//

import Foundation

// Dispatch a work item after certain time.

// This is usually done to throttle the keyword search so if the user type SEAT GEEK so fast he is intersted in the full keywords instead of each individual keywords.

public class Debouncer {
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?

    public init(delay: TimeInterval) {
        self.delay = delay
    }

    /// Trigger the action after some delay
    public func dispatchDebounce(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem!)
    }
    
    public func cancelWorkItem() {
        workItem?.cancel()
    }
}
