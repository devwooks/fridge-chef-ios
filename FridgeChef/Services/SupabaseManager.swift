import Foundation
import Supabase

// Info.plist에 등록한 접속 정보를 읽어옴
enum SupabaseConfig {        // enum은 객체를 생성할 수 없어 상수 보관용으로 사용
    static let url : URL = { // 객체 생성 없이 상수 선언 let (변화 X), {}()는 {내부 코드}를 한번만 실행하고 이후 결과를 저장
        guard                // let host, !host.isEmpty, let url 3가지가 모두 실행되도록 통제 (모두 수행해야 함)
            let host = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_HOST") as? String,
                            // Bundle.main.object()로 해당 앱의 Info.plist에서 SUPABASE_HOST값을 거내 String으로 변환하여 host 상수로 저장
            !host.isEmpty,  // host 값이 비어있지 않은지 확인
            let url = URL(string: "https://\(host)")
        else{
            fatalError("SUPABASE_HOST가 없습니다. Secret.xcconfig와 Info.plist를 확인하세요.")
        }
        return url
    }()
    
    static let key : String = {
        guard
            let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_KEY") as? String,
            !key.isEmpty
        else {
            fatalError("SUPABASE_KEY가 없습니다. Secret.xcconfig와 Info.plist를 확인하세요.")
        }
        return key
    }()
}

// 앱 전체가 함께 쓰는 Supabase 접속 객체 (하나만 생성)
let supabase = SupabaseClient( // 전역 상수로 import 없이 supabase로 사용 가능
    supabaseURL : SupabaseConfig.url,
    supabaseKey : SupabaseConfig.key
)
