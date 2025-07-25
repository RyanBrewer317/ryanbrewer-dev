-module(arctic@build).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).
-define(FILEPATH, "src/arctic/build.gleam").
-export([build/1]).

-if(?OTP_RELEASE >= 27).
-define(MODULEDOC(Str), -moduledoc(Str)).
-define(DOC(Str), -doc(Str)).
-else.
-define(MODULEDOC(Str), -compile([])).
-define(DOC(Str), -compile([])).
-endif.

-file("src/arctic/build.gleam", 26).
-spec lift_ordering(fun((arctic:page(), arctic:page()) -> gleam@order:order())) -> fun((arctic:cacheable_page(), arctic:cacheable_page()) -> gleam@order:order()).
lift_ordering(Ordering) ->
    fun(A, B) -> Ordering(arctic:to_dummy_page(A), arctic:to_dummy_page(B)) end.

-file("src/arctic/build.gleam", 32).
-spec get_id(arctic:cacheable_page()) -> binary().
get_id(P) ->
    case P of
        {cached_page, _, Metadata} ->
            Id@1 = case gleam_stdlib:map_get(Metadata, <<"id"/utf8>>) of
                {ok, Id} -> Id;
                _assert_fail ->
                    erlang:error(#{gleam_error => let_assert,
                                message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                file => <<?FILEPATH/utf8>>,
                                module => <<"arctic/build"/utf8>>,
                                function => <<"get_id"/utf8>>,
                                line => 35,
                                value => _assert_fail,
                                start => 904,
                                'end' => 948,
                                pattern_start => 915,
                                pattern_end => 921})
            end,
            Id@1;

        {new_page, Page} ->
            erlang:element(2, Page)
    end.

-file("src/arctic/build.gleam", 42).
-spec to_metadata(list(binary())) -> {ok, gleam@dict:dict(binary(), binary())} |
    {error, snag:snag()}.
to_metadata(Csv) ->
    case Csv of
        [] ->
            {ok, maps:new()};

        [Pair_str | Rest] ->
            case gleam@string:split(Pair_str, <<":"/utf8>>) of
                [] ->
                    snag:error(
                        <<"malformed cache (metadata item with no colon)"/utf8>>
                    );

                [Key | Vals] ->
                    gleam@result:'try'(
                        to_metadata(Rest),
                        fun(Rest2) ->
                            {ok,
                                gleam@dict:insert(
                                    Rest2,
                                    Key,
                                    gleam@string:join(Vals, <<":"/utf8>>)
                                )}
                        end
                    )
            end
    end.

-file("src/arctic/build.gleam", 56).
-spec to_cache(list(list(binary()))) -> {ok,
        gleam@dict:dict(binary(), {bitstring(),
            gleam@dict:dict(binary(), binary())})} |
    {error, snag:snag()}.
to_cache(Csv) ->
    case Csv of
        [] ->
            {ok, maps:new()};

        [[Id, Hash | Metadata] | Rest] ->
            gleam@result:'try'(
                to_cache(Rest),
                fun(Rest2) ->
                    gleam@result:'try'(
                        to_metadata(Metadata),
                        fun(Metadata2) ->
                            gleam@result:'try'(
                                begin
                                    _pipe = gleam@bit_array:base64_decode(Hash),
                                    gleam@result:map_error(
                                        _pipe,
                                        fun(_) ->
                                            snag:new(
                                                <<<<"malformed cache (`"/utf8,
                                                        Hash/binary>>/binary,
                                                    "` is not a valid base-64 hash)"/utf8>>
                                            )
                                        end
                                    )
                                end,
                                fun(Hash_str) ->
                                    {ok,
                                        gleam@dict:insert(
                                            Rest2,
                                            Id,
                                            {Hash_str, Metadata2}
                                        )}
                                end
                            )
                        end
                    )
                end
            );

        [Malformed_row | _] ->
            snag:error(
                <<<<"malformed cache (row `"/utf8,
                        (gleam@string:join(Malformed_row, <<", "/utf8>>))/binary>>/binary,
                    "`)"/utf8>>
            )
    end.

