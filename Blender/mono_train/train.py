# Projet S4
# Equipe P5
import bpy
import mathutils
from math import *
from numpy import genfromtxt

ops = bpy.ops
scene = bpy.context.scene
fps = 60

# Lecture du fichier de coordonnees
my_data = genfromtxt('coordinates.csv', delimiter=',') # data from csv file
coords = []
for i in range(len(my_data[:,0])):
    coords.append(mathutils.Vector((my_data[i,0], my_data[i,1], 0.0)))

# Fonctions ------------------------------------------------------------------------

# Change le texte a afficher selon l'image en cours
def recalculate_text(scene):
    text = bpy.data.objects["CameraText"]
    text.data.body = "Frame #{0:.0f}, temps: {1:.1f} sec.".format((scene.frame_current), (scene.frame_current/fps))

bpy.app.handlers.frame_change_pre.append(recalculate_text)

# Supprime un objet par son nom
def delete_object(obj_name):
    ops.object.select_all(action='DESELECT')
    bpy.data.objects[obj_name].select = True
    ops.object.delete() 

# Cree une ligne joignant tous les points, dont la forme est définie par modeler_name
def make_polyline(name, coords, origin, modeler_name):
    if bpy.data.objects.get(name) is not None:
        print(name)
        delete_object(name)

    modeler = bpy.data.objects[modeler_name]
    curvedata = bpy.data.curves.new(name=name+'_curve', type='CURVE')
    curvedata.dimensions = '3D'

    objectdata = bpy.data.objects.new(name, curvedata)
    objectdata.location = origin # (0,0,0) object origin
    modeler.location = origin
    bpy.context.scene.objects.link(objectdata)

    len_coords = len(coords)
    polyline = curvedata.splines.new('POLY')
    polyline.points.add(len_coords-1)
    for num in range(len_coords):
        x, y, z = coords[num]
        polyline.points[num].co = (x, y, z, 1)

    modeler.modifiers["Curve"].object = objectdata
    return objectdata

# Retourne l'angle a partir d'un vecteur unitair
def get_rotation_euler(v):
    return mathutils.Vector((atan2(v.z, v.y), 0, atan2(v.y, v.x)+(pi/2))) # (((pi/2)+pi-atan2(v.y, v.z), 0.0, pi-atan2(v.y, v.x)))

# Ajoute un point de l'animation avec la position xy et l'angle
def set_keyframe(frame, *objects):
    for obj in objects:
        obj.keyframe_insert(data_path="location", frame=frame)
        obj.keyframe_insert(data_path="rotation_euler", frame=frame)

# Determine la direction normaliser entre 2 points
def get_tangent(v1, v2):
    return (v2 - v1).normalized();

# Variables de la scene ------------------------------------------------------------
scene.frame_start = 0
scene.frame_end = len(coords)-1

camera = bpy.data.objects["Camera"]
train = bpy.data.objects["Train"]

hi = 0 # hauteur initiale

# Position initial -----------------------------------------------------------------
camera_offset = mathutils.Vector((-11.6, 7.9, 3.66)) # (xpos, ypos, zpos)
train.location = (0, 0, hi)
set_keyframe(0, train)

# Animation ------------------------------------------------------------------------
for frame in range(len(coords)-1):
    t = frame/fps # s
    
    # Train
    direction = get_tangent(coords[frame], coords[frame+1])

    train.rotation_euler = get_rotation_euler(direction)
    train.location = coords[frame]

    # Camera
    camera.location = train.location + camera_offset
    
    # Sauvegarde
    set_keyframe(frame, train)
    set_keyframe(frame, camera)

# Creation des rails du chemin de fer ----------------------------------------------
direction = get_tangent(coords[1], coords[0])
for b in range(25):
    coords.insert(0, coords[0]+direction)

railway_origin = mathutils.Vector((0, 0, hi-0.2))
railway = make_polyline('Railway', coords, railway_origin, 'Track')