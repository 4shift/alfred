require 'spec_helper'

describe "tickets/edit" do
  before(:each) do
    @ticket = assign(:ticket, stub_model(Ticket,
      :from => "MyString",
      :suject => "MyString",
      :content => "MyText"
    ))
  end

  it "renders the edit ticket form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", ticket_path(@ticket), "post" do
      assert_select "input#ticket_from[name=?]", "ticket[from]"
      assert_select "input#ticket_suject[name=?]", "ticket[suject]"
      assert_select "textarea#ticket_content[name=?]", "ticket[content]"
    end
  end
end
