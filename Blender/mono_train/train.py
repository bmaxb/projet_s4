# Projet S4
# Equipe P5
import bpy
import mathutils
from math import *

ops = bpy.ops
scene = bpy.context.scene

# Fonctions ------------------------------------------------------------------------
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

def add_track_part(location):
    track = rail.copy()
    scene.objects.link(track)
    set_parent(rail, track)
    track.location = location

# Ajoute un point de l'animation avec la position xy et l'angle
def set_keyframe(frame, *objects):
    for obj in objects:
        # scene.frame_set(frame)
        # obj.location = (xpos, ypos, zpos)
        # obj.rotation_euler[1] = theta
        obj.keyframe_insert(data_path="location", frame=frame)
        obj.keyframe_insert(data_path="rotation_euler", frame=frame)

# Variables de la scene ------------------------------------------------------------
scene.frame_start = 0
scene.frame_end = 280
camera = bpy.data.objects["Camera"]
train = bpy.data.objects["Train"]
rail = bpy.data.objects["RailDouble"]

hi = 8.7 # hauteur initiale
v_train = 10 # m/s
direction = mathutils.Vector((0.0, -1.0, 0.0)) # .normalize()

# Position initial -----------------------------------------------------------------
camera.location = (-11, -9, 14) # (xpos, ypos, zpos)
train.location = (0, 0, hi)
rail.location = (0, 0, hi-1)
set_keyframe(0, train)

# Destruction de l'ancien chemin de fer --------------------------------------------
delete_objects(get_children(rail))

# Creation du chemin de fer --------------------------------------------------------
rail_pos = rail.location.copy()
# Arriere du chemin de fer
for b in range(25):
    rail_pos -= (0.6*direction)
    add_track_part(rail_pos)

# Animation ------------------------------------------------------------------------
rail_pos = rail.location.copy()
for frame in range(scene.frame_end):
    t = frame/24 # s
    
    # Train
    s = (1/24)*v_train
    train.location += s*direction

    # Chemin de fer
    rail_pos += s*direction
    add_track_part(rail_pos)

    # Camera
    camera.location += s*direction

    
    # Sauvegarde
    set_keyframe(frame, train)
    set_keyframe(frame, camera)


# Devant du chemin de fer
for b in range(25):
    rail_pos += (0.6*direction)
    add_track_part(rail_pos)