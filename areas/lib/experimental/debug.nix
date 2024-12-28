{
  lib,
  mimics,
  self,
  inputs,
  ...
}: let
  inherit (builtins) filter;
  inherit (lib) toList;
  inherit (mimics) recipe;

  testSet = {
    a = {
      b = {
        fn = a: true;
      };
    };

    a1 = {
      b1 = {
        fn2 = {...}: false;
        a = "";
      };
    };
  };

  simpleFn = {
    d ? 4,
    a,
    c,
    b ? 2,
    ...
  }: {
    inherit a b c d;
    r = a + b + c + d;
  };
  dFu = {
    a_d ? 4,
    b_a,
    c_c,
    d_b ? 2,
    e_path,
    ...
  } @ pargs: let
    args = mimics.amb pargs ["a_d" "b_a" "c_c" "d_b" "e_path"];
  in
    with args; {
      inherit a b c d;
      r = a + b + c + d;
    };

  simpleFzf = path: regex: nregex: let
    matchedRegex = x: builtins.isList (builtins.match regex (builtins.toString x));
    notMatchedRegex = x: builtins.isNull (builtins.match nregex (builtins.toString x));
    target =
      if builtins.isPath path
      then (lib.filesystem.listFilesRecursive path)
      else path;
  in
    lib.pipe target [
      (lib.filter matchedRegex)
      (lib.filter notMatchedRegex)
    ];
  wrapWith = left: right: str: left + str + right;
  wrapAny = wrapWith ".*" ".*";
  wrapParen = wrapWith ".*(" ").*";
  wrapExpr = wrapper: lst: sep: wrapper (builtins.concatStringsSep sep lst);

  fzf' = path: regexList: let
    isPos = x: ! (lib.hasPrefix "!" x);
    isNeg = x: lib.hasPrefix "!" x;
    trunc = x: let p = builtins.toString x; in builtins.substring 1 ((builtins.stringLength p) - 1) p;
    processed =
      builtins.foldl' (
        acc: next: {
          pos =
            acc.pos
            ++ (
              if isPos next
              then [next]
              else []
            );
          neg =
            acc.neg
            ++ (
              if isNeg next
              then [(trunc next)]
              else []
            );
        }
      ) {
        pos = [];
        neg = [];
      };
    req = processed (lib.toList regexList);
    wrappedRegex = wrapExpr wrapAny req.pos ".*";
    wrappedNregex =
      if req.neg == []
      then ""
      else wrapExpr wrapParen req.neg "|";
  in
    simpleFzf path wrappedRegex wrappedNregex;
  # [path wrappedRegex wrappedNregex];
  fzf = path: regexLst: let regex = lib.strings.splitString " " regexLst; in fzf' path regex;
in {
  inherit
    fzf'
    fzf
    simpleFzf
    testSet
    simpleFn
    dFu
    self
    inputs
    ;
}
