//
//  Notification.swift
//  Eat Orgasm
//
//  Created by 지원구 on 2022/05/19.
//

import Foundation

//로그인 상태가 바뀐 noti를 파악하기 위해 Notification.Name에 authStateDidChange 이름 추가
extension Notification.Name {
    static let authStateDidChange = NSNotification.Name("authStateDidChange")
}
