from gym import Env
from gym.spaces import Discrete, Box
import numpy as np
import random
import math
import sys
import pygame
import pygame.font as fonts
from pygame.locals import *
import random
import warnings
from logging import exception
from gym import spaces


class RoomEnv(Env):

    def __init__(self,keywords,WallRects,FurnitureRects,SFD,RFD):
        # Actions we can up, down, right, left
        self.action_space = Discrete(4)
        # Room Dimensions
        self.turn = 0
        self.RoomDimension = (600, 600)
        self.observation_space = np.zeros((1, 2))
        # Set start temp
        self.SFD=SFD
        self.RFD=RFD
        self.font=None
        self.state2 = [elm.topleft for elm in FurnitureRects]
        self.state = self.state2[self.turn]
        self.FurnitureQueue = 1
        self.scale_factor = 1
        self.WallRects = WallRects
        self.FurnitureRects = FurnitureRects
        # add custom room dimentions in the future
        self.screen_width = self.scale_factor*self.RoomDimension[0]
        self.screen_height = self.scale_factor*self.RoomDimension[1]
        self.color = [(252, 198, 108) for elem in keywords[1]]
        # need to change the array from (door pos, door dim) to (door dim , (door 1 pos , door 2 pos , door 3 pos,etc))
        self.offsetX=300
        self.offsetZ=300
        # same for windows



        self.real_furniture_dimensions=[[elm.width,elm.height] for elm in FurnitureRects]
        # need to calculate an array of distances not just 3 maybe like (furniture to center , furn to doors(furn to door1 ,etc), furn to windows (furn to window 1 , etc))
        self.entropy = [0, 0]
        self.text = [0, 0]
        self.Furnituretext = [0 for elm in keywords[1]]
        self.lastdistance = 1000000
        self.keywords = keywords[1]
        print(self.keywords)
        self.keywordsWalls = keywords[0]
        self.colided = [False, False, False, False]
        self.colided2 = [False, False, False, False]
        self.move = False

        self.human_block = 30
        # Set shower length
        self.move_length = 10000*len(keywords[1])
        self.screen = None
        self.clock = None
        self.isopen = False
        self.accumulator = 0
        self.maxReward = np.zeros((len(self.keywords)))
        self.BestStates = [[random.randint(0, self.RoomDimension[0]), random.randint(
            0, self.RoomDimension[1])] for _ in range(len(self.keywords))]
        self.past_dist = np.zeros((len(self.keywords), 2))

    def check_door_in_axis(self, state, door_pos, door_dimensions, scale_factor):
        if (state[0] < door_pos[0]+(door_dimensions[0]/(scale_factor*2)) and state[0] > door_pos[0]-(door_dimensions[0]/(scale_factor*2))) or (state[1] < door_pos[1]+(door_dimensions[1]/(scale_factor*2)) and state[1] > door_pos[1]-(door_dimensions[1]/(scale_factor*2))):
            return True

        return False

    def GetReward(self, keyword, Furniturepos, dimensions):
        
        self.check_furniture_collision(Furniturepos, dimensions)
        reward = int(self.entropy)
        if keyword == "bed":
            if self.colided2.count(False) == 3:
                self.color[self.turn] = (0, 255, 0)
                reward = reward+100
                self.color[self.turn] = (0, 0, 255)
                # check if bed in same axis as door 
            # for door_pos in self.doors_pos:
            #     if (self.check_door_in_axis(Furniturepos, door_pos, self.door_dimensions, self.scale_factor)):
            #         reward = -1
            #         self.color[self.turn] = (255, 0, 0)
            for KW in range(len(self.keywords)):
                if self.turn > KW:
                    if KW == self.turn:

                        continue
                    if self.keywords[KW] == "bed":
                        for KW2 in range(len(self.keywords)):
                            # need to dynamically align beds
                            if self.keywords[KW2] == "Storage":
                                distance = math.pow(int(math.dist(Furniturepos, (self.state2[KW][0]-(
                                    self.FurnitureRects[KW].width+max(self.FurnitureRects[KW2])+3), self.state2[KW][1]))), 2)
                                break
                            else:
                                distance = math.pow(int(math.dist(Furniturepos, (self.state2[KW][0]-(
                                    self.FurnitureRects[KW].width+self.human_block), self.state2[KW][1]))), 2)
                        if distance >= self.lastdistance:
                            reward = -10

                        else:
                            reward = reward + (5000 / (distance + 1))

                        self.lastdistance = distance

                        self.color[self.turn] = (255, 0, 0)

        return reward

    def policyShaping(self, action, keyword, Furniturepos):

        if keyword == "Storage":
            BedsCount = []
            for KW in range(len(self.keywords)):
                if self.turn > KW:
                    if KW == self.turn:

                        continue
                    if self.keywords[KW] == "bed":
                        BedsCount.append(KW)
                if len(BedsCount) == 2 and not self.move:

                    avg = [(self.state2[BedsCount[0]][0]+self.state2[BedsCount[1]][0])/2,
                           ((self.state2[BedsCount[0]][1]+self.state2[BedsCount[1]][1])/2)]

                    self.state = avg
                    self.move = True
                    self.color[self.turn] = (255, 0, 0)
                if self.move:
                    action = 2
        # this part is only to help the desk and other furnuture in the future to not get stuck
        if keyword == "desk":
            if self.colided2[0] and not (self.colided[2] or self.colided[3]):
                action = 1
         # -------------------------------------------------------------------------------------
        # Chairs
        if keyword == "chair":

            for KW in range(len(self.keywords)):
                if KW == self.turn:
                    continue
                if self.keywords[KW] == "desk":

                    point = (self.state2[KW][0], self.state2[KW]
                             [1]-(self.real_furniture_dimensions[KW][1]))

                    self.state = point
        return action

    def CalculateDistances(self, Furniturepos):

        totalDistance = 0
        for i,DoorOrWindow in enumerate(self.WallRects):
            if self.keywordsWalls[i] =="door" or self.keywordsWalls[i] =="window":
                totalDistance += int(math.dist(Furniturepos, DoorOrWindow.topleft))

        # dist From center of the room
        # totalDistance += int(math.dist([self.door_dimensions[0]/2,
        #                      self.door_dimensions[1]/2], Furniturepos))
        return totalDistance

    def isColliding(self, CurrentRect):
        
        for rect in self.WallRects:
            if pygame.Rect.colliderect(rect, CurrentRect):
                return True
        for pos,rect in enumerate(self.FurnitureRects):
            if pos!=self.turn and pygame.Rect.colliderect(rect, CurrentRect):
                return True
        return False

    def nextPlease(self):
        self.FurnitureQueue += 1
        self.turn = (self.turn+1) % len(self.keywords)

    def check_furniture_collision(self, furniture_pos, furniture_dimensions, ignore_index=None):
        for i, pos in enumerate(self.state2[:self.FurnitureQueue]):
            if ignore_index is not None and i == ignore_index:
                continue

            other_furniture_dimensions = self.real_furniture_dimensions[i]
            other_furniture_pos = self.state2[i]

            x1, y1 = furniture_pos
            x2, y2 = other_furniture_pos
            w1, h1 = furniture_dimensions
            w2, h2 = other_furniture_dimensions

            # Check if the two pieces of furniture overlap
            if (abs(x1 - x2) * 2 < (w1 + w2)) and (abs(y1 - y2) * 2 < (h1 + h2)):
                # The two pieces of furniture are colliding

                # Check which side of the furniture is colliding
                left_collision = (x1 + w1/2 > x2 - w2 /
                                  2) and (x1 + w1/2 < x2 + w2/2)
                right_collision = (x1 - w1/2 < x2 + w2 /
                                   2) and (x1 - w1/2 > x2 - w2/2)
                bottom_collision = (y1 - h1/2 < y2 + h2 /
                                    2) and (y1 - h1/2 > y2 - h2/2)
                top_collision = (y1 + h1/2 > y2 - h2 /
                                 2) and (y1 + h1/2 < y2 + h2/2)

                self.colided2[0] = left_collision
                self.colided2[1] = right_collision
                self.colided2[2] = top_collision
                self.colided2[3] = bottom_collision

        # If no collision is detected, return None
        return None

    def step(self, action):
        # Apply action

        #  need to adjust bounds to room dimensions dynamically

        self.state = self.state2[self.turn]
        self.move_length -= 1

        # need to calculate an array of distances not just 3 maybe like (furniture to center , furn to doors(furn to door1 ,etc), furn to windows (furn to window 1 , etc))
        self.entropy = self.CalculateDistances(self.state)
        #  a func  or a method to sum distances

        reward = self.GetReward(
            self.keywords[self.turn], self.state, (self.FurnitureRects[self.turn].width,self.FurnitureRects[self.turn].height))
        action = self.policyShaping(
            action, self.keywords[self.turn], self.state)

        # Calculate reward
        # if( self.past_dist[self.turn]<self.entropy[self.turn]):

        #     reward= -1

        #         reward = int(math.dist(np.mean( np.array([ [50,50], self.door_pos ]), axis=0 ), self.state))
        #         if(self.past_state[0] ==self.state[0] and self.past_state[1] ==self.state[1]):

        #             reward= -1
        if self.isColliding(self.FurnitureRects[self.turn]):
            self.FurnitureRects[self.turn].inflate_ip(-2,-2)
            self.state = self.FurnitureRects[self.turn].topleft
        else:
            state_Copy=self.state
            Current_Furniture_Copy = self.FurnitureRects[self.turn].copy()
            if (action == 0 ):
                self.state = np.add([1, 0], self.state)
            elif (action == 1 ):
                self.state = np.add([-1, 0], self.state)
            elif (action == 2 ):
                self.state = np.add([0, 1], self.state)

            elif (action == 3 ):
                self.state = np.add([0, -1], self.state)
            Current_Furniture_Copy.topleft=self.state

            if self.isColliding(Current_Furniture_Copy):
                self.state=state_Copy
            # Reduce move length by 1 second

        if self.maxReward[self.turn] < reward:
            self.maxReward[self.turn] = reward
            self.BestStates[self.turn] = self.state

        self.past_dist = int(self.entropy)
        # Check if the moves are done
        if self.move_length <= 0:
            done = True
        else:
            done = False

        # Apply temperature noise
        # self.state += random.randint(-1,1)
        # Set placeholder for info
        info = {}

        # print(self.colided)
        self.colided[0] = False
        self.colided[1] = False
        self.colided[2] = False
        self.colided[3] = False
        self.colided2[0] = False
        self.colided2[1] = False
        self.colided2[2] = False
        self.colided2[3] = False
        self.state2[self.turn] = self.state

        # Return step information

        return self.state, reward, done, info
    def exportRoom(self):

        for pos,rect in enumerate(self.FurnitureRects):
            rect.topleft=self.state2[pos]


        return self.FurnitureRects,self.WallRects
    def render(self, mode):
        
        if not self.isopen:
            self.isopen = True
            pygame.init()
            pygame.display.init()
            pygame.display.set_caption("Layout Optimization")
            self.font = fonts.Font(None, 20)
        self.screen = pygame.display.set_mode(
            (self.screen_width, self.screen_height))
        if self.clock is None:
            self.clock = pygame.time.Clock()

        if self.state is None:
            return None

        x = self.state

        self.screen.fill((143, 0, 255))
        # self.clock.tick(200)
        # need to draw rects dynamically in a func

        self.DrawElements(self.font)

        self.color[self.turn] = (252, 198, 108)

        pygame.display.update()

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                self.close()

    def DrawElements(self,font):

        
        # for i,wallrect in enumerate(self.SFD):

        #     # Category = font.render(
        #     #     self.keywordsWalls[i], True, (255, 255, 255))
        #     # color = (55, 100, 0) if self.keywordsWalls[i] == "wall" else (
        #     #     0, 200, 0) if self.keywordsWalls[i] == "door" else (0, 0, 200)
        #     temprect=self.RFD[i].copy()
        #     temprect.centerx+=self.offsetX
        #     temprect.centery+=self.offsetZ
        #     # pygame.draw.rect(self.screen, color, temprect)
            
        #     self.screen.blit(wallrect, temprect)
        
        for i, wallrect in enumerate(self.WallRects):
            Category = font.render(
                self.keywordsWalls[i], True, (255, 255, 255))
            color = (50, 50, 50)
            temprect=wallrect.copy()
            temprect.centerx+=self.offsetX
            temprect.centery+=self.offsetZ
            pygame.draw.rect(self.screen, color, temprect)
            self.screen.blit(Category, temprect.center)

        for i, FurnRect in enumerate(self.FurnitureRects):
            self.FurnitureRects[i].topleft=self.state2[i]
            Category = font.render(
                self.keywords[i], True, (255, 255, 255))
            color = (50, 50, 50)
            temprect=FurnRect.copy()
            temprect.centerx+=self.offsetX
            temprect.centery+=self.offsetZ
            pygame.draw.rect(self.screen, color, temprect)
            self.screen.blit(Category, temprect.center)

    def close(self):
        pygame.display.quit()
        pygame.quit()
        self.isopen=False
    def reset(self):

        # Reset shower time
        self.move_length = 10000*len(self.keywords)
        return self.state
