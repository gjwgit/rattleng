/// GRAPHICS: List of available ggplot themes for the user to choose from.

const List<Map<String, String>> themeOptions = [
  {
    'label': 'Rattle',
    'value': 'theme_rattle',
    'tooltip': 'The default theme used in Rattle.',
  },
  {
    'label': 'Base',
    'value': 'ggthemes::theme_base',
    'tooltip': "A theme based on R's Base plotting system.",
  },
  {
    'label': 'Black and White',
    'value': 'ggplot2::theme_bw',
    'tooltip': '''

        A theme with a white background and black grid lines, often used for
        publication quality plots.

        ''',
  },
  {
    'label': 'Calc',
    'value': 'ggthemes::theme_calc',
    'tooltip': 'A theme based on the Calc spreadsheet.',
  },
  {
    'label': 'Classic',
    'value': 'ggplot2::theme_classic',
    'tooltip': '''

        A theme resembling base R graphics, with a white background and no
        gridlines.

        ''',
  },
  {
    'label': 'Dark',
    'value': 'ggplot2::theme_dark',
    'tooltip': '''

        A theme with a dark background and white grid lines, useful for dark
        mode or high contrast needs.

        ''',
  },
  {
    'label': 'Economist',
    'value': 'ggthemes::theme_economist',
    'tooltip': 'A theme inspired by The Economist journal.',
  },
  {
    'label': 'Excel',
    'value': 'ggthemes::theme_excel',
    'tooltip': 'A theme inspired by the Excel spreadsheet.',
  },
  {
    'label': 'Few',
    'value': 'ggthemes::theme_few',
    'tooltip': "A theme based on Few's work.",
  },
  {
    'label': 'Fivethirtyeight',
    'value': 'ggthemes::theme_fivethirtyeight',
    'tooltip': 'A theme inspired by the FiveThirtyEight website.',
  },
  {
    'label': 'Foundation',
    'value': 'ggthemes::theme_foundation',
    'tooltip': "A theme based on Zurb's Foundation.",
  },
  {
    'label': 'Gdocs',
    'value': 'ggthemes::theme_gdocs',
    'tooltip': 'A theme inspired by Google Docs.',
  },
  {
    'label': 'Grey',
    'value': 'ggplot2::theme_grey',
    'tooltip': 'The default theme of ggplot2, with a grey background.',
  },
  {
    'label': 'Highcharts',
    'value': 'ggthemes::theme_hc',
    'tooltip': 'A theme inspired by Highcharts.',
  },
  {
    'label': 'IGray',
    'value': 'ggthemes::theme_igray',
    'tooltip': 'A minimalist grayscale theme.',
  },
  {
    'label': 'Light',
    'value': 'ggplot2::theme_light',
    'tooltip': 'A theme with a light grey background and white grid lines.',
  },
  {
    'label': 'Linedraw',
    'value': 'ggplot2::theme_linedraw',
    'tooltip':
        'A theme with black and white line drawings, without color shading.',
  },
  {
    'label': 'Minimal',
    'value': 'ggplot2::theme_minimal',
    'tooltip':
        'A minimalistic theme with no background annotations and grid lines.',
  },
  {
    'label': 'Pander',
    'value': 'ggthemes::theme_pander',
    'tooltip': "A theme inspired by Pandoc's pander package.",
  },
  {
    'label': 'Solarized',
    'value': 'ggthemes::theme_solarized',
    'tooltip': 'a theme based on the Solarized color scheme.',
  },
  {
    'label': 'Stata',
    'value': 'ggthemes::theme_stata',
    'tooltip': 'A theme inspired by the Stata software.',
  },
  {
    'label': 'Tufte',
    'value': 'ggthemes::theme_tufte',
    'tooltip': 'A theme inspired by Edward Tufte.',
  },
  {
    'label': 'Void',
    'value': 'ggplot2::theme_void',
    'tooltip': '''

        A completely blank theme, useful for creating annotations or background-less plots

        ''',
  },
  {
    'label': 'Wall Street Journal',
    'value': 'ggthemes::theme_wsj',
    'tooltip': 'A theme inspired by the Wall Street Journal.',
  },
];
