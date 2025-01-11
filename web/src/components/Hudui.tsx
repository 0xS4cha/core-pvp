import React, { useState, useRef, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import HudCSS from "./Hud.module.scss";

debugData([
    {
      action: "showHud",
      data: {
        show: true,
        data: {
            healthPercent: 50,
            armorPercent: 50,
            pausemenu: true
        }
        
      }

    }
]);


const Hudui = () => {
    const [openedHUD, setOpenedHUD] = useState(false);
    const [dataHUD, setDataHUD] = useState<any>({});
      useEffect(() => {
        const handleMessage = (event: MessageEvent) => {
          const data2 = event.data;
          if (data2.action === "showHud") {
            setDataHUD(data2.data.data);
            setOpenedHUD(data2.data.show);
          }
        };
        window.addEventListener("message", handleMessage);
    
        return () => {
          window.removeEventListener("message", handleMessage);
        };
      });
return ( openedHUD && dataHUD.pausemenu && (
<div>
<div className={HudCSS["ui"]}>
            <div className={HudCSS["armour"]}>

                <div id={HudCSS["armour-level"]} style={{width:`${dataHUD.armorPercent}%`}}></div>
            </div>
            <div className={HudCSS["health"]}>

                <div id={HudCSS["health-level"]} style={{width:`${dataHUD.healthPercent}%`}}></div>
            </div>
        </div>
        <div className={HudCSS["ui2"]}>
            <div className={HudCSS["carre-armour"]}>
                <img src="../assets/images/redzone/armor.png"  alt=""/>
            </div>
            <div className={HudCSS["carre-health"]}>
            <img src="../assets/images/redzone/health.png" alt=""/>
            </div>
        </div>
 
</div>)
    );
};

export default Hudui;
