from flask import Flask
from flask import json
from flask import request, redirect, url_for
from tinydb import TinyDB, Query
import base64

app = Flask(__name__)

@app.route('/', methods=['POST'])
def index():
    json = request.get_json(force=True)
    accesstype = json['type']
    db = TinyDB('hitch.json')
    # SIGN IN
    if accesstype == 'signin':
        name = json['username']
        password = json['password']
        db = TinyDB('hitch.json')
        User = Query()
        if len(db.search(User.rideFounder == name)) == 0:
            print("Error: No user for the name")
            return("Error: No user for the name")
        else:
            returneddata = db.search(User.rideFounder == name)
            userInfo = returneddata[0]
            if userInfo['password'] == password:
                print("Success")
                return("Success")
            else:
                print("Error: Incorrect Password")
                return("Error: Incorrect Password")
    # SIGN UP
    if accesstype == 'signup':
        name = json['username']
        password = json['password']
        print("Username: {0} \nPassword: {1}".format(name,password))
        db = TinyDB('hitch.json')
        User = Query()
        if len(db.search(User.rideFounder == name)) == 0:
            db.insert({'image': '', 'rideFounder': name, 'password': password, 'friends': '', 'what': '', 'from': '', 'to': ''})
            print('Thanks for signing up, %s' % name)
            return 'Success'
        else:
            print("Already a user with that name")
            return 'Already a user with that name'
    # SAVE IMAGE
    if accesstype == 'imageUpload':
        imageString = json['imageString']
        name = json['username']
        db = TinyDB('hitch.json')
        User = Query()
        if len(db.search(User.rideFounder == name)) == 0:
            db.update({'image': imageString})
            return 'Succes'
    # POST RIDE
    if accesstype == 'postDrive':
        name = json['username']
        zipFrom = json['from']
        textForm = json['text']
        timetextForm = json['time']
        zipTo = json['to']
        when = json['date']
        seats = json['seats']
        cost = json['cost']
        rideID = json['rideID']
        ridedb = TinyDB('rides.json')
        ridedb.insert({'rideFounder': name, 'riderNames': '', 'messages' : '','id': rideID, 'cost': cost,'plainText': textForm, 'plainTime' : timetextForm,'rideFrom': zipFrom, 'rideTo': zipTo, 'date': float(when), 'seats': int(seats), 'riders': int(0)})
        print 'Success: Ride Posted'
        return 'Ride Request Posted'
    # APPLY FOR RIDE
    if accesstype == 'applyRide':
        # ADD CODE TO NOTIFY DRIVER HERE!!!!!
        temprideid = json['rideID']
        rider = json['rider']
        Search = Query()
        ridedb = TinyDB('rides.json')
        returneddata = ridedb.search(Search.id == temprideid)
        userInfo = returneddata[0]
        name = userInfo['rideFounder']
        zipFrom = userInfo['rideFrom']
        textForm = userInfo['plainText']
        timetextForm = userInfo['plainTime']
        zipTo = userInfo['rideTo']
        when = userInfo['date']
        seats = userInfo['seats']
        cost = userInfo['cost']
        ridedb = TinyDB('pendingrides.json')
        ridedb.insert({'rideFounder': name, 'applicant': rider,'id': temprideid, 'cost': cost,'plainText': textForm, 'plainTime' : timetextForm,'rideFrom': zipFrom, 'rideTo': zipTo, 'date': float(when), 'seats': int(seats), 'riders': int(0)})
        print 'Success: Ride Requested'
        return 'Ride Request Posted'
    # CHECK IF ALREADY APPLIED
    if accesstype == 'didAlreadyApply':
        rider = json['rider']
        Search = Query()
        ridedb = TinyDB('pendingrides.json')
        returneddata = ridedb.search(Search.applicant == rider)
        if len(returneddata) == 0:
            print("No Applicant")
            return "N"
        else:
            print("Already applied, restricting applications")
            return "Y"
    # CONFIRM APPLICATION
    if accesstype == 'confirmRequest':
        name = json['user']
        applicant = json['applicant']
        rideID = json['rideID']
        ridedb = TinyDB('rides.json')
        Search = Query()
        returneddata = ridedb.search(Search.id == rideID)
        rideObject = returneddata[0]
        riderNames = rideObject['riderNames'] + applicant + '%'
        riderCount = int(rideObject['riders']) + 1
        ridedb.update({'riderNames': riderNames}, Search.id == rideID)
        ridedb.update({'riders': int(riderCount)}, Search.id == rideID)
        pendingdb = TinyDB('pendingrides.json')
        pendingSearch = Query()
        pendingdb.remove(pendingSearch.id == rideID)
        print 'Success: Ride Confirmed'
        return 'Ride Request Posted'
    # SEND MESSAGE
    if accesstype == 'sendMessage':
        sender = json['sender']
        reciever = json['reciever']
        text = json['message']
        ridedb = TinyDB('messages.json')
        ridedb.insert({'sender': sender, 'reciever': reciever, 'message': text})
        print 'Success: Message Sent'
        return 'Message Sent'
    # GET CONVERSATIONS
    if accesstype == 'getConversations':
        drive = json['currentUser']
        ridedb = TinyDB('messages.json')
        Search = Query()
        returneddata = ridedb.search((Search.reciever == drive) | (Search.sender == drive))
        if returneddata != 0:
            returnObjects = ''
            for i in returneddata:
                myList = [i['reciever'], i['sender']]
                myList.sort()
                returnObjects = returnObjects + myList[0] + ':' + myList[1] + '~'
            print "Found " + str(len(returneddata)) + " Messages"
            return returnObjects
        print 'Error: No Messages'
        return 'Error: No Messages'
    # GET MESSAGES
    if accesstype == 'getMessages':
        personA = json['personA']
        personB = json['personB']
        ridedb = TinyDB('messages.json')
        Search = Query()
        returneddata = ridedb.search(((Search.reciever == personA) | (Search.reciever == personB)) & ((Search.sender == personA) | (Search.sender == personB)))
        if returneddata != 0:
            print "Found " + str(len(returneddata)) + " Messages"
            returnObjects = ''
            for i in returneddata:
                myList = [i['sender'], i['message'], i['reciever']]
                returnObjects = returnObjects + myList[0] + ':' + myList[1] +':'+ myList[2] + '~'
            return returnObjects
            print returnObjects
        print 'Error: No Messages'
        return 'Error: No Messages'
    # GET RIDE
    if accesstype == 'getRide':
        ridedb = TinyDB('rides.json')
        rideID = json['ID']
        Search = Query()
        returneddata = ridedb.search(Search.id == rideID)
        if returneddata != 0:
            returnObjects = ''
            for i in returneddata:
                currentObject = i
                returnObjects = returnObjects + currentObject['rideFounder'] + '~'
                returnObjects = returnObjects + currentObject['plainText'] + '~'
                returnObjects = returnObjects + str(currentObject['rideFrom']) + '~'
                returnObjects = returnObjects + str(currentObject['rideTo']) + '~'
                returnObjects = returnObjects + str(currentObject['date']) + '~'
                returnObjects = returnObjects + str(currentObject['cost']) + '~'
                returnObjects = returnObjects + str(currentObject['seats'])
            print "Success: Found Ride"
            return returnObjects
        else:
            print 'Error'
            return 'Error'
    # GET TRIP
    if accesstype == 'getTripPage':
        ridedb = TinyDB('rides.json')
        rideID = json['ID']
        Search = Query()
        returneddata = ridedb.search(Search.id == rideID)
        if returneddata != 0:
            returnObjects = ''
            for i in returneddata:
                currentObject = i
                returnObjects = returnObjects + currentObject['rideFounder'] + '~' # 0
                returnObjects = returnObjects + currentObject['plainText'] + '~' # 1
                returnObjects = returnObjects + str(currentObject['rideFrom']) + '~' # 2
                returnObjects = returnObjects + str(currentObject['rideTo']) + '~' # 3
                returnObjects = returnObjects + str(currentObject['date']) + '~' # 4
                returnObjects = returnObjects + str(currentObject['cost']) + '~' # 5
                returnObjects = returnObjects + currentObject['messages'] + '~' # 6
                returnObjects = returnObjects + currentObject['riderNames'] + '~' # 7
                returnObjects = returnObjects + str(currentObject['riders']) + '~' # 8
                returnObjects = returnObjects + str(currentObject['seats']) # 9
            print "Success: Found Ride"
            return returnObjects
        else:
            print 'Error'
            return 'Error'
    # SEND GROUP MESSAGE
    if accesstype == 'sendGroupMessage':
        sender = json['sender']
        rideID = json['rideID']
        message = json['message']
        ridedb = TinyDB('rides.json')
        Search = Query()
        returneddata = ridedb.search(Search.id == rideID)
        rideObject = returneddata[0]
        messages = rideObject['messages']
        messages = messages + message + '&&' + sender + '%'
        ridedb.update({'messages': messages}, Search.id == rideID)
        print 'Success: Message Sent'
        return messages
    # SEARCH MY RIDES
    if accesstype == 'myTrips':
        returnObjects = ''
        user = json['user']
        pendingdb = TinyDB('pendingrides.json')
        Request = Query()
        if pendingdb.contains(Request.rideFounder == user):
            returnObjects = returnObjects + 'Y' + '~'
        else:
            returnObjects = returnObjects + 'N' + '~'
        Search = Query()
        pendingdata = pendingdb.search(Search.applicant == user)
        confirmeddb = TinyDB('rides.json')
        Search = Query()
        confirmeddata = confirmeddb.search(((Search.applicant == user) | (Search.rideFounder == user)) & (Search.riders > 0))
        tripCount = len(pendingdata) + len(confirmeddata)
        returnObjects = returnObjects + str(tripCount) + '~'
        if pendingdata != 0:
            for i in pendingdata:
                currentObject = i
                returnObjects = returnObjects + currentObject['rideFounder'] + '~'
                returnObjects = returnObjects + currentObject['plainText'] + '~'
                returnObjects = returnObjects + currentObject['plainTime'] + '~'
                returnObjects = returnObjects + str(currentObject['rideFrom']) + '~'
                returnObjects = returnObjects + str(currentObject['rideTo']) + '~'
                returnObjects = returnObjects + str(currentObject['date']) + '~'
                returnObjects = returnObjects + str(currentObject['cost']) + '~'
                returnObjects = returnObjects + str(currentObject['seats']) + '~'
                returnObjects = returnObjects + str(currentObject['id']) + '~'
                returnObjects = returnObjects + str(currentObject['riders']) + '~'
                returnObjects = returnObjects + 'PENDING' + '~'
        if confirmeddata != 0:
            for i in confirmeddata:
                currentObject = i
                returnObjects = returnObjects + currentObject['rideFounder'] + '~'
                returnObjects = returnObjects + currentObject['plainText'] + '~'
                returnObjects = returnObjects + currentObject['plainTime'] + '~'
                returnObjects = returnObjects + str(currentObject['rideFrom']) + '~'
                returnObjects = returnObjects + str(currentObject['rideTo']) + '~'
                returnObjects = returnObjects + str(currentObject['date']) + '~'
                returnObjects = returnObjects + str(currentObject['cost']) + '~'
                returnObjects = returnObjects + str(currentObject['seats']) + '~'
                returnObjects = returnObjects + str(currentObject['id']) + '~'
                returnObjects = returnObjects + str(currentObject['riders']) + '~'
                returnObjects = returnObjects + 'CONFIRMED' + '~'
            print returnObjects
            return returnObjects
        else:
            print 'Error'
            return 'Error'
    # GET MY REQUESTS
    if accesstype == 'myRequests':
        returnObjects = ''
        user = json['user']
        ridedb = TinyDB('pendingrides.json')
        Search = Query()
        returneddata = ridedb.search(Search.rideFounder == user)
        returnObjects = returnObjects + str(len(returneddata)) + '~'
        if returneddata != 0:
            for i in returneddata:
                currentObject = i
                returnObjects = returnObjects + currentObject['applicant'] + '~'
                returnObjects = returnObjects + str(currentObject['id']) + '~'
                returnObjects = returnObjects + currentObject['plainTime'] + '~'
            print returnObjects
            return returnObjects
        else:
            print 'Error'
            return 'Error'
    # SEARCH RIDES
    if accesstype == 'queryRides':
        ridedb = TinyDB('rides.json')
        zipFrom = int(json['from'])
        zipTo = int(json['to'])
        toUpper = zipTo + 10
        toLower = zipTo - 10
        fromUpper = zipFrom + 10
        fromLower = zipFrom - 10
        Search = Query()
        if zipTo == 0:
            returneddata = ridedb.search(Search.rideFrom == zipFrom)
            if returneddata != 0:
                returnObjects = ''
                for i in returneddata:
                    currentObject = i
                    returnObjects = returnObjects + currentObject['rideFounder'] + '~'
                    returnObjects = returnObjects + currentObject['plainText'] + '~'
                    returnObjects = returnObjects + currentObject['plainTime'] + '~'
                    returnObjects = returnObjects + currentObject['id'] + '~'
                    returnObjects = returnObjects + str(currentObject['cost']) + '~'
                    returnObjects = returnObjects + str(currentObject['seats']) + '%'
                print "Success: Found Rides"
                return returnObjects
            else:
                print 'Error'
                return 'Error'
        else:
            returneddata = ridedb.search((Search.rideFrom == zipFrom) & (Search.rideTo == zipTo))
            if returneddata != 0:
                print "Found " + str(len(returneddata)) + " Rides:"
                returnObjects = ''
                for i in returneddata:
                    currentObject = i
                    returnObjects = returnObjects + currentObject['rideFounder'] + '~'
                    returnObjects = returnObjects + currentObject['plainText'] + '~'
                    returnObjects = returnObjects + currentObject['plainTime'] + '~'
                    returnObjects = returnObjects + currentObject['id'] + '~'
                    returnObjects = returnObjects + str(currentObject['cost']) + '~'
                    returnObjects = returnObjects + str(currentObject['seats']) + '%'
                print "Success: Found Rides"
                return returnObjects
            else:
                print 'Error'
                return 'Error'




if __name__ == "__main__":
    app.run(debug = True)