-file("src/arctic/build.gleam", 79).
-spec parse_csv(binary()) -> {ok, list(list(binary()))} | {error, snag:snag()}.
parse_csv(Csv) ->
    Res = party:go(
        begin
            _pipe = begin
                party:do(
                    party:char(<<"\""/utf8>>),
                    fun(_) ->
                        party:do(
                            party:many_concat(
                                party:either(
                                    party:map(
                                        party:string(<<"\"\""/utf8>>),
                                        fun(_) -> <<"\""/utf8>> end
                                    ),
                                    party:satisfy(
                                        fun(C) -> C /= <<"\""/utf8>> end
                                    )
                                )
                            ),
                            fun(Val) ->
                                party:do(
                                    party:char(<<"\""/utf8>>),
                                    fun(_) -> party:return(Val) end
                                )
                            end
                        )
                    end
                )
            end,
            _pipe@1 = party:sep(_pipe, party:char(<<","/utf8>>)),
            _pipe@2 = (fun(P) ->
                party:do(
                    P,
                    fun(Row) ->
                        party:seq(party:char(<<"\n"/utf8>>), party:return(Row))
                    end
                )
            end)(_pipe@1),
            party:many(_pipe@2)
        end,
        Csv
    ),
    gleam@result:map_error(Res, fun(E) -> case E of
                {unexpected, P@1, S} ->
                    snag:new(
                        <<<<<<<<S/binary, " at "/utf8>>/binary,
                                    (erlang:integer_to_binary(
                                        erlang:element(2, P@1)
                                    ))/binary>>/binary,
                                ":"/utf8>>/binary,
                            (erlang:integer_to_binary(erlang:element(3, P@1)))/binary>>
                    );

                {user_error, P@2, nil} ->
                    snag:new(
                        <<<<<<"internal Arctic error at "/utf8,
                                    (erlang:integer_to_binary(
                                        erlang:element(2, P@2)
                                    ))/binary>>/binary,
                                ":"/utf8>>/binary,
                            (erlang:integer_to_binary(erlang:element(3, P@2)))/binary>>
                    )
            end end).

