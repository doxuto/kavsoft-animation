//
//  Extensions.swift
//  MapsBottomSheet
//
//  Created by Balaji on 18/06/22.
//

import SwiftUI

// MARK: Custom View Extensions
// MARK: Custom Bottom Sheet Extracting From Native SwiftUI
extension View{
    @ViewBuilder
    func bottomSheet<Content: View>(
        presentationDetents: Set<PresentationDetent>,
        isPresented: Binding<Bool>,
        dragIndicator: Visibility = .visible,
        sheetCornerRadius: CGFloat?,
        largestUndimmedIdentifier: UISheetPresentationController.Detent.Identifier = .large,
        isTransparentBG: Bool = false,
        interactiveDisabled: Bool = true,
        @ViewBuilder content: @escaping ()->Content,
        onDismiss: @escaping ()->()
    )->some View{
        self
            .sheet(isPresented: isPresented) {
                onDismiss()
            } content: {
                if #available(iOS 16.4, *) {
                    content()
                        .presentationDetents(presentationDetents)
                        .presentationDragIndicator(dragIndicator)
                        .interactiveDismissDisabled(interactiveDisabled)
                        .presentationCornerRadius(sheetCornerRadius)
                        .presentationBackgroundInteraction(.enabled(upThrough: largestUndimmedIdentifier == .large ? .large : .medium))
                        .presentationBackground {
                            if isTransparentBG {
                                Rectangle()
                                    .fill(.clear)
                            }
                        }
                } else {
                    content()
                        .presentationDetents(presentationDetents)
                        .presentationDragIndicator(dragIndicator)
                        .interactiveDismissDisabled(interactiveDisabled)
                        .onAppear {
                            // MARK: Custom Code For Bottom Sheet
                            // Finding the Presented View Controller
                            guard let windows = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
                                return
                            }
                            
                            
                            if let controller = windows.windows.first?.rootViewController?.presentedViewController,let sheet = controller.presentationController as? UISheetPresentationController{
                                
                                // FOR TRANSPERNT BACKGROUND
                                if isTransparentBG{
                                    controller.view.backgroundColor = .clear
                                }
                                
                                // FROM THIS EXTRACTING PRESENTATION CONTROLLER
                                // SOME TIMES BUTTONS AND ACTIONS WILL BE TINTED IN HIDDEN FORM
                                // TO AVOID THIS
                                controller.presentingViewController?.view.tintAdjustmentMode = .normal
                                
                                // MARK: As Usual Set Properties What Ever Your Wish Here With Sheet Controller
                                sheet.largestUndimmedDetentIdentifier = largestUndimmedIdentifier
                                sheet.preferredCornerRadius = sheetCornerRadius
                            }else{
                                print("NO CONTROLLER FOUND")
                            }
                        }
                }
            }
    }
}
