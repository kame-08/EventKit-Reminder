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
        VStack {
            Text(reminderManager.statusMessage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