-file("src/arctic/build.gleam", 117).
-spec read_collection(
    arctic:collection(),
    gleam@dict:dict(binary(), {bitstring(), gleam@dict:dict(binary(), binary())})
) -> {ok, list(arctic:cacheable_page())} | {error, snag:snag()}.
read_collection(Collection, Cache) ->
    gleam@result:'try'(
        begin
            _pipe = simplifile:get_files(erlang:element(2, Collection)),
            gleam@result:map_error(
                _pipe,
                fun(Err) ->
                    snag:new(
                        <<<<<<<<"couldn't get files in `"/utf8,
                                        (erlang:element(2, Collection))/binary>>/binary,
                                    "` ("/utf8>>/binary,
                                (simplifile:describe_error(Err))/binary>>/binary,
                            ")"/utf8>>
                    )
                end
            )
        end,
        fun(Paths) ->
            _pipe@2 = gleam@list:try_fold(
                Paths,
                [],
                fun(So_far, Path) ->
                    gleam@result:'try'(
                        gleam@result:map_error(
                            simplifile:read(Path),
                            fun(Err@1) ->
                                snag:new(
                                    <<<<<<<<"could not load file `"/utf8,
                                                    Path/binary>>/binary,
                                                "` ("/utf8>>/binary,
                                            (simplifile:describe_error(Err@1))/binary>>/binary,
                                        ")"/utf8>>
                                )
                            end
                        ),
                        fun(Content) ->
                            New_hash = gleam@crypto:hash(
                                sha256,
                                gleam_stdlib:identity(Content)
                            ),
                            case gleam_stdlib:map_get(Cache, Path) of
                                {ok, {Current_hash, Metadata}} when Current_hash =:= New_hash ->
                                    {ok,
                                        [{cached_page, Path, Metadata} | So_far]};

                                _ ->
                                    gleam@result:'try'(
                                        (erlang:element(3, Collection))(
                                            Path,
                                            Content
                                        ),
                                        fun(P) ->
                                            gleam@result:'try'(
                                                begin
                                                    _pipe@1 = simplifile:append(
                                                        <<".arctic_cache.csv"/utf8>>,
                                                        <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"\""/utf8,
                                                                                                                        (gleam@string:replace(
                                                                                                                            Path,
                                                                                                                            <<"\""/utf8>>,
                                                                                                                            <<"\"\""/utf8>>
                                                                                                                        ))/binary>>/binary,
                                                                                                                    "\",\""/utf8>>/binary,
                                                                                                                (gleam_stdlib:bit_array_base64_encode(
                                                                                                                    New_hash,
                                                                                                                    false
                                                                                                                ))/binary>>/binary,
                                                                                                            "\",\"id:"/utf8>>/binary,
                                                                                                        (gleam@string:replace(
                                                                                                            erlang:element(
                                                                                                                2,
                                                                                                                P
                                                                                                            ),
                                                                                                            <<"\""/utf8>>,
                                                                                                            <<"\"\""/utf8>>
                                                                                                        ))/binary>>/binary,
                                                                                                    "\",\"title:"/utf8>>/binary,
                                                                                                (gleam@string:replace(
                                                                                                    erlang:element(
                                                                                                        5,
                                                                                                        P
                                                                                                    ),
                                                                                                    <<"\""/utf8>>,
                                                                                                    <<"\"\""/utf8>>
                                                                                                ))/binary>>/binary,
                                                                                            "\""/utf8>>/binary,
                                                                                        (gleam@option:unwrap(
                                                                                            gleam@option:map(
                                                                                                erlang:element(
                                                                                                    8,
                                                                                                    P
                                                                                                ),
                                                                                                fun(
                                                                                                    D
                                                                                                ) ->
                                                                                                    <<<<",\"date:"/utf8,
                                                                                                            (arctic:date_to_string(
                                                                                                                D
                                                                                                            ))/binary>>/binary,
                                                                                                        "\""/utf8>>
                                                                                                end
                                                                                            ),
                                                                                            <<""/utf8>>
                                                                                        ))/binary>>/binary,
                                                                                    ",\"tags:"/utf8>>/binary,
                                                                                (gleam@string:join(
                                                                                    gleam@list:map(
                                                                                        erlang:element(
                                                                                            7,
                                                                                            P
                                                                                        ),
                                                                                        fun(
                                                                                            _capture
                                                                                        ) ->
                                                                                            gleam@string:replace(
                                                                                                _capture,
                                                                                                <<"\""/utf8>>,
                                                                                                <<"\"\""/utf8>>
                                                                                            )
                                                                                        end
                                                                                    ),
                                                                                    <<","/utf8>>
                                                                                ))/binary>>/binary,
                                                                            "\",\"blerb:"/utf8>>/binary,
                                                                        (gleam@string:replace(
                                                                            erlang:element(
                                                                                6,
                                                                                P
                                                                            ),
                                                                            <<"\""/utf8>>,
                                                                            <<"\"\""/utf8>>
                                                                        ))/binary>>/binary,
                                                                    "\""/utf8>>/binary,
                                                                (gleam@dict:fold(
                                                                    erlang:element(
                                                                        4,
                                                                        P
                                                                    ),
                                                                    <<""/utf8>>,
                                                                    fun(B, K, V) ->
                                                                        <<<<<<<<<<B/binary,
                                                                                            ",\""/utf8>>/binary,
                                                                                        (gleam@string:replace(
                                                                                            K,
                                                                                            <<"\""/utf8>>,
                                                                                            <<"\"\""/utf8>>
                                                                                        ))/binary>>/binary,
                                                                                    ":"/utf8>>/binary,
                                                                                (gleam@string:replace(
                                                                                    V,
                                                                                    <<"\""/utf8>>,
                                                                                    <<"\"\""/utf8>>
                                                                                ))/binary>>/binary,
                                                                            "\""/utf8>>
                                                                    end
                                                                ))/binary>>/binary,
                                                            "\n"/utf8>>
                                                    ),
                                                    gleam@result:map_error(
                                                        _pipe@1,
                                                        fun(Err@2) ->
                                                            snag:new(
                                                                <<<<"couldn't write to cache ("/utf8,
                                                                        (simplifile:describe_error(
                                                                            Err@2
                                                                        ))/binary>>/binary,
                                                                    ")"/utf8>>
                                                            )
                                                        end
                                                    )
                                                end,
                                                fun(_) ->
                                                    {ok,
                                                        [{new_page, P} | So_far]}
                                                end
                                            )
                                        end
                                    )
                            end
                        end
                    )
                end
            ),
            gleam@result:map(_pipe@2, fun lists:reverse/1)
        end
    ).

