import Foundation
import ModelsR4

extension Goal {
    public var twCore: TWCoreGoalNamespace {
        get { TWCoreGoalNamespace(self) }
        set { self = newValue.goal }
    }
}

public struct TWCoreGoalNamespace {
    var goal: Goal
    public init(_ goal: Goal) { self.goal = goal }

    public func identifier(system: String) -> String? {
        goal.identifier?.first { $0.system?.absoluteString == system }?.value?.value?.string
    }

    public mutating func setIdentifier(_ value: String?, system: String) {
        if let value {
            let newId = makeIdentifier(value: value, system: system, typeCode: "FILL", typeText: "目標識別碼")
            if let idx = goal.identifier?.firstIndex(where: { $0.system?.absoluteString == system }) {
                goal.identifier?[idx] = newId
            } else {
                if goal.identifier == nil { goal.identifier = [newId] }
                else { goal.identifier?.append(newId) }
            }
        } else {
            goal.identifier?.removeAll { $0.system?.absoluteString == system }
        }
    }

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.goal, on: &goal.meta)
    }
}

extension Goal {
    public func validateTWCore() -> Result<Void, TWCoreValidationError> { .success(()) }
}
