import React, { useState, useRef, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import { Divider } from "@mantine/core";

import SpawnSelectorSCSS from "./SpawnSelector.module.scss";
/*
debugData([
    {
      action: "showSpawnSelector",
      data: {
        show: true,
        translation: {
            select: 'SELECT'
        },
        lobby: [
            {Name: 'Los Santos', Description: 'Los Santos, fgds,gfdkgfdsgfsd', Image: 'lspd.png'},
            {Name: 'Los Santos', Description: 'SandyShore', Image: 'sandy_shore.png'},
            {Name: 'Los Santos', Description: 'SandyShore2', Image: 'sandy_shore.png'},
             
        ]
      },
    },
]);*/

const SpawnSelector = () => {
  const [opened, setOpened] = useState(false);
  const [dataSelector, setDataSelector] = useState<any>([]);
  const [translation, setTranslation] = useState<any>({});
  const [tab, setTab] = useState<number>(1);
  const handleTabNext = () => {
    setTab((prevTab) => (prevTab + 1 > dataSelector.length ? 1 : prevTab + 1));
  };
  const handleTabBefore = () => {    setTab((prevTab) => (prevTab - 1 < 1 ? dataSelector.length : prevTab - 1));
  }
  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {

      if (event.data.action === "showSpawnSelector") {
        setTranslation(event.data.data.translation);
        setOpened(event.data.data.show);
        setDataSelector(event.data.data.lobby);
      }
    };
    window.addEventListener("message", handleMessage);

    return () => {
      window.removeEventListener("message", handleMessage);
    };
  });

    useEffect(() => {
        const handleKeyDown = (event: any) => {
          if (event.key === "Escape" && opened) {
            fetchNui("spawnSelector:Close")

          }
        };
  
        window.addEventListener("keydown", handleKeyDown);
  
        return () => {
          window.removeEventListener("keydown", handleKeyDown);
        };
      
    });

  return opened && (
    <div className={SpawnSelectorSCSS["ui"]}>
<div className={SpawnSelectorSCSS["main-screen"]}>
    <img src={`../assets/images/${dataSelector[tab - 1].Image}.webp`} alt='' />
            <div className={SpawnSelectorSCSS["spawn-selector"]}>
                
                <div className={SpawnSelectorSCSS["selected-spawn"]}>
                    <div className={SpawnSelectorSCSS["selected-spawn-text"]} id={SpawnSelectorSCSS["current-label"]}>{dataSelector[tab - 1].Name}</div>
                    <div className={SpawnSelectorSCSS["selected-spawn-text-address"]} id={SpawnSelectorSCSS["current-address"]}>{dataSelector[tab - 1].Description}</div>
                </div>
                <div className={SpawnSelectorSCSS["selecting-menu"]}>
                    <div className={SpawnSelectorSCSS["arrow-left"]} onClick={handleTabBefore}>
                        <div>{"<"}</div>
                    </div>
                    <div className={SpawnSelectorSCSS["select-spawn"]} id={SpawnSelectorSCSS["select-spawn"]} onClick={() => fetchNui("spawnSelector:Select", tab)}>
                        <div>{translation.select}</div>
                    </div>
                    <div className={SpawnSelectorSCSS["arrow-right"]} onClick={handleTabNext}>
                        <div>{">"}</div>
                    </div>
                </div>

            </div>
        </div>
        </div>
  )
};

export default SpawnSelector;
