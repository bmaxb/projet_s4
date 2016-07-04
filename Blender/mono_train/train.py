# Projet S4
# Equipe P5
import bpy
import mathutils
from math import *

ops = bpy.ops
scene = bpy.context.scene

# Fonctions ------------------------------------------------------------------------

# Supprime un objet par son nom
def delete_object(obj_name):
    ops.object.select_all(action='DESELECT')
    bpy.data.objects[obj_name].select = True
    ops.object.delete() 

# Cree une ligne joignant tous les points, dont la forme est définie par modeler_name
def make_polyline(name, coords, origin, modeler_name, material_name):
    if bpy.data.objects.get(name) is not None:
        delete_object(name)
    
    curvedata = bpy.data.curves.new(name=name+'_curve', type='CURVE')
    curvedata.dimensions = '3D'
    curvedata.bevel_object = bpy.data.objects[modeler_name]

    objectdata = bpy.data.objects.new(name, curvedata)
    objectdata.data.materials.append(bpy.data.materials.get(material_name))
    objectdata.location = origin # (0,0,0) object origin
    bpy.context.scene.objects.link(objectdata)

    len_coords = len(coords)
    polyline = curvedata.splines.new('POLY')
    polyline.points.add(len_coords-1)
    for num in range(len_coords):
        x, y, z = coords[num]
        polyline.points[num].co = (x, y, z, 1)

    return objectdata

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
fps = 24
camera = bpy.data.objects["Camera"]
train = bpy.data.objects["Train"]

hi = 8.7 # hauteur initiale
v_train = 10 # m/s
s = (1/fps)*v_train # position de deplacement par frame
direction = mathutils.Vector((0.0, -1.0, 0.0)) # .normalize()

# Position initial -----------------------------------------------------------------
camera.location = (-11.5, -9, 14) # (xpos, ypos, zpos)
train.location = (0, 0, hi)
railway_origin = (0, 0, hi-1)
set_keyframe(0, train)


# Creation du chemin de fer --------------------------------------------------------
coords = [mathutils.Vector((0.0, 0.0, 0.0))]
# Arriere du chemin de fer
for b in range(25):
    coords.insert(0, coords[0]-0.6*direction)

# Animation ------------------------------------------------------------------------
for frame in range(scene.frame_end):
    t = frame/fps # s
    
    # Train
    train.location += s*direction

    # Chemin de fer
    coords.append(coords[-1] + s*direction)

    # Camera
    camera.location += s*direction
    
    # Sauvegarde
    set_keyframe(frame, train)
    set_keyframe(frame, camera)


# Devant du chemin de fer
for b in range(25):
    coords.append(coords[-1]+0.6*direction)

left_railway = make_polyline('Railway_L', coords, railway_origin, 'Rail_Modeler', 'concrete')