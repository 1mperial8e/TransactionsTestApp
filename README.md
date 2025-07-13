# TransactionsTestApp

## Project architecture:
Classic MVVM with router. Communication between viewModel and views implemented using Combine and Input/Output events. Cons: a lot of code when using UIKit. Pros: easy to add new events, easy to test view models.

## Navigation
AppRouter manage all navigation, since the whole app is single flow. Once growing - router per flow is good approach, while main app router should manage app state and core navigation.

## Services

### Bitcoin rate service
Not sure what was the problem decribed in comments, but IMO that service in designed to fetch bitcoin rate only, which makes it a perfect place to log events after successful fetch.
The service publish current rate after every change, so every object can subcribe and monitor for rate changes.
Service also store last known rate to core data as required, however this is very bad practice because cached rate is always invalid.

### NetworkClient
Simple network client built using URLSession and async/await. Supports only requests which return Decodable but easy to extend for more use cases.
Enpoint is an easy way for each service to define network request rules.

### WalletService and TransactionsService
Convenience services to work with respective core data models. 

### DataStorage
Generic storage to manage core data entities.

### ServicesAssembler
TBH I didn't understand the goal of that object. It just stores "singleton" instances of services and solves just "easy access" use case, however it doesn't solve dependency injection at all.
I would add `Resolver` dependency to the project. Easy and nice way to manage services/clients, provides different injection mechanisms which allow easily inject mock/stub/spy in tests.

Refactoring `ServicesAssembler` into something like `Resolver` is a waste of time, so left it as it is.

### AnalyticsService
Typical analytics tracker. Not sure what was expected from `getEvents` method :)
Defined `AnalyticsEventName` and `AnalyticsParameterName` for convenience. Added couple of events in the app which track user behavior but not user's data.

## Design System
Each project should have some sort of design system which provide:
- Color palete
- Text styles
- Spacers/Corner radius
- ViewModifiers/styles
- UI Molecules

In test app DesignSystem simply provide some basic design configurations.

## Localisation
Used legacy `Localizable.strigs` as new strings catalog is not supported by `swiftgen`.

## Unit tests
Provided just exapmle of unit tests for 2 services. Remaining classes to test are: viewModels, Wallet/Transaction services. 

## Code comments
Minimum comments in code, as code must be self explanatory. 
