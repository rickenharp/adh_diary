# frozen_string_literal: true

RSpec.describe AdhDiary::Views::Parts::Pager do
  subject { described_class.new(value:) }
  let(:current_page) { 1 }
  let(:total_pages) { 15 }
  let(:value) do
    instance_double(
      ROM::SQL::Plugin::Pagination::Pager,
      total_pages: total_pages,
      current_page: current_page
    )
  end

  it "works" do
    expect(subject).to be_kind_of(described_class)
  end

  context "in the middle" do
    let(:current_page) { 7 }
    let(:total_pages) { 15 }
    it "returns stuff" do
      expect(subject.visible_pages).to eq [1, nil, 6, 7, 8, nil, 15]
    end
  end

  context "at the beginning" do
    let(:current_page) { 1 }
    let(:total_pages) { 15 }
    it "returns stuff" do
      expect(subject.visible_pages).to eq [1, 2, 3, nil, 15]
    end
  end

  context "on page 2" do
    let(:current_page) { 2 }
    let(:total_pages) { 15 }
    it "returns stuff" do
      expect(subject.visible_pages).to eq [1, 2, 3, nil, 15]
    end
  end

  context "at the end" do
    let(:current_page) { 15 }
    let(:total_pages) { 15 }
    it "returns stuff" do
      expect(subject.visible_pages).to eq [1, nil, 13, 14, 15]
    end
  end

  context "at the second to last page" do
    let(:current_page) { 14 }
    let(:total_pages) { 15 }
    it "returns stuff" do
      expect(subject.visible_pages).to eq [1, nil, 13, 14, 15]
    end
  end

  context "with less than 3 pages it returns all pages" do
    let(:current_page) { 1 }
    let(:total_pages) { 2 }
    it "returns stuff" do
      expect(subject.visible_pages).to eq [1, 2]
    end
  end

  context "with less than 4 pages it returns all pages" do
    let(:current_page) { 1 }
    let(:total_pages) { 3 }
    it "returns stuff" do
      expect(subject.visible_pages).to eq [1, 2, 3]
    end
  end
end
