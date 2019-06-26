import UIKit

extension Date {

    static var is24HoursFormat: Bool {
        let dateString = Date.localFormatter.string(from: Date())
        if dateString.contains("AM") || dateString.contains("PM") {
            return false
        }
        return true
    }

    private static let localFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()

    var GMT: Date {
        return addingTimeInterval(-Double(TimeZone.current.secondsFromGMT()))
    }

    var fromGMT: Date {
        return addingTimeInterval(Double(TimeZone.current.secondsFromGMT()))
    }

    static var GMTDifference: Int {
        return TimeZone.current.secondsFromGMT() / 3600
    }

    func dateUsing(format: Format) -> String {
        return Formatter.formatter(using: format).string(from: self)
    }

    var chatTime: String {
        if isToday == true {
            return "\(NSLocalizedString("today_title", comment: "")), \(Formatter.formatter(using: .time).string(from: self))"
        }
        if isYesterday == true {
            return "\(NSLocalizedString("yesterday_title", comment: "")), \(Formatter.formatter(using: .time).string(from: self))"
        }
        return Formatter.formatter(using: .anchor).string(from: self)
    }

    var header: String {
        let unitFlags: NSCalendar.Unit = [.year, .month, .day, .weekday]
        let calendar = Calendar.current
        var comps = defaultComponents(unitFlags, forDate: self)
        let suppliedDate = calendar.date(from: comps)
        for i in -1...6 {
            comps = (calendar as NSCalendar).components(unitFlags, from: Date())
            comps.day = comps.day! - i
            let referenceDate = calendar.date(from: comps)!
            if suppliedDate?.compare(referenceDate) == ComparisonResult.orderedSame && i == -1 {
                return NSLocalizedString("tomorrow_title", comment: "")
            } else if suppliedDate?.compare(referenceDate) == ComparisonResult.orderedSame && i == 0 {
                return NSLocalizedString("today_title", comment: "")
            } else if suppliedDate?.compare(referenceDate) == ComparisonResult.orderedSame && i == 1 {
                return NSLocalizedString("yesterday_title", comment: "")
            }
        }
        return longDate
    }

    var string: String {
        let dateFormatter = Formatter.formatter(using: .time)
        let unitFlags: NSCalendar.Unit = [.year, .month, .day, .weekday]
        let calendar = Calendar.current
        var comps = defaultComponents(unitFlags, forDate: self)
        let suppliedDate = calendar.date(from: comps)
        for i in -1...6 {
            comps = (calendar as NSCalendar).components(unitFlags, from: Date())
            comps.day = comps.day! - i
            let referenceDate = calendar.date(from: comps)!
            if suppliedDate?.compare(referenceDate) == ComparisonResult.orderedSame && i == -1 {
                return String(format: "\(NSLocalizedString("tomorrow_title", comment: "")) %@", dateFormatter.string(from: self))
            } else if suppliedDate?.compare(referenceDate) == ComparisonResult.orderedSame && i == 0 {
                return NSLocalizedString("today_title", comment: "")
            } else if suppliedDate?.compare(referenceDate) == ComparisonResult.orderedSame && i == 1 {
                return String(format: "\(NSLocalizedString("yesterday_title", comment: "")) %@", dateFormatter.string(from: self))
            } else if suppliedDate?.compare(referenceDate) == ComparisonResult.orderedSame {
                return thisWeek
            }
        }
        return longTimeAgo
    }

    var stringAgo: String {
        let dateFormatter = Formatter.formatter(using: .time)
        let unitFlags: NSCalendar.Unit = [.year, .month, .day, .weekday]
        let calendar = Calendar.current
        var comps = defaultComponents(unitFlags, forDate: self)
        let suppliedDate = calendar.date(from: comps)
        for i in -1...6 {
            comps = (calendar as NSCalendar).components(unitFlags, from: Date())
            comps.day = comps.day! - i
            let referenceDate = calendar.date(from: comps)!
            if suppliedDate?.compare(referenceDate) == ComparisonResult.orderedSame && i == -1 {
                return String(format: "%@", NSLocalizedString("tomorrow_at", comment: ""), dateFormatter.string(from: self))
            } else if suppliedDate?.compare(referenceDate) == ComparisonResult.orderedSame && i == 0 {
                return today
            } else if suppliedDate?.compare(referenceDate) == ComparisonResult.orderedSame && i == 1 {
                return thisWeek
            } else if suppliedDate?.compare(referenceDate) == ComparisonResult.orderedSame {
                return thisWeek
            }
        }
        return longTimeAgo
    }

    fileprivate func defaultComponents(_ unitFlags: NSCalendar.Unit, forDate date: Date) -> DateComponents {
        let calendar = Calendar.current
        var comps = (calendar as NSCalendar).components(unitFlags, from: date)
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        return comps
    }

