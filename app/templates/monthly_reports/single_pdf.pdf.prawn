#!/bin/env ruby

font_path = Hanami.app.root.join("app/assets/fonts/")
pdf.font_families.update(
  "Noto Sans" => {
    normal: font_path.join("NotoSans-Regular.ttf"),
    italic: font_path.join("NotoSans-Italic.ttf"),
    bold: font_path.join("NotoSans-Bold.ttf")
  }
)
pdf.define_grid(columns: 12, rows: 12, gutter: 5)
pdf.font_size 10
pdf.outline
full_width = pdf.margin_box.width
pdf.margin_box.height
pdf.font("Noto Sans") do
  reports.each_with_index do |report, i|
    pdf.outline.section(report.month, destination: pdf.page_number)
    pdf.font_size(14) do
      pdf.text("<b>ADHS-Monatsprotokoll</b>", inline_format: true)
    end
    pdf.move_down(10)
    pdf.text("Von #{report.name}")
    pdf.move_down(10)
    pdf.text("Monat vom #{report.from} bis #{report.to}")
    pdf.move_down(10)
    pdf.text("Medikament: #{report.medication}", inline_format: true)
    pdf.move_down(10)
    symptoms_table = [
      [
        "<b>Aufmerksamkeitsprobleme:</b>\n(Konzentrationsschwierigkeiten, Ablenkbarkeit, Vergesslichkeit, und/oder Reizoffenheit)",
        strengths_list(selected: report.attention)
      ],
      [
        "Probleme mit der <b>Selbst- und Alltagsorganisation</b> (Zeitmanagement, Prioritäten setzen, Planungen durchführen)",
        strengths_list(selected: report.organisation)
      ],
      [
        "<b>Emotionale Labilität, Stimmungsschwankungen</b>",
        strengths_list(selected: report.mood_swings)
      ],
      [
        "(Emotionale) <b>Stressempfindlichkeit</b>",
        strengths_list(selected: report.stress_sensitivity)
      ],
      [
        "<b>Temperament</b>-Ausbrüche, jähzorniges Verhalten, Gereiztheit",
        strengths_list(selected: report.irritability)
      ],
      [
        "Motorische un/oder innere <b>Unruhe</b>",
        strengths_list(selected: report.restlessness)
      ],
      [
        "<b>Impulsivität</b> beim Reden oder Handeln",
        strengths_list(selected: report.impulsivity)
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
        report.side_effects
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
    pdf.text("Bitte sammeln Sie diese Blätter in einer Mappe oder digital und senden Ihre Protokolle 4-5 Arbeitstage vor Ihren Terminen an: <link href=\"mailto:fkg.protokolle@fliedner.de\">fkg.protokolle@fliedner.de</link>", inline_format: true)

    pdf.start_new_page

    pdf.image(report.blood_pressure_chart_image, fit: [pdf.bounds.width, pdf.bounds.height / 2])
    pdf.image(report.weight_chart_image, fit: [pdf.bounds.width, pdf.bounds.height / 2])

    pdf.start_new_page
    pdf.table(
      report.dates_chart_data.dup.prepend("Datum").map { {content: it.to_s, align: :right} }.zip(
        report.weights.dup.prepend("Gewicht").map { {content: it.to_s, align: :right} },
        report.blood_pressure.dup.prepend("Blutdruck").map { {content: it.to_s, align: :right} }
      ),
      width: full_width,
      cell_style: {inline_format: true}
    )
    pdf.start_new_page if i < (reports.size - 1)
  end
end
page_options = {
  at: [pdf.bounds.right - 150, 0],
  width: 150,
  align: :right,
  # page_filter: (1..7),
  start_count_at: 1,
  color: "333333"
}
pdf.number_pages "Seite <page> von <total>", page_options
