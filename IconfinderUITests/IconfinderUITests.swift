import XCTest

final class IconfinderUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testValueNotFoundSearch() {
        let searchBar = app.searchFields["Start your search ..."]
        searchBar.tap()
        let searchQuery = "starstarstarstarstarstar"
        searchBar.typeText(searchQuery)
        XCTAssertEqual(searchBar.value as? String, searchQuery, "The text in Usearchbar is different from the expected")
    }
    
    func testSuccessfulQuerySearchSwipe() throws {
        let searchBar = app.searchFields["Start your search ..."]
        searchBar.tap()
        let searchQuery = "Star"
        searchBar.typeText(searchQuery)
        XCTAssertEqual(searchBar.value as? String, searchQuery, "The text in Usearchbar is different from the expected")
        let element = app.collectionViews.children(matching: .cell).element(boundBy: 1).children(matching: .other).element
        element.swipeUp()
        element.children(matching: .other).element.swipeUp()
    }
}
