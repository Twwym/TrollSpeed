//
//  HiddenContainerRecognizer.swift
//  
//
//  Created by Князьков Илья on 23.07.2022.
//

import UIKit

/// Recognize view, which can be hidden before system screenshot event did triggered, depend on `iOS version`
struct HiddenContainerRecognizer {

    // MARK: - Nested Types

    private enum Error: Swift.Error {
        case unsupportedIosVersion(version: Float)
        case desiredContainerWasNotFound(_ containerName: String)
    }

    // MARK: - Internal Methods

    func getHiddenContainer(from view: UIView) throws -> UIView {
        let containerName = try getHiddenContainerTypeInStringRepresentation()

        // Exact match for known iOS versions
        let exactMatches = view.subviews.filter { subview in
            type(of: subview).description() == containerName
        }
        if let container = exactMatches.first {
            return container
        }

        // iOS 17+ fallback: Apple renamed/restructured the secure canvas,
        // so fall back to any private canvas/content-like subview.
        let fuzzyMatches = view.subviews.filter { subview in
            let className = String(describing: type(of: subview))
            return className.hasPrefix("_")
                && (className.contains("Canvas") || className.contains("ContentView"))
        }
        if let container = fuzzyMatches.first {
            return container
        }

        throw Error.desiredContainerWasNotFound(containerName)
    }

    func getHiddenContainerTypeInStringRepresentation() throws -> String {
        
        if #available(iOS 15, *) {
            return "_UITextLayoutCanvasView"
        }

        if #available(iOS 14, *) {
            return "_UITextFieldCanvasView"
        }

        if #available(iOS 13, *) {
            return "_UITextFieldCanvasView"
        }

        if #available(iOS 12, *) {
            return "_UITextFieldContentView"
        }

        let currentIOSVersion = (UIDevice.current.systemVersion as NSString).floatValue
        throw Error.unsupportedIosVersion(version: currentIOSVersion)
    }

    func viewIsAlreadyInHiddenContainer(_ view: UIView) -> Bool {
        guard
            let containerClassName = try? getHiddenContainerTypeInStringRepresentation(),
            let superViewInspectableView = view.superview
        else {
            return false
        }

        let typeOfClassContainer = type(of: superViewInspectableView)
        let stringRepresentationOfClassContainer = String(describing: typeOfClassContainer.self)

        return stringRepresentationOfClassContainer == containerClassName
    }

}
