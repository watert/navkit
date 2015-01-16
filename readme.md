webview-navkit
==============

inspired by iOS SDK UINavigationController, provides mobile first navigation controll features, 


## Features

- Views/Dom/HTML pushing/popping
- Swipe from edge navigation back feature
- Navbar title and buttons control
- Extendable PageView as page controller, and navbar instance as its property
- Based on `jQuery` like DOM lib only

## quick start:

```coffeescript
navbar = $(selector).navbar()
navbar.push($dom)
navbar.pop()
```

## events

- `push(e,pageView,nav)`
- `pop(e,pageView,nav)`
- `show(e,pageView,nav)`
- `shown(e,pageView,nav)`
- `dismiss(e,pageView,nav)`
- `dismissed(e,pageView,nav)`

## init options:

- `animate: true|false`, default `true`

## methods

- `push($dom, options)`: push dom to stack with options:
	- init: function when initializing the view
	- title: string sets title
- `pop(options)`: pop dom to back
- `setTitle(titleString)`