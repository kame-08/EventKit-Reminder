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
            @unknown default:
                statusMessage = "@unknown default"
            }
        }
    }
}
