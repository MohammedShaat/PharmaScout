//
//  SupabaseRealtime.swift
//  PharmaScout
//
//  Created by Mohammed on 10/27/26.
//

import Foundation
import Supabase

struct RealtimeTable {
    let tableName: String
    var filter: RealtimePostgresFilter? = nil
}

extension SupabaseManager {
    class SupabaseRealtimeHub {
        private let supabase = SupabaseManager.shared.client
        
        private let channelName: String
        private let realtimeTables: [RealtimeTable]
        private let onIdle: ((SupabaseRealtimeHub) -> Void)?
        
        private var realtimeChannel: RealtimeChannelV2?
        private var subscribers: [UUID: AsyncStream<Void>.Continuation] = [:]
        private var setupTask: Task<Void, Error>?
        private var emittingTask: Task<Void, Never>?
        
        init(
            channelName: String,
            realtimeTables: RealtimeTable...,
            onIdle: ((SupabaseRealtimeHub) -> Void)? = nil
        ) {
            self.channelName = channelName
            self.realtimeTables = realtimeTables
            self.onIdle = onIdle
        }
        
        func subscribeToChanges() async throws -> AsyncStream<Void> {
            let id = UUID()
            let (stream, continuation) = AsyncStream.makeStream(
                of: Void.self, bufferingPolicy: .bufferingNewest(1)
            )
            continuation.onTermination = { [weak self] _ in
                Task { await self?.unsubscribeChanges(for: id) }
            }
            subscribers[id] = continuation

            do {
                try await startIfNeeded()
            } catch {
                continuation.finish()
                throw error
            }
            return stream
        }

        private func startIfNeeded() async throws {
            if let setupTask {
                try await setupTask.value
                return
            }

            let task = Task {
                let channel = supabase.channel("\(channelName)-\(UUID().uuidString)")
                let streamsGroup = realtimeTables.map {
                    channel.postgresChange(
                        AnyAction.self,
                        schema: "public",
                        table: $0.tableName,
                        filter: $0.filter
                    )
                }

                do {
                    try await channel.subscribeWithError()
                } catch {
                    await supabase.removeChannel(channel)
                    setupTask = nil
                    throw error
                }

                realtimeChannel = channel
                emittingTask = Task {
                    await withTaskGroup { group in
                        streamsGroup.forEach { stream in
                            group.addTask {
                                for await _ in stream { await self.broadcast() }
                            }
                        }
                    }
                }
            }
            setupTask = task
            try await task.value
        }

        private func broadcast() {
            for continuation in subscribers.values { continuation.yield() }
        }

        private func unsubscribeChanges(for id: UUID) async {
            subscribers[id] = nil
            guard subscribers.isEmpty else { return }

            _ = try? await setupTask?.value
            guard subscribers.isEmpty, let channel = realtimeChannel else { return }

            realtimeChannel = nil
            setupTask = nil
            emittingTask?.cancel()
            emittingTask = nil
            onIdle?(self)
            await supabase.removeChannel(channel)
        }
    }
}

extension SupabaseManager.SupabaseRealtimeHub {
    convenience init(
        channelName: String,
        tableName: String,
        filter: RealtimePostgresFilter?,
        onIdle: ((SupabaseManager.SupabaseRealtimeHub) -> Void)? = nil
    ) {
        self.init(
            channelName: channelName,
            realtimeTables: RealtimeTable(tableName: tableName, filter: filter),
            onIdle: onIdle
        )
    }
}
