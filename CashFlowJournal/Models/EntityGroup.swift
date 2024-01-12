//
//  EntityGroup.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 11.01.2024.
//

import Foundation
import SwiftData

protocol EntityGroup: AnyObject {
    var name: String { get set }
    init(name: String)
}

@Model
class AccountGroup: EntityGroup {
    @Attribute(.unique) var name: String
    
    required init(name: String) {
        self.name = name
    }
}

@Model
class CategoryGroup: EntityGroup {
    @Attribute(.unique) var name: String
    
    required init(name: String) {
        self.name = name
    }
}