-file("src/arctic/build.gleam", 203).
-spec process(
    list(arctic:collection()),
    gleam@dict:dict(binary(), {bitstring(), gleam@dict:dict(binary(), binary())})
) -> {ok, list(arctic:processed_collection())} | {error, snag:snag()}.
process(Collections, Cache) ->
    gleam@list:try_fold(
        Collections,
        [],
        fun(Rest, Collection) ->
            gleam@result:'try'(
                read_collection(Collection, Cache),
                fun(Pages_unsorted) ->
                    Pages = gleam@list:sort(
                        Pages_unsorted,
                        lift_ordering(erlang:element(6, Collection))
                    ),
                    {ok, [{processed_collection, Collection, Pages} | Rest]}
                end
            )
        end
    ).

-file("src/arctic/build.gleam", 241).
-spec spa(
    fun((lustre@vdom@vnode:element(nil)) -> lustre@vdom@vnode:element(nil)),
    lustre@vdom@vnode:element(nil)
) -> lustre@vdom@vnode:element(nil).
spa(Frame, Html) ->
    Frame(
        lustre@element@html:'div'(
            [],
            [lustre@element@html:script(
                    [],
                    <<"
var _ARCTIC_C;
if (typeof HTMLDocument === 'undefined') HTMLDocument = Document;
let arctic_dom_content_loaded_listeners = [];
HTMLDocument.prototype.arctic_addEventListener = HTMLDocument.prototype.addEventListener;
HTMLDocument.prototype.addEventListener = function(type, listener, options) {
  if (type === 'DOMContentLoaded') {
    arctic_dom_content_loaded_listeners.push(listener);
    document.arctic_addEventListener(type, listener, options);
  } else document.arctic_addEventListener(type, listener, options);
}
       "/utf8>>
                ),
                lustre@element@html:'div'(
                    [lustre@attribute:id(<<"arctic-app"/utf8>>)],
                    [Html]
                ),
                lustre@element@html:script(
                    [],
                    <<"
// SPA algorithm partially inspired by Hayleigh Thompson's wonderful Modem library
async function go_to(url, loader, back) {
  if (!back && url.pathname === window.location.pathname) {
    if (url.hash) document.getElementById(url.hash.slice(1))?.scrollIntoView();
    else window.scrollTo(0, 0);
    return;
  }
  document.dispatchEvent(new Event('beforeunload'));
  document.dispatchEvent(new Event('unload'));
  for (let i = 0; i < arctic_dom_content_loaded_listeners.length; i++)
    document.removeEventListener('DOMContentLoaded', arctic_dom_content_loaded_listeners[i]);
  arctic_dom_content_loaded_listeners = [];
  const $app = document.getElementById('arctic-app');
  if (loader) $app.innerHTML = '<div id=\"arctic-loader\"></div>';
  if (!back) window.history.pushState({}, '', url.href);
  // handle new path
  const response = await fetch('/__pages/' + url.pathname + '/index.html');
  if (!response.ok) response = await fetch('/__pages/404.html');
  if (!response.ok) return;
  const html = await response.text();
  $app.innerHTML = '<script>_ARCTIC_C=0;</'+'script>'+html;
  // re-create script elements, so their javascript runs
  const scripts = $app.querySelectorAll('script');
  const num_scripts = scripts.length;
  for (let i = 0; i < num_scripts; i++) {
    const script = scripts[i];
    const n = document.createElement('script');
    // scripts load nondeterministically, so we figure out when they've all finished via the _ARCTIC_C barrier
    if (script.innerHTML === '') {
      // external scripts don't run their inline js, so they need an onload listener
      n.onload = () => {
        if (++_ARCTIC_C >= num_scripts)
          document.dispatchEvent(new Event('DOMContentLoaded'));
      };
    } else {
      // inline scripts might not trigger onload, so they get js appended to the end instead
      const t = document.createTextNode(
        script.innerHTML +
        ';if(++_ARCTIC_C>=' + num_scripts +
        ')document.dispatchEvent(new Event(\\'DOMContentLoaded\\'));'
      );
      n.appendChild(t);
    }
    // attributes at the end because 'src' needs to load after onload is listening
    for (let j = 0; j < script.attributes.length; j++) {
      const attr = script.attributes[j];
      n.setAttribute(attr.name, attr.value);
    }
    script.parentNode.replaceChild(n, script);
  }
  window.requestAnimationFrame(() => {
    if (url.hash)
      document.getElementById(url.hash.slice(1))?.scrollIntoView();
    else
      window.scrollTo(0, 0);
  });
}
document.addEventListener('click', async function(e) {
  const a = find_a(e.target);
  if (!a) return;
  try {
    const url = new URL(a.href);
    const is_external = url.host !== window.location.host;
    if (is_external) return;
    event.preventDefault();
    go_to(url, false, false);
  } catch {
    return;
  }
});
window.addEventListener('popstate', (e) => {
  e.preventDefault();
  const url = new URL(window.location.href);
  go_to(url, false, true);
});
function find_a(target) {
  if (!target || target.tagName === 'BODY') return null;
  if (target.tagName === 'A') return target;
  return find_a(target.parentElement);
}"/utf8>>
                )]
        )
    ).

