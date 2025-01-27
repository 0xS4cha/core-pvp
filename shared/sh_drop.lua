_DROP = _DROP or {}

_DROP.Drop = {
    Prop = 'prop_drop_armscrate_01', 
    Label = "Pick up",
    Veolicty = 0.01,
}

_DROP.Blip = {
    Label = "Supply Drop", 
    Sprite = 550, 
    Color = 1, 
    Scale = 0.7, 
}
_DROP.Vehicle = {
    Pilot = "s_m_m_pilot_02", 
    Model = "titan", 
    Height = 500.0, 
    Speed = 95.0, 
}

_DROP.Global = {
    Time = 10,
    Positions = {
        vector3(-337.17535400391, -753.10974121094, 53.246444702148),
        vector3(423.64587402344, -1337.02734375, 46.002811431885),
        vector3(-1299.7772216797, -503.44476318359, 33.157447814941),
        vector3(326.47494506836, -2032.2906494141, 20.938215255737),
        vector3(1156.5728759766, -475.54290771484, 66.371040344238),
        vector3(1367.8199462891, -734.60180664062, 67.225082397461)

    },
    Rewards = {
        [1] = {},
        [2] = {},
        [3] = {},
    }
}