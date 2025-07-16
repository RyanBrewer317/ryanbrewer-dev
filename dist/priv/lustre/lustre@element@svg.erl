-module(lustre@element@svg).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).
-define(FILEPATH, "src/lustre/element/svg.gleam").
-export([animate/1, animate_motion/1, animate_transform/1, mpath/1, set/1, circle/1, ellipse/1, line/1, polygon/1, polyline/1, rect/1, a/2, defs/2, g/2, marker/2, mask/2, missing_glyph/2, pattern/2, svg/2, switch/2, symbol/2, desc/2, metadata/2, title/2, fe_blend/1, fe_color_matrix/1, fe_component_transfer/1, fe_composite/1, fe_convolve_matrix/1, fe_diffuse_lighting/2, fe_displacement_map/1, fe_drop_shadow/1, fe_flood/1, fe_func_a/1, fe_func_b/1, fe_func_g/1, fe_func_r/1, fe_gaussian_blur/1, fe_image/1, fe_merge/2, fe_merge_node/1, fe_morphology/1, fe_offset/1, fe_specular_lighting/2, fe_tile/2, fe_turbulence/1, linear_gradient/2, radial_gradient/2, stop/1, image/1, path/1, text/2, use_/1, fe_distant_light/1, fe_point_light/1, fe_spot_light/1, clip_path/2, script/2, style/2, foreign_object/2, text_path/2, tspan/2]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-file("src/lustre/element/svg.gleam", 20).
?DOC("\n").
-spec animate(list(lustre@vdom@vattr:attribute(TOP))) -> lustre@vdom@vnode:element(TOP).
animate(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"animate"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 25).
?DOC("\n").
-spec animate_motion(list(lustre@vdom@vattr:attribute(TOT))) -> lustre@vdom@vnode:element(TOT).
animate_motion(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"animateMotion"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 30).
?DOC("\n").
-spec animate_transform(list(lustre@vdom@vattr:attribute(TOX))) -> lustre@vdom@vnode:element(TOX).
animate_transform(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"animateTransform"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 35).
?DOC("\n").
-spec mpath(list(lustre@vdom@vattr:attribute(TPB))) -> lustre@vdom@vnode:element(TPB).
mpath(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"mpath"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 40).
?DOC("\n").
-spec set(list(lustre@vdom@vattr:attribute(TPF))) -> lustre@vdom@vnode:element(TPF).
set(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"set"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 47).
?DOC("\n").
-spec circle(list(lustre@vdom@vattr:attribute(TPJ))) -> lustre@vdom@vnode:element(TPJ).
circle(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"circle"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 52).
?DOC("\n").
-spec ellipse(list(lustre@vdom@vattr:attribute(TPN))) -> lustre@vdom@vnode:element(TPN).
ellipse(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"ellipse"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 57).
?DOC("\n").
-spec line(list(lustre@vdom@vattr:attribute(TPR))) -> lustre@vdom@vnode:element(TPR).
line(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"line"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 62).
?DOC("\n").
-spec polygon(list(lustre@vdom@vattr:attribute(TPV))) -> lustre@vdom@vnode:element(TPV).
polygon(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"polygon"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 67).
?DOC("\n").
-spec polyline(list(lustre@vdom@vattr:attribute(TPZ))) -> lustre@vdom@vnode:element(TPZ).
polyline(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"polyline"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 72).
?DOC("\n").
-spec rect(list(lustre@vdom@vattr:attribute(TQD))) -> lustre@vdom@vnode:element(TQD).
rect(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"rect"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 79).
?DOC("\n").
-spec a(
    list(lustre@vdom@vattr:attribute(TQH)),
    list(lustre@vdom@vnode:element(TQH))
) -> lustre@vdom@vnode:element(TQH).
a(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"a"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 87).
?DOC("\n").
-spec defs(
    list(lustre@vdom@vattr:attribute(TQN)),
    list(lustre@vdom@vnode:element(TQN))
) -> lustre@vdom@vnode:element(TQN).
defs(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"defs"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 95).
?DOC("\n").
-spec g(
    list(lustre@vdom@vattr:attribute(TQT)),
    list(lustre@vdom@vnode:element(TQT))
) -> lustre@vdom@vnode:element(TQT).
g(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"g"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 103).
?DOC("\n").
-spec marker(
    list(lustre@vdom@vattr:attribute(TQZ)),
    list(lustre@vdom@vnode:element(TQZ))
) -> lustre@vdom@vnode:element(TQZ).
marker(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"marker"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 111).
?DOC("\n").
-spec mask(
    list(lustre@vdom@vattr:attribute(TRF)),
    list(lustre@vdom@vnode:element(TRF))
) -> lustre@vdom@vnode:element(TRF).
mask(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"mask"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 119).
?DOC("\n").
-spec missing_glyph(
    list(lustre@vdom@vattr:attribute(TRL)),
    list(lustre@vdom@vnode:element(TRL))
) -> lustre@vdom@vnode:element(TRL).
missing_glyph(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"missing-glyph"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 127).
?DOC("\n").
-spec pattern(
    list(lustre@vdom@vattr:attribute(TRR)),
    list(lustre@vdom@vnode:element(TRR))
) -> lustre@vdom@vnode:element(TRR).
pattern(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"pattern"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 135).
?DOC("\n").
-spec svg(
    list(lustre@vdom@vattr:attribute(TRX)),
    list(lustre@vdom@vnode:element(TRX))
) -> lustre@vdom@vnode:element(TRX).
svg(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"svg"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 143).
?DOC("\n").
-spec switch(
    list(lustre@vdom@vattr:attribute(TSD)),
    list(lustre@vdom@vnode:element(TSD))
) -> lustre@vdom@vnode:element(TSD).
switch(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"switch"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 151).
?DOC("\n").
-spec symbol(
    list(lustre@vdom@vattr:attribute(TSJ)),
    list(lustre@vdom@vnode:element(TSJ))
) -> lustre@vdom@vnode:element(TSJ).
symbol(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"symbol"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 161).
?DOC("\n").
-spec desc(
    list(lustre@vdom@vattr:attribute(TSP)),
    list(lustre@vdom@vnode:element(TSP))
) -> lustre@vdom@vnode:element(TSP).
desc(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"desc"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 169).
?DOC("\n").
-spec metadata(
    list(lustre@vdom@vattr:attribute(TSV)),
    list(lustre@vdom@vnode:element(TSV))
) -> lustre@vdom@vnode:element(TSV).
metadata(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"metadata"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 177).
?DOC("\n").
-spec title(
    list(lustre@vdom@vattr:attribute(TTB)),
    list(lustre@vdom@vnode:element(TTB))
) -> lustre@vdom@vnode:element(TTB).
title(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"title"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 187).
?DOC("\n").
-spec fe_blend(list(lustre@vdom@vattr:attribute(TTH))) -> lustre@vdom@vnode:element(TTH).
fe_blend(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feBlend"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 192).
?DOC("\n").
-spec fe_color_matrix(list(lustre@vdom@vattr:attribute(TTL))) -> lustre@vdom@vnode:element(TTL).
fe_color_matrix(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feColorMatrix"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 197).
?DOC("\n").
-spec fe_component_transfer(list(lustre@vdom@vattr:attribute(TTP))) -> lustre@vdom@vnode:element(TTP).
fe_component_transfer(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feComponentTransfer"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 202).
?DOC("\n").
-spec fe_composite(list(lustre@vdom@vattr:attribute(TTT))) -> lustre@vdom@vnode:element(TTT).
fe_composite(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feComposite"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 207).
?DOC("\n").
-spec fe_convolve_matrix(list(lustre@vdom@vattr:attribute(TTX))) -> lustre@vdom@vnode:element(TTX).
fe_convolve_matrix(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feConvolveMatrix"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 212).
?DOC("\n").
-spec fe_diffuse_lighting(
    list(lustre@vdom@vattr:attribute(TUB)),
    list(lustre@vdom@vnode:element(TUB))
) -> lustre@vdom@vnode:element(TUB).
fe_diffuse_lighting(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feDiffuseLighting"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 220).
?DOC("\n").
-spec fe_displacement_map(list(lustre@vdom@vattr:attribute(TUH))) -> lustre@vdom@vnode:element(TUH).
fe_displacement_map(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feDisplacementMap"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 225).
?DOC("\n").
-spec fe_drop_shadow(list(lustre@vdom@vattr:attribute(TUL))) -> lustre@vdom@vnode:element(TUL).
fe_drop_shadow(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feDropShadow"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 230).
?DOC("\n").
-spec fe_flood(list(lustre@vdom@vattr:attribute(TUP))) -> lustre@vdom@vnode:element(TUP).
fe_flood(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feFlood"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 235).
?DOC("\n").
-spec fe_func_a(list(lustre@vdom@vattr:attribute(TUT))) -> lustre@vdom@vnode:element(TUT).
fe_func_a(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feFuncA"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 240).
?DOC("\n").
-spec fe_func_b(list(lustre@vdom@vattr:attribute(TUX))) -> lustre@vdom@vnode:element(TUX).
fe_func_b(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feFuncB"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 245).
?DOC("\n").
-spec fe_func_g(list(lustre@vdom@vattr:attribute(TVB))) -> lustre@vdom@vnode:element(TVB).
fe_func_g(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feFuncG"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 250).
?DOC("\n").
-spec fe_func_r(list(lustre@vdom@vattr:attribute(TVF))) -> lustre@vdom@vnode:element(TVF).
fe_func_r(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feFuncR"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 255).
?DOC("\n").
-spec fe_gaussian_blur(list(lustre@vdom@vattr:attribute(TVJ))) -> lustre@vdom@vnode:element(TVJ).
fe_gaussian_blur(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feGaussianBlur"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 260).
?DOC("\n").
-spec fe_image(list(lustre@vdom@vattr:attribute(TVN))) -> lustre@vdom@vnode:element(TVN).
fe_image(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feImage"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 265).
?DOC("\n").
-spec fe_merge(
    list(lustre@vdom@vattr:attribute(TVR)),
    list(lustre@vdom@vnode:element(TVR))
) -> lustre@vdom@vnode:element(TVR).
fe_merge(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feMerge"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 273).
?DOC("\n").
-spec fe_merge_node(list(lustre@vdom@vattr:attribute(TVX))) -> lustre@vdom@vnode:element(TVX).
fe_merge_node(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feMergeNode"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 278).
?DOC("\n").
-spec fe_morphology(list(lustre@vdom@vattr:attribute(TWB))) -> lustre@vdom@vnode:element(TWB).
fe_morphology(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feMorphology"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 283).
?DOC("\n").
-spec fe_offset(list(lustre@vdom@vattr:attribute(TWF))) -> lustre@vdom@vnode:element(TWF).
fe_offset(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feOffset"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 288).
?DOC("\n").
-spec fe_specular_lighting(
    list(lustre@vdom@vattr:attribute(TWJ)),
    list(lustre@vdom@vnode:element(TWJ))
) -> lustre@vdom@vnode:element(TWJ).
fe_specular_lighting(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feSpecularLighting"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 296).
?DOC("\n").
-spec fe_tile(
    list(lustre@vdom@vattr:attribute(TWP)),
    list(lustre@vdom@vnode:element(TWP))
) -> lustre@vdom@vnode:element(TWP).
fe_tile(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feTile"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 304).
?DOC("\n").
-spec fe_turbulence(list(lustre@vdom@vattr:attribute(TWV))) -> lustre@vdom@vnode:element(TWV).
fe_turbulence(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feTurbulence"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 311).
?DOC("\n").
-spec linear_gradient(
    list(lustre@vdom@vattr:attribute(TWZ)),
    list(lustre@vdom@vnode:element(TWZ))
) -> lustre@vdom@vnode:element(TWZ).
linear_gradient(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"linearGradient"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 319).
?DOC("\n").
-spec radial_gradient(
    list(lustre@vdom@vattr:attribute(TXF)),
    list(lustre@vdom@vnode:element(TXF))
) -> lustre@vdom@vnode:element(TXF).
radial_gradient(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"radialGradient"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 327).
?DOC("\n").
-spec stop(list(lustre@vdom@vattr:attribute(TXL))) -> lustre@vdom@vnode:element(TXL).
stop(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"stop"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 334).
?DOC("\n").
-spec image(list(lustre@vdom@vattr:attribute(TXP))) -> lustre@vdom@vnode:element(TXP).
image(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"image"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 339).
?DOC("\n").
-spec path(list(lustre@vdom@vattr:attribute(TXT))) -> lustre@vdom@vnode:element(TXT).
path(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"path"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 344).
?DOC("\n").
-spec text(list(lustre@vdom@vattr:attribute(TXX)), binary()) -> lustre@vdom@vnode:element(TXX).
text(Attrs, Content) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"text"/utf8>>,
        Attrs,
        [lustre@element:text(Content)]
    ).

-file("src/lustre/element/svg.gleam", 349).
?DOC("\n").
-spec use_(list(lustre@vdom@vattr:attribute(TYB))) -> lustre@vdom@vnode:element(TYB).
use_(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"use"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 356).
?DOC("\n").
-spec fe_distant_light(list(lustre@vdom@vattr:attribute(TYF))) -> lustre@vdom@vnode:element(TYF).
fe_distant_light(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feDistantLight"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 361).
?DOC("\n").
-spec fe_point_light(list(lustre@vdom@vattr:attribute(TYJ))) -> lustre@vdom@vnode:element(TYJ).
fe_point_light(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"fePointLight"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 366).
?DOC("\n").
-spec fe_spot_light(list(lustre@vdom@vattr:attribute(TYN))) -> lustre@vdom@vnode:element(TYN).
fe_spot_light(Attrs) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"feSpotLight"/utf8>>,
        Attrs,
        []
    ).

-file("src/lustre/element/svg.gleam", 373).
?DOC("\n").
-spec clip_path(
    list(lustre@vdom@vattr:attribute(TYR)),
    list(lustre@vdom@vnode:element(TYR))
) -> lustre@vdom@vnode:element(TYR).
clip_path(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"clipPath"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 381).
?DOC("\n").
-spec script(list(lustre@vdom@vattr:attribute(TYX)), binary()) -> lustre@vdom@vnode:element(TYX).
script(Attrs, Js) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"script"/utf8>>,
        Attrs,
        [lustre@element:text(Js)]
    ).

-file("src/lustre/element/svg.gleam", 386).
?DOC("\n").
-spec style(list(lustre@vdom@vattr:attribute(TZB)), binary()) -> lustre@vdom@vnode:element(TZB).
style(Attrs, Css) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"style"/utf8>>,
        Attrs,
        [lustre@element:text(Css)]
    ).

-file("src/lustre/element/svg.gleam", 393).
?DOC("\n").
-spec foreign_object(
    list(lustre@vdom@vattr:attribute(TZF)),
    list(lustre@vdom@vnode:element(TZF))
) -> lustre@vdom@vnode:element(TZF).
foreign_object(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"foreignObject"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 401).
?DOC("\n").
-spec text_path(
    list(lustre@vdom@vattr:attribute(TZL)),
    list(lustre@vdom@vnode:element(TZL))
) -> lustre@vdom@vnode:element(TZL).
text_path(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"textPath"/utf8>>,
        Attrs,
        Children
    ).

-file("src/lustre/element/svg.gleam", 409).
?DOC("\n").
-spec tspan(
    list(lustre@vdom@vattr:attribute(TZR)),
    list(lustre@vdom@vnode:element(TZR))
) -> lustre@vdom@vnode:element(TZR).
tspan(Attrs, Children) ->
    lustre@element:namespaced(
        <<"http://www.w3.org/2000/svg"/utf8>>,
        <<"tspan"/utf8>>,
        Attrs,
        Children
    ).
