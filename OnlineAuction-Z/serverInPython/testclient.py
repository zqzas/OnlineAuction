import socket

#addr = ('103.6.84.203', 32332)
addr = ('127.0.0.1', 32332)

msg = 'hello'

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

while True:
    msg = raw_input()
    print 'log: ready to send ', msg
    s.sendto(msg, addr)
    print 'log: send done'

    (reply, senderAddr) = s.recvfrom(1024)
    print '>>', reply
    
