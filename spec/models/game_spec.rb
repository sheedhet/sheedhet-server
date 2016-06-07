require 'spec_helper'
require_relative '../../app/modules/json_equivalence.rb'
require_relative '../../app/models/game.rb'

RSpec.describe Game do
  let(:game) { GameFactory.build }
  let(:player) { game.players.first }

  describe '#started?' do
    subject { game.send(:started?) }
    context 'history is greater than max possible' do
      before do
        game.players.size.next.times.with_index do |i|
          game.history << OpenStruct.new(player: i)
        end
      end
      it { is_expected.to eq true }
    end

    context 'there are multiple plays by same player' do
      let(:play) { OpenStruct.new(player: player) }
      before { game.history += [play, play] }
      it { is_expected.to eq true }
    end

    context 'all turns unique to players and less than max possible' do
      let(:play1) { OpenStruct.new(player: 'player1') }
      let(:play2) { OpenStruct.new(player: 'player2') }
      let(:play3) { OpenStruct.new(player: 'player3') }
      before { game.history += [play1, play2, play3] }
      it { is_expected.to eq false }
    end
  end
end
