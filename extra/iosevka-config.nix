
super: prev: let
  design-common = {
    braille-dot = "square";

    asterisk = "turn-hex-high";
    brace = "curly";
    guillemet = "curly";
    question = "smooth";

    lig-equal-chain = "without-notch";
    lig-hyphen-chain = "without-notch";
  };
  
  consolas-based = {
    inherits = "ss03";
    design = {
      g = "single-storey-serifless";
      j = "serifless";
      l = "serifed-asymmetric";
      y = "cursive-serifless";
      z = "curly-serifless";

      capital-g = "toothed-serifless-capped";
      capital-m = "hanging-serifless";

      six = "straight-bar";
      nine = "straight-bar";
    } // design-common;
  };

  anonymous-pro-based = {
    inherits = "ss02";
    design = {
      capital-c = "serifless";
      capital-s = "serifless";
      
      c = "serifless";
      f = "flat-hook-serifless-crossbar-at-x-height";
      r = "top-serifed";
    } // design-common;
  };

  menlo-based = {
    inherits = "ss04";

    design = {
      f = "serifless";
      j = "serifed";
      l = "serifed";
      q = "diagonal-tailed-serifless";
      t = "flat-hook";
    } // design-common;
  };

  buildPlan = {
    family = "Iosevka Custom";

    serifs = "sans";
    noCvSs = true;
    exportGlyphNames = false;

    variants = menlo-based;
  };
in {
  iosevka-custom = prev.iosevka.override  {
    privateBuildPlan = buildPlan;
    set = "Custom";
  };
  iosevka-term-custom = prev.iosevka.override  {
    privateBuildPlan = buildPlan // {
      family = "Iosevka Term Custom";
      spacing = "term";
      noLigation = true;
    };
    set = "TermCustom";
  };
}
