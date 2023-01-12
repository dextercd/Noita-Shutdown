import argparse
from PIL import Image, ImageDraw, ImageFont
import xml.dom.minidom


parser = argparse.ArgumentParser()
parser.add_argument("--font", required=True)
parser.add_argument("--image-out")
parser.add_argument("--sprite-xml-out")
args = parser.parse_args()

font = args.font
image_out = args.image_out
sprite_out = args.sprite_xml_out

transparent = (255, 255, 255, 0)
white = (255, 255, 255, 255)
text_width = 300
text_height = 40

steps = [0, 11, 14, 20, 26, 34, 43, 44, 49, 68, 75, 95, 100]
texts = [f"{v}% complete" for v in steps]

image_size = (text_width, text_height * len(texts))
image = Image.new(mode="RGBA", size=image_size, color=transparent)
draw = ImageDraw.Draw(image)
font = ImageFont.truetype(font, 40)

y_positions = []
for ix, text in enumerate(texts):
    y_position = text_height * ix
    y_positions.append(y_position)
    draw.text((0, y_position), text, font=font, anchor="lt", fill=white)

if image_out:
    image.save(image_out)

if sprite_out:
    document = xml.dom.minidom.Document()
    sprite = document.createElement("Sprite")
    sprite.setAttribute('filename', 'mods/shutdown/files/ui_gfx/bluescreen/completed.png')

    for rect_num, ypos in enumerate(y_positions):
        rect_anim = document.createElement("RectAnimation")
        rect_anim.setAttribute("name", str(rect_num))
        rect_anim.setAttribute("pos_x", "0")
        rect_anim.setAttribute("pos_y", str(ypos))
        rect_anim.setAttribute("frame_count", "1")
        rect_anim.setAttribute("frame_width", str(text_width))
        rect_anim.setAttribute("frame_height", str(text_height))

        sprite.appendChild(rect_anim)

    with open(sprite_out, "w") as out:
        sprite.writexml(out)
