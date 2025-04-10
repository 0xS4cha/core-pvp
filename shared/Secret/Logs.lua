_LOGS = {
    ["connexion"] = {
        hook = "https://discord.com/api/webhooks/1331700759053602948/ei4HDRwGnw4pIaF2Hq8rKbDxZDSg5I1WjYdJBy--SH-rHDSlqhi05q9ToG_mzQB7P7_d", -- OP
        color = 0x04f253,
        player = true,
        title = "Connexion",
        text = "**TempID**: %d\n**UUID**: %s\n**Discord**: <@%s>\n**Pseudo**: %s",
    },
    ["deconnexion"] = {
        player = true,
        hook = "https://discord.com/api/webhooks/1331342173555396669/QYizC793s0JEimuetXblaIIEpB-jTmsKOZHujZRhBWYl35TFHSz4_4h-1nyBI3i5QnDV", -- OP
        color = 0xf44336,
        title = "Déconnexion",
        text = "**TempID**: %d\n**UUID**: %s\n**Discord**: <@%s>\n**Pseudo**: %s\n**Raison**: %s",
    },
    ["screenshot_anticheat"] = {
        player = true,
        hook = "https://discord.com/api/webhooks/1331341156432478249/ULCJshGxGB1Ahth6A5-ovw57wjysRxgMG-BnZuiif4zWOKrwg_Nx8Sbd6hZAky3mG79q", -- OP
        color = 0x03fc20,
        title = "Screen Anticheat | New player banned",
        text = "**TempID**: %s\n**UUID**: %d\n**Punishment Method**: %s\n**Name**: %s\n**Reason**: %s\n**Ban ID**: %s\n**Discord**: <@%s>\n**Image**: \n%s",
    },
    ["explosion_anticheat"] = {
        player = true,
        hook = "https://discord.com/api/webhooks/1331341634193068043/iEm4OjCWyQUhpSdqvRWhD7YXN3teiZhD4fu1Oy6qo28imrBYkhehlWYahUzS4BldFlwT", -- OP
        color = 0x03fc20,
        title = "Screen Anticheat | Explosion detection",
        text = "**TempID**: %s\n**UUID**\n**Punishment Method**: %s\n**Name**: %s\n**Reason**: %s\n**Ban ID**: %s\n**Discord**: <@%s>\n**Image**: \n%s",
    },
    ["object_anticheat"] = {
        player = true,
        hook = "https://discord.com/api/webhooks/1331341435278200873/kcBy7zKXekFRo--gFu55fV6npybAcXgpVJwkDJ8rOV5WXNVJ9E_eaPIOgJaX1UT1MuVz", -- OP
        color = 0x03fc20,
        title = "Screen Anticheat | Objects Detection",
        text = "**TempID**: %s\n**UUID**: %d\n**Punishment Method**: %s\n**Name**: %s\n**Reason**: %s\n**Ban ID**: %s\n**Discord**: <@%s>\n**Image**: \n%s",
    },
    ["ped_anticheat"] = {
        player = true,
        hook = "https://discord.com/api/webhooks/1331341509781618698/6taz_wG6F36XwYnw2QmUdyQ-zHGnpcrB384gPECcS0jM1FYcGhxAGFIvpHwSu7yfgV7G", -- OP
        color = 0x03fc20,
        title = "Screen Anticheat | Peds Detection",
        text = "**TempID**: %s\n**UUID**: %d\n**Punishment Method**: %s\n**Name**: %s\n**Reason**: %s\n**Ban ID**: %s\n**Discord**: <@%s>\n**Image**: \n%s",
    },
    ["vehicle_anticheat"] = {
        player = true,
        hook = "https://discord.com/api/webhooks/1331342010849689651/sZCW2fJ8aq9eY3yb6AypwwHQL7Rm8SP9X8POBZmSgrou2unkumaN98rukLwwpwLgU9FP", -- OP
        color = 0x03fc20,
        title = "Screen Anticheat | Vehicles Detection",
        text = "**TempID**: %s\n**Punishment Method**: %s\n**Name**: %s\n**Reason**: %s\n**Ban ID**: %s\n**Discord**: <@%s>\n**UUID**: %d\n**Image**: \n%s",
    },
    ["events_anticheat"] = {
        player = true,
        hook = "https://discord.com/api/webhooks/1331342068005474366/eG4U08PS-6xjbPXETaixPtnXNlbh1gCmekTxeFrCznJj0oHFMXIGqZM4UKKtOt_ZYEM4", -- OP
        color = 0x03fc20,
        title = "Screen Anticheat | Events Detection",
        text = "**TempID**: %s\n**Punishment Method**: %s\n**Name**: %s\n**Reason**: %s\n**Ban ID**: %s\n**Discord**: <@%s>\n**UUID**: %d\n**Image**: \n%s",
    },
    ["client_anticheat"] = {
        player = true,
        hook = "https://discord.com/api/webhooks/1331341690098684016/iJ4yFVh2Vv5NLwQviu3-VnLpcUw29EBnoJTsULygocas0cezZ9yeZqHh6k_yH2BXC-wb", -- OP
        color = 0x03fc20,
        title = "Screen Anticheat | Client Detection",
        text = "**TempID**: %s\n**Punishment Method**: %s\n**Name**: %s\n**Reason**: %s\n**Ban ID**: %s\n**Discord**: <@%s>\n**UUID**: %d\n**Image**: \n%s",
    },
    ["admin"] = {
        hook = "https://discord.com/api/webhooks/1331340985388765276/3r14xPK-L_HkxuR0EF8kGX6D0wYwi7kmR2E5IdxROdAqP2AY1612yoSdf4ZMD9fOtNtF", -- OP
        color = 0x03fc20,
        title = "Screen Anticheat | Client Detection",
        text = "**TempID**: %s\n**UUID**: %d\n**Punishment Method**: %s\n**Name**: %s\n**Reason**: %s\n**Ban ID**: %s\n**Discord**: <@%s>\n**Image**: \n%s",
    },
    ["screenshot_admin"] = {
        player = true,
        hook = "https://discord.com/api/webhooks/1331341082029592678/QsonXd4uUyouhSgvAZMqDhdQHcEj1ckGGyGAq8V6oqFVyfPz43ArFd953tkDSnL3Mbon", -- OP
        color = 0x03fc20,
        title = "Screen Anticheat | Client Detection",
        text = "**TempID**: %s\n**Screen of**:<@%s>\n**Image**: \n%s",
    },
    ["death"] = {
        player = true,
        hook = "https://discord.com/api/webhooks/1331716733664493732/-P5201lylb2h1PpocRhxCYGyqXCuHSF9ue-0z3wmf1Qki7XPbrUm3yOUIISZjO9agZc3", -- OP
        color = 0x03fc20,
        title = "New player death",
        text = "**TempID**: %s\n**UUID**: %s\n**Discord**: <@%s>\n**Pseudo**: %s\n**Raison**: %s",
    },
    ["kill"] = {
        player = true,
        hook = "https://discord.com/api/webhooks/1331716733664493732/-P5201lylb2h1PpocRhxCYGyqXCuHSF9ue-0z3wmf1Qki7XPbrUm3yOUIISZjO9agZc3", -- OP
        color = 0x03fc20,
        title = "New player kill",
        text = "> **Victim**\n**TempID**: %d\n**UUID**: %s\n**Discord**: <@%s>\n**Pseudo**: %s\n**Raison**: %s\n\n> **Killer**\n**TempID**: %d\n**UUID**: %s\n**Discord**: <@%s>\n**Pseudo**: %s",
    },
    ["warning_anticheat"] = {
        player = true,
        hook = "https://discord.com/api/webhooks/1334242837675638845/Qf67mDF4SKxAeBClvcKyem61yS9NHSyNFY3N7-8hjMyU_L_Yn-7Xsje8Ms-qw24Cd_9C", -- OP
        color = 0x03fc20,
        title = "Warning Anticheat | Client Detection",
        text = "**TempID**: %s\n**UUID**: %s\n**Raison**: %s\n**Video**: %s",
    },
}


