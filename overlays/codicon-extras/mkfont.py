import sys

from fontTools.misc.transform import Transform
from fontTools.pens.boundsPen import BoundsPen
from fontTools.pens.transformPen import TransformPen
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.subset import Options, Subsetter
from fontTools.ttLib import TTFont

CODICON, BASE, OUT = sys.argv[1], sys.argv[2], sys.argv[3]

FAMILY = "Codicon Extras Mono"
GLYPHS = {0xEC81: "cod-openai", 0xEC82: "cod-claude"}
REFERENCE = 0xF029A


def ink(glyph_set, name):
    pen = BoundsPen(glyph_set)
    glyph_set[name].draw(pen)
    return pen.bounds


source = TTFont(CODICON)
source_cmap = source.getBestCmap()
source_glyphs = source.getGlyphSet()

font = TTFont(BASE)
cmap = font.getBestCmap()
glyph_set = font.getGlyphSet()
glyf, hmtx = font["glyf"], font["hmtx"]

reference = cmap[REFERENCE]
rx0, ry0, rx1, ry1 = ink(glyph_set, reference)
advance = hmtx[reference][0]

for codepoint, name in GLYPHS.items():
    sx0, sy0, sx1, sy1 = ink(source_glyphs, source_cmap[codepoint])
    scale = min((rx1 - rx0) / (sx1 - sx0), (ry1 - ry0) / (sy1 - sy0))
    transform = (
        Transform()
        .translate(
            rx0 + ((rx1 - rx0) - (sx1 - sx0) * scale) / 2,
            ry0 + ((ry1 - ry0) - (sy1 - sy0) * scale) / 2,
        )
        .scale(scale)
        .translate(-sx0, -sy0)
    )

    pen = TTGlyphPen(glyph_set)
    source_glyphs[source_cmap[codepoint]].draw(TransformPen(pen, transform))
    glyph = pen.glyph()
    glyf[name] = glyph
    glyph.recalcBounds(glyf)
    hmtx[name] = (advance, glyph.xMin if glyph.numberOfContours else 0)
    for table in font["cmap"].tables:
        if table.isUnicode():
            table.cmap[codepoint] = name

options = Options()
options.layout_features = []
options.name_IDs = ["*"]
options.notdef_outline = True
subsetter = Subsetter(options=options)
subsetter.populate(unicodes=list(GLYPHS))
subsetter.subset(font)

for record in font["name"].names:
    if record.nameID in (1, 3, 4, 6, 16):
        value = FAMILY.replace(" ", "") if record.nameID == 6 else FAMILY
        record.string = value.encode(
            "utf_16_be" if record.platformID == 3 else "latin-1"
        )

font.save(OUT)
