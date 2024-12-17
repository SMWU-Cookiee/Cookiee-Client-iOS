//
//  TermsOfServiceViewModel.swift
//  Cookiee
//
//  Created by minseo Kyung on 12/17/24.
//

import Combine
import SwiftUI

class TermsOfServiceViewModel: ObservableObject {

    @Published var allPermit: Bool = false
    @Published var termsOfServicePermit: Bool = false
    @Published var privacyPolicyPermit: Bool = false

    private var allSelected = false
    private var store: [AnyCancellable] = []

    init() {
        $allPermit
            .sink { [weak self] newValue in
                guard let self = self else { return }

                if newValue && !allSelected {
                    allSelected = true
                    self.termsOfServicePermit = true
                    self.privacyPolicyPermit = true
                } else if !newValue && allSelected {
                    allSelected = false
                    self.termsOfServicePermit = false
                    self.privacyPolicyPermit = false
                }
            }
            .store(in: &store)

        Publishers.CombineLatest($termsOfServicePermit, $privacyPolicyPermit)
            .sink { [weak self] terms, privacy in
                guard let self = self else { return }

                if allSelected {
                    if self.allPermit {
                        allSelected = false
                        self.allPermit = false
                    }
                } else {
                    if terms && privacy {
                        self.allPermit = true
                    }
                }
            }
            .store(in: &store)
    }
}
