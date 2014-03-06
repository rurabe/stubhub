require 'spec_helper'

module Stubhub
  describe Document do

    context ".demodulize" do
      it "returns only the class name without a namespace" do
        Stubhub::Ticket.demodulize.should eq "Ticket"
      end
    end

  end
end