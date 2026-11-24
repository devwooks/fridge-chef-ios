import SwiftUI

// 메인 화면: 현재 상태 표시 + 메뉴(재료 관리, 레시피 검색) + 로그인/로그아웃

struct MainView: View {
    @Environment(SessionStore.self) private var session

    @State private var showLogoutAlert = false     // 로그아웃 확인창 표시 여부
    @State private var showErrorAlert = false      // 오류 알림창 표시 여부
    @State private var errorMessage = ""           // 오류 알림창 내용

    var body: some View {
        NavigationStack {
            List {          // HTML의 <ul>
                // 현재 상태
                Section {   // List에 추가할 소분류
                    Label(statusText, systemImage: statusIcon) // 아이콘과 텍스트 한 쌍
                }

                // 메뉴
                Section {
                    NavigationLink {
                        Text("재료 관리 (E-5단계에서 FridgeView로 교체)")       // 임시
                    } label: {
                        Label("재료 관리", systemImage: "refrigerator")
                    }
                    .disabled(!session.canUsePersonalData)                     // 로그인 전에는 비활성
                    
                    NavigationLink {
                        Text("레시피 검색 (E-5단계에서 RecipeSearchView로 교체)") // 임시
                    } label: {
                        Label("레시피 검색", systemImage: "magnifyingglass")
                    }
                } header: {         // list 위 설명 부분
                    Text("메뉴")
                } footer: {         // list 아래 설명 부분
                    if !session.canUsePersonalData {
                        Text("재료 관리는 로그인 후 사용할 수 있어요")
                    }
                }
            }
            .navigationTitle("FridgeChef")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { // 툴바 우측 최상단 버튼 추가
                    if session.state == .signedIn {
                        Button("로그아웃") { showLogoutAlert = true } // -> 로그아웃 버튼 누르면 showLogoutAlert 값이 변하면서 확인창을 띄움
                    } else {
                        Button("로그인") { session.goToWelcome() }
                    }
                }
            }
            // 로그아웃 확인창
            .alert("로그아웃", isPresented: $showLogoutAlert) {
                Button("로그아웃", role: .destructive) {
                    Task { await logout() }
                }
                Button("취소", role: .cancel) { }
            } message: {
                Text(session.isAnonymousUser
                     ? "개발용 익명 계정은 로그아웃하면 같은 계정으로 다시 들어올 수 없어요."
                     : "로그아웃할까요?")
            }
            
            // 오류 알림창
            .alert("오류", isPresented: $showErrorAlert) {
                Button("확인", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    // MARK: - 상태 표시용 계산 속성

    // 현재 상태 문구
    private var statusText: String {
        switch session.state {
        case .checking:
            return "확인 중..."
        case .signedOut:
            return "로그인 안 됨"
        case .guest:
            return "둘러보기 중 (로그인 안 함)"
        case .signedIn:
            return session.isAnonymousUser ? "개발용 익명 로그인 중" : "로그인됨"
        }
    }

    // 현재 상태 아이콘 (SF Symbol 이름)
    private var statusIcon: String {
        switch session.state {
        case .checking:
            return "hourglass"
        case .signedOut:
            return "person.slash"
        case .guest:
            return "eye"
        case .signedIn:
            return session.isAnonymousUser ? "hammer" : "person.crop.circle.badge.checkmark"
        }
    }

    // MARK: - 동작

    // 로그아웃 실행
    private func logout() async {
        do {
            try await session.signOut()
            // 성공하면 authStateChanges가 .signedOut을 알려 주어 초기 화면으로 바뀜 (F단계 이후)
        } catch {
            errorMessage = "로그아웃 실패: \(error.localizedDescription)"
            showErrorAlert = true
        }
    }
}

#Preview {
    MainView()
        .environment(SessionStore())
}
