import React, { useState, useEffect } from "react";
import { Button } from "@mantine/core";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { isEnvBrowser } from "../../utils/misc";
import { debugData } from "../../utils/debugData";
import Menu from "./Panel";

import "./index.scss";
import { fetchNui } from "../../utils/fetchNui";
debugData([
  {
    action: "crew:manage",
    data: {
      show: true,
      playerName: 'Sxcha',
      CrewName: 'LDO:PVP',
      PlayerLogo: 'https://cdn.discordapp.com/attachments/1276573907192774656/1335045727784665098/telechargement_2.jpg?ex=679ebdb9&is=679d6c39&hm=683f0f7e0cd4aadb2b7e9972e0a94394e55608a3cf3b62b830736fd1f98a0456&',
      PlayersData: [
        {label: 'Sxcha', id_rank: 1, id_player: 1},
        {label: 'Jbik', id_rank: 2, id_player: 13},
      ],
      deaths: 33,
      kills: 10,
      ranks: {
        0: {rank: 1, id_rank: 38, name: 'Boss', permission: {"addPlayer":true,"removePlayer":true,"changeRank":true,"deleteRank":true,"changePerm":true,"changeCrewPerm":true}},
        1: {rank: 2,  id_rank: 39, name: 'Sous-boss', permission: {"addPlayer":false,"removePlayer":false,"changeRank":true,"deleteRank":true,"changePerm":true,"changeCrewPerm":false}},
      },
      ranksId: [
        {value: 0, label: 'Boss'},
        {value: 1, label: 'Sous-boss'},
      ],
      permission: {"addPlayer":true,"removePlayer":true,"changeRank":true,"deleteRank":true,"changePerm":true}

    }
  }
])
const App: React.FC = () => {
  const [panelVisible, setPanelVisible] = useState(false);
  const [playersData, setPlayersData] = useState([]);
  const [CrewName, setCrewName] = useState('');
  const [playerName, setplayerName] = useState('');
  const [PlayerLogo, setPlayerLogo] = useState('');
  const [deaths, setDeaths] = useState(0)
  const [kills, setKills] = useState(0)
  const [ranksId, setRanksId] = useState([]);
  const [ranks, setRanks] = useState([]);
  const [permission, setPermission] = useState([])
  useEffect(() => {
    const handleKeyDown = (event: any) => {
      if (event.key === "Escape" && panelVisible) {
        fetchNui("crew:manage:close");
      }
    };

    window.addEventListener("keydown", handleKeyDown);

    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  });
  useNuiEvent<any>("crew:manage", (data) => {
    setPanelVisible(data.show);
    setPlayersData(data.PlayersData)
    setDeaths(data.deaths)
    setCrewName(data.CrewName)
    setplayerName(data.playerName)
    setPlayerLogo(data.PlayerLogo)
    setKills(data.kills)
    setRanksId(data.ranksId)
    setRanks(data.ranks)
    setPermission(data.permission)
  });

  useEffect(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (panelVisible && e.code === "Escape") {
        if (!isEnvBrowser()) {
          fetchNui("LGF_DebugTool:closePanel", {
            uiName: "openTool",
          });
        }
      }
    };

    window.addEventListener("keydown", keyHandler);

    return () => {
      window.removeEventListener("keydown", keyHandler);
    };
  }, [panelVisible]);

  return (
    <>
      <Menu
        visible={panelVisible}
        playersData={playersData}
        deaths={deaths}
        kills={kills}
        playerName={playerName}
        CrewName={CrewName}
        PlayerLogo={PlayerLogo}
        ranksId={ranksId}
        ranks={ranks}
        permission={permission}

      />
    </>
  );
};

export default App;
