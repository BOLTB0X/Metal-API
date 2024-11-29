//
//  ContentView.swift
//  Ex01-Triangle
//
//  Created by KyungHeon Lee on 2024/11/26.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            Triangle_01()
                .tabItem {
                    Text("01")
                }
            
            Triangle_02()
                .tabItem {
                    Text("02")
                }
        }
    } // body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
