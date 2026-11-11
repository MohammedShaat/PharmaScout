//
//  LoadingContentView.swift
//  PharmaScout
//
//  Created by Mohammed on 9/26/26.
//

import SwiftUI

struct LoadingContentView<Content: View, Icon: View>: View {
    let LoadingState: LoadingState
    let showMessage: Bool
    let emptyTitle: String
    let emptyMessage: String
    let showIcon: Bool
    @ViewBuilder let emptyIcon: Icon
    @ViewBuilder let content: Content
    
    init(
        LoadingState: LoadingState,
        showMessage: Bool,
        emptyTitle: String = "Couldn't find results",
        emptyMessage: String,
        showIcon: Bool = true,
        @ViewBuilder emptyIcon: () -> Icon = { EmptyView() },
        @ViewBuilder content: () -> Content
    ) {
        self.LoadingState = LoadingState
        self.showMessage = showMessage
        self.emptyTitle = emptyTitle
        self.emptyMessage = emptyMessage
        self.showIcon = showIcon
        self.emptyIcon = emptyIcon()
        self.content = content()
    }
    
    var body: some View {
        switch LoadingState.status {
        case .loading:
            RingProgressView()
            
        case .idle, .loadingMore, .refreshing:
            if !showMessage {
                content
            } else if LoadingState.hasStarted {
                errorOrEmpty
            }
        }
    }
    
    private var errorOrEmpty: some View {
        VStack(spacing: 0) {
            // Icon
            if showIcon {
                Group {
                    if LoadingState.error != nil {
                        errorIcon
                    } else {
                        emptyIconTemplate
                    }
                }
                .padding(.vertical, DesignSystem.Spacing.xLarge)
            }
            
            // Title & message
            VStack(spacing: DesignSystem.Spacing.medium) {
                let error = LoadingState.error
                
                Text(error != nil ? "Couldn't load" : emptyTitle)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundStyle(.theme.textPrimary)
                
                Group {
                    if let error = error {
                        Text(error.errorDescription)
                    } else {
                        Text(emptyMessage)
                    }
                }
                .foregroundStyle(.theme.textSecondary)
                .multilineTextAlignment(.center)
            }
        }
    }
    
    private var emptyIconTemplate: some View {
        Group {
            if Icon.self == EmptyView.self {
                Image(.magnifyingglassCross)
                    .resizable()
                    .scaledToFit()
            } else {
                emptyIcon
            }
        }
        .frame(width: 34)
        .padding(14)
        .roundedBackground(showBorder: true)
        .padding(6)
        .overlay {
            Circle()
                .stroke(
                    .theme.disabledContent,
                    style: .init(lineWidth: 1, dash: [3])
                )
        }
        .padding(18)
        .overlay {
            Circle()
                .stroke(
                    .theme.disabledContent,
                    style: .init(lineWidth: 1, dash: [3])
                )
        }
    }
    
    private var errorIcon: some View {
        Image(.triangleExclamationMark)
            .resizable()
            .scaledToFit()
            .frame(width: 34)
            .foregroundStyle(.theme.error)
            .padding(18)
            .roundedBackground(showBorder: true)
            .padding(10)
            .overlay {
                Circle()
                    .stroke(
                        .theme.error.opacity(0.6),
                        style: .init(lineWidth: 1)
                    )
            }
            .padding(18)
            .background {
                Circle()
                    .fill(.theme.error.opacity(0.1))
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
            LoadingContentView(LoadingState: loadingState, showMessage: false, emptyMessage: "There is no data") {
                HStack {
                    ForEach(data, id: \.self) { i in
                        Text("\(i)")
                    }
                }
            }
            
            LoadingContentView(LoadingState: loadingState, showMessage: true, emptyMessage: "There is no data") {
                ForEach(data, id: \.self) { i in
                    Text("\(i)")
                }
            }
            
            LoadingContentView(LoadingState: loadingState2, showMessage: true, emptyMessage: "There is no data") {
                ForEach(data, id: \.self) { i in
                    Text("\(i)")
                }
            }
        }
        .padding()
    }
}
