project = "MetaSkill"
author = "Muxing Shen"
copyright = "2026, Muxing Shen"

extensions = [
    "myst_parser",
]

source_suffix = {
    ".rst": "restructuredtext",
    ".md": "markdown",
}

templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

html_theme = "sphinx_rtd_theme"
html_title = "MetaSkill Documentation"
html_static_path = []

myst_heading_anchors = 3