-file("src/arctic/build.gleam", 438).
-spec add_route(
    lustre@ssg:config(any(), XGP, XGQ),
    arctic:config(),
    binary(),
    lustre@vdom@vnode:element(nil)
) -> lustre@ssg:config(lustre@ssg:has_static_routes(), XGP, XGQ).
add_route(Ssg_config, Config, Path, Content) ->
    case erlang:element(5, Config) of
        {some, Frame} ->
            _pipe = Ssg_config,
            _pipe@1 = lustre@ssg:add_static_route(
                _pipe,
                <<"/__pages/"/utf8, Path/binary>>,
                Content
            ),
            lustre@ssg:add_static_route(
                _pipe@1,
                <<"/"/utf8, Path/binary>>,
                spa(Frame, Content)
            );

        none ->
            _pipe@2 = Ssg_config,
            lustre@ssg:add_static_route(
                _pipe@2,
                <<"/"/utf8, Path/binary>>,
                Content
            )
    end.

-file("src/arctic/build.gleam", 351).
-spec make_ssg_config(
    list(arctic:processed_collection()),
    arctic:config(),
    fun((lustre@ssg:config(lustre@ssg:has_static_routes(), lustre@ssg:no_static_dir(), lustre@ssg:use_index_routes())) -> {ok,
            nil} |
        {error, snag:snag()})
) -> {ok, nil} | {error, snag:snag()}.
make_ssg_config(Processed_collections, Config, K) ->
    Home = (erlang:element(2, Config))(Processed_collections),
    gleam@result:'try'(
        begin
            _pipe = lustre@ssg:new(<<"arctic_build"/utf8>>),
            _pipe@1 = lustre@ssg:use_index_routes(_pipe),
            _pipe@2 = add_route(_pipe@1, Config, <<""/utf8>>, Home),
            _pipe@4 = gleam@list:fold(
                erlang:element(3, Config),
                _pipe@2,
                fun(Ssg_config, Page) -> _pipe@3 = Ssg_config,
                    add_route(
                        _pipe@3,
                        Config,
                        erlang:element(2, Page),
                        erlang:element(3, Page)
                    ) end
            ),
            gleam@list:try_fold(
                Processed_collections,
                _pipe@4,
                fun(Ssg_config@1, Processed) ->
                    Ssg_config2 = case erlang:element(
                        4,
                        erlang:element(2, Processed)
                    ) of
                        {some, Render} ->
                            add_route(
                                Ssg_config@1,
                                Config,
                                erlang:element(2, erlang:element(2, Processed)),
                                Render(erlang:element(3, Processed))
                            );

                        none ->
                            Ssg_config@1
                    end,
                    Ssg_config3 = gleam@list:fold(
                        erlang:element(8, erlang:element(2, Processed)),
                        Ssg_config2,
                        fun(S, Rp) ->
                            add_route(
                                S,
                                Config,
                                <<<<(erlang:element(
                                            2,
                                            erlang:element(2, Processed)
                                        ))/binary,
                                        "/"/utf8>>/binary,
                                    (erlang:element(2, Rp))/binary>>,
                                erlang:element(3, Rp)
                            )
                        end
                    ),
                    _pipe@7 = gleam@list:fold(
                        erlang:element(3, Processed),
                        Ssg_config3,
                        fun(S@1, P) -> case P of
                                {new_page, New_page} ->
                                    add_route(
                                        S@1,
                                        Config,
                                        <<<<(erlang:element(
                                                    2,
                                                    erlang:element(2, Processed)
                                                ))/binary,
                                                "/"/utf8>>/binary,
                                            (erlang:element(2, New_page))/binary>>,
                                        (erlang:element(
                                            7,
                                            erlang:element(2, Processed)
                                        ))(New_page)
                                    );

                                {cached_page, Path, _} ->
                                    Start@1 = case gleam@string:split(
                                        Path,
                                        <<".txt"/utf8>>
                                    ) of
                                        [Start | _] -> Start;
                                        _assert_fail ->
                                            erlang:error(
                                                    #{gleam_error => let_assert,
                                                        message => <<"Pattern match failed, no pattern matched the value."/utf8>>,
                                                        file => <<?FILEPATH/utf8>>,
                                                        module => <<"arctic/build"/utf8>>,
                                                        function => <<"make_ssg_config"/utf8>>,
                                                        line => 402,
                                                        value => _assert_fail,
                                                        start => 12886,
                                                        'end' => 12937,
                                                        pattern_start => 12897,
                                                        pattern_end => 12908}
                                                )
                                    end,
                                    Cached_path = <<<<"arctic_build/"/utf8,
                                            Start@1/binary>>/binary,
                                        "/index.html"/utf8>>,
                                    Res = simplifile:read(Cached_path),
                                    Content = case Res of
                                        {ok, C} ->
                                            C;

                                        {error, _} ->
                                            erlang:error(#{gleam_error => panic,
                                                    message => Cached_path,
                                                    file => <<?FILEPATH/utf8>>,
                                                    module => <<"arctic/build"/utf8>>,
                                                    function => <<"make_ssg_config"/utf8>>,
                                                    line => 407})
                                    end,
                                    case erlang:element(5, Config) of
                                        {some, _} ->
                                            Spa_content_path = <<<<"arctic_build/__pages/"/utf8,
                                                    Start@1/binary>>/binary,
                                                "/index.html"/utf8>>,
                                            Res@1 = simplifile:read(
                                                Spa_content_path
                                            ),
                                            Spa_content = case Res@1 of
                                                {ok, C@1} ->
                                                    C@1;

                                                {error, _} ->
                                                    erlang:error(
                                                        #{gleam_error => panic,
                                                            message => Cached_path,
                                                            file => <<?FILEPATH/utf8>>,
                                                            module => <<"arctic/build"/utf8>>,
                                                            function => <<"make_ssg_config"/utf8>>,
                                                            line => 419}
                                                    )
                                            end,
                                            _pipe@5 = S@1,
                                            _pipe@6 = lustre@ssg:add_static_asset(
                                                _pipe@5,
                                                <<<<"/__pages/"/utf8,
                                                        Start@1/binary>>/binary,
                                                    "/index.html"/utf8>>,
                                                Spa_content
                                            ),
                                            lustre@ssg:add_static_asset(
                                                _pipe@6,
                                                <<<<"/"/utf8, Start@1/binary>>/binary,
                                                    "/index.html"/utf8>>,
                                                Content
                                            );

                                        none ->
                                            lustre@ssg:add_static_asset(
                                                S@1,
                                                <<<<"/"/utf8, Start@1/binary>>/binary,
                                                    "/index.html"/utf8>>,
                                                Content
                                            )
                                    end
                            end end
                    ),
                    {ok, _pipe@7}
                end
            )
        end,
        fun(Ssg_config@2) -> K(Ssg_config@2) end
    ).

