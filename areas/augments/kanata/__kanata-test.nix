{lib, ...}: let
  s = str: lib.stringAsChars (c: c + " ") str;
  v = str: " (on-press tap-vkey ${str}) ";
  vkeyInit = str: lib.stringAsChars (c: "${c} ${c}\n") str;
  frostbite = fmt: str:
    lib.stringAsChars (c:
      v
      (
        if c == "("
        then "pl"
        else if c == ")"
        then "pr"
        else if c == "\\"
        then "bsl"
        else if c == " "
        then "spc"
        else c
      ))
    str;
  u = frostbite v;
in ''
  (defseq
    co-abstract (a b s)
    find-fish (f z f)
    loadQol (q o l)
    matchVimStart (${s "vi1"})
    matchVimEnd (${s "vi2"})
    vimIncrement (${s "vi3"})
    recall (${s "qwe"})
    loadQol2 (${s "qop"})
    zl (${s "zl"})
    lgt (${s "lgt"})
  )

  (defvirtualkeys
    % S-5
    + S-=
    pl S-9
    pr S-0
    : S-;
    bsl \
    spc spc

    ${vkeyInit "',-./0123456789;=[\\]`abcdefghijklmnopqrstuvwxyz"}
    co-abstract (macro S-. [ S-1 a b s t r a c t ] spc )
    find-fish (macro y a z i spc C-A-f )
    loadQol (macro S-; a spc b u i l t i n s ret 1 S-; l f spc n i x p k g s ret 1 S-; a spc l i b ret 1 S-; l f spc . ret 1 S-; a spc q o l ret)
    loadQol2 (
      macro S-; a spc b u i l t i n s ret 1 S-; l f spc n i x p k g s ret 1 S-; a spc l i b ret 1 S-; l f spc . ret 1 S-; a spc q o l ret
      1 S-; a spc q o l . e ret
      )
    matchVimStart (macro S-; s / \ S-5 S-v )
    matchVimEnd (macro / g )
    vimIncrement (macro ${u ":s/\\d\\+/\\=submatch(0)+1/g"} )
    recall (macro S-; l f spc . 1 ret 2 up up ret)
    zl (macro z e l l i j 110 ret 110 C-t 110 n 110 C-t 110 left 110 ret)
    lgt (macro ret 2 ret t 1 t 1 i 1 m 1 e 2 spc 2 - 2 spc)


  )
''
