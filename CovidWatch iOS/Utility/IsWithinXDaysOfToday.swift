//
//  IsWithinXDaysOfToday.swift
//  CovidWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/14/20.
//  
//

import Foundation

func isDWithinXDaysOfToday(D: Date, X: Int) -> Bool {
    let calendar = Calendar.current
    let now = Date()

    let components = calendar.dateComponents([.day], from: D, to: now)
    if let numDays = components.day {
        if numDays <= X {
            return true
        } else {
            return false
        }
    }
    return false // Should not reach here
}
