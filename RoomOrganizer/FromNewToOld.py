import math
from NewRoomModel import *
import json
import pygame
import numpy as np
def drawRects(majorAngle, minAngle,rects,walls_dimensions,Surfaces):
    WallRects=[]

    for pos, rect in enumerate(rects):
        angle = round((majorAngle+minAngle[pos])%360)
        
        if abs(angle) == 0 or abs(angle) == 180 or abs(angle)== 360:
            rect.width=walls_dimensions[pos][0]
            rect.height=1
            temprect = Surfaces[pos].get_rect()
            WallRects.append(pygame.Rect(rect.centerx-rect.width/2,rect.centery+(temprect.height/2),rect.width,rect.height))

        else:
            rect.width=1
            rect.height=walls_dimensions[pos][0]
            temprect = Surfaces[pos].get_rect()
            WallRects.append(pygame.Rect(rect.centerx+(temprect.width/2),rect.centery-rect.height/2,rect.width,rect.height))
            # return a list of rects not one  
        
    print(WallRects)
    return WallRects
def drawRects2(majorAngle, RectAngle,rects,walls_dimensions,Surfaces,state4):
    WallRects=[]
    
    for pos, rect in enumerate(rects):
        angle = round((majorAngle+RectAngle[pos])%360)


        if abs(angle) == 0 or abs(angle) == 180 or abs(angle)== 360:
            rect.width=walls_dimensions[pos][0]
            rect.height=walls_dimensions[pos][1]
            temprect = Surfaces[pos].get_rect()
            edgeX = state4[pos].width-Surfaces[pos].get_width()
            edgeY = state4[pos].height-Surfaces[pos].get_height()
            WallRects.append(pygame.Rect(rect.centerx-rect.width/2-edgeX/2 ,rect.centery-rect.height/2-edgeY/2,rect.width,rect.height))

            
        else:
            rect.width=walls_dimensions[pos][1]
            rect.height=walls_dimensions[pos][0]
            edgeX = state4[pos].width-Surfaces[pos].get_width()
            edgeY = state4[pos].height-Surfaces[pos].get_height()
            WallRects.append(pygame.Rect(rect.centerx-rect.width/2-edgeX/2,rect.centery-rect.height/2-edgeY/2,rect.width,rect.height))
            
            # return a list of rects not one  

        print(edgeX)
        # print("first is chair:",WallRects[pos].center)
    return WallRects
            

def intitRoomShape(angle,rotations,positions,dimensions,Categories,offsetX,offsetZ,scale_factor):
    WallsSurfaces=[]
    state3=positions
    state4 = []
    sumX=0
    sumZ=0
    TempWalls=[[pygame.Surface((0, 0))] for _ in range(len(dimensions))]
    for i in range(len(rotations)):
        # print(self.walls_dimensions[i][1])
        image_orig = pygame.Surface((dimensions[i][0], 1))
        image_orig.set_colorkey((0, 0, 0))
        # for making transparent background while rotating an image
        color = (55, 100, 0) if Categories[i]=="wall" else (0, 200, 0) if Categories[i]=="door" else (0, 0, 200)
        # fill the rectangle / surface with green color
        image_orig.fill(color)
        # creating a copy of orignal image for smooth rotation
        
        # define rect for placing the rectangle at the desired position
        rect = image_orig.get_rect()
        
        rect.center = ((positions[i][0]),
                    (positions[i][1]))

        # keep rotating the rectangle until running is set to False

        # set FPS

        # clear the screen every time before drawing new objects

        # making a copy of the old center of the rectangle
        old_center = rect.center
        # defining angle of the rotation
        
        # rotating the orignal image
        
        TempWalls[i] = pygame.transform.rotate(image_orig, rotations[i])
        


        rect = TempWalls[i].get_rect()
        # set the rotated rectangle to the old center
        rect.center = old_center
        sumX+=rect.centerx
        sumZ+=rect.centery
        # drawing the rotated rectangle to the screen
        # self.screen.blit(new_image, rect)
        # TempWalls.append(TempWalls[i])

    pivot= (sumX/len(list(filter(lambda a: a =="wall", Categories))),sumZ/len(list(filter(lambda a: a =="wall", Categories))))

    # New x-coordinate = (x - a)*cos(θ) - (y - b)*sin(θ) + a

    # New y-coordinate = (x - a)*sin(θ) + (y - b)*cos(θ) + b
    for i in range(len(rotations)):
        rect = TempWalls[i].get_rect()
        rect.center = ((positions[i][0]+offsetX)*scale_factor,
                    (positions[i][1]+offsetZ)*scale_factor)
        
        old_center = rect.center
        TempWalls[i]= pygame.transform.rotate(TempWalls[i], angle)
        rect.center = old_center
        TempWalls[i].set_colorkey((0, 0, 0))
        

        x_coordinate = (rect.centerx - pivot[0])*math.cos(np.radians(angle)) + (rect.centery - pivot[1])*math.sin(np.radians(angle)) + pivot[0]

        
        z_coordinate = (rect.centerx - pivot[0])*math.sin(np.radians(angle)) - (rect.centery - pivot[1])*math.cos(np.radians(angle)) - pivot[1]

        rect.center=[(x_coordinate)-(TempWalls[i].get_width()/2-rect.width/2),((z_coordinate)*-1)-(TempWalls[i].get_height()/2-rect.height/2)]

        

        state3[i]=rect.center
        WallsSurfaces.append(TempWalls[i])
        state4.append(rect)

    return state3,state4,WallsSurfaces,pivot
