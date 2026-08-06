# EE476 Course Website

A responsive static course website for **EE476: Introduction to VLSI Systems**, styled with a CHIA-inspired palette: pale cyan backgrounds, white surfaces, deep blue-black controls, cyan highlights, and acid-lime accents.

## Changes in this revision

- Added the official UET Lahore logo as a local asset.
- Added “Department of Electrical Engineering” to the header, hero, contact section, and footer.
- Changed the default theme to the light CHIA-style palette.
- Changed primary buttons from lime to deep blue-black, with cyan/lime hover accents.
- Integrated lecture readings, tool documentation, and practical links directly into each schedule row.
- Removed the separate resources section.

## Run locally

Open `index.html` directly, or run a small local server:

```bash
python -m http.server 8000
```

Then visit `http://localhost:8000`.

## Publish on GitHub Pages

1. Upload `index.html`, `styles.css`, `script.js`, and the `assets` folder to the repository root.
2. In **Settings → Pages**, choose **Deploy from a branch** and select the main branch/root folder.

## Customize

- Edit schedule topics and resource URLs in the `#schedule` section of `index.html`.
- Change the palette in the `:root` block of `styles.css`.
- Replace the teaching-assistant placeholder email when the official address is available.


## Latest layout changes
- Removed the quick-jump strip and course-wide link cards.
- Added original illustrations to all four learning-skill cards.
- Added Readings, Assignments, and Labs buttons to every schedule week.
