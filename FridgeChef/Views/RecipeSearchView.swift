//
//  RecipeSearchView.swift
//  FridgeChef
//
//  Created by 이성욱 on 11/25/26.
//

import SwiftUI

// 레시피 검색 화면 (임시): 이후 재료 사전(ingredients_master)에서 재료를 골라 만들 수 있는 레시피 검색

struct RecipeSearchView: View {
    var body: some View {
        ContentUnavailableView("레시피 검색 준비 중",
                               systemImage: "magnifyingglass",
                               description: Text("냉장고 재료로 만들 수 있는 요리를 찾아줄 예정이에요"))
            .navigationTitle("레시피 검색")
    }
}

#Preview {
    NavigationStack {
        RecipeSearchView()
    }
}
