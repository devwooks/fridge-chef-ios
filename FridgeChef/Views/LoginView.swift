import SwiftUI

// 로그인 화면: 소셜 로그인 버튼(현재 준비 중) + 개발용 익명 로그인
// .alert()에서 isPresented로 넘겨받은 showAlert의 값은 action이 종료된 후 false로 자동 반환 -> SwiftUI 프레임워크의 동작 방식이므로 코드 상 showAlert = false가 없음

struct LoginView: View {
    @Environment(SessionStore.self) private var session

    // 로그인 화면에서만 필요한 3가지 값으로 @State를 사용함 -> 지역 변수
    @State private var showAlert = false        // 알림창 표시 여부
    @State private var alertMessage = ""        // 알림창 내용
    @State private var isLoading = false        // 개발용 로그인 진행 중 여부

    var body: some View {                       // UI 구성
        VStack(spacing: 16) {
            Spacer() // 이미지 위 공백

            // 상단 안내
            Image(systemName: "person.crop.circle")
                .font(.system(size: 56))
                .foregroundStyle(.mint)
            Text("FridgeChef 시작하기")
                .font(.title2.bold())
            Text("로그인하면 내 냉장고 재료를 저장할 수 있어요")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer() // Apple 로그인 버튼 위 공백

            // 소셜 로그인 버튼 (실제 연결은 각 개발자 콘솔 설정 후)
            SignInButton(icon: "apple.logo",
                         title: "Apple로 계속하기",
                         background: .black,
                         foreground: .white) {
                showMessage("Apple 로그인은 준비 중이에요")
            }
            SignInButton(icon: "g.circle.fill",
                         title: "Google로 계속하기",
                         background: Color(.systemGray6),
                         foreground: .primary) {
                showMessage("Google 로그인은 준비 중이에요")
            }
            SignInButton(icon: "message.fill",
                         title: "카카오로 계속하기",
                         background: Color(red: 0.996, green: 0.898, blue: 0.0),
                         foreground: .black) {
                showMessage("카카오 로그인은 준비 중이에요")
            }

            #if DEBUG
            // 개발용 익명 로그인 (Release 빌드에서는 코드 자체가 빠짐)
            Button {
                Task { await testLogin() }
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("개발용 익명 로그인")
                }
            }
            .disabled(isLoading)
            .padding(.top, 8)
            #endif

            Spacer()
        }
        .padding() // 좌우 공백
        .alert("알림", isPresented: $showAlert) { // $showAlert 값을 보고 알림을 띄움
            Button("확인", role: .cancel) { }     // role과 cancel을 통해 닫기 버튼임을 명시
        } message: {
            Text(alertMessage)
        }
    }

    // 알림창 띄우기
    private func showMessage(_ text: String) {
        alertMessage = text
        showAlert = true
    }

    // 개발용 익명 로그인 실행 -> do catch = try catch와 동일
    private func testLogin() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await session.signInAnonymouslyForTesting()
        } catch {
            showMessage("익명 로그인 실패: \(error.localizedDescription)")
        }
    }
}

// 소셜 로그인 버튼 한 개 (이 파일에서만 쓰는 부품)
private struct SignInButton: View {
    let icon: String
    let title: String
    let background: Color
    let foreground: Color
    let action: () -> Void      // 눌렀을 때 실행할 동작을 밖에서 전달받음 (매개변수x 리턴x인 람다함수)
                                // 버튼을 눌렀을 때 행해야하는 행동이 모두 상이하기 때문에 일반화한 것

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(title)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(background)
            .foregroundStyle(foreground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
        LoginView()
    .environment(SessionStore())
}