def intitFurnitureShape(angle,rotations,positions,dimensions,Categories,offsetX,offsetZ,scale_factor,pivot):
    WallsSurfaces=[]
    state3=positions
    state4 = []
    sumX=0
    sumZ=0
    TempWalls=[[pygame.Surface((0, 0))] for _ in range(len(dimensions))]
    for i in range(len(rotations)):
        # print(self.walls_dimensions[i][1])
        image_orig = pygame.Surface((dimensions[i][0], dimensions[i][1]))
        
        image_orig.set_colorkey((0, 0, 0))
        # for making transparent background while rotating an image
        color = (55, 100, 0) if Categories[i]=="wall" else (0, 200, 0) if Categories[i]=="door" else (0, 0, 200)
        # fill the rectangle / surface with green color
        image_orig.fill(color)
        # creating a copy of orignal image for smooth rotation
        
        # define rect for placing the rectangle at the desired position
        rect = image_orig.get_rect()
        
        rect.center = ((positions[i][0]+offsetX)*scale_factor,
                    (positions[i][1]+offsetZ)*scale_factor)
        # keep rotating the rectangle until running is set to False

        # set FPS

        # clear the screen every time before drawing new objects

        # making a copy of the old center of the rectangle
        old_center = rect.center
        # defining angle of the rotation
        
        # rotating the orignal image
        
        TempWalls[i] = pygame.transform.rotate(image_orig, rotations[i])
        


        rect = TempWalls[i].get_rect()
        # set the rotated rectangle to the old center
        rect.center = old_center
        sumX+=rect.centerx
        sumZ+=rect.centery
        # drawing the rotated rectangle to the screen
        # self.screen.blit(new_image, rect)
        # TempWalls.append(TempWalls[i])



    # New x-coordinate = (x - a)*cos(θ) - (y - b)*sin(θ) + a

    # New y-coordinate = (x - a)*sin(θ) + (y - b)*cos(θ) + b
    for i in range(len(rotations)):
        rect = TempWalls[i].get_rect()
        rect.center = ((positions[i][0]+offsetX)*scale_factor,
                    (positions[i][1]+offsetZ)*scale_factor)
        
        old_center = rect.center
        TempWalls[i]= pygame.transform.rotate(TempWalls[i], angle)
        rect.center = old_center
        TempWalls[i].set_colorkey((0, 0, 0))
        

        x_coordinate = (rect.centerx - pivot[0])*math.cos(np.radians(angle)) + (rect.centery - pivot[1])*math.sin(np.radians(angle)) + pivot[0]

        
        z_coordinate = (rect.centerx - pivot[0])*math.sin(np.radians(angle)) - (rect.centery - pivot[1])*math.cos(np.radians(angle)) - pivot[1]
        
        rect.center=[(x_coordinate)-(TempWalls[i].get_width()/2-rect.width/2),((z_coordinate)*-1)-(TempWalls[i].get_height()/2-rect.height/2)]

        

        state3[i]=rect.center
        WallsSurfaces.append(TempWalls[i])
        state4.append(rect)

    return state3,state4,WallsSurfaces

