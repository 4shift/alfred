require 'spec_helper'

describe "tickets/index" do
  before(:each) do
    assign(:tickets, [
      stub_model(Ticket,
        :from => "From",
        :suject => "Suject",
        :content => "MyText"
      ),
      stub_model(Ticket,
        :from => "From",
        :suject => "Suject",
        :content => "MyText"
      )
    ])
  end

  it "renders a list of tickets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "From".to_s, :count => 2
    assert_select "tr>td", :text => "Suject".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
