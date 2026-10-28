#!/usr/bin/env python3
import bpy
import os

OUTPUT_DIR = "/Users/katya/Roblox Juego/PetRush/assets/blender/exports/"
PREVIEW_DIR = "/Users/katya/Roblox Juego/PetRush/assets/blender/previews/"

COLORS = {
    "naranja": (1.0, 0.478, 0.098, 1.0),
    "naranja_oscuro": (0.784, 0.290, 0.0, 1.0),
    "morado": (0.420, 0.176, 0.627, 1.0),
    "morado_oscuro": (0.165, 0.063, 0.251, 1.0),
    "negro": (0.082, 0.071, 0.102, 1.0),
    "blanco_hueso": (0.961, 0.933, 0.863, 1.0),
    "verde_acido": (0.486, 1.0, 0.227, 1.0),
    "dorado": (1.0, 0.824, 0.247, 1.0),
    "rojo": (0.820, 0.125, 0.184, 1.0),
    "gris_piedra": (0.541, 0.529, 0.580, 1.0),
}

def set_mat(name, r, g, b, a=1.0):
    mat = bpy.data.materials.new(name=name)
    mat.diffuse_color = (r, g, b, a)
    mat.metallic = 0
    mat.roughness = 0.3
    return mat

def assign_mat(obj, mat):
    if obj.data.materials:
        obj.data.materials[0] = mat
    else:
        obj.data.materials.append(mat)

def sel(obj):
    bpy.ops.object.select_all(action='DESELECT')
    obj.select_set(True)
    bpy.context.view_layer.objects.active = obj

def fbx(obj, path):
    sel(obj)
    bpy.ops.export_scene.fbx(
        filepath=path, path_mode='COPY',
        embed_textures=True,
        global_scale=0.01,
        add_leaf_bones=False,
        bake_anim=False
    )

def sph(radius=0.5, loc=(0,0,0)):
    bpy.ops.mesh.primitive_uv_sphere_add(radius=radius, location=loc)
    return bpy.context.object

def plane(size=0.8, loc=(0,0,0)):
    bpy.ops.mesh.primitive_plane_add(size=size, location=loc)
    return bpy.context.object

def mycone(loc=(0,0,0), depth=0.3):
    bpy.ops.mesh.primitive_cone_add(depth=depth, location=loc)
    return bpy.context.object

def mycylinder(depth=0.3, radius=0.05, loc=(0,0,0)):
    bpy.ops.mesh.primitive_cylinder_add(radius=radius, depth=depth, location=loc)
    return bpy.context.object

def icosphere(radius=0.1, loc=(0,0,0)):
    bpy.ops.mesh.primitive_ico_sphere_add(radius=radius, location=loc)
    return bpy.context.object

def torus_simple(radius=0.1, tube=0.02, loc=(0,0,0)):
    bpy.ops.mesh.primitive_torus_add(radius=radius, tube=tube, location=loc)
    return bpy.context.object

def get_mat_or_create(name, r, g, b, a=1.0):
    if name not in bpy.data.materials:
        bpy.data.materials.new(name=name)
    mat = bpy.data.materials[name]
    mat.diffuse_color = (r, g, b, a)
    return mat

def make_body(color_key, scale=(0.5,0.5,0.5)):
    r,g,b,a = COLORS[color_key]
    ob = sph(0.5, (0,0,0))
    ob.name = "Body"
    mat = get_mat_or_create("Body_Mat", r, g, b, a)
    assign_mat(ob, mat)
    ob.scale = scale
    return ob

def make_wing(obj):
    ob = plane(0.8, (0.4, 0, 0.2))
    ob.name = "Wing"
    mat = get_mat_or_create("Wing_Mat", 0.420, 0.176, 0.627, 1.0)
    assign_mat(ob, mat)
    ob.parent = obj

def make_ear(obj):
    ob = mycone(loc=(0, 0.3, 0.5), depth=0.2)
    ob.name = "Ear"
    ob.scale = (1, 1, 1.5)
    mat = get_mat_or_create("Ear_Mat", 0.420, 0.176, 0.627, 1.0)
    assign_mat(ob, mat)
    ob.parent = obj

def make_fang(obj):
    ob = sph(0.05, (0.1, 0, -0.1))
    ob.name = "Fang"
    mat = get_mat_or_create("Fang_Mat", 1.0, 1.0, 1.0, 1.0)
    assign_mat(ob, mat)
    ob.scale = (1, 1, 1.5)
    ob.parent = obj

def make_yellow_eye(obj, px):
    make_eye_h(obj, px, 1.0, 0.8, 0.0)

def make_eye_h(obj, px, r, g, b):
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.1, location=(px, 0.3, 0.4))
    eye = bpy.context.object
    assign_mat(eye, get_mat_or_create("Eye_Mat", r, g, b, 1.0))
    eye.scale = (1.2, 1.2, 1.2)
    eye.parent = obj

def make_ghost_body(obj):
    bpy.ops.object.mode_set(mode='EDIT')
    for v in obj.data.vertices:
        if v.co.z < 0:
            v.co.z -= 0.1
    bpy.ops.object.mode_set(mode='OBJECT')

def make_arm(obj):
    ob = mycylinder(depth=0.3, radius=0.05, loc=(0.2, 0, 0))
    ob.name = "Arm"
    mat = get_mat_or_create("Arm_Mat", 0.961, 0.933, 0.863, 1.0)
    assign_mat(ob, mat)
    ob.scale = (1, 0.5, 1)
    ob.parent = obj

def make_mouth_ghost(obj):
    ob = sph(0.08, (0, -0.2, 0.1))
    ob.name = "Mouth"
    assign_mat(ob, get_mat_or_create("Mouth_Mat", 0.0, 0.0, 0.0, 1.0))
    ob.scale = (1.5, 1, 1)
    ob.parent = obj

