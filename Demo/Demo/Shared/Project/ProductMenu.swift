//
//  ProductMenu.swift
//  Demo
//
//  Created by nori on 2021/07/04.
//

import SwiftUI

struct ProductMenu: View {
    var body: some View {
        ProductList()
            .navigationTitle("Menu")
    }
}

struct ProductMenu_Previews: PreviewProvider {
    static var previews: some View {
        ProductMenu()
    }
}
