//
//  CrashReportingManager.swift
//  PharmaScout
//
//  Created by Mohammed on 11/4/26.
//

import Foundation
import Sentry

enum CrashReportingManager {
    static func start() {
        SentrySDK.start { options in
            options.dsn = "https://9215082dbcc4791e09216c3d13ce3b22@o4512372154236928.ingest.us.sentry.io/4512372177174528"
            #if DEBUG
                options.environment = "debug"
            #else
                options.environment = "production"
            #endif
        }
    }
    
    static func observeAuthChanges(_ stream: AsyncStream<AuthState>) async {
        for await state in stream {
            switch state {
            case .authenticated(let session):
                SentrySDK.setUser(User(userId: session.user.id))
                
            case .passwordReset, .failed:
                break
            
            case .signedOut, .non:
                SentrySDK.setUser(nil)
            }
        }
    }
}
