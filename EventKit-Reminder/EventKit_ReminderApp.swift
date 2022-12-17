//
//  EventKit_ReminderApp.swift
//  EventKit-Reminder
//
//  Created by Ryo on 2022/12/17.
//

import SwiftUI

@main
struct EventKit_ReminderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ReminderManager())
        }
    }
}
