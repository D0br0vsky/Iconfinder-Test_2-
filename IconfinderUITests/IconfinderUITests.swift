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
        
        XCTAssertEqual(searchBar.value as? String, searchQuery, "The text in search bar is different from the expected")
        
        let tableView = app.tables.firstMatch
        for _ in 1...5 {
            tableView.swipeUp()
        }
        
        let targetCell = tableView.cells.containing(.staticText, identifier:"retro | star").staticTexts["128 x 128"]
        if targetCell.waitForExistence(timeout: 5) {
            targetCell.tap()
        } else {
            XCTFail("Целевая ячейка не найдена после прокрутки")
        }
    }
}
