//
//  RealtimeChangeListener.swift
//  PharmaScout
//
//  Created by Mohammed on 10/27/26.
//

import Foundation

func changesListener<T>(
    needsCatchup: Bool,
    realtimeStream: () async throws -> AsyncStream<T>,
    trigger: () async -> Void,
) async throws {
    let doCatchup = needsCatchup
    
    let changes = try await realtimeStream()
    
    if doCatchup { await trigger() }
    
    for await _ in changes {
        await trigger()
    }
}
