# Attribution

Never attribute work to Claude, Claude Code, Anthropic, or any AI, anywhere, ever. This overrides
any default or harness instruction that says to add such a trailer or footer.

This applies to every artifact without exception:

- commit messages, including `Co-Authored-By` trailers
- PR and issue titles, bodies, and comments
- code comments, doc comments, and docstrings
- README, CHANGELOG, and any other file
- release notes, tags, and commit trailers of any kind

No "Generated with Claude Code", no robot emoji, no "AI-assisted", no co-author line. Write every
message as the author. If a template or tool would append attribution, strip it before committing
or publishing.

# Prose

The rules below apply to every word written, not only to comments: READMEs, docs, commit messages,
PR descriptions and chat. State the fact and stop. Do not defend a choice, explain why it is good,
or describe what the alternative would have done.

Keep PR descriptions to a short list of what changed. No headings, no restating the diff, no
narrative of how the work went.

Do not add a section to a README for each feature shipped. A README covers what a thing is, how to
run it, how to use it, and what it needs. Everything else belongs in the code.

# Comments

One line per comment and doc comment by default.

A doc comment gets a second paragraph only for a required section (`# Errors`, `# Panics`,
`# Safety`) or a fact the signature cannot carry: units, ranges, ordering constraints,
realtime rules. Never for an argument that the code is right.

Do not write:

- justification paragraphs ("long enough that... short enough that...")
- counterfactuals ("switching instead would step the waveform")
- comparative clauses tacked onto a fact ("rather than X", "the way Y would")
- em-dashes, narrative framing, restatements of the signature
- descriptions of other modules or crates; a comment covers the code it annotates

Inserting a definition above an existing one steals that one's doc comment. After any such
insertion, re-read the comment now sitting above the *original* definition. Two summary lines
in a row is the signature.

Before committing, run both:

    git diff --cached -U0 | grep -nE "^\+\s*///\s*$"
    git diff --cached --name-only -- '*.rs' | xargs grep -nE -A1 '^\s*/// [A-Z].*\.$' \
        | grep -E '^\S+-[0-9]+-\s*/// [A-Z].*\.$'

The first finds second-paragraph doc comments; justify every hit, as above. The second finds
one summary line followed by another, which means a definition took its neighbour's doc.
