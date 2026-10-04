//
//  InquiryView.swift
//  PharmaScout
//
//  Created by Mohammed on 10/4/26.
//

import SwiftUI

struct InquiryView: View {
    let inquiry: Inquiry
    
    init(_ inquiry: Inquiry) {
        self.inquiry = inquiry
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(inquiry.genericName) \(inquiry.drugFormulation.title)")
            
            HStack {
                Text("Status: \(inquiry.status.rawValue)")
                    .foregroundStyle(inquiry.status == .answered ? .theme.success : .theme.textTertiary)
                Spacer()
                Text("Response: \(inquiry.response?.rawValue ?? "no response")")
            }
            
            VStack(alignment: .leading) {
                Text("Sent: \(inquiry.createdAt.formattedDateTime)")
                
                if let respondedAt = inquiry.respondedAt{
                    Text("Responded: \(respondedAt.formattedDateTime)")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.gray.opacity(0.2))
    }
}

#Preview {
    VStack(spacing: 30) {
        ForEach(0...2, id: \.self) { _ in
            InquiryView(.samples.randomElement()!)
        }
    }
    .padding()
}
