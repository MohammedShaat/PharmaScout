//
//  LoadingContentView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/26/26.
//

import SwiftUI

struct LoadingContentView<Content: View, Icon: View>: View {
    let loadingState: LoadingState
    let showMessage: Bool
    let emptyTitle: String
    let emptyMessage: String
    let errorTitle: String
    let showIcon: Bool
    @ViewBuilder let emptyIcon: Icon
    @ViewBuilder let content: Content
    
    init(
        loadingState: LoadingState,
        showMessage: Bool,
        emptyTitle: String = "Couldn't find results",
        emptyMessage: String,
        errorTitle: String = "Couldn't load",
        showIcon: Bool = true,
        @ViewBuilder emptyIcon: () -> Icon = { EmptyView() },
        @ViewBuilder content: () -> Content
    ) {
        self.loadingState = loadingState
        self.showMessage = showMessage
        self.emptyTitle = emptyTitle
        self.emptyMessage = emptyMessage
        self.errorTitle = errorTitle
        self.showIcon = showIcon
        self.emptyIcon = emptyIcon()
        self.content = content()
    }
    
    private var error: AppError? { loadingState.error }
    private var title: String {
        if error != nil { return errorTitle }
        else { return emptyTitle }
    }
    private var message: String {
        if let error { return error.errorDescription }
        else { return emptyMessage }
    }
    
    var body: some View {
        switch loadingState.status {
        case .loading:
            RingProgressView(trimColor: .theme.secondary)
            
        case .idle, .loadingMore, .refreshing:
            if !showMessage {
                content
            } else if loadingState.hasStarted  {
                errorOrEmptyContent
            }
        }
    }
    
    private var errorOrEmptyContent: some View {
        VStack(spacing: 0) {
            // Icon
            if showIcon {
                if loadingState.error != nil {
                    ErrorIconView()
                        .padding(.vertical, DesignSystem.Spacing.xLarge)
                } else {
                    EmptyIconView(emptyIcon: { emptyIcon })
                        .padding(.vertical, DesignSystem.Spacing.xLarge)
                }
            }
            
            // Title & message
            VStack(spacing: DesignSystem.Spacing.medium) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundStyle(.theme.textPrimary)
                
                Text(message)
                    .foregroundStyle(.theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    let loadingState = LoadingState()
    let data = [1, 2]
    
    let loadingState2 = {
        var state = LoadingState()
        state.fail(NetworkError.notConnectedToInternet)
        return state
    }()
    
    CustomNavStack {
        VStack(spacing: 50) {
            LoadingContentView(loadingState: loadingState, showMessage: false, emptyMessage: "There is no data") {
                HStack {
                    ForEach(data, id: \.self) { i in
                        Text("\(i)")
                    }
                }
            }
            
            LoadingContentView(loadingState: loadingState, showMessage: true, emptyMessage: "There is no data") {
                ForEach(data, id: \.self) { i in
                    Text("\(i)")
                }
            }
            
            LoadingContentView(loadingState: loadingState2, showMessage: true, emptyMessage: "There is no data") {
                ForEach(data, id: \.self) { i in
                    Text("\(i)")
                }
            }
        }
        .padding()
    }
}