-file("src/arctic/build.gleam", 450).
-spec ssg_build(
    lustre@ssg:config(lustre@ssg:has_static_routes(), any(), any()),
    fun(() -> {ok, nil} | {error, snag:snag()})
) -> {ok, nil} | {error, snag:snag()}.
ssg_build(Ssg_config, K) ->
    gleam@result:'try'(
        begin
            _pipe = lustre@ssg:build(Ssg_config),
            gleam@result:map_error(_pipe, fun(Err) -> case Err of
                        {cannot_create_temp_directory, File_err} ->
                            snag:new(
                                <<<<"couldn't create temp directory ("/utf8,
                                        (simplifile:describe_error(File_err))/binary>>/binary,
                                    ")"/utf8>>
                            );

                        {cannot_write_static_asset, File_err@1, Path} ->
                            snag:new(
                                <<<<<<<<"couldn't put asset at `"/utf8,
                                                Path/binary>>/binary,
                                            "` ("/utf8>>/binary,
                                        (simplifile:describe_error(File_err@1))/binary>>/binary,
                                    ")"/utf8>>
                            );

                        {cannot_generate_route, File_err@2, Path@1} ->
                            snag:new(
                                <<<<<<<<"couldn't generate `"/utf8,
                                                Path@1/binary>>/binary,
                                            "` ("/utf8>>/binary,
                                        (simplifile:describe_error(File_err@2))/binary>>/binary,
                                    ")"/utf8>>
                            );

                        {cannot_write_to_output_dir, File_err@3} ->
                            snag:new(
                                <<<<"couldn't move from temp directory to output directory ("/utf8,
                                        (simplifile:describe_error(File_err@3))/binary>>/binary,
                                    ")"/utf8>>
                            );

                        {cannot_cleanup_temp_dir, File_err@4} ->
                            snag:new(
                                <<<<"couldn't remove temp directory ("/utf8,
                                        (simplifile:describe_error(File_err@4))/binary>>/binary,
                                    ")"/utf8>>
                            )
                    end end)
        end,
        fun(_) -> K() end
    ).

