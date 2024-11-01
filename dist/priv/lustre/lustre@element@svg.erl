-module(lustre@element@svg).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([animate/1, animate_motion/1, animate_transform/1, mpath/1, set/1, circle/1, ellipse/1, line/1, polygon/1, polyline/1, rect/1, a/2, defs/2, g/2, marker/2, mask/2, missing_glyph/2, pattern/2, svg/2, switch/2, symbol/2, desc/2, metadata/2, title/2, fe_blend/1, fe_color_matrix/1, fe_component_transfer/1, fe_composite/1, fe_convolve_matrix/1, fe_diffuse_lighting/2, fe_displacement_map/1, fe_drop_shadow/1, fe_flood/1, fe_func_a/1, fe_func_b/1, fe_func_g/1, fe_func_r/1, fe_gaussian_blur/1, fe_image/1, fe_merge/2, fe_merge_node/1, fe_morphology/1, fe_offset/1, fe_specular_lighting/2, fe_tile/2, fe_turbulence/1, linear_gradient/2, radial_gradient/2, stop/1, image/1, path/1, text/2, use_/1, fe_distant_light/1, fe_point_light/1, fe_spot_light/1, clip_path/2, script/2, style/2, foreign_object/2, text_path/2, tspan/2]).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 19).
-spec animate(list(lustre@internals@vdom:attribute(RSJ))) -> lustre@internals@vdom:element(RSJ).
animate(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"animate"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 24).
-spec animate_motion(list(lustre@internals@vdom:attribute(RSN))) -> lustre@internals@vdom:element(RSN).
animate_motion(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"animateMotion"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 29).
-spec animate_transform(list(lustre@internals@vdom:attribute(RSR))) -> lustre@internals@vdom:element(RSR).
animate_transform(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"animateTransform"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 34).
-spec mpath(list(lustre@internals@vdom:attribute(RSV))) -> lustre@internals@vdom:element(RSV).
mpath(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"mpath"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 39).
-spec set(list(lustre@internals@vdom:attribute(RSZ))) -> lustre@internals@vdom:element(RSZ).
set(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"set"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 46).
-spec circle(list(lustre@internals@vdom:attribute(RTD))) -> lustre@internals@vdom:element(RTD).
circle(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"circle"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 51).
-spec ellipse(list(lustre@internals@vdom:attribute(RTH))) -> lustre@internals@vdom:element(RTH).
ellipse(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"ellipse"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 56).
-spec line(list(lustre@internals@vdom:attribute(RTL))) -> lustre@internals@vdom:element(RTL).
line(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"line"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 61).
-spec polygon(list(lustre@internals@vdom:attribute(RTP))) -> lustre@internals@vdom:element(RTP).
polygon(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"polygon"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 66).
-spec polyline(list(lustre@internals@vdom:attribute(RTT))) -> lustre@internals@vdom:element(RTT).
polyline(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"polyline"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 71).
-spec rect(list(lustre@internals@vdom:attribute(RTX))) -> lustre@internals@vdom:element(RTX).
rect(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"rect"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 78).
-spec a(
    list(lustre@internals@vdom:attribute(RUB)),
    list(lustre@internals@vdom:element(RUB))
) -> lustre@internals@vdom:element(RUB).
a(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"a"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 86).
-spec defs(
    list(lustre@internals@vdom:attribute(RUH)),
    list(lustre@internals@vdom:element(RUH))
) -> lustre@internals@vdom:element(RUH).
defs(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"defs"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 94).
-spec g(
    list(lustre@internals@vdom:attribute(RUN)),
    list(lustre@internals@vdom:element(RUN))
) -> lustre@internals@vdom:element(RUN).
g(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"g"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 102).
-spec marker(
    list(lustre@internals@vdom:attribute(RUT)),
    list(lustre@internals@vdom:element(RUT))
) -> lustre@internals@vdom:element(RUT).
marker(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"marker"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 110).
-spec mask(
    list(lustre@internals@vdom:attribute(RUZ)),
    list(lustre@internals@vdom:element(RUZ))
) -> lustre@internals@vdom:element(RUZ).
mask(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"mask"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 118).
-spec missing_glyph(
    list(lustre@internals@vdom:attribute(RVF)),
    list(lustre@internals@vdom:element(RVF))
) -> lustre@internals@vdom:element(RVF).
missing_glyph(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"missing-glyph"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 126).
-spec pattern(
    list(lustre@internals@vdom:attribute(RVL)),
    list(lustre@internals@vdom:element(RVL))
) -> lustre@internals@vdom:element(RVL).
pattern(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"pattern"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 134).
-spec svg(
    list(lustre@internals@vdom:attribute(RVR)),
    list(lustre@internals@vdom:element(RVR))
) -> lustre@internals@vdom:element(RVR).
svg(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"svg"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 142).
-spec switch(
    list(lustre@internals@vdom:attribute(RVX)),
    list(lustre@internals@vdom:element(RVX))
) -> lustre@internals@vdom:element(RVX).
switch(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"switch"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 150).
-spec symbol(
    list(lustre@internals@vdom:attribute(RWD)),
    list(lustre@internals@vdom:element(RWD))
) -> lustre@internals@vdom:element(RWD).
symbol(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"symbol"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 160).
-spec desc(
    list(lustre@internals@vdom:attribute(RWJ)),
    list(lustre@internals@vdom:element(RWJ))
) -> lustre@internals@vdom:element(RWJ).
desc(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"desc"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 168).
-spec metadata(
    list(lustre@internals@vdom:attribute(RWP)),
    list(lustre@internals@vdom:element(RWP))
) -> lustre@internals@vdom:element(RWP).
metadata(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"metadata"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 176).
-spec title(
    list(lustre@internals@vdom:attribute(RWV)),
    list(lustre@internals@vdom:element(RWV))
) -> lustre@internals@vdom:element(RWV).
title(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"title"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 186).
-spec fe_blend(list(lustre@internals@vdom:attribute(RXB))) -> lustre@internals@vdom:element(RXB).
fe_blend(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feBlend"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 191).
-spec fe_color_matrix(list(lustre@internals@vdom:attribute(RXF))) -> lustre@internals@vdom:element(RXF).
fe_color_matrix(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feColorMatrix"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 196).
-spec fe_component_transfer(list(lustre@internals@vdom:attribute(RXJ))) -> lustre@internals@vdom:element(RXJ).
fe_component_transfer(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feComponentTransfer"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 201).
-spec fe_composite(list(lustre@internals@vdom:attribute(RXN))) -> lustre@internals@vdom:element(RXN).
fe_composite(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feComposite"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 206).
-spec fe_convolve_matrix(list(lustre@internals@vdom:attribute(RXR))) -> lustre@internals@vdom:element(RXR).
fe_convolve_matrix(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feConvolveMatrix"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 211).
-spec fe_diffuse_lighting(
    list(lustre@internals@vdom:attribute(RXV)),
    list(lustre@internals@vdom:element(RXV))
) -> lustre@internals@vdom:element(RXV).
fe_diffuse_lighting(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feDiffuseLighting"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 219).
-spec fe_displacement_map(list(lustre@internals@vdom:attribute(RYB))) -> lustre@internals@vdom:element(RYB).
fe_displacement_map(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feDisplacementMap"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 224).
-spec fe_drop_shadow(list(lustre@internals@vdom:attribute(RYF))) -> lustre@internals@vdom:element(RYF).
fe_drop_shadow(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feDropShadow"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 229).
-spec fe_flood(list(lustre@internals@vdom:attribute(RYJ))) -> lustre@internals@vdom:element(RYJ).
fe_flood(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feFlood"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 234).
-spec fe_func_a(list(lustre@internals@vdom:attribute(RYN))) -> lustre@internals@vdom:element(RYN).
fe_func_a(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feFuncA"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 239).
-spec fe_func_b(list(lustre@internals@vdom:attribute(RYR))) -> lustre@internals@vdom:element(RYR).
fe_func_b(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feFuncB"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 244).
-spec fe_func_g(list(lustre@internals@vdom:attribute(RYV))) -> lustre@internals@vdom:element(RYV).
fe_func_g(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feFuncG"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 249).
-spec fe_func_r(list(lustre@internals@vdom:attribute(RYZ))) -> lustre@internals@vdom:element(RYZ).
fe_func_r(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feFuncR"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 254).
-spec fe_gaussian_blur(list(lustre@internals@vdom:attribute(RZD))) -> lustre@internals@vdom:element(RZD).
fe_gaussian_blur(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feGaussianBlur"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 259).
-spec fe_image(list(lustre@internals@vdom:attribute(RZH))) -> lustre@internals@vdom:element(RZH).
fe_image(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feImage"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 264).
-spec fe_merge(
    list(lustre@internals@vdom:attribute(RZL)),
    list(lustre@internals@vdom:element(RZL))
) -> lustre@internals@vdom:element(RZL).
fe_merge(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feMerge"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 272).
-spec fe_merge_node(list(lustre@internals@vdom:attribute(RZR))) -> lustre@internals@vdom:element(RZR).
fe_merge_node(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feMergeNode"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 277).
-spec fe_morphology(list(lustre@internals@vdom:attribute(RZV))) -> lustre@internals@vdom:element(RZV).
fe_morphology(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feMorphology"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 282).
-spec fe_offset(list(lustre@internals@vdom:attribute(RZZ))) -> lustre@internals@vdom:element(RZZ).
fe_offset(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feOffset"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 287).
-spec fe_specular_lighting(
    list(lustre@internals@vdom:attribute(SAD)),
    list(lustre@internals@vdom:element(SAD))
) -> lustre@internals@vdom:element(SAD).
fe_specular_lighting(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feSpecularLighting"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 295).
-spec fe_tile(
    list(lustre@internals@vdom:attribute(SAJ)),
    list(lustre@internals@vdom:element(SAJ))
) -> lustre@internals@vdom:element(SAJ).
fe_tile(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feTile"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 303).
-spec fe_turbulence(list(lustre@internals@vdom:attribute(SAP))) -> lustre@internals@vdom:element(SAP).
fe_turbulence(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feTurbulence"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 310).
-spec linear_gradient(
    list(lustre@internals@vdom:attribute(SAT)),
    list(lustre@internals@vdom:element(SAT))
) -> lustre@internals@vdom:element(SAT).
linear_gradient(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"linearGradient"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 318).
-spec radial_gradient(
    list(lustre@internals@vdom:attribute(SAZ)),
    list(lustre@internals@vdom:element(SAZ))
) -> lustre@internals@vdom:element(SAZ).
radial_gradient(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"radialGradient"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 326).
-spec stop(list(lustre@internals@vdom:attribute(SBF))) -> lustre@internals@vdom:element(SBF).
stop(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"stop"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 333).
-spec image(list(lustre@internals@vdom:attribute(SBJ))) -> lustre@internals@vdom:element(SBJ).
image(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"image"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 338).
-spec path(list(lustre@internals@vdom:attribute(SBN))) -> lustre@internals@vdom:element(SBN).
path(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"path"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 343).
-spec text(list(lustre@internals@vdom:attribute(SBR)), binary()) -> lustre@internals@vdom:element(SBR).
text(Attrs, Content) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"text"/utf8>>,
        Attrs,
        [lustre@element:text(Content)]
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 348).
-spec use_(list(lustre@internals@vdom:attribute(SBV))) -> lustre@internals@vdom:element(SBV).
use_(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"use"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 355).
-spec fe_distant_light(list(lustre@internals@vdom:attribute(SBZ))) -> lustre@internals@vdom:element(SBZ).
fe_distant_light(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feDistantLight"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 360).
-spec fe_point_light(list(lustre@internals@vdom:attribute(SCD))) -> lustre@internals@vdom:element(SCD).
fe_point_light(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"fePointLight"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 365).
-spec fe_spot_light(list(lustre@internals@vdom:attribute(SCH))) -> lustre@internals@vdom:element(SCH).
fe_spot_light(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feSpotLight"/utf8>>,
        Attrs,
        []
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 372).
-spec clip_path(
    list(lustre@internals@vdom:attribute(SCL)),
    list(lustre@internals@vdom:element(SCL))
) -> lustre@internals@vdom:element(SCL).
clip_path(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"clipPath"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 380).
-spec script(list(lustre@internals@vdom:attribute(SCR)), binary()) -> lustre@internals@vdom:element(SCR).
script(Attrs, Js) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"script"/utf8>>,
        Attrs,
        [lustre@element:text(Js)]
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 385).
-spec style(list(lustre@internals@vdom:attribute(SCV)), binary()) -> lustre@internals@vdom:element(SCV).
style(Attrs, Css) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"style"/utf8>>,
        Attrs,
        [lustre@element:text(Css)]
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 392).
-spec foreign_object(
    list(lustre@internals@vdom:attribute(SCZ)),
    list(lustre@internals@vdom:element(SCZ))
) -> lustre@internals@vdom:element(SCZ).
foreign_object(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"foreignObject"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 400).
-spec text_path(
    list(lustre@internals@vdom:attribute(SDF)),
    list(lustre@internals@vdom:element(SDF))
) -> lustre@internals@vdom:element(SDF).
text_path(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"textPath"/utf8>>,
        Attrs,
        Children
    ).

-file("/Users/hayleigh/work/lustre-labs/lustre/src/lustre/element/svg.gleam", 408).
-spec tspan(
    list(lustre@internals@vdom:attribute(SDL)),
    list(lustre@internals@vdom:element(SDL))
) -> lustre@internals@vdom:element(SDL).
tspan(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"tspan"/utf8>>,
        Attrs,
        Children
    ).
