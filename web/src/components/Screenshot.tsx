import React, { useState, useRef, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import ScreenCSS from "./Screenshot.module.scss";

debugData([
    {
      action: "showScreenshot",
      data: {
        show: false,
        data: {
            screen:'https://cdn.discordapp.com/attachments/1075885824257835089/1334245553654992936/screenshot.webm?ex=679bd481&is=679a8301&hm=999f27d7ccf1507acb8d909030fd3b3f69382a07266996bb7b51556026d882ff&',
            type: 'video',
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
    const [type, setType] = useState<any>('');
      useEffect(() => {
        const handleMessage = (event: MessageEvent) => {
          const data2 = event.data;
          if (data2.action === "showScreenshot") {
            setOpened(data2.data.show);
            setTranslation(data2.data.data.translation);
            setType(data2.data.data.type)
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
      {type === 'image' && (
        <img src={link} alt="" />
      )}
      {type === 'video' && (
        <video loop controls className={ScreenCSS.controls}>
          <source  type='video/webm' src={link}/>
        </video>
      )}
      <button onClick={() => fetchNui("screenshot:Close")}>{translation.close}</button>
    </div>
    
));
};

export default Hudui;
