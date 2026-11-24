//
//  WelcomeView.swift
//  FridgeChef
//
//  Created by 이성욱 on 11/19/26.
//

import SwiftUI // View, Text, Button 등을 쓰기 위한 모듈

// 초기 화면: 앱 설명 + 로그인 / 둘러보기 선택

struct WelcomeView: View {
    @Environment(SessionStore.self) private var session

    var body: some View {
        NavigationStack {           // NavigationLink를 통해 다른 화면들을 쌓을 수 있도록 NavigationStack이 필요, 자동으로 뒤로가기 버튼 생성
            VStack(spacing: 24) {   // 수직으로 Stack 생성
                Spacer()            // 아이콘 위 공백 추가를 위함

                // 앱 이름과 아이콘
                Image(systemName: "refrigerator")
                    .font(.system(size: 64))
                    .foregroundStyle(.mint)
                Text("FridgeChef")
                    .font(.largeTitle.bold())

                // 앱 설명
                VStack(alignment: .leading, spacing: 16) { // alignment = 정렬
                    FeatureRow(icon: "carrot",
                               color: .orange,
                               title: "냉장고 재료 관리",
                               detail: "가진 재료를 저장하고 한눈에 확인해요")
                    FeatureRow(icon: "fork.knife",
                               color: .gray,
                               title: "만들 수 있는 요리 추천",
                               detail: "보유한 재료로 가능한 레시피를 찾아줘요")
                    FeatureRow(icon: "play.rectangle",
                               color: .red,
                               title: "인기 레시피 영상",
                               detail: "조회수가 높은 요리 영상을 함께 보여줘요")
                }
                .padding(.horizontal)

                Spacer()

                // 로그인 버튼 → 로그인 화면으로 이동
                NavigationLink {    // NavigationLink {A} label: {B} = B 누르면 A로 이동
                    Text("로그인 화면 (E-3단계에서 LoginView로 교체)")  // 임시
                } label: {
                    Text("로그인")
                        .frame(maxWidth: .infinity)             // 버튼 좌우 공백 최대
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                // 둘러보기 버튼 → 둘러보기 모드
                Button("로그인 없이 둘러보기") {     // 둘러보기 모드는 화면을 쌓는게 아니라 상태를 변화시킴
                    session.continueAsGuest()   //session의 상태를 guest로 변경
                }
                .controlSize(.large)
            }
            .padding()
        }
    }
}

/// 기능 설명 한 줄 (이 파일에서만 쓰는 부품 -> Views/Components/로 옮겨 다른 화면에서도 가져다 쓸 수 있음) 현재는 Private
private struct FeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let detail: String

    var body: some View {   // HStack으로 아이콘 정렬, VStack으로 title, detail 정렬
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview { // 캔버스 미리보기용
    WelcomeView()
        .environment(SessionStore()) // SessionStore를 직접 전달해야 함
}
