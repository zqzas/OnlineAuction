#!/usr/bin/env python
'''
    Server side program
    Online Auction by Ma Hao
    2013.6.11
'''

import socket
port = 32332

TEST_MODE = True
DEBUG_MODE = True

class AuctionUser:
    def __init__(self):
        self.userName = ''
        self.userAddress = None
        self.currentRoom = None
        self.currentPrice = 0


    @classmethod
    def loginServer(cls, userName, userAddress):
        #a class method
        user = cls()
        user.userName = userName
        user.userAddress = userAddress
        return user

    def leaveServer(self):
        self.currentRoom = None
        self.currentPrice = 0

    def joinRoom(self, room):
        if self.currentRoom == None:
            self.currentRoom = room
            return True
        return False

    def leaveRoom(self):
        if self.currentRoom != None:
            self.currentRoom = None
            self.currentPrice = None
            return True
        return False

    def placeBid(self, price):
        #like above
        if self.currentRoom != None:
            if price > self.currentPrice:
                self.currentPrice = price
                return True
        return False

class AuctionRoom:
    def __init__(self, roomID = None, name = 'ExampleRoom'):
        self.roomID = roomID
        self.roomName = name
        self.currentPrice= 0
        self.bidHolder = None
        self.isClosed = False

    def placeBid(self, user, price):
        if price > self.currentPrice:
            self.currentPrice = price
            self.bidHolder = user
            return True
        return False

    def leaveRoom(self, user):
        if user == self.bidHolder:
            return False
        return True

    def closeRoom(self):
        self.isClosed = True

class UserArray:
    def __init__(self):
        self.userArray = []


    def findUser(self, address):
        for member in self.userArray:
            if member.userAddress == address:
                return member
        return None

    def userLeave(self, user):
        for member in self.userArray:
            if member.userAddress == user.userAddress:
                self.userArray.remove(member)
                return True
        return False

    def userLogin(self, user):
        self.userArray.append(user)

    def getUsersInSameRoom(self, room):
        answer = []
        for user in self.userArray:
            if user.currentRoom.roomID == room.roomID:
                answer.append(user)
        return answer


class RoomArray:
    def __init__(self):
        self.roomArray = []
        
    def addRoom(self, room):
        self.roomArray.append(room)

    def removeRoom(self, room):
        for obj in self.roomArray:
            if obj.roomID == room.roomID:
                self.roomArray.remove(obj)
                return True
        return False

    def getAllRooms(self):
        return [room for room in self.roomArray]

    def countRooms(self):
        return len(self.roomArray)

    def findRoom(self, roomID):
        roomID = int(roomID)
        for obj in self.roomArray:
            if obj.roomID == roomID:
                return obj
        return None





def parseCMD(data):
    if data[0] == '/':
        spacePos = data.find(' ')
        if spacePos == -1:
            (cmd, param) = (data, None)
        else:
            (cmd, param) = (data[ : spacePos], data[spacePos + 1 : ])
        return (cmd, param)
    return (None, None)

def makeResponse(data):
    response = ''
    for row in data:
        for col in row:
            response += str(col) + ' '
        response += '\n'
    return response



if __name__ == "__main__":
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    s.bind(("", port))

    print "waiting on port: ", port       

    userList = UserArray()
    roomList = RoomArray()

    if TEST_MODE:
        ''' for test
        '''
        testRoom = AuctionRoom(roomID = 0)
        roomList.addRoom(testRoom)



    while True:
        data, senderAddr = s.recvfrom(1024)
        print 'From ', senderAddr, ':  ', data

        (cmd, param) = parseCMD(data)
        response = ''
        alart = ''

        currentUser = userList.findUser(senderAddr)
        currentRoom = None

        if cmd == '/login':
            if currentUser == None: #if true, then valid new user
                user = AuctionUser.loginServer(param, senderAddr)
                userList.userLogin(user)
                currentUser = user
            response = 'OK'

        if currentUser != None:
            currentRoom = currentUser.currentRoom

            if cmd == '/auctions':
                allrooms = roomList.getAllRooms()
                response = makeResponse([(room.roomID, room.roomName, room.currentPrice) for room in allrooms])

            if cmd == '/join':
                if currentUser:
                    room = roomList.findRoom(param)
                    if room:
                        currentUser.joinRoom(room)
                        currentRoom = room
                        response = makeResponse([(room.roomName, room.currentPrice)])
                        print currentRoom



            if currentRoom != None:
                if cmd == '/list':
                    usersInSameRoom = userList.getUsersInSameRoom(currentRoom)
                    print currentRoom, usersInSameRoom
                    response = makeResponse([(user.userName, user.currentPrice) for user in usersInSameRoom])

                if cmd == '/bid':
                    price = int(param)
                    if currentUser.placeBid(price):
                        if currentRoom.placeBid(currentUser, price):
                            response = 'OK'
                            #need to send alart to the users in the same room
                            alart = '!A higher price %d from %s' % (price, currentUser.userName)


                if cmd == '/leave':
                    if currentUser.currentPrice == currentRoom.currentPrice:
                        alart = '!The holder of highest bid has left the auction.'
                        response = 'No'
                    else:
                        currentUser.leaveRoom()
                        userList.userLeave(currentUser)
                        currentRoom = None

        #send normal reply
        print 'Reply to ', senderAddr, ' : ', response
        s.sendto(response, senderAddr)

        #send alart
        if alart != '' and currentRoom != None:
            usersInSameRoom = userList.getUsersInSameRoom(currentRoom)
            for user in usersInSameRoom:
                s.sendto(alart, user.userAddress)


    print "This hell never happen."


