//
//  ContentView.swift
//  EventKit-Reminder
//
//  Created by Ryo on 2022/12/17.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var reminderManager: ReminderManager
    // sheetのフラグ
    @State var isShowCreateReminderView = false
    
    var body: some View {
        if let aReminder = reminderManager.reminders {
            NavigationStack {
                List(aReminder, id: \.calendarItemIdentifier) { reminder in
                    HStack {
                        Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(reminder.isCompleted ? Color.accentColor : Color.gray)
                        Text(reminder.title)
                    }
                }
                .sheet(isPresented: $isShowCreateReminderView) {
                    CreateReminderView()
                        .presentationDetents([.medium])
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        DatePicker("", selection: $reminderManager.day, displayedComponents: .date)
                            .labelsHidden()
                            .onChange(of: reminderManager.day) { newValue in
                                reminderManager.fetchReminder()
                            }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isShowCreateReminderView = true
                        } label: {
                            Label("追加", systemImage: "plus")
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
