//
//  PeriodFilter.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 09.01.2024.
//

import Foundation

enum PeriodFilter: CaseIterable {
    case last7days
    case month
    case year
    case overall
    
    var title: String {
        switch self {
        case .last7days: return String(localized: "picker_last7days")
        case .month: return String(localized: "picker_month")
        case .year: return String(localized: "picker_year")
        case .overall: return String(localized: "picker_overall")
        }
    }
    
    func periodDates() -> DateInterval? {
        switch self {
        case .last7days:
            guard let startDay = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else { return nil }
            return DateInterval(start: startDay, end: Date())
        case .month:
            let currentYear = Calendar.current.component(.year, from: Date())
            let currentMonth = Calendar.current.component(.month, from: Date())
            let monthComponents = DateComponents(year: currentYear, month: currentMonth, day: 1)
            guard let startDay = Calendar.current.date(from: monthComponents) else { return nil }
            return DateInterval(start: startDay, end: Date())
        case .year:
            let currentYear = Calendar.current.component(.year, from: Date())
            let yearComponents = DateComponents(year: currentYear, month: 1, day: 1)
            guard let startDay = Calendar.current.date(from: yearComponents) else { return nil }
            return DateInterval(start: startDay, end: Date())
        case .overall:
            return nil
        }
    }
}

