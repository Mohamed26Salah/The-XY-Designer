# pygame.transform module
# https://www.pygame.org/docs/ref/transform.html
#
# How do I rotate an image around its center using PyGame?
# https://stackoverflow.com/questions/4183208/how-do-i-rotate-an-image-around-its-center-using-pygame/54714144#54714144
#
# How to rotate an image around its center while its scale is getting larger(in Pygame)
# https://stackoverflow.com/questions/54462645/how-to-rotate-an-image-around-its-center-while-its-scale-is-getting-largerin-py/54713639#54713639
#
# GitHub - PyGameExamplesAndAnswers - Collision and Intersection - Circle and circle
# https://github.com/Rabbid76/PyGameExamplesAndAnswers/blob/master/documentation/pygame/pygame_surface_rotate.md

import pygame
import os
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), './'))
pygame.init()

screen = pygame.display.set_mode((300, 300))
clock = pygame.time.Clock()
try:
    image = pygame.image.load('Home.png')
    image2 = pygame.image.load('Home.png')
except:
    text = pygame.font.SysFont('Times New Roman', 50).render('image', False, (255, 255, 0))
    image = pygame.Surface((text.get_width()+1, text.get_height()+1))
    pygame.draw.rect(image, (0, 0, 255), (1, 1, *text.get_size()))
    image.blit(text, (1, 1))

start = True
angle = 0
done = False
while not done:
    clock.tick(60)
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            done = True
        elif event.type == pygame.KEYDOWN or event.type == pygame.MOUSEBUTTONDOWN:
            start = True

    pos = (150, 150) 
    # originPos = image.get_rect().center
    
    image_rect = image.get_rect(topleft = (200, 0))
    image_rect2 = image2.get_rect(topleft = (0, 0))
    offset_center_to_pivot = pygame.math.Vector2(pos) - image_rect.center
    offset_center_to_pivot2 = pygame.math.Vector2(pos) - image_rect2.center
    rotated_offset = offset_center_to_pivot.rotate(angle)
    rotated_offset2 = offset_center_to_pivot2.rotate(angle)
    rotated_image_center = (pos[0] - rotated_offset.x, pos[1] - rotated_offset.y)
    rotated_image_center2 = (pos[0] - rotated_offset2.x, pos[1] - rotated_offset2.y)

    # get a rotated image
    rotated_image = pygame.transform.rotate(image, angle)
    rotated_image_rect = rotated_image.get_rect(center = rotated_image_center)
    origin = rotated_image_rect.topleft
    rotated_image2 = pygame.transform.rotate(image2, angle)
    rotated_image_rect2 = rotated_image2.get_rect(center = rotated_image_center2)
    origin2 = rotated_image_rect2.topleft

    screen.fill(0)
    # rotated_image = pygame.transform.rotate(image, angle)
    if start:
        angle += 1

    screen.blit(rotated_image, origin)
    screen.blit(rotated_image2, origin2)
    pygame.draw.rect(screen,(255, 0, 0), (*origin, *rotated_image.get_size()),2)
    
    pygame.draw.line(screen, (0, 255, 0), (pos[0]-20, pos[1]), (pos[0]+20, pos[1]), 3)
    pygame.draw.line(screen, (0, 255, 0), (pos[0], pos[1]-20), (pos[0], pos[1]+20), 3)
    pygame.draw.circle(screen, (0, 255, 0), pos, 7, 0)

    pygame.display.flip()

pygame.quit()
exit()