//
//  CreateReminderView.swift
//  EventKit-Reminder
//
//  Created by Ryo on 2022/12/17.
//

import SwiftUI

struct CreateReminderView: View {
    @EnvironmentObject var reminderManager: ReminderManager
    // ContentViewのsheetのフラグ
    @Environment(\.dismiss) var dismiss
    // eventのタイトル
    @State var title = ""
    // eventの開始日時
    @State var dueDate = Date()
    
    var body: some View {
        NavigationStack{
            List {
                TextField("タイトル", text: $title)
                DatePicker("開始", selection: $dueDate)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("追加") {
                        reminderManager.createReminder(title: title, dueDate: dueDate)
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
    }
}

struct CreateReminderView_Previews: PreviewProvider {
    static var previews: some View {
        CreateReminderView()
    }
}
