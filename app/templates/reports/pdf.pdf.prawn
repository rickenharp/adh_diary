font_path = Hanami.app.root.join("app/assets/fonts/")
pdf.font_families.update(
  "Noto Sans" => {
    normal: font_path.join("NotoSans-Regular.ttf"),
    italic: font_path.join("NotoSans-Italic.ttf"),
    bold: font_path.join("NotoSans-Bold.ttf")
  }
)
pdf.font_size 10

full_width = pdf.margin_box.width
pdf.font("Noto Sans") do
  pdf.font_size(14) do
    pdf.text("<b>ADHS-Wochenprotokoll/-Monatsprotokoll</b>", inline_format: true)
  end
  pdf.move_down(10)
  pdf.text("Von #{weekly_report.user.name}")
  pdf.move_down(10)
  pdf.text("Woche vom #{weekly_report.from.strftime("%d.%m.%Y")} bis #{weekly_report.to.strftime("%d.%m.%Y")}")
  pdf.move_down(10)
  pdf.text("Medikament: #{weekly_report.medication}", inline_format: true)
  pdf.move_down(10)
  symptoms_table = [
    [
      "<b>Aufmerksamkeitsprobleme:</b>\n(Konzentrationsschwierigkeiten, Ablenkbarkeit, Vergesslichkeit, und/oder Reizoffenheit)",
      strengths_list(selected: weekly_report.attention)
    ],
    [
      "Probleme mit der <b>Selbst- und Alltagsorganisation</b> (Zeitmanagement, Prioritäten setzen, Planungen durchführen)",
      strengths_list(selected: weekly_report.organisation)
    ],
    [
      "<b>Emotionale Labilität, Stimmungsschwankungen</b>",
      strengths_list(selected: weekly_report.mood_swings)
    ],
    [
      "(Emotionale) <b>Stressempfindlichkeit</b>",
      strengths_list(selected: weekly_report.stress_sensitivity)
    ],
    [
      "<b>Temperament</b>-Ausbrüche, jähzorniges Verhalten, Gereiztheit",
      strengths_list(selected: weekly_report.irritability)
    ],
    [
      "Motorische un/oder innere <b>Unruhe</b>",
      strengths_list(selected: weekly_report.restlessness)
    ],
    [
      "<b>Impulsivität</b> beim Reden oder Handeln",
      strengths_list(selected: weekly_report.impulsivity)
    ]
  ]
  pdf.table(
    symptoms_table,
    column_widths: [full_width / 2, full_width / 2],
    cell_style: {
      inline_format: true,
      padding: [10, 5, 10, 5],
      valign: :center,
      size: 9
    }
  )

  side_effects_table = [
    [
      "<b>Unerwünschte Wirkungen</b> (bitte genau beschreiben)",
      weekly_report.side_effects
    ]
  ]
  pdf.move_down(10)
  pdf.table(
    side_effects_table,
    cell_style: {
      inline_format: true,
      padding: [20, 5, 20, 5]
    },

    width: full_width,
    column_widths: [(full_width / 2) - 50, (full_width / 2) + 50]
  )
  pdf.move_down(10)
  pdf.text("Außerdem messen Sie bitte ihren <b>Blutdruck</b> bzw. lassen ihn messen (in der medikamentösen Einstellungsphase möglichst täglich) und Ihr <b>Körpergewicht</b>", inline_format: true)
  pdf.move_down(10)

  biometrics_table = weekly_report.blood_pressure.map.with_index do |bp, index|
    if index.zero?
       [
         {content: "<b>Blutdruck</b>", rowspan: weekly_report.blood_pressure.size, valign: :center },
         { content: bp, align: :right }
       ]
     else
       [{ content: bp, align: :right }]
     end
  end

  biometrics_table << [
    "<b>Körpergewicht</b>",
    weekly_report.weight
  ]


  pdf.table(
    biometrics_table,
    width: full_width,
    column_widths: [full_width / 2, full_width / 2],
    cell_style: {inline_format: true}
  )
  pdf.move_down(10)
  pdf.text("Bitte sammeln Sie diese Blätter in einer Mappe oder digital und senden Ihre Protokolle 4-5 Arbeitstage vor Ihren Terminen an: <link href=\"mailto:fkg.protokolle@fliedner.de\">fkg.protokolle@fliedner.de</link>", inline_format: true)

end

