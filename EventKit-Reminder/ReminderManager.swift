//
//  ReminderManager.swift
//  EventKit-Reminder
//
//  Created by Ryo on 2022/12/17.
//

import Foundation
import EventKit

class ReminderManager: ObservableObject {
    var store = EKEventStore()
    // リマインダーへの認証ステータスのメッセージ
    @Published var statusMessage = ""
    // 取得されたリマインダー
    @Published var reminders: [EKReminder]? = nil
    // 取得したいリマインダーの日付
    @Published var day = Date()
    
    init() {
        Task {
            do {
                // リマインダーへのアクセスを要求
                try await store.requestAccess(to: .reminder)
            } catch {
                print(error.localizedDescription)
            }
            // リマインダーへの認証ステータス
            let status = EKEventStore.authorizationStatus(for: .reminder)
            
            switch status {
            case .notDetermined:
                statusMessage = "リマインダーへのアクセスする\n権限が選択されていません。"
            case .restricted:
                statusMessage = "リマインダーへのアクセスする\n権限がありません。"
            case .denied:
                statusMessage = "リマインダーへのアクセスが\n明示的に拒否されています。"
            case .authorized:
                statusMessage = "リマインダーへのアクセスが\n許可されています。"
                fetchReminder()
                // カレンダーデータベースの変更を検出したらfetchReminder()を実行する
                NotificationCenter.default.addObserver(self, selector: #selector(fetchReminder), name: .EKEventStoreChanged, object: store)
            @unknown default:
                statusMessage = "@unknown default"
            }
        }
    }
    
    /// リマインダーの取得
    @objc func fetchReminder() {
        // 開始日コンポーネントの作成
        // 指定した前の日付の23:59:59
        let start = Calendar.current.date(byAdding: .second, value: -1, to: Calendar.current.startOfDay(for: day))!
        // 終了日コンポーネントの作成
        // 指定した日付の23:59:0
        let end = Calendar.current.date(bySettingHour: 23, minute: 59, second: 0, of: Calendar.current.startOfDay(for: day))
        // イベントストアのインスタンスメソッドから述語を作成
        var predicate: NSPredicate? = nil
        if let end {
            predicate = store.predicateForIncompleteReminders(withDueDateStarting: start, ending: end, calendars: nil)
        }
        // 述語に一致する全てのリマインダーを取得
        if let predicate {
            store.fetchReminders(matching: predicate) { reminder in
                self.reminders = reminder
            }
        }
    }
    
}
