//
//  QuerySearchRunnerTests.swift
//  PharmaScoutTests
//
//  Created by Mohammed on 11/23/26.
//

import Testing
@testable import PharmaScout

// MARK: - shouldPerform

@MainActor
struct ShouldPerformTests {

    private struct Case {
        let index: Int
        let query: String
        let lastQuery: String?
        var allowsEmptyQuery: Bool = false
        var hasPreviousPage: Bool = false
        var isRefreshing: Bool = false
        let expected: Bool
    }
    
    private static let cases: [Case] = [
        .init(index: 0, query: "", lastQuery: nil, expected: false),
        .init(index: 1, query: "   ", lastQuery: nil, expected: false),
        .init(index: 2, query: "", lastQuery: nil, allowsEmptyQuery: true, expected: true),
        
        .init(index: 3, query: "a", lastQuery: nil, allowsEmptyQuery: true, expected: false),
        .init(index: 4, query: "aa", lastQuery: nil, expected: false),
        .init(index: 5, query: "aaa", lastQuery: nil, expected: true),
        
        .init(index: 6, query: "xyz", lastQuery: "abc", expected: true),
        .init(index: 7, query: "xyz  ", lastQuery: "xyz", expected: false),
        
        .init(index: 8, query: "", lastQuery: nil, isRefreshing: true, expected: true),
        .init(index: 9, query: "xyz", lastQuery: "abc", isRefreshing: true, expected: true),
        .init(index: 10, query: "xyz  ", lastQuery: "xyz", isRefreshing: true, expected: true),
        
        .init(index: 11, query: "", lastQuery: nil, hasPreviousPage: true, expected: true),
        .init(index: 12, query: "xyz", lastQuery: "xyz", hasPreviousPage: true, expected: true),
    ]
    
    @Test func `shouldPerform returns true when query is valid`() async throws {
        for c in Self.cases {
            let result = QuerySearchRunner.shouldPerform(
                query: c.query,
                lastQuery: c.lastQuery,
                allowsEmptyQuery: c.allowsEmptyQuery,
                hasPreviousPage: c.hasPreviousPage,
                isRefreshing: c.isRefreshing
            )
            #expect(result == c.expected, "\(c.index)")
        }
    }
}

// MARK: - perform

private class Recorder<T> {
    var logs: [T] = []
}

private enum RunLog {
    case stopLoading, startLoading, advancePage, handleError, updateLastQuery, executeWork, onSucees
}

private struct TestError: Error {
    
}

@MainActor
struct PerformTests {
    
    private func run(
        recorder: Recorder<RunLog>,
        shouldPerform: Bool,
        hasPreviousPage: Bool,
        isRefreshing: Bool,
        asyncWork: () async throws -> [Int]
    ) async {
        await QuerySearchRunner.perform(
            shouldPerform: shouldPerform,
            hasPreviousPage: hasPreviousPage,
            isRefreshing: isRefreshing,
            stopLoading: { recorder.logs.append(.stopLoading) },
            startLoading: { recorder.logs.append(.startLoading) },
            advancePage: { recorder.logs.append(.advancePage) },
            handleError: {	_ in recorder.logs.append(.handleError) },
            query: "aspirin",
            updateLastQuery: { recorder.logs.append(.updateLastQuery) },
            asyncWork: {
                recorder.logs.append(.executeWork)
                return try await asyncWork()
            },
            onSuccess: { _ in recorder.logs.append(.onSucees) }
        )
    }
    
    @Test func `Does nothing when shouldPerform is false`() async {
        let recorder = Recorder<RunLog>()
        await run(recorder: recorder, shouldPerform: false, hasPreviousPage: false, isRefreshing: false) {
            [1, 2]
        }
        #expect(recorder.logs.isEmpty)
    }
    
    @Test func `Success with non-empty result executes steps in order and advances page`() async {
        let recorder = Recorder<RunLog>()
        await run(recorder: recorder, shouldPerform: true, hasPreviousPage: false, isRefreshing: false) {
            [1, 2]
        }
        #expect(recorder.logs == [.startLoading, .executeWork, .updateLastQuery, .onSucees, .advancePage, .stopLoading])
    }
    
    @Test func `Success with empty result executes steps in order and doesn't advance page`() async {
        let recorder = Recorder<RunLog>()
        await run(recorder: recorder, shouldPerform: true, hasPreviousPage: false, isRefreshing: false) {
            []
        }
        #expect(recorder.logs == [.startLoading, .executeWork, .updateLastQuery, .onSucees, .stopLoading])
    }
    
    @Test func `Failure reports an error and stops loading`() async {
        let recorder = Recorder<RunLog>()
        await run(recorder: recorder, shouldPerform: true, hasPreviousPage: false, isRefreshing: false) {
            throw TestError()
        }
        #expect(recorder.logs == [.startLoading, .executeWork, .handleError, .stopLoading])
    }
}
