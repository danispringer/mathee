//
//  MatemagicaScreenshots.swift
//  MatemagicaScreenshots
//
//  Created by dani on 5/20/22.
//  Copyright © 2022 Dani Springer. All rights reserved.
//

import XCTest

class MatemagicaScreenshots: XCTestCase {

    // xcodebuild -testLanguage en -scheme Matemagica -project ./Matemagica.xcodeproj -derivedDataPath
    // '/tmp/MatemagicaDerivedData/' -destination "platform=iOS Simulator,name=iPhone 13 Pro Max" build test
    // https://blog.winsmith.de/english/ios/2020/04/14/xcuitest-screenshots.html

    var app: XCUIApplication!

    let aList = ["Shabbos", "Spot it", "Guess it"]


    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()

        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--matemagicaScreenshots")
    }


    func anAction(word: String) {
        let tablesQuery = app.tables
        let aThing = tablesQuery.cells.staticTexts[word]
        XCTAssertTrue(aThing.waitForExistence(timeout: 5))
        aThing.tap()
        switch word {
            case "Shabbos":
                XCTAssertTrue(app.staticTexts["⭐️ Level 1"].firstMatch.waitForExistence(timeout: 5))
                takeScreenshot(named: "Shabbos-levels")
                app.swipeUp()
                app.swipeUp()
                XCTAssertTrue(app.staticTexts["⭐️ Level 10"].firstMatch.waitForExistence(timeout: 5))
                app.staticTexts["⭐️ Level 10"].firstMatch.tap()
                for _ in 0...4 {
                    XCTAssertTrue(app.buttons["Nope"].firstMatch.waitForExistence(timeout: 5))
                    app.buttons["Nope"].firstMatch.tap()
                }
                takeScreenshot(named: "Shabbos-game-middle")
                XCTAssertTrue(app.buttons["Play Again"].firstMatch.waitForExistence(timeout: 20))
                takeScreenshot(named: "Shabbos-game-over")
                app.buttons["Choose a Level"].firstMatch.tap()
                app.buttons["Math Magic"].firstMatch.tap()
            case "Guess it":
                XCTAssertTrue(app.buttons["OK"].firstMatch.waitForExistence(timeout: 5))
                takeScreenshot(named: "Guess-it-think")
                app.buttons["OK"].firstMatch.tap()
                takeScreenshot(named: "Guess-it-multiply")
                app.buttons["OK"].firstMatch.tap()
                app.buttons["Even"].firstMatch.tap()
                app.buttons["OK"].firstMatch.tap() // /2 1
                app.buttons["OK"].firstMatch.tap() // x3 2
                app.buttons["Odd"].firstMatch.tap()
                app.buttons["OK"].firstMatch.tap() // add 1
                app.buttons["OK"].firstMatch.tap() // /2 2
                app.textFields.firstMatch.typeText("6")
                app.buttons["Guess my number"].firstMatch.tap()
                takeScreenshot(named: "Guess-it-result")
                app.buttons["Done"].firstMatch.tap()
            case "Spot it":
                XCTAssertTrue(app.buttons["OK"].firstMatch.waitForExistence(timeout: 5))
                app.buttons["OK"].firstMatch.tap()
                app.buttons["Yes"].firstMatch.tap()
                app.buttons["Yes"].firstMatch.tap()
                app.buttons["Yes"].firstMatch.tap()
                takeScreenshot(named: "Spot-it")
                app.buttons["Math Magic"].firstMatch.tap()
            default:
                fatalError()
        }
    }


    func testMakeScreenshots() {
        app.launch()

        // Home
        takeScreenshot(named: "Home")

        for aItem in aList {
            anAction(word: aItem)
        }

    }


    func takeScreenshot(named name: String) {
        // Take the screenshot
        let fullScreenshot = XCUIScreen.main.screenshot()

        // Create a new attachment to save our screenshot
        // and give it a name consisting of the "named"
        // parameter and the device name, so we can find
        // it later.
        let screenshotAttachment = XCTAttachment(
            uniformTypeIdentifier: "public.png",
            name: "Screenshot-\(UIDevice.current.name)-\(name).png",
            payload: fullScreenshot.pngRepresentation,
            userInfo: nil)

        // Usually Xcode will delete attachments after
        // the test has run; we don't want that!
        screenshotAttachment.lifetime = .keepAlways

        // Add the attachment to the test log,
        // so we can retrieve it later
        add(screenshotAttachment)
    }

}