def make_eye_ghost(obj, px):
    make_eye_h(obj, px, 0.0, 0.0, 0.0)

def make_cat_ear(obj):
    ob = mycone(loc=(0, 0.35, 0.3), depth=0.3)
    ob.name = "Ear"
    ob.scale = (1, 1, 1.2)
    mat = get_mat_or_create("Ear_Mat", 0.0, 0.0, 0.0, 1.0)
    assign_mat(ob, mat)
    ob.parent = obj

def make_cat_tail(obj):
    ob = icosphere(0.08, (0, -0.4, 0.1))
    ob.name = "Tail"
    bpy.ops.object.mode_set(mode='EDIT')
    for v in ob.data.vertices:
        if v.co.x > 0:
            v.co.x += 0.1
    bpy.ops.object.mode_set(mode='OBJECT')
    ob.scale = (1, 1, 1.5)
    mat = get_mat_or_create("Tail_Mat", 0.0, 0.0, 0.0, 1.0)
    assign_mat(ob, mat)
    ob.parent = obj

def make_cat_eye(obj, px):
    make_eye_h(obj, px, 0.486, 1.0, 0.227)

def make_cat_bow_skip(obj):
    pass

def make_pumpkin_eye(obj, px):
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.06, location=(px, 0.1, 0.15))
    eye = bpy.context.object
    assign_mat(eye, get_mat_or_create("Pumpkin_Eye", 1.0, 1.0, 0.2, 1.0))
    eye.scale = (1, 1, 1)
    eye.parent = obj

def make_pumpkin_smile(obj):
    ob = icosphere(0.1, (0, -0.15, 0.05))
    ob.name = "Smile"
    # Asignar material en lugar de set directo
    assign_mat(ob, get_mat_or_create("Smile_Mat", 1.0, 0.8, 0.2, 1.0))
    ob.scale = (1.5, 0.8, 0.5)
    ob.parent = obj

def pumpkin_gajo(obj):
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.select_all(action='TOGGLE')
    bpy.ops.object.mode_set(mode='OBJECT')

def pumpkin_stem(obj):
    ob = mycylinder(depth=0.3, radius=0.05, loc=(0, 0, 0.35))
    ob.name = "Stem"
    ob.scale = (0.5, 0.5, 1.5)
    mat = get_mat_or_create("Stem_Mat", 0.0, 0.5, 0.0, 1.0)
    assign_mat(ob, mat)
    ob.parent = obj

def emissive_aura_skip(obj):
    pass

def purple_accents_skip(obj):
    pass

def gold_accents_skip(obj):
    pass

def create_all():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    os.makedirs(PREVIEW_DIR, exist_ok=True)
    
    # MURCIÉLAGO 4 rarezas
    print("=== MURCIÉLAGO ===")
    for rarity, color_key in [("Common", "morado"), ("Rare", "morado_oscuro"), ("Epic", "morado"), ("Legendary", "negro")]:
        print(f"Murciélago {rarity}...")
        ob = make_body(color_key, (0.5,0.5,0.5))
        make_wing(ob); make_ear(ob); make_fang(ob); make_yellow_eye(ob, -0.3); make_yellow_eye(ob, 0.3)
        fbx(ob, os.path.join(OUTPUT_DIR, f"Murcielago_{rarity}.fbx"))
        bpy.data.objects.remove(ob)
    
    # FANTASMA 4 rarezas
    print("=== FANTASMA ===")
    for rarity, color_key in [("Common", "blanco_hueso"), ("Rare", "blanco_hueso"), ("Epic", "blanco_hueso"), ("Legendary", "blanco_hueso")]:
        print(f"Fantasma {rarity}...")
        ob = make_body(color_key, (0.5,0.5,0.5))
        make_ghost_body(ob); make_arm(ob); make_mouth_ghost(ob)
        make_eye_ghost(ob, -0.35); make_eye_ghost(ob, 0.35)
        fbx(ob, os.path.join(OUTPUT_DIR, f"Fantasma_{rarity}.fbx"))
        bpy.data.objects.remove(ob)
    
    # GATO NEGRO 4 rarezas
    print("=== GATO NEGRO ===")
    for rarity, color_key in [("Common", "negro"), ("Rare", "negro"), ("Epic", "negro"), ("Legendary", "negro")]:
        print(f"Gato negro {rarity}...")
        ob = make_body(color_key, (0.5,0.5,0.5))
        make_cat_ear(ob); make_cat_tail(ob); make_cat_eye(ob, -0.3); make_cat_eye(ob, 0.3)
        make_cat_bow_skip(ob)
        fbx(ob, os.path.join(OUTPUT_DIR, f"Gato_negro_{rarity}.fbx"))
        bpy.data.objects.remove(ob)
    
    # CALABAZA 4 rarezas
    print("=== CALABAZA ===")
    for rarity, color_key in [("Common", "naranja"), ("Rare", "naranja"), ("Epic", "naranja"), ("Legendary", "naranja")]:
        print(f"Calabaza {rarity}...")
        ob = make_body(color_key, (0.5,0.5,0.5))
        pumpkin_gajo(ob)
        pumpkin_stem(ob)
        make_pumpkin_eye(ob, -0.15); make_pumpkin_eye(ob, 0.15)
        make_pumpkin_smile(ob)
        fbx(ob, os.path.join(OUTPUT_DIR, f"Calabaza_{rarity}.fbx"))
        bpy.data.objects.remove(ob)
    
    print("¡Modelos generados!")

if __name__ == "__main__":
    create_all()
