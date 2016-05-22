require 'spec_helper'
require_relative '../../app/modules/json_equivalence.rb'
require_relative '../../app/modules/direction.rb'
require_relative '../../app/models/hand.rb'
require 'json'

RSpec.describe Hand do
  let(:pile) { class_double('Pile', new: []) }
  describe '#initialize' do
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
    let(:card1_json) { 'as' }
    let(:card2_json) { '9d' }
    let(:pile1_json) { "[\"#{card1_json}\", \"#{card2_json}\"]" }
    let(:pile2_json) { "[\"#{card2_json}\", \"#{card1_json}\"]" }
    let(:hand_json) { "{ \"pile1\": #{pile1_json}, \"pile2\": #{pile2_json}}" }
    subject { Hand.from_json(hand_json, pile).instance_variable_get(:@data) }
    before { allow(pile).to receive(:from_json) }
    it 'sends from_json to all members and returns whatever' do
      expect(pile).to receive(:from_json).with(pile1_json, pile2_json)
      is_expected.to eq('pile1' => [], 'pile2' => [])
    end
  end
end
