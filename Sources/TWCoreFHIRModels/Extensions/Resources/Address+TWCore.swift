import Foundation
import ModelsR4

// MARK: - Namespace 注入

extension Address {
    public var twCore: TWCoreAddressNamespace {
        get { TWCoreAddressNamespace(self) }
        set { self = newValue.address }
    }
}

// MARK: - TWCoreAddressNamespace

/// 台灣地址細部元素讀寫介面
///
/// 台灣地址格式（由大到小）：
/// 縣市（city）> 鄉鎮市區（district）> 村里（village）> 鄰（neighborhood）>
/// 路段（line）> 段（section）> 巷（lane）> 弄（alley）> 號（number）> 樓（floor）> 室（room）
public struct TWCoreAddressNamespace {

    var address: Address

    public init(_ address: Address) {
        self.address = address
    }

    // MARK: 台灣專屬 Extension 欄位

    /// 村里
    public var village: String? {
        get { stringExtension(TWCoreURL.AddressExtension.village) }
        set { setStringExtension(TWCoreURL.AddressExtension.village, value: newValue) }
    }

    /// 鄰
    public var neighborhood: String? {
        get { stringExtension(TWCoreURL.AddressExtension.neighborhood) }
        set { setStringExtension(TWCoreURL.AddressExtension.neighborhood, value: newValue) }
    }

    /// 段
    public var section: String? {
        get { stringExtension(TWCoreURL.AddressExtension.section) }
        set { setStringExtension(TWCoreURL.AddressExtension.section, value: newValue) }
    }

    /// 巷
    public var lane: String? {
        get { stringExtension(TWCoreURL.AddressExtension.lane) }
        set { setStringExtension(TWCoreURL.AddressExtension.lane, value: newValue) }
    }

    /// 弄
    public var alley: String? {
        get { stringExtension(TWCoreURL.AddressExtension.alley) }
        set { setStringExtension(TWCoreURL.AddressExtension.alley, value: newValue) }
    }

    /// 號
    public var number: String? {
        get { stringExtension(TWCoreURL.AddressExtension.number) }
        set { setStringExtension(TWCoreURL.AddressExtension.number, value: newValue) }
    }

    /// 樓
    public var floor: String? {
        get { stringExtension(TWCoreURL.AddressExtension.floor) }
        set { setStringExtension(TWCoreURL.AddressExtension.floor, value: newValue) }
    }

    /// 室
    public var room: String? {
        get { stringExtension(TWCoreURL.AddressExtension.room) }
        set { setStringExtension(TWCoreURL.AddressExtension.room, value: newValue) }
    }
}

// MARK: - Private Helpers

private extension TWCoreAddressNamespace {

    func stringExtension(_ urlString: String) -> String? {
        guard let ext = address.extension?.first(where: {
            $0.url.value?.url.absoluteString == urlString
        }) else { return nil }
        if case .string(let s) = ext.value { return s.value?.string }
        return nil
    }

    mutating func setStringExtension(_ urlString: String, value: String?) {
        address.extension?.removeAll { $0.url.value?.url.absoluteString == urlString }
        guard let value, let url = urlString.fhirURI else { return }
        let ext = Extension(url: url, value: .string(value.fhirString))
        if address.extension == nil { address.extension = [ext] }
        else { address.extension?.append(ext) }
    }
}
