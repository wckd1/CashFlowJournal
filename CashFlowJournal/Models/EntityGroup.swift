//
//  EntityGroup.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 11.01.2024.
//

import Foundation
import SwiftData

@Model
class EntityGroup {
    @Attribute(.unique) var name: String
    
    init(name: String) {
        self.name = name
    }
}
