import Foundation

extension Dictionary where Key == AnyHashable, Value == Any {
    func isEqual(to rhs: [String: String]) -> Bool {
        guard count == rhs.count else {
            return false
        }

        for (key, rhsValue) in rhs {
            if let lhsValue = self[key] as? String {
                if lhsValue != rhsValue {
                    return false
                }
            } else {
                return false
            }
        }

        return true
    }
}

extension Dictionary {
    func mergingKeepingCurrent(_ other: Dictionary?) -> Dictionary {
        guard let other else { return self }
        return merging(other) { (current, _) in current }
    }
}
