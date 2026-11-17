// 앱 전체에서 사용하는 로그인 정보를 저장 -> 로그인 상태에 따라 화면을 재구성

import Foundation
import Supabase

@Observable // SessionStore의 속성이 변하면 이 속성을 사용하는 화면이 재구성되도록 하기 위함
final class SessionStore { // 객체로 구현하여 복사되지 않음 -> 모든 화면에서 같은 로그인 상태를 봐야하기 때문에 class로 구현 (call by reference)
    
    // 로그인 상태 4가지
    enum State {
        case checking   // 앱 시작 직후, 저장된 로그인 정보 확인 중
        case signedOut  // 로그인 안함 -> 초기 화면으로 이동하기 위함
        case guest      // 로그인 없이 둘러보기
        case signedIn   // 로그인 됨
    }
    
    // 현재 상태
    // private(set) var 를 통해 외부에서 state값을 변경하지 못하고 해당 클래스 내부에서만 변경 가능
    private(set) var state : State = .checking // .cheking이 State.checking와 동일 (State 타입의 변수 state 초기값 설정)
    
    // 개발용 익명 로그인인지 확인
    private(set) var isAnonymousUser = false // =false를 통해 : Bool 생략 가능
    
    // 개인 데이터를 쓸 수 있는지 확인
    var canUsePersonalData : Bool {
        state == .signedIn // 값을 저장하지 않고 state 값을 읽고 계산
    }
    
    // MARK: - 상태 감지 (앱 시작 시 한 번 호출)
    
    func start() async { // 비동기 함수로 작성 -> 앱이 멈추지 않도록 하기 위함, ContentView에서 1회 호출하여 앱이 실행되는 동안 동작
        
        // 1) Keychain에 저장된 로그인 정보 확인(만료됐으면 자동 갱신 시도)
        if let session = try? await supabase.auth.session { // await로 if실행 전 supabase.auth.session가 로그인 정보를 가져올 때까지 대기
            apply(session)
        }
        else{
            state = .signedOut
        }
        
        //2) 이후 로그인, 로그아웃이 일어날 때마다 알림을 받아 상태 변경
        for await (event, session) in supabase.auth.authStateChanges { // supabase.auth.authStateChanges가 로그인 상태 변화 이벤트 발생
                                                                        // await로 이벤트 발생 시 처리 및 대기
                                                                        // (event, session) 무슨 일이 발생, 현재 로그인 정보
            switch event {
            case .signedIn, .tokenRefreshed, .userUpdated:  // event가 로그인됨, 토큰 갱신, 사용자 정보 변경일 때
                if let session {apply(session)}             // 로그인 상태 유지
            case .signedOut:                                // event가 로그아웃일 때
                isAnonymousUser = false
                state = .signedOut                          //state 값을 signedOut으로 변경
            default:
                break
            }
        }
    }
    
    // 앱 시작 시 기존의 로그인 정보를 확인하기 위해, 앱 사용 중 로그인하거나 토큰 갱신, 사용자 정보가 변경되는 이벤트가 발생했을 때 호출됨
    private func apply(_ session : Session) {       // SessionStore 클래스에서만 호출 가능한 내부 함수
                                                    // _ session : Session을 통해 apply(session)으로 호출할 수 있도록 함
                                                    // _ 가 없으면 apply(session : session)으로 호출해야 함
        isAnonymousUser = session.user.isAnonymous
        state = .signedIn
    }
    
    // MARK: - 화면에서 호출하는 동작
    
    // 로그인 없이 둘러보기
    private func continueAsGuest() {
        state = .guest
    }
    // 둘러보기 중 로그인하러 초기 화면으로 돌아가기
    private func goToWelcome() {
        state = .signedOut
    }
    // 개발용 익명 로그인 (소셜 로그인 연결 전 테스트용)
    func signInAnonymousForTesting() async throws {
        try await supabase.auth.signInAnonymously()
        // 성공하면 authStateChanges가 .signedIn을 알려 주어 state가 바뀜
    }
    // 로그아웃
    func signOut() async throws {
        try await supabase.auth.signOut()
        // 성공하면 authStateChanges가 .signedOut을 알려 주어 state가 바뀜
    }
}
