import argparse
from PIL import Image, ImageDraw, ImageFont
import qrcode
import xml.dom.minidom


parser = argparse.ArgumentParser()
parser.add_argument("--image-out")
parser.add_argument("--sprite-xml-out")
args = parser.parse_args()

image_out = args.image_out
sprite_out = args.sprite_xml_out

white = (255, 255, 255, 255)
blue = (0, 120, 215, 255)

qr_width = 115

texts = [
    "Didn't expect someone to check this :^)",
    "🍆",
    "https://github.com/dextercd/Noita-Shutdown",
    "Have a serious reason you use this mod? Let me know! Discord:dextercd#7326",
    "I hope you got a laugh out of this",
    "How many QR code messages are there? 🤔",
    "silmä-huone channel is full of smart code breakers",
    "🇺🇦🇺🇦🇺🇦🇺🇦🇺🇦",
    "Thanks for trying the mod!",
    "Your computer should now turn off >:)",
]

image = Image.new(mode="RGBA", size=(qr_width, qr_width * len(texts)), color=white)

for ix, text in enumerate(texts):
    qr = qrcode.QRCode(
        version=3,
        border=2,
        box_size=10
    )
    qr.add_data(text)
    qr.make(fit=True)
    qr_image = qr.make_image(fill_color=blue, back_color=white)
    qr_image.thumbnail((qr_width, qr_width))

    region = (0, qr_width * ix)
    image.paste(qr_image.convert("RGBA"), region)


if image_out:
    image.save(image_out)

if sprite_out:
    document = xml.dom.minidom.Document()
    sprite = document.createElement("Sprite")
    sprite.setAttribute('filename', 'mods/shutdown/files/ui_gfx/bluescreen/qr_code.png')

    for rect_num in range(len(texts)):
        ypos = rect_num * qr_width
        rect_anim = document.createElement("RectAnimation")
        rect_anim.setAttribute("name", str(rect_num))
        rect_anim.setAttribute("pos_x", "0")
        rect_anim.setAttribute("pos_y", str(ypos))
        rect_anim.setAttribute("frame_count", "1")
        rect_anim.setAttribute("frame_width", str(qr_width))
        rect_anim.setAttribute("frame_height", str(qr_width))

        # Prevent self-closing with empty text node
        text_node = document.createTextNode("")
        rect_anim.appendChild(text_node)

        sprite.appendChild(rect_anim)

    with open(sprite_out, "w") as out:
        sprite.writexml(out)
