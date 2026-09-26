//
//  LoadingContentView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/26/26.
//

import SwiftUI

struct LoadingContentView<Content: View>: View {
    let LoadingState: LoadingState
    let isEmpty: Bool
    let emptyMessage: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        switch LoadingState.status {
        case .loading:
            RingProgressView()
            
        case .idle, .loadingMore, .refreshing:
            if !isEmpty {
                content()
            } else {
                if let error = LoadingState.error {
                    Text(error.errorDescription)
                } else {
                    Text(emptyMessage)
                }
            }
        }
    }
}

#Preview {
    let loadingState = LoadingState()
    let data = [1, 2]
    
    VStack(spacing: 50) {
        LoadingContentView(LoadingState: loadingState, isEmpty: false, emptyMessage: "There is no data") {
            HStack {
                ForEach(data, id: \.self) { i in
                    Text("\(i)")
                }
            }
        }
        
        LoadingContentView(LoadingState: loadingState, isEmpty: true, emptyMessage: "There is no data") {
            ForEach(data, id: \.self) { i in
                Text("\(i)")
            }
        }
    }
}
