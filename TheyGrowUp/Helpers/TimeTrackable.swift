//
//  TimeTrackable.swift
//  TheyGrowUp
//
//  Created by Jared Shenson on 10/8/18.
//  Copyright © 2018 Brenda Miao. All rights reserved.
//

import Foundation

protocol TimeTrackable {
    var startTime: Date {get}
    var endTime: Date {get set}
    
    var timeElapsed: TimeInterval {get}
}

extension TimeTrackable {
    
    var timeElapsed: TimeInterval {
        return endTime.timeIntervalSince(startTime)
    }
    
}
