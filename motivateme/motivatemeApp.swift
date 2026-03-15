//
//  motivatemeApp.swift
//  motivateme
//
//  Created by Luis Yuja on 3/14/26.
//

import SwiftUI
import UIKit

@main
struct motivatemeApp: App {
    init() {
        for family in UIFont.familyNames.sorted() {
            for name in UIFont.fontNames(forFamilyName: family) {
                print("FONT: \(name)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
