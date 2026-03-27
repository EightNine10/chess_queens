# chess_queens
N-Queens Puzzle Game

Peter Rutherford
Application for iOS Developer position at Chess.com

** Overview ***
The app uses a simple MVVM-style architecture with a clear split between menu and gameplay.

MainMenuView handles board selection and best-time display, while GameView creates and
presents the active game through GameViewModel, which owns the core game state and logic.

From there, data flows into smaller views like BoardView, BoardSquareView,
GameTimerView, and WinPopupView, keeping the UI modular and the logic centralized.


*** Building/Running ***
- Open the project in Xcode, build/run from the Queens scheme


*** Testing ***
- Unit Test files are:
    GameTimerTests.swift        - Covers Game Timer Tests
    GameViewModelTests.swift    - Covers Game Logic Tests
    StringTests.swift           - Covers Time Format tests


*** Architecture Decisions ***
- Used an MVVM-style structure, with SwiftUI views handling presentation and input,
  and GameViewModel handling gameplay state and rules

- App Flow
  - QueensApp is the app entry point and loads MainMenuView
  - MainMenuView owns menu-specific state such as the selected board size and loaded best times
  - MainMenuView displays the list of board sizes in MenuButtonView Views
  - Each MenuButtonView loads the GameView for a given board size
  - GameView owns the active game screen and creates the GameViewModel for the chosen board size

- Game View
  - BoardView for the grid
  - GameTimerView for the timer display
  - WinPopupView for the win overlay
  - BoardView builds the board by creating a BoardSquareView for each square
  - BoardView Passes data downward into focused child views, so views like stay lightweight and presentation-focused.

- Data
  - Stores queen positions in a Set<SquarePos> for simple updates and fast lookups.
  - Stores best times with lightweight persistence through UserDefaults.

- Testing
  - Used protocol-based abstractions for sound and best-time storage to improve testability.

 
*** AI-Code Generation Tool Disclosures
- Assisted with View Modifiers to obtain the look/design I wanted
- Assisted with Timer Task logic in GameTimer class
- Assisted with animation sequencing
- Assisted with algorithm to help write 'onLineBetween' method in GameViewModel
- Assisted with appropriate Unit Testing scope
