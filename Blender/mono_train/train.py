# Projet S4
# Equipe P5
import bpy
import mathutils
from math import *
from numpy import genfromtxt

ops = bpy.ops
scene = bpy.context.scene
fps = 60

# Fonctions ------------------------------------------------------------------------

# Change le texte a afficher selon l'image en cours
def recalculate_text(scene):
    text = bpy.data.objects["CameraText"]
    index = '0.0113'
    text.data.body = "Index de performance: {2}\nFrame #{0:.0f}, temps: {1:.1f} sec.".format(scene.frame_current, scene.frame_current/fps, index)

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

# x=phi=2, y=theta=3

# Retourne l'angle a partir d'un vecteur direction unitair et des angles
def get_rotation_euler(v, phi=0.0, theta=0.0):
    return mathutils.Vector((theta, phi, atan2(v.y, v.x)+(pi/2))) # (((pi/2)+pi-atan2(v.y, v.z), 0.0, pi-atan2(v.y, v.x)))

# Ajoute un point de l'animation avec la position xy et l'angle
def set_keyframe(frame, *objects):
    for obj in objects:
        obj.keyframe_insert(data_path="location", frame=frame)
        obj.keyframe_insert(data_path="rotation_euler", frame=frame)

# Determine la direction normaliser entre 2 points
def get_tangent(v1, v2):
    return (v2 - v1).normalized();


camera = bpy.data.objects["Camera"]
train = bpy.data.objects["Train"]

hi = 0 # hauteur initiale

# Position initial -----------------------------------------------------------------
camera_offset = mathutils.Vector((13.6, 2.3, 3.66)) # (xpos, ypos, zpos)
train.location = (0, 0, hi)
set_keyframe(0, train)

# Lecture du fichier de coordonnees ------------------------------------------------
with_angles = True
csv = genfromtxt('xy_phi_theta.csv', delimiter=',') # data from csv file
data_length = len(csv[:,0])

# Variables de la scene ------------------------------------------------------------
scene.frame_start = 0
scene.frame_end = data_length-1

# Animation ------------------------------------------------------------------------
coords = []
coords.append(mathutils.Vector((csv[0,0]*1.5, csv[0,1], 0.0)))

for frame in range(data_length-1):
    t = frame/fps # s
    
    pos = mathutils.Vector((csv[frame+1,0]*1.5, csv[frame+1,1], 0.0))
    coords.append(pos)

    # Train
    direction = get_tangent(coords[-2], coords[-1])

    if with_angles:
        train.rotation_euler = get_rotation_euler(direction, csv[frame+1,2], csv[frame+1,3])
    else:
        train.rotation_euler = get_rotation_euler(direction)

    train.location = pos

    # Camera
    camera.location = train.location + camera_offset
    
    # Sauvegarde
    set_keyframe(frame, train)
    set_keyframe(frame, camera)

# Creation des rails du chemin de fer ----------------------------------------------
direction = get_tangent(coords[31], coords[30])
for b in range(25):
    coords.insert(0, coords[0]+direction)

railway_origin = mathutils.Vector((0, 0, hi-0.2))
railway = make_polyline('Railway', coords, railway_origin, 'Track')