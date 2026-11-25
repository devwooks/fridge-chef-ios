//
//  GoogleSignInService.swift
//  FridgeChef
//
//  Created by 이성욱 on 11/25/26.
//

import UIKit        // SWiftUI 개발 전 프레임워크로 GoogleSignIn 패키지가 UIKit 기반이라 UIViewController 사용
import GoogleSignIn

// Google 로그인 담당: Google 로그인 화면을 띄우고 ID 토큰을 받아 옴
// Supabase는 모름 → 받은 토큰을 Supabase에 넘기는 일은 SessionStore가 담당

enum GoogleSignInService {  // 객체 생성 없는 함수 모음

    // Google 로그인 결과 중 Supabase에 넘길 두 토큰
    struct Tokens {
        let idToken: String         // "이 사람은 Google 계정 ○○○"라는 Google의 서명이 들어간 증명서(JWT)
        let accessToken: String     // Supabase가 ID 토큰과 짝이 맞는지 확인할 때 사용
    }

    // 이 파일에서 직접 만드는 오류 종류 -> 사용자 정의 예외 처리
    enum GoogleSignInError: LocalizedError {
        case noPresentingScreen     // 로그인 화면을 띄울 화면을 못 찾음
        case noIDToken              // Google이 ID 토큰을 주지 않음

        var errorDescription: String? {     // error.localizedDescription으로 보일 문구
            switch self {
            case .noPresentingScreen:
                return "로그인 화면을 띄울 수 없어요"
            case .noIDToken:
                return "Google에서 로그인 정보를 받지 못했어요"
            }
        }
    }

    // Google 로그인 실행 → 성공: 토큰 반환, 사용자가 취소: nil 반환, 그 외 문제: 오류 던짐
    static func signIn() async throws -> Tokens? {  // static func로 작성해 객체 생성 없이 GoogleSignInService.signIn() 함수 호출 가능
        guard let presenter = topViewController() else {    // topViewController() 함수로 화면부터 찾아야 do 수행 (guard)
            throw GoogleSignInError.noPresentingScreen
        }

        do {
            // Info.plist의 GIDClientID를 자동으로 읽어 Google 로그인 화면을 띄움
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenter)
            // GIDSignIn.sharedInstance.signIn(withPresenting: presenter)로 로그인 시트를 띄우고 사용자가 계정을 선택할 때까지 await로 대기

            guard let idToken = result.user.idToken?.tokenString else {
                // tokenString에서 토큰값을 꺼냄, 없으면 에러 throw
                throw GoogleSignInError.noIDToken
            }
            return Tokens(idToken: idToken,
                          accessToken: result.user.accessToken.tokenString)

        } catch let error as GIDSignInError where error.code == .canceled {
            return nil      // 사용자가 취소한 것은 오류가 아니므로 nil
        }
    }

    // Google 쪽 로그인 기록 지우기 (다음 로그인 때 계정을 다시 고를 수 있도록)
    static func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }

    // 지금 화면 맨 위에 떠 있는 UIViewController 찾기 (Google 로그인 화면을 그 위에 띄우기 위함)
    private static func topViewController() -> UIViewController? {
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }                        // 앱의 화면(Scene)들 중 창이 있는 것만
            .first { $0.activationState == .foregroundActive }          // 그중 지금 사용 중인 것

        var top = scene?.keyWindow?.rootViewController                  // 창의 가장 아래 화면에서 시작
        while let presented = top?.presentedViewController {            // 위에 다른 화면이 떠 있으면
            top = presented                                             // 한 칸씩 올라감
        }
        return top
    }
}
