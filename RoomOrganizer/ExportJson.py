import pygame


def RotateObjectsBack(majorAngle, minAngle,rects,walls_dimensions):
    WallRects=[]
    print(rects)
    for pos, rect in enumerate(rects):
        angle = round((majorAngle+minAngle[pos])%360)

        if abs(angle) == 0 or abs(angle) == 180 or abs(angle)== 360:
            rect.width=walls_dimensions[pos][0]
            rect.height=walls_dimensions[pos][1]
            
        else:
            rect.width=walls_dimensions[pos][1]
            rect.height=walls_dimensions[pos][0]
            # return a list of rects not one  
        WallRects.append(pygame.Rect(rect.centerx-rect.width/2+rect.height/2,rect.centery-rect.height/2+rect.width/2,rect.width,rect.height))
    return WallRects