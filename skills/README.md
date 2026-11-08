# Skills for AI agents

Two skills that teach an AI agent to write decks with this theme, in Portuguese. Each one is a folder with a `SKILL.md` (the format of Claude Code skills): the rules, the workflow, the patterns of the theme, the prompts of three reviewers, a checker and the templates.

| Skill | For |
| ----- | --- |
| [`lectures/`](lectures/) (`touying-ufac-lectures`) | the lectures of a course: the lesson plan, the deck and its review |
| [`academic/`](academic/) (`touying-ufac-academic`) | the presentation of an academic work: the defense of a final paper, a dissertation or a thesis, a qualifying exam, a coursework, a talk |

To install one, copy its folder into the skills folder of the agent under the name of the skill: for Claude Code, `~/.claude/skills/touying-ufac-academic/`, or `.claude/skills/touying-ufac-academic/` in a project.

They need the theme 0.3.0 (before it reaches Typst Universe, the development version as a local package: the `SKILL.md` says how), Typst, Python 3, and `pdftotext` and `pdfinfo` (Poppler) for the checker and the contact sheet of each skill. The slides that present a course, in `lectures/`, also read the plan of the course with the `ufac-syllabus` package, installed as `@local/ufac-syllabus:0.0.3`.

The rules of each `SKILL.md` are choices (one idea per slide, never a smaller text, the title of a result that states the finding): edit them to your own. The skills are not part of the package: the `exclude` of `typst.toml` leaves this folder out.
