CS446 Project Pickup

Simple Setup Instructions

1. Checkout code from this repository: git clone https://git.uwaterloo.ca/pickup/frontend.git
2. If you have gem installed, skip to step 4 else go to step 3
3. a) Install homebrew - https://brew.sh/
   b) Install ruby via homebrew - https://www.ruby-lang.org/en/documentation/installation/#homebrew
4. Install cocoapods - https://guides.cocoapods.org/using/getting-started.html
5. Compile pods by running the command 'pod install' in terminal in the root directory of the project
   NOTE** cocoapods looks for packages specified in the 'Podfile' and the loads the assocaited packages
6. Open 'pickup.xcworkspace' to start the project 
   NOTE** do not use 'pickup.xcodeproj', this will not give you access to the right packages you imported via cocoapods