    private var longTimeAgo: String {
        let timeInterval: Int = Int(floor(fabs(self.timeIntervalSinceNow / 86400)))
        if timeInterval < 365 {
            return thisYear
        }
        return notThisYear
    }

    private var today: String {
        let timeInterval: Int = Int(floor(fabs(self.timeIntervalSinceNow / 60)))
        if timeInterval < 60 {
            return timeInterval == 0 ? NSLocalizedString("just_now", comment: "") : String(format: "%@ %@", String.endOfWord(words: [NSLocalizedString("minute_1", comment: ""), NSLocalizedString("minute_2", comment: ""), NSLocalizedString("minute_3", comment: "")], number: timeInterval), NSLocalizedString("time_ago", comment: ""))
        }
        return String(format: "%@ %@", String.endOfWord(words: [NSLocalizedString("hour_1", comment: ""), NSLocalizedString("hour_2", comment: ""), NSLocalizedString("hour_3", comment: "")], number: timeInterval / 60), NSLocalizedString("time_ago", comment: ""))
    }

    private var thisWeek: String {
        let timeInterval: Int = Int(floor(fabs(self.timeIntervalSinceNow / 86400)))
        return String(format: "%@ %@", String.endOfWord(words: [NSLocalizedString("day_1", comment: ""), NSLocalizedString("day_2", comment: ""), NSLocalizedString("day_3", comment: "")], number: timeInterval), NSLocalizedString("time_ago", comment: ""))
    }

    private var thisMonth: String {
        let timeInterval: Int = Int(floor(fabs(self.timeIntervalSinceNow / 86400) / 7))
        return String(format: "%@ %@", String.endOfWord(words: [NSLocalizedString("week_1", comment: ""), NSLocalizedString("week_2", comment: ""), NSLocalizedString("week_3", comment: "")], number: timeInterval), NSLocalizedString("time_ago", comment: ""))
    }

    private var thisYear: String {
        return Formatter.formatter(using: .shortActivity).string(from: self)
    }

    private var notThisYear: String {
        return Formatter.formatter(using: .anchor).string(from: self)
    }

    private  var longDate: String {
        return Formatter.formatter(using: .header).string(from: self)
    }

    var numberOfDaysInCurrentMonth: Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)!
        return range.count
    }

    var fullCurrentYear: Int {
        return Calendar.current.component(.year, from: self)
    }

    var currentYear: Int {
        return Calendar.current.component(.year, from: self) - 2000
    }

    var currentMonth: Int {
        return Calendar.current.component(.month, from: self)
    }

    var day: Int {
        return Calendar.current.dateComponents([.day], from: self).day ?? 1
    }

    var nextHourStart: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.hour, .minute], from: self)
        components.minute = 0
        components.hour = (components.hour ?? 0) + 1
        return calendar.date(from: components) ?? Date()
    }

    var dayStart: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date? {
        return Calendar.current.startOfDay(for: self).addingTimeInterval(86400)
    }

    var zeroSeconds: Date {
        return Date(timeIntervalSinceReferenceDate: floor(timeIntervalSinceReferenceDate / 60) * 60)
    }

    var hour: CGFloat {
        let calendar = Calendar.current
        let hour = calendar.dateComponents([.hour], from: self).hour ?? 0
        if hour == 0 {
            return 24.0
        }
        let minutes = calendar.dateComponents([.minute], from: self).minute ?? 0
        return CGFloat(hour) + CGFloat(minutes) / 60
    }

    var isToday: Bool {
        return isEqual(to: Date())
    }

    private var isTomorrow: Bool {
        return isEqual(to: tomorrowDate!)
    }

    private var isYesterday: Bool {
        return isEqual(to: yesterdayDate!)
    }

    private var tomorrowDate: Date? {
        return Date().date(adding: 1)
    }

    private var yesterdayDate: Date? {
        return Date().date(substract: 1)
    }

    private func date(adding days: Int) -> Date? {
        var components: DateComponents = DateComponents()
        components.day = days
        return Calendar.current.date(byAdding: components, to: self)
    }

    private func date(substract days: Int) -> Date? {
        return date(adding: -days)
    }

    func isEqual(to date: Date) -> Bool {
        let set: Set<Calendar.Component> = [.year, .month, .day]
        let c1: DateComponents = Calendar.current.dateComponents(set, from: date)
        let c2: DateComponents = Calendar.current.dateComponents(set, from: self)
        return c1.year == c2.year && c1.month == c2.month && c1.day == c2.day
    }

    func combineDateWithTime(time: Date) -> Date? {
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!
        return calendar.date(from: mergedComponments)
    }

}
