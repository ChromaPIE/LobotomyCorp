local joker = {
    name = "Theresia",
    config = {extra = {chips = 0, gain = 7, hands_played = 0}}, rarity = 1, cost = 5,
    pos = {x = 6, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    discover_rounds = 3,
    loc_txt = {
        name = "Theresia",
        text = {
            "This Abnormality gains",
            "{C:chips}+#2#{} Chips each hand",
            "{C:attention}(#3#/3){} After the third hand played,",
            "debuffs all {C:attention}playing cards{}",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
        }
    },
}

joker.process_loc_text = function(self)
    SMODS.Joker.process_loc_text(self)
    SMODS.process_loc_text(G.localization.descriptions["Other"], "und_j_lobc_theresia", {
        name = "T-09-09",
        text = {
            "\"Do you remember this melody?",
            "The professor used to play",
            "this song when the students",
            "were sleepy. Happy birthday.\""
        }
    })
    SMODS.process_loc_text(G.localization.descriptions["Joker"], "dis_j_lobc_theresia", {
        name = "F-01-02",
        text = {
            "This Abnormality gains",
            "{C:chips}+#2#{} Chips each hand",
            "{C:attention}(#3#/3){} ...",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
        }
    })
end

joker.calculate = function(self, card, context)
    if context.cardarea == G.jokers and not context.blueprint then
        if context.before then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.gain
            card.ability.extra.hands_played = card.ability.extra.hands_played + 1
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS,
                card = card
            }
        elseif context.after and card.ability.extra.hands_played >= 3 then
            play_sound('card1', 1)
            for _, v in ipairs(G.hand.cards) do
                if not v.debuff then
                    v.debuff = true
                    v:juice_up()
                end
            end
            for _, v in ipairs(G.deck.cards) do
                v.debuff = true
            end
        end
    end

    if context.joker_main then
        return {
            message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}},
            chip_mod = card.ability.extra.chips, 
            colour = G.C.CHIPS
        }
    end

    if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
        card.ability.extra.hands_played = 0
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.chips, card.ability.extra.gain, card:check_rounds(3) }
    local desc_key = self.key
    if card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key
    end

    if not card.config.center.discovered then
        full_UI_table.name = localize{type = 'name', key = 'und_'..self.key, set = "Other", name_nodes = {}, vars = specific_vars or {}}
    else
        full_UI_table.name = localize{type = 'name', key = self.key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    end
    localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
end

return joker