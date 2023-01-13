//
//  CreateReminderView.swift
//  EventKit-Reminder
//
//  Created by Ryo on 2022/12/17.
//

import SwiftUI
import EventKit

struct CreateReminderView: View {
    @EnvironmentObject var reminderManager: ReminderManager
    // ContentViewのsheetのフラグ
    @Environment(\.dismiss) var dismiss
    // 変更したいイベント(nilの場合は新規追加)
    @Binding var reminder: EKReminder?
    // リマインダーのタイトル
    @State var title = ""
    // リマインダーの開始日時
    @State var dueDate = Date()
    // リマインダーの終日のフラグ
    @State var allDay = false
    // リマインダーのURL
    @State var URLText = ""
    
    var body: some View {
        NavigationStack{
            List {
                TextField("タイトル", text: $title)
                Toggle("終日", isOn: $allDay)
                DatePicker("開始", selection: $dueDate, displayedComponents: allDay ? [.date] : [.date, .hourAndMinute])
                HStack {
                    TextField("URL", text: $URLText)
                    PasteButton(payloadType: URL.self) { Paste in
                        URLText = Paste[0].absoluteString
                    }
                    .labelStyle(.iconOnly)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(reminder == nil ? "追加" : "変更") {
                        if let reminder {
                            reminderManager.modifyEvent(reminder: reminder, title: title, dueDate: dueDate)
                        } else{
                            reminderManager.createReminder(title: title, dueDate: dueDate)
                        }
                        // sheetを閉じる
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル", role: .destructive) {
                        // sheetを閉じる
                        dismiss()
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
        .task {
            if let reminder {
                // eventが渡されたら既存の値をセットする(変更の場合)
                self.title = reminder.title
                self.dueDate = reminder.dueDateComponents?.date ?? Date()
            }
        }
    }
}

struct CreateReminderView_Previews: PreviewProvider {
    static var previews: some View {
        CreateReminderView(reminder: .constant(nil))
    }
}
