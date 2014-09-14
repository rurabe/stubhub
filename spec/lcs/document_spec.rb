require 'spec_helper'

module Stubhub
  module LCS
    describe Document do

      context ".demodulize" do
        it "returns only the class name without a namespace" do
          Stubhub::LCS::Ticket.demodulize.should eq "Ticket"
        end
      end

    end
  end
end