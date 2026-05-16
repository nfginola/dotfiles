Stow knowledge from the current session into the personal wiki at /data/media/docs/knowbase.

## Your job

Review the conversation so far and identify knowledge worth preserving — insights, techniques, explanations, comparisons, decisions, or summaries the user arrived at during this session.

## Steps

1. **Identify candidates.** Scan the conversation for substantive learnings. Ignore setup chatter. Focus on things the user would want to find again later.

2. **Propose a stow plan.** Before writing anything, tell the user:
   - What you plan to file (title + one-line summary for each item)
   - Which wiki category each belongs to (check /data/media/docs/knowbase/CLAUDE.md for the category structure)
   - What type each page will be (`concept`, `qa`, `analysis`, `comparison`, `summary`, or `entity`)
   - Whether you'll create a new page or update an existing one
   Ask the user to confirm, add, or cut items before proceeding.

3. **PDF check.** If any items being stowed include PDF source files:
   - Ask the user: "Do you want to run this PDF through the Markdown pipeline before stowing? (`pdf_to_markdown_ocr.py` → `postprocess_markdown_outline.py`)"
   - If yes: instruct the user to run the two-stage pipeline (see [[engineering/coding/pdf-to-markdown-pipeline]] or the scripts in `raw/engineering/coding/`), then stow the resulting `.md` file as the source instead of the PDF directly
   - If no: proceed with the PDF path as-is, noting in the wiki page that no Markdown conversion was done

4. **Execute.** For each confirmed item:
   - Write or update the page in `wiki/<category>/` with proper frontmatter (`type`, `category`, `tags`, `sources`, `updated`)
   - Use `[[WikiLink]]` syntax for any internal cross-references
   - Update `wiki/index.md` — add new pages to the right category section
   - Update relevant `_overview.md` pages if the content is significant enough
   - Append a single `## [YYYY-MM-DD] stow | <title>` entry to `wiki/log.md` listing all pages touched

4. **Report.** List every file created or modified with a one-line description of what changed.

## Tone

Be selective — don't file everything, file what's *valuable*. A short, sharp page is better than a padded one. The goal is a wiki the user will actually want to read later.
