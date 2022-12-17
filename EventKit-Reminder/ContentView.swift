//
//  ContentView.swift
//  EventKit-Reminder
//
//  Created by Ryo on 2022/12/17.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var reminderManager: ReminderManager
    
    var body: some View {
        if let aReminder = reminderManager.reminders {
            NavigationStack {
                List(aReminder, id: \.calendarItemIdentifier) { reminder in
                    Text(reminder.title)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        DatePicker("", selection: $reminderManager.day, displayedComponents: .date)
                            .labelsHidden()
                            .onChange(of: reminderManager.day) { newValue in
                                reminderManager.fetchReminder()
                            }
                    }
                }
            }
        } else {
            Text(reminderManager.statusMessage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
