require 'spec_helper'

describe "tickets/new" do
  before(:each) do
    assign(:ticket, stub_model(Ticket,
      :from => "MyString",
      :suject => "MyString",
      :content => "MyText"
    ).as_new_record)
  end

  it "renders new ticket form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", tickets_path, "post" do
      assert_select "input#ticket_from[name=?]", "ticket[from]"
      assert_select "input#ticket_suject[name=?]", "ticket[suject]"
      assert_select "textarea#ticket_content[name=?]", "ticket[content]"
    end
  end
end
