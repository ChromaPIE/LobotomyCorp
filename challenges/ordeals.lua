local chal = {
    rules = {
        custom = {
            {id = "lobc_ordeals"},
            {id = "lobc_fast_ante_1"},
        },
    },
    restrictions = {
        banned_cards = {
            {id = 'j_chicot'},
        },
    },
    unlocked = function(self)
        return true
    end
}

return chal