import Foundation
import ModelsR4

extension Device {
    public var twCore: TWCoreDeviceNamespace {
        get { TWCoreDeviceNamespace(self) }
        set { self = newValue.device }
    }
}

public struct TWCoreDeviceNamespace {
    var device: Device
    public init(_ device: Device) { self.device = device }

    public mutating func declareProfile() {
        TWCoreFHIRModels.declareProfile(TWCoreURL.Profile.device, on: &device.meta)
    }
}

extension Device {
    public func validateTWCore() -> Result<Void, TWCoreValidationError> { .success(()) }
}
