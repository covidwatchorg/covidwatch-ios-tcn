//
//  IsWithinXDaysOfToday.swift
//  COVIDWatch iOS
//
//  Created by Isaiah Becker-Mayer on 4/14/20.
//  Copyright © 2020 IZE. All rights reserved.
//

import Foundation

func isDWithinXDaysOfToday(D: Date, X: Int) -> Bool {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())

    let components = calendar.dateComponents([.day], from: D, to: today)
    if let numDays = components.day {
        if numDays <= X {
            return true
        } else {
            return false
        }
    }
    return false // Should not reach here
}
