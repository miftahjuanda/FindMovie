//
//  NetworkManager.swift
//  FindMovie
//
//  Created by Miftah Juanda Batubara on 25/02/24.
//

import UIKit
import Network

internal class NetworkReachability {
    static let shared = NetworkReachability()
    
    private var monitor: NWPathMonitor?
    private var networkStatusUpdateHandler: ((Bool) -> Void)?
    
    private init() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            let isConnected = (path.status == .satisfied)
            self?.networkStatusUpdateHandler?(isConnected)
            print("cek path: ", path)
        }
    }
    
    func startMonitoring(updateHandler: @escaping (Bool) -> Void) {
        networkStatusUpdateHandler = updateHandler
        let queue = DispatchQueue(label: "NetworkMonitorQueue")
        monitor?.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor?.cancel()
        networkStatusUpdateHandler = nil
    }
}
