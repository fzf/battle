require 'rails_helper'

RSpec.describe Turn, :type => :model do
  let(:turn) { FactoryGirl.create :turn }

  describe 'damage prevented' do
    let(:attack) { FactoryGirl.create :attack, turn: turn }
    let(:defend) { FactoryGirl.create :defend, turn: turn }

    before do
      turn.actions << attack
      turn.actions << defend
    end

    it 'attacker takes damage' do
      expect(turn.damage_prevented(attack, defend)).to eq(0)
    end

    it 'defender takes no damage' do
      expect(turn.damage_prevented(defend, attack)).to eq(6)
    end
  end
  describe 'calculate' do
    context 'attack' do
      context 'vs attack' do
        let(:attack) { FactoryGirl.create :attack, turn: turn }
        let(:other_attack) { FactoryGirl.create :attack, turn: turn }

        before do
          turn.actions << attack
          turn.actions << other_attack
        end

        it 'does damage to each user' do
          expect(attack.user.current_hit_points).to eq(attack.user.hit_points - other_attack.damage)
          expect(other_attack.user.current_hit_points).to eq(other_attack.user.hit_points - attack.damage)
        end
      end

      context 'vs jab' do
        let(:attack) { FactoryGirl.create :attack, turn: turn }
        let(:jab) { FactoryGirl.create :jab, turn: turn }

        before do
          turn.actions << attack
          turn.actions << jab
        end

        it 'attacker takes damage' do
          expect(attack.user.current_hit_points).to eq(attack.user.hit_points - jab.piercing)
        end

        it 'jab takes damage' do
          expect(jab.user.current_hit_points).to eq(jab.user.hit_points - attack.damage)
        end
      end

      context 'vs defend' do
        let(:attack) { FactoryGirl.create :attack, turn: turn }
        let(:defend) { FactoryGirl.create :defend, turn: turn }

        before do
          turn.actions << attack
          turn.actions << defend
        end

        it 'attacker takes damage' do
          expect(attack.user.current_hit_points).to eq(attack.user.hit_points - defend.defense)
        end

        it 'defender takes no damage' do
          expect(defend.user.current_hit_points).to eq(defend.user.hit_points)
        end
      end
    end

    context 'jab' do
      context 'vs jab' do
        let(:jab) { FactoryGirl.create :jab, turn: turn }
        let(:other_jab) { FactoryGirl.create :jab, turn: turn }

        before do
          turn.actions << jab
          turn.actions << other_jab
        end

        it 'does piercing damage to each user' do
          expect(jab.user.current_hit_points).to eq(jab.user.hit_points - other_jab.piercing)
          expect(other_jab.user.current_hit_points).to eq(other_jab.user.hit_points - jab.piercing)
        end
      end

      context 'vs defend' do
        let(:jab) { FactoryGirl.create :jab, turn: turn }
        let(:defend) { FactoryGirl.create :defend, turn: turn }

        before do
          turn.actions << jab
          turn.actions << defend
        end

        it 'jab takes no damage' do
          expect(jab.user.current_hit_points).to eq(jab.user.hit_points)
        end

        it 'defender takes piercing damage' do
          expect(defend.user.current_hit_points).to eq(defend.user.hit_points - jab.piercing)
        end
      end
    end

    context 'defend' do
      context 'vs defend' do
        let(:defend) { FactoryGirl.create :defend, turn: turn }
        let(:other_defend) { FactoryGirl.create :defend, turn: turn }

        before do
          turn.actions << defend
          turn.actions << other_defend
        end

        it 'defender takes no damage' do
          expect(defend.user.current_hit_points).to eq(defend.user.hit_points)
          expect(other_defend.user.current_hit_points).to eq(other_defend.user.hit_points)
        end
      end
    end
  end
end