def ExtractFurniturePosition(rects,angle,pivot):

    transform12=[]
    transform14=[]
    for pos,rect in enumerate(rects):
        print(pos,rect.center)
        
        x_coordinate = (rect.centerx - pivot[0])*math.cos(np.radians(-angle)) + (rect.centery - pivot[1])*math.sin(np.radians(-angle)) + pivot[0]

        
        z_coordinate = (rect.centerx - pivot[0])*math.sin(np.radians(-angle)) - (rect.centery - pivot[1])*math.cos(np.radians(-angle)) - pivot[1]
        print(pos,"x coord: ",x_coordinate,"z coord:",z_coordinate)
        transform12.append(x_coordinate)
        transform14.append(z_coordinate*-1)
    return transform12,transform14




def filter_list(lst, value):
    result = []
    for item in lst:
        if item.category == value:
            result.append(item)
    return result



def pre_processing(json_request=None):
    # Opening JSON file
    data=None
    if(json_request==None):
        f = open('rooma.json')

        # returns JSON object as 
        # a dictionary
        data = json.load(f)
        
        # Iterating through the json
        # list
        Room1 =Room.from_dict(data)

        # Closing file
        f.close()
    else:
        Room1 =Room.from_dict(json_request)
    wallsArray = Room1.surfaces
    FurnitureArray = Room1.objects
    FurnitureArray2=[[0 for elem in FurnitureArray],[0 for elem in FurnitureArray],[0 for elem in FurnitureArray]]

    wallsArray2=[[0 for elem in wallsArray],[0 for elem in wallsArray],[0 for elem in wallsArray]]
    MaxNegativeZ= 0
    MaxNegativeX= 0
    Keywords=[[0 for elem in wallsArray],[0 for elem in FurnitureArray]]
    MinAngle=float('inf')


    for pos,Wall in enumerate(wallsArray):
        transform = np.array(Wall.transform).reshape((4,4))

        # Extract the rotation matrix
        rotation = transform[:3, :3]
        # Compute the rotation angles (in degrees)
        
        y_angle = np.degrees(np.arctan2(rotation[2, 0], rotation[2, 2]))

        

        if MinAngle>=abs(y_angle):
            MinAngle=abs(y_angle)
        Keywords[0][pos]=Wall.category
        wallsArray2[0][pos]= [Wall.transform[12]*100,Wall.transform[14]*100]
        wallsArray2[1][pos]= [Wall.scale.x*100,2]
        wallsArray2[2][pos]=y_angle
        
        if MaxNegativeZ>Wall.transform[14]:
            MaxNegativeZ=Wall.transform[14]
        if MaxNegativeX>Wall.transform[12]:
            MaxNegativeX=Wall.transform[12]
        
    # rotations=[-43.6396,-133.639,46.3604,136.36,136.36,46.36]
    for i,furniture in enumerate(FurnitureArray):
        transform = np.array(furniture.transform).reshape((4,4))

        # Extract the rotation matrix
        rotation = transform[:3, :3]
        # Compute the rotation angles (in degrees)
        
        y_angle = np.degrees(np.arctan2(rotation[2, 0], rotation[2, 2]))


        

        if MinAngle>=abs(y_angle):
            MinAngle=abs(y_angle)

        Keywords[1][i]=furniture.category
        FurnitureArray2[0][i]= [furniture.transform[12]*100,furniture.transform[14]*100]
        FurnitureArray2[1][i]= [furniture.scale.x*100,furniture.scale.z*100]
        FurnitureArray2[2][i]=y_angle

    offsetZ= 0
    offsetX= 0
    print(wallsArray2[2])
    # [-87.60322023930604, -177.60321988323176, 2.3967782678969614, 92.39678160956532, 92.39678082697752, 2.3968175071310722, -177.60321988323176, 2.3967847360371812]
    angle = abs((min(wallsArray2[2]))+90)
    print("assssssssssssssssssssssssssssssssssssssssssssssssssssss",angle)
    state3,state44,Surfaces,pivot=intitRoomShape(angle,wallsArray2[2],wallsArray2[0],wallsArray2[1],Keywords[0],offsetX,offsetZ,1)
    print("pivoooooooooooooooooooot",pivot)
    WallRects=drawRects(angle, wallsArray2[2],state44,wallsArray2[1],Surfaces)

    state3,state4,Surfaces2=intitFurnitureShape(angle,FurnitureArray2[2],FurnitureArray2[0],FurnitureArray2[1],Keywords[1],offsetX,offsetZ,1,pivot)
    FurnitureRects=drawRects2(angle, FurnitureArray2[2],state4,FurnitureArray2[1],Surfaces2,state4)

    # from rect to number in array
    # adjusting rects


        
    # divid by 100 again 
    return FurnitureRects,WallRects,Keywords,FurnitureArray,Room1,pivot,angle,Surfaces2,state4,data

