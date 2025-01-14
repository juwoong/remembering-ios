//
//  rememberingApp.swift
//  remembering
//
//  Created by 배주웅 on 1/11/25.
//

import SwiftUI

@main
struct rememberingApp: App {
    init() {
        SQLiteDatabase.initialize()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
