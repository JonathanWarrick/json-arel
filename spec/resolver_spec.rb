require "spec_helper"
require_relative '../lib/resolver'
require 'json'
require 'pry'

describe Resolver do

  describe "#initialize" do    

    subject { Resolver.new(data) }

    context "basic" do
      let(:data) { JSON.parse(File.open('spec/fixtures/basic.js').read) }

      it "should be able to parse expressions correctly" do
        expect { subject.parse_where('index$not_eq', 10) }.to_not raise_error
      end

      it "should raise exception with invalid expressions" do
        expect { subject.parse_where('index$foo', 10) }.to raise_error(ResolverError)
      end

      it "should be able to resolve a simple query" do
        expect(subject.resolve).to eq(
          "SELECT  * FROM \"lending_club_loans\" WHERE \"lending_club_loans\".\"loan_status\" IN (NULL), \"lending_club_loans\".\"loan_id\" = 1234, \"lending_club_loans\".\"loan_amount\" >= 123 LIMIT 100")
      end
    end

    context "basic2" do
      let(:data) { JSON.parse(File.open('spec/fixtures/basic2.js').read) }

      it "should support multiple fields" do
        expect(subject.resolve).to eq("SELECT  loan_amount, loan_id, issue_date FROM \"lending_club_loans\" WHERE \"lending_club_loans\".\"loan_amount\" >= 123 LIMIT 100")
      end
    end

    context "basic3" do
      let(:data) { JSON.parse(File.open('spec/fixtures/basic3.js').read) }

      it "should support multiple fields" do
        expect(subject.resolve).to eq("SELECT  fico ^ 2 + 200 AS inflated_fico FROM \"lending_club_loans\" WHERE \"lending_club_loans\".\"loan_amount\" >= 123 LIMIT 100")
      end
    end

    context "complex" do
      let(:data) { JSON.parse(File.open('spec/fixtures/complex.js').read) }
    end
  end

end