-file("src/arctic/build.gleam", 495).
-spec add_public(fun(() -> {ok, nil} | {error, snag:snag()})) -> {ok, nil} |
    {error, snag:snag()}.
add_public(K) ->
    gleam@result:'try'(
        begin
            _pipe = simplifile_erl:create_directory(
                <<"arctic_build/public"/utf8>>
            ),
            gleam@result:map_error(
                _pipe,
                fun(Err) ->
                    snag:new(
                        <<<<"couldn't create directory `arctic_build/public` ("/utf8,
                                (simplifile:describe_error(Err))/binary>>/binary,
                            ")"/utf8>>
                    )
                end
            )
        end,
        fun(_) ->
            gleam@result:'try'(
                begin
                    _pipe@1 = simplifile:copy_directory(
                        <<"public"/utf8>>,
                        <<"arctic_build/public"/utf8>>
                    ),
                    gleam@result:map_error(
                        _pipe@1,
                        fun(Err@1) ->
                            snag:new(
                                <<<<"couldn't copy `public` to `arctic_build/public` ("/utf8,
                                        (simplifile:describe_error(Err@1))/binary>>/binary,
                                    ")"/utf8>>
                            )
                        end
                    )
                end,
                fun(_) -> K() end
            )
        end
    ).

-file("src/arctic/build.gleam", 519).
-spec option_to_result_nil(
    gleam@option:option(WYX),
    fun((WYX) -> {ok, nil} | {error, snag:snag()})
) -> {ok, nil} | {error, snag:snag()}.
option_to_result_nil(Opt, F) ->
    case Opt of
        {some, A} ->
            F(A);

        none ->
            {ok, nil}
    end.

-file("src/arctic/build.gleam", 526).
-spec add_feed(
    list(arctic:processed_collection()),
    fun(() -> {ok, nil} | {error, snag:snag()})
) -> {ok, nil} | {error, snag:snag()}.
add_feed(Processed_collections, K) ->
    gleam@result:'try'(
        begin
            _pipe = simplifile:create_file(
                <<"arctic_build/public/feed.rss"/utf8>>
            ),
            gleam@result:map_error(
                _pipe,
                fun(Err) ->
                    snag:new(
                        <<<<"couldn't create file `arctic_build/public/feed.rss` ("/utf8,
                                (simplifile:describe_error(Err))/binary>>/binary,
                            ")"/utf8>>
                    )
                end
            )
        end,
        fun(_) ->
            gleam@result:'try'(
                (gleam@list:try_each(
                    Processed_collections,
                    fun(Processed) ->
                        option_to_result_nil(
                            erlang:element(5, erlang:element(2, Processed)),
                            fun(Feed) ->
                                _pipe@1 = simplifile:write(
                                    <<"arctic_build/public/"/utf8,
                                        (erlang:element(1, Feed))/binary>>,
                                    (erlang:element(2, Feed))(
                                        erlang:element(3, Processed)
                                    )
                                ),
                                gleam@result:map_error(
                                    _pipe@1,
                                    fun(Err@1) ->
                                        snag:new(
                                            <<<<"couldn't write to `arctic_build/public/feed.rss` ("/utf8,
                                                    (simplifile:describe_error(
                                                        Err@1
                                                    ))/binary>>/binary,
                                                ")"/utf8>>
                                        )
                                    end
                                )
                            end
                        )
                    end
                )),
                fun(_) -> K() end
            )
        end
    ).

