# Projet S4
# Equipe P5
import bpy
import mathutils
from math import *

ctx = bpy.context
ops = bpy.ops

# Ajoute un point de l'animation avec la position xy et l'angle
def set_keyframe(frame, *objects):
    for obj in objects:
        # ctx.scene.frame_set(frame)
        # obj.location = (xpos, ypos, zpos)
        # obj.rotation_euler[1] = theta
        obj.keyframe_insert(data_path="location", frame=frame)
        obj.keyframe_insert(data_path="rotation_euler", frame=frame)

# Variables de la scène
ctx.scene.frame_start = 0
ctx.scene.frame_end = 280
train = bpy.data.objects["Train"]
rail = bpy.data.objects["RailDouble"]

# Variable de position du vaisseau
hi = 8.7 # hauteur initiale
v_train = 10 # m/s
direction = mathutils.Vector((0.0, -1.0, 0.0)) # .normalize()

# Position initial
train.location = (0, 0, hi) # (xpos, ypos, zpos)
rail.location = (0, 0, hi-1)
set_keyframe(0, train)

# Creation du chemin de fer


# Calcul des positions du train
for frame in range(ctx.scene.frame_end):
    t = frame/24 # s
    
    s = (1/24)*v_train
    train.location += s*direction
            
    set_keyframe(frame, train)