//
//  FridgeView.swift
//  FridgeChef
//
//  Created by 이성욱 on 11/25/26.
//

import SwiftUI

// 재료 관리 화면 (임시): 이후 Supabase의 ingredients_user 테이블과 연결해 재료 목록 조회·추가·수정·삭제

struct FridgeView: View {
    var body: some View {   // ContentUnavailableView는 ios가 제공하는 표준 빈 화면으로 아이콘, 제목, 설명을 배치 ex) 사진 앱에 사진이 비어 있거나 검색 결과가 없을 때 나오는 화면
        ContentUnavailableView("아직 등록된 재료가 없어요",
                               systemImage: "refrigerator",
                               description: Text("다음 단계에서 재료 추가 기능을 만들어요"))
            .navigationTitle("재료 관리")
    }
}

#Preview {
    NavigationStack {       // 미리보기에서 제목 표시줄을 보기 위해서만 감쌈
        FridgeView()
    }
}
