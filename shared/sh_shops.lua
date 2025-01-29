_SHOP = _SHOP or {}
_SHOP.Items = {
    ['weapons'] = {

            label =  "Weapons",
            list = {
                { item =  "WEAPON_PISTOL", label = GetPhrase('WEAPON_PISTOL'), price =  10 },
                { item =  "WEAPON_PISTOL50", label =  GetPhrase('WEAPON_PISTOL50'), price =  10 },
                { item =  "WEAPON_COMBATPISTOL", label =  GetPhrase('WEAPON_COMBATPISTOL'), price =  10 },
            }
    },
    ['items'] = {
        label =  "Items",
        list = {
            { item =  "bandage", label = GetPhrase('bandage'), price =  10 },
            { item =  "kevlar", label =  GetPhrase('kevlar'), price =  10 },
            { item =  "medikit", label =  GetPhrase('medikit'), price =  10 },
        }

    },
}