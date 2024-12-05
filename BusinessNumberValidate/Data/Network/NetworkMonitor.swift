//
//  NetworkMonitor.swift
//  BusinessNumberValidate
//
//  Created by 일하는석찬 on 12/5/24.
//

import Network
import UIKit

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    var isConnected: Bool = false

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            if path.status == .satisfied {
                print("Network connected")
                NotificationCenter.default.post(name: .networkRestored, object: nil)
            } else {
                print("Network disconnected")
            }
        }
        monitor.start(queue: queue)
    }
}

extension Notification.Name {
    static let networkRestored = Notification.Name("networkRestored")
}
