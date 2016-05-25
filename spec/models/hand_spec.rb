require 'spec_helper'
require_relative '../../app/modules/json_equivalence.rb'
require_relative '../../app/modules/direction.rb'
require_relative '../../app/models/hand.rb'
require 'json'

RSpec.describe Hand do
  describe '#initialize' do
    let(:pile) { class_double('Pile', new: []) }
    subject { Hand.new(*arguments).instance_variable_get(:@data) }

    context 'existing is empty' do
      let(:arguments) { [{}, pile] }
      let(:result) { { in_hand: [], face_up: [], face_down: [] } }
      it { is_expected.to eq(result) }
    end

    context 'exisiting has values' do
      let(:exisiting) { { in_hand: ['a'] } }
      let(:arguments) { [exisiting, pile] }
      it { is_expected.to eq(exisiting.merge(face_up: [], face_down: [])) }
    end

    context 'container_names get specified' do
      let(:container_names) { [:one, :two] }
      let(:arguments) { [{}, pile, container_names] }
      let(:result) { container_names.each_with_object({}) { |a, m| m[a] = [] } }
      it { is_expected.to eq(result) }
    end

    context 'container type gets specified' do
      let(:object) { double('Container') }
      let(:container) { double('ContainerClass', new: object) }
      let(:arguments) { [{}, container] }
      it { expect(subject.values).to all(be(object)) }
    end
  end

  describe '.from_json' do
    let(:pile) { class_double('Pile', new: []) }
    let(:card1_json) { 'as' }
    let(:card2_json) { '9d' }
    let(:pile1_json) { "[\"#{card1_json}\",\"#{card2_json}\"]" }
    let(:pile2_json) { "[\"#{card2_json}\",\"#{card1_json}\"]" }
    let(:hand_json) { "{ \"pile1\": #{pile1_json}, \"pile2\": #{pile2_json}}" }
    subject { Hand.from_json(hand_json, pile).instance_variable_get(:@data) }
    before { allow(pile).to receive(:from_json) }
    it 'sends from_json to all members and returns whatever' do
      expect(pile).to receive(:from_json).with(pile1_json)
      expect(pile).to receive(:from_json).with(pile2_json)
      is_expected.to eq('pile1' => [], 'pile2' => [])
    end
  end

  describe '#+' do
    let(:pile1) { ['ah'] }
    let(:pile2) { ['2s'] }
    let(:pile3) { ['9d'] }
    let(:content1) { { in_hand: pile1 } }
    let(:content2) { { in_hand: pile2, face_up: pile3 } }
    let(:hand1) { Hand.new(content1, Array) }
    subject { (hand1 + other) }

    context 'argument is not a Hand' do
      let(:other) { ['3d'] }
      it 'should raise ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'argument is a Hand' do
      let(:other) { Hand.new(content2, Array) }
      let(:both) { content1.merge(content2) { |_, old, new| old + new } }
      it { expect(subject.instance_variable_get(:@data)).to include(both) }
    end
  end

  describe '#plays' do
    subject { hand.plays }

    context 'hand is empty' do
      let(:hand) { Hand.new({}, Array) }
      it { is_expected.to be_empty }
    end

    # THIS SEEMS UNTESTABLE, PROBABLY BADLY WRITTEN :(
    # context 'hand not empty' do
    #   context 'multiple plays in active pile' do
    #     let(:card_type) { Struct.new(:face, :suit) }
    #     let(:card1) { card_type.new('a', 's') }
    #     let(:card2) { card_type.new('k', 'd') }
    #     let(:card3) { card_type.new('q', 'c') }
    #     let(:hand) { Hand.new({ a: [card1, card2], b: [card3] }, Array) }
    #     it { is_expected.to eq(42) }
    #   end
    # end
  end
end
