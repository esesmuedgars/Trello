# Trello

### Recources:
- [Trello API](https://developers.trello.com/docs/api-introduction);
  - [Authorization reference](https://developers.trello.com/page/authorization);
  - [Boards reference](https://developers.trello.com/reference#boards-2);
  - [Lists reference](https://developers.trello.com/reference#lists);
  - [Cards reference](https://developers.trello.com/reference#cards-1);
- [Assets]();

### Workflow:
- Create branch `develop` of `master` branch;
- Split assignment in multiple components and/or steps (_eg._ set-up environment, create user interface, implement fetching of user location, add networking layer, fetch weather data for current day, fetch weather forcaset for future days _etc._);
- For each component You will create seperate branch (_eg._ `component-x` branch), **one-at-a-time**, push changes to that branch and create pull request from `component-x` branch to `develop` branch. This way each component will be reviewed seperately inside pull request and `develop` branch will have only clean, reviewed code which will eventually build-up to complete application.

### Tips:
- Project has been pre-created;
- You'll have to add neccessary strings, for placeholders and use those while communicating with Trello application programming interface;
- Upon successful authorization with Trello API, token will be received via [`application(_:open:options:)`](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623112-application) in `AppDelegate` class. Token will be part of `URL` accessible via `url` parameter;
