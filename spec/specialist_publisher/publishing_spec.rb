require "spec_helper"

feature "Publishing with Specialist Publisher", specialist_publisher: true do
  include SpecialistPublisherHelpers

  let(:title) { title_with_timestamp }

  scenario "Publishing an AAIB Report" do
    given_there_is_a_draft_aaib_report
    when_i_publish_it
    then_i_can_view_it_on_gov_uk
  end

  def given_there_is_a_draft_aaib_report
    visit(Plek.find("specialist-publisher") + "/aaib-reports/new")

    fill_in_aaib_report_form(title: title)

    click_button("Save as draft")
    expect_created_alert(title)
  end

  def when_i_publish_it
    page.accept_confirm do
      click_button("Publish")
    end
    expect_published_alert(title)
  end

  def then_i_can_view_it_on_gov_uk
    click_link("View on website")
    reload_page_until_status_code(200)

    expect_rendering_application("specialist-frontend")
    expect(page).to have_content(title)
  end
end
