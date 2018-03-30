#import tst
import math

class Vector:
    def __init__(self,x,y,z):
        self.x = x
        self.y = y
        self.z = z
    
    def GetYaw(self):
        yaw = math.atan2(self.x, self.z) *180 / math.pi
        print(self.x, self.y, self.z, yaw)

Vector(1,0,0).GetYaw()
Vector(1,0,1).GetYaw()
Vector(0,0,1).GetYaw()
Vector(-1,0,0).GetYaw()
Vector(-1,0,-1).GetYaw()
Vector(0,0,-1).GetYaw()

a = 10
if a==11 or a== 5 or not (a==8 or a==9):
    print(a)
