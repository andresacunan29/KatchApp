//
//  Item.swift
//  KatchApp
//
//  Created by Andres Acuna on 8/12/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
