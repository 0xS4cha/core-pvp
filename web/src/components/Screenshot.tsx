import React, { useState, useRef, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import ScreenCSS from "./Screenshot.module.scss";

debugData([
    {
      action: "showScreenshot",
      data: {
        show: true,
        data: {
            screen:'https://cdn.discordapp.com/attachments/1075885824257835089/1330578967899668534/screenshot.jpg?ex=678e7dba&is=678d2c3a&hm=1800ba2e443ac5fbd3d25ea4c87398d0ace16e18444580beead289998467e0e1&',
            translation: {
                close: "Fermer"
            }
        }
      }

    }
]);


const Hudui = () => {
    const [opened, setOpened] = useState(false);
    const [translation, setTranslation] = useState<any>({});
    const [link, setLink] = useState<any>('');
      useEffect(() => {
        const handleMessage = (event: MessageEvent) => {
          const data2 = event.data;
          if (data2.action === "showScreenshot") {
            setOpened(data2.data.show);
            setTranslation(data2.data.data.translation);
            setLink(data2.data.data.screen);
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
              fetchNui("screenshot:Close");
            }
          };
      
          window.addEventListener("keydown", handleKeyDown);
      
          return () => {
            window.removeEventListener("keydown", handleKeyDown);
          };
        });


return ( opened && (
    
    <div className={ScreenCSS.screenshot}>
        <img src={link} alt="" />
        <button onClick={() => fetchNui("screenshot:Close")}>{translation.close}</button>
    </div>
    
));
};

export default Hudui;
