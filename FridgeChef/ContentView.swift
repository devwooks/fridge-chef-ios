//
//  ContentView.swift
//  FridgeChef
//
//  Created by 이성욱 on 10/29/26.
//

import SwiftUI

// 앱의 루트 화면: 로그인 상태(session.state)에 따라 보여 줄 화면을 결정, 앱 시작 시 로그인 상태 감시 시작
// ContentView는 앱이 실행되는 동안 사라지지 않는 루트 화면
struct ContentView: View {
    @Environment(SessionStore.self) private var session

    var body: some View {
        Group { // switch 문에 .수정자를 붙일 수 없기 때문에 Group으로 임의의 하나의 화면으로 묶는 것
            switch session.state {
            case .checking:                 // 저장된 로그인 정보 확인 중
                ProgressView("준비 중...")
            case .signedOut:                // 로그인 안 함 → 초기 화면
                WelcomeView()
            case .guest, .signedIn:         // 둘러보기 또는 로그인 → 메인 화면
                MainView()
            }
        }
        .animation(.default, value: session.state)  // 상태가 바뀔 때 화면을 부드럽게 전환
        .task {                             // 화면이 나타났을 때 {}안의 비동기 작업 수행
            await session.start()           // 앱 시작 시 1회: 로그인 정보 확인 + 이후 로그인 상태 확인 (start()함수가 앱이 켜져있는 내내 실행)
        }
    }
}

#Preview {
    ContentView()
        .environment(SessionStore())
}
