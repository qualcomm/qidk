#============================================================================
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
#============================================================================

# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'qidk_doc'
copyright = 'Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.'
author = 'Qualcomm Technologies, Inc.'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = ['sphinx_rtd_theme', 'sphinx_design', 'sphinx.ext.autosectionlabel', 'sphinxcontrib.youtube']

root_doc = 'index'

templates_path = ['_templates']
exclude_patterns = []

autosectionlabel_prefix_document = True


# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']
html_baseurl = 'https://qualcomm.github.io/qidk-pages/'


def setup(app):
    add_css_file = getattr(app, "add_css_file", getattr(app, "add_stylesheet", None))
    add_css_file('custom_css.css')
