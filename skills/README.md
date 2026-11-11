# A skill for AI agents

[`touying-ufac/`](touying-ufac/) is a skill that teaches an AI agent to write decks with this theme, in Portuguese. It is a folder with a `SKILL.md` (the format of Claude Code skills): the rules, the workflow, the patterns of the theme, the prompts of three reviewers, a checker and the templates.

The skill has two modes, which share the common rules (little per slide, never a smaller text, explicit code, figures in their own files, credits only at the end) and add their own:

| Mode | For | Template |
| ---- | --- | -------- |
| aula | the lectures of a course: the lesson plan, the deck and its review, and the presentation of the course | [`templates/aula/`](touying-ufac/templates/aula/), a course folder with one deck |
| acadêmico | the presentation of an academic work: the defense of an undergraduate thesis, a dissertation or a thesis, a qualifying exam, a coursework | [`templates/academico/`](touying-ufac/templates/academico/), the folder of one presentation |

The agent picks the mode from the request, or from the `flavor` of an existing deck. Both modes lay out a deck the same way: each figure made in Typst in its own file under `figures/` (`graphs/`, `diagrams/`, `drawings/`, `circuits/`), the data in `data/`, the images in `assets/` and the large helper functions in the `header.typ` of the deck (in lectures, also what several decks of a course share, such as the plan of the course and the style of the graphs: each deck carries its own copy, and there is no `common.typ`).

To install it, copy the folder into the skills folder of the agent: for Claude Code, `cp -R skills/touying-ufac ~/.claude/skills/`, or into `.claude/skills/` in a project. It replaces the two skills of before, `touying-ufac-lectures` and `touying-ufac-academic`: remove them if they are installed.

It needs the theme 0.4.0 (before it reaches Typst Universe, the development version as a local package: the `SKILL.md` says how), Typst, Python 3, and `pdftotext` and `pdfinfo` (Poppler) for the checker and the contact sheet. The slides that present a course, in the lectures mode, also read the plan of the course with the `ufac-syllabus` package, installed as `@local/ufac-syllabus:0.0.3`.

The rules of the `SKILL.md` are choices (one idea per slide, never a smaller text, the title of a result that states the finding, credits only at the end): edit them to your own. The skill is not part of the package: the `exclude` of `typst.toml` leaves this folder out.
