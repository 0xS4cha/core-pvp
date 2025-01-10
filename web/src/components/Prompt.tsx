


import promptStyle from './Prompt.module.scss';
import React, { useEffect, useState, useRef  } from "react";
import { Badge, DEFAULT_THEME, Divider, Paper, Text } from "@mantine/core";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";

/*
debugData([
  {
    action: "showPrompt",
    data: true,
  },
]);*/



const Prompt = () => {
    const [prompt, setPrompt] = useState({ show: false, title: '', description: '', description2: '' });
  const [opened, setOpened] = useState(false);

    useEffect(() => {
      const handleMessage = (event: MessageEvent) => {
        const data = event.data;
        if (data.action === "showPrompt") {
          console.log("showPrompt");
          setOpened(data.data);
        }
      };
      window.addEventListener("message", handleMessage);
  
      return () => {
        window.removeEventListener("message", handleMessage);
      };
    });
    useNuiEvent('PROMPT_CREATE', (data) => {

        const regexColor = /~([^h])~([^~]+)/g;
        const regexBold = /~([h])~([^~]+)/g;
        const regexStop = /~s~/g;
        const regexLine = /\n/g;

        data.title = data.title.replace(regexColor, "<span class='$1'>$2</span>").replace(regexBold, "<span class='$1'>$2</span>").replace(regexStop, "").replace(regexLine, "<br />");
        data.description = data.description.replace(regexColor, "<span class='$1'>$2</span>").replace(regexBold, "<span class='$1'>$2</span>").replace(regexStop, "").replace(regexLine, "<br />");
        data.description2 = data.description2.replace(regexColor, "<span class='$1'>$2</span>").replace(regexBold, "<span class='$1'>$2</span>").replace(regexStop, "").replace(regexLine, "<br />");

        setPrompt(data)
    })



    useEffect(() => {
        if (prompt.show) {
            const keyHandler = (e: KeyboardEvent) => {
                if (["KeyY", "KeyN"].includes(e.code)) {
                    if (e.code === 'KeyY') {
                        fetchNui('PROMPT_ACCEPT')
                    } else {
                        fetchNui('PROMPT_REFUSE')
                    }
                }
            }

            window.addEventListener("keydown", keyHandler)

            return () => window.removeEventListener("keydown", keyHandler)
        }
    }, [prompt]);


    const handleAccept = () => {
        fetchNui('PROMPT_ACCEPT')
    }
    const handleDenied = () => {
        fetchNui('PROMPT_REFUSE')
    }

    return (opened && (
        <div className={promptStyle['prompt-container']}>


            <div className={promptStyle['prompt-contain']}>

                <h1 className={promptStyle['h1']} dangerouslySetInnerHTML={{ __html: prompt.title }}></h1>

                <div className={promptStyle['desc']}>
                    <p dangerouslySetInnerHTML={{ __html: prompt.description }}></p>
                    <p dangerouslySetInnerHTML={{ __html: prompt.description2 }}></p>
                </div>

                <div className={promptStyle['buttons']}>

                    <button className={`${promptStyle.refuse} ${promptStyle.btn}`} onClick={handleDenied}>Refuser<b className={promptStyle['b']}>(N)</b></button>
                    <button className={`${promptStyle.accept} ${promptStyle.btn}`} onClick={handleAccept}>Accepter<b className={promptStyle['b']}>(Y)</b></button>

                </div>

            </div>

        </div>

    ));

};

export default Prompt;