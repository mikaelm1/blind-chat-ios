# Blind Chat

A chat application built in Swift using Swift socketio [library](https://github.com/socketio/socket.io-client-swift) for client 
side chat functionality. Communicates with a Flask [backend](https://github.com/mikaelm1/blind-chat-api). 


<img src="https://cloud.githubusercontent.com/assets/16492296/19833772/65ae1d7c-9e03-11e6-9e52-757b23b9e5c7.gif" height="400" width="500" />


## Getting Started

### Setup Client Side
1. Either clone the repo or download the zip project.
2. `cd` into the directory where you downloaded the project and run`pod install`
3. Open the .xworkspace project
4. If you see a file called `APIKeys.swift` under Util directory, delete it
5. Find the IP address of youre computer ([instructions](http://www.wikihow.com/Find-Your-IP-Address-on-a-Mac)). Open `APIManager.swift` and change line 15 to:`private let localhost = "your ip address"`. Then open `ChatAPIManager.swift` and change line 16 to: `var socket = SocketIOClient(socketURL: URL(string: "http://yourIPAddress:5000")!)`

### Setup Backend
1. Go to the backend [repo](https://github.com/mikaelm1/blind-chat-api) and either clone or download it.
2. `cd` into the directory where you downloaded the project and run `virtualenv venv`
3. Then run `source venv/bin/activate`. This will activate the virtual environment created above.
4. While in the virtual environment, run `pip install -r requirements.txt`. This will install all the necessary dependencies 
5. Create a file called settings.py. Add the following to the file:
    ```
import os 

SECRET_KEY = 'supersecretpassword'
DEBUG = True 
DB_USERNAME = 'root'
DB_PASSWORD = ''
CHAT_DATABASE_NAME = 'chatdb'
DB_HOST = 'localhost'
DB_URI = "mysql+pymysql://%s:%s@%s/%s" % (DB_USERNAME, DB_PASSWORD, DB_HOST, CHAT_DATABASE_NAME)
SQLALCHEMY_DATABASE_URI = DB_URI
SQLALCHEMY_TRACK_MODIFICATIONS = True 

SERVER_HOST = "your ip address"
```
6. Run `python manage.py run`. If you don't get any errors, then the server is running. You can now run the iOS app, register and start chatting.
