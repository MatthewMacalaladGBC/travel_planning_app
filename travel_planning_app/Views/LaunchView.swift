//
//  LaunchView.swift
//  travel_planning_app
//
//  Created by Sara Yohannes on 2026-03-13.
//

import SwiftUI

struct LaunchView: View {
    @State private var goToHome = false

    var body: some View {
        if goToHome {
            NavigationStack {
                HomeView()
            }
        } else {
            VStack(spacing: 24) {
                Image(systemName: "list.clipboard")
                    .font(.system(size: 70))
                    .foregroundColor(.green)

                Text("Trip Planner")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Plan together. Split fairly.")
                    .font(.title3)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGray6))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    goToHome = true
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
