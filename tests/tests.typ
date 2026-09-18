// TEST catalogue of the touying-ufac syntax. Each topic lives in tests/<group>/<case>/body.typ, which is at the
// same time a Tytanic test (tests/<group>/<case>/test.typ = preamble + #include "body.typ") and a chunk of this
// catalogue: what is here is exactly what the suite compares. For a new case: `tt new --use-system-fonts group/case`,
// move the markup to body.typ, leave test.typ with the #include and add the matching #include below.
// The config/ tests (theme parameters, 4:3) and unit/ (assertions) have their own preamble and are not included here.
// Compile: `typst compile tests.typ` (inside this folder). Every path in the suite is relative, so the root does not matter.
#import "common.typ": *
#show: setup

#include "./sections/cover/body.typ"

// =====================================================================================================================
= Style guide
#placeholder(label: [section figure])
#include "./guide/colors/body.typ"
#include "./guide/typography/body.typ"

// =====================================================================================================================
= Elements
#placeholder(label: [section figure])
#include "./elements/emphasis/body.typ"
#include "./elements/highlight/body.typ"
#include "./elements/lists/body.typ"
#include "./elements/enum/body.typ"
#include "./elements/terms/body.typ"
#include "./elements/tables/body.typ"
#include "./elements/figures/body.typ"
#include "./elements/icons/body.typ"
#include "./elements/equations/body.typ"
#include "./elements/code/body.typ"
#include "./elements/quotes/body.typ"
#include "./elements/layout/body.typ"

// =====================================================================================================================
= New elements
#placeholder(label: [section figure])
#include "./new/escapes/body.typ"
#include "./new/emph-box/body.typ"
#include "./new/eq-box/body.typ"
#include "./new/quote-box/body.typ"
#include "./new/arrows/body.typ"
#include "./new/cols/body.typ"

// =====================================================================================================================
= Sections, titles \ and subtitles
#placeholder()
#include "./sections/subtitles/body.typ"
#include "./sections/overflow/body.typ"
#include "./sections/titles/body.typ"
#include "./sections/exercises/body.typ"
#include "./sections/animations/body.typ"
#include "./sections/pause-cover/body.typ"
#include "./sections/explicit-slides/body.typ"

#include "./sections/edge-cases/body.typ"

// =====================================================================================================================
// Variants of the section slide, one after the other; the last one ("without image") closes the catalogue.
#include "./sections/section/body.typ"
