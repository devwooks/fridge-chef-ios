//
//  FridgeChefApp.swift
//  FridgeChef
//
//  Created by 이성욱 on 10/29/26.
//

import SwiftUI

@main                                           // 앱의 시작점임을 알림
struct FridgeChefApp: App {                     // 앱이라는 구조체로 정의
    @State private var session = SessionStore() // 앱 전체에서 객체 하나만 생성(SessionStore.swift에 정의된 객체)
                                                // @State로 앱이 실행되는 동안 유지하도록 함 + 기존 객체 사용을 통해 로그인 정보 유지
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(session)           // 모든 하위 화면에 객체 전달 , ContentView가 루트인 트리구조로 생각하면 편함
                                                // MainView나 WelcomeView가 ContentView 안에 포함되어 있어 session 정보를 꺼낼 수 있음
                                                // 상속개념과 비슷하지만 다른 것, @Environment로 사용
        }
    }
}