-file("src/arctic/build.gleam", 560).
-spec add_vite_config(
    arctic:config(),
    list(arctic:processed_collection()),
    fun(() -> {ok, nil} | {error, snag:snag()})
) -> {ok, nil} | {error, snag:snag()}.
add_vite_config(Config, Processed_collections, K) ->
    Home_page = <<"\"main\": \"arctic_build/index.html\""/utf8>>,
    Main_pages = gleam@list:fold(
        erlang:element(3, Config),
        <<""/utf8>>,
        fun(Js, Page) ->
            <<<<<<<<<<Js/binary, "\""/utf8>>/binary,
                            (erlang:element(2, Page))/binary>>/binary,
                        "\": \"arctic_build/"/utf8>>/binary,
                    (erlang:element(2, Page))/binary>>/binary,
                "/index.html\", "/utf8>>
        end
    ),
    Collected_pages = gleam@list:fold(
        Processed_collections,
        <<""/utf8>>,
        fun(Js@1, Processed) ->
            gleam@list:fold(
                erlang:element(3, Processed),
                Js@1,
                fun(Js@2, Page@1) ->
                    <<<<<<<<<<<<<<<<<<Js@2/binary, "\""/utf8>>/binary,
                                                    (erlang:element(
                                                        2,
                                                        erlang:element(
                                                            2,
                                                            Processed
                                                        )
                                                    ))/binary>>/binary,
                                                "/"/utf8>>/binary,
                                            (get_id(Page@1))/binary>>/binary,
                                        "\": \"arctic_build/"/utf8>>/binary,
                                    (erlang:element(
                                        2,
                                        erlang:element(2, Processed)
                                    ))/binary>>/binary,
                                "/"/utf8>>/binary,
                            (get_id(Page@1))/binary>>/binary,
                        "/index.html\", "/utf8>>
                end
            )
        end
    ),
    gleam@result:'try'(
        begin
            _pipe = simplifile:write(
                <<"arctic_vite_config.js"/utf8>>,
                <<<<<<<<"
  // NOTE: AUTO-GENERATED! DO NOT EDIT!
  export default {"/utf8,
                                Main_pages/binary>>/binary,
                            Collected_pages/binary>>/binary,
                        Home_page/binary>>/binary,
                    "};"/utf8>>
            ),
            gleam@result:map_error(
                _pipe,
                fun(Err) ->
                    snag:new(
                        <<<<"couldn't create `arctic_vite_config.js` ("/utf8,
                                (simplifile:describe_error(Err))/binary>>/binary,
                            ")"/utf8>>
                    )
                end
            )
        end,
        fun(_) -> K() end
    ).

-file("src/arctic/build.gleam", 214).
?DOC(" Fill out an `arctic_build` directory from an Arctic configuration.\n").
-spec build(arctic:config()) -> {ok, nil} | {error, snag:snag()}.
build(Config) ->
    _ = simplifile:create_file(<<".arctic_cache.csv"/utf8>>),
    gleam@result:'try'(
        begin
            _pipe = simplifile:read(<<".arctic_cache.csv"/utf8>>),
            gleam@result:map_error(
                _pipe,
                fun(Err) ->
                    snag:new(
                        <<<<"couldn't read cache ("/utf8,
                                (simplifile:describe_error(Err))/binary>>/binary,
                            ")"/utf8>>
                    )
                end
            )
        end,
        fun(Content) -> gleam@result:'try'(case Content of
                    <<""/utf8>> ->
                        {ok, []};

                    _ ->
                        _pipe@1 = parse_csv(Content),
                        snag:context(_pipe@1, <<"couldn't parse cache"/utf8>>)
                end, fun(Csv) ->
                    gleam@result:'try'(
                        to_cache(lists:reverse(Csv)),
                        fun(Cache) ->
                            gleam@result:'try'(
                                process(erlang:element(4, Config), Cache),
                                fun(Processed_collections) ->
                                    make_ssg_config(
                                        Processed_collections,
                                        Config,
                                        fun(Ssg_config) ->
                                            ssg_build(
                                                Ssg_config,
                                                fun() ->
                                                    add_public(
                                                        fun() ->
                                                            add_feed(
                                                                Processed_collections,
                                                                fun() ->
                                                                    add_vite_config(
                                                                        Config,
                                                                        Processed_collections,
                                                                        fun() ->
                                                                            {ok,
                                                                                nil}
                                                                        end
                                                                    )
                                                                end
                                                            )
                                                        end
                                                    )
                                                end
                                            )
                                        end
                                    )
                                end
                            )
                        end
                    )
                end) end
    ).
