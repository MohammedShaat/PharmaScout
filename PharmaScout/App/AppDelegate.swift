//
//  AppDelegate.swift
//  PharmaScout
//
//  Created by Mohammed on 10/12/26.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    let tokenStream: AsyncStream<String>
    private let tokenContinuation: AsyncStream<String>.Continuation
    
    override init() {
        (tokenStream, tokenContinuation) = AsyncStream.makeStream(
            bufferingPolicy: .bufferingNewest(1)
        )
        
        super.init()
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        Task {
            do {
                let granted = try await UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .badge, .sound])
                
                guard granted else {
                    print("Notification permission not granted")
                    return
                }
                
                application.registerForRemoteNotifications()
                
            } catch {
                print("Notification permission error\n", error)
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken
            .map { String(format: "%02.2hhx", $0) }
            .joined()
        
        tokenContinuation.yield(token)
    }
    
    func application(
            _ application: UIApplication,
            didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("APNs registration failed:", error)
    }
}
