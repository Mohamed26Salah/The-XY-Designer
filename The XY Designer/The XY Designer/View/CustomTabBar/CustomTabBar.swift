//
//  CustomTabBar.swift
//  The XY Designer
//
//  Created by Mohamed Salah on 17/03/2023.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case house
    case plus
    case person
    //    case gearshape
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        switch selectedTab {
        case .plus:
            return selectedTab.rawValue + ".circle.fill"
        default:
            return selectedTab.rawValue + ".fill"
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    Image(systemName: tab == .plus ? (selectedTab == .plus ? fillImage : "plus.circle") : (selectedTab == tab ? fillImage : tab.rawValue))
                        .scaleEffect(tab == .plus ? (selectedTab == .plus ? 2 : 1.8) : (selectedTab == tab ? 1.5 : 1.25))
                        .foregroundColor(tab == selectedTab ? .primary : .gray)
                        .font(.system(size: 20))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .frame(width:nil, height: 60)
            //            .background(.thinMaterial)
            .cornerRadius(20)
            .padding()
        }
    }
}
struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(.house))
    }
}
