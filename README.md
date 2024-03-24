# iOS - take-home assignment

The objective of this project is to develop an iOS app using Swift, which will fetch a contact list from an API, cache it, and display the contacts. The app's user interface should closely resemble the design provided in the XD link. The code for this project should be hosted on GitHub or another public Git repository.

Please don’t spend more than 2 hours of your time on this project.

## Design
This is the contact list we currently have in Pago for the Money Transfer section: https://xd.adobe.com/view/4b6d936d-bc40-4d3f-ba3c-a6d7195ffe6d-1e3e/

## App requirements
- Make the API request (GET https://gorest.co.in/public/v2/users) and filter out the inactive contacts.
- Display the active contacts’ names in a list
- If the id of the user is even, the logo should be formed by the initials of the user (ex: Johnny Cage, should be JC)
- If the id of the user is odd, you should download an image from https://picsum.photos/200/200 and display it
- Use a common architecture like MVVM or MV
- Have at least one relevant unit test
  
## Bonus points if you:
- Create a cache mechanism so when you open the app a second time, you don’t need to do an API request.
- Use SwiftUI
- Have a commit history for the project
