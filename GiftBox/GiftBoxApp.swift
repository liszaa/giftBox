//
//  GiftBoxApp.swift
//  GiftBox
//
//  Created by Lisa on 12.10.2022.
//

import SwiftUI

@main
struct GiftBoxApp: App {
    var db = DataWrapper()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(db)
        }
    }
}
