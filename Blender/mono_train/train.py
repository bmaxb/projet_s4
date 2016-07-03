# Projet S4
# Equipe P5
import bpy
import mathutils
from math import *

ops = bpy.ops
scene = bpy.context.scene

deselect_all = lambda: ops.object.select_all(action='DESELECT')

# Selectionne dans Blender la liste d'objets
def select_objects(objs):
    deselect_all()
    for obj in objs:
        obj.select = True

# Supprime une liste d'objets
def delete_objects(objs):
    select_objects(objs)
    ops.object.delete() 

# Definie l'objet parent d'une liste d'objets enfants
def set_parent(parent, *children):
    parent.select = True
    select_objects(children)
    bpy.context.scene.objects.active = parent 
    ops.object.parent_set()

# Retourne la liste des enfants d'un objet
def get_children(obj):
    return [child for child in bpy.data.objects if child.parent == obj]

# Ajoute un point de l'animation avec la position xy et l'angle
def set_keyframe(frame, *objects):
    for obj in objects:
        # scene.frame_set(frame)
        # obj.location = (xpos, ypos, zpos)
        # obj.rotation_euler[1] = theta
        obj.keyframe_insert(data_path="location", frame=frame)
        obj.keyframe_insert(data_path="rotation_euler", frame=frame)

# Variables de la scène
scene.frame_start = 0
scene.frame_end = 280
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

# Destruction de l'ancien chemin de fer
delete_objects(get_children(rail))

# Creation du chemin de fer
rail_pos = rail.location
for b in range(4):
    track = rail.copy()
    scene.objects.link(track)
    set_parent(rail, track)
    # rail_pos -= (0.6*direction)
    # track.location = rail_pos

# Calcul des positions du train
for frame in range(scene.frame_end):
    t = frame/24 # s
    
    s = (1/24)*v_train
    train.location += s*direction
            
    set_keyframe(frame, train)