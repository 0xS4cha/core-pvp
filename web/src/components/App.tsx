import React, { useState, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { isEnvBrowser } from "../utils/misc";
import { debugData } from "../utils/debugData";
import ClothingStore from "./ClothingStore";
import GroupCreaComponent from "./group_creator";

import InputComponent from "./Input";
import CharCreator from "./CharCreator";
import Screenshot from "./Screenshot";
import PinComponent from "./Pin";
import AnimationComponent from "./Animation"
import LobbyUI from "./Choice_gamemode";
import PromptComponent from "./Prompt";

import Speedometer from "./Speedometer"


import Copy from "./Copy";

const App: React.FC = () => {
  const [contextVisible, setContextVisible] = useState(false);



  useEffect(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (contextVisible && e.code === "Escape") {
        if (!isEnvBrowser()) {
        }
      }
    };

    window.addEventListener("keydown", keyHandler);

    return () => {
      window.removeEventListener("keydown", keyHandler);
    };
  }, [contextVisible]);

  return (
    <>
      <LobbyUI/>
     <AnimationComponent/>
      <Copy/>
      
      <Speedometer/>
      <Screenshot/>
      <CharCreator/>
      
      <ClothingStore />
      <PromptComponent />
      <PinComponent />
      <GroupCreaComponent />
      <InputComponent />
       {/**/}




    </>
  );
};

export default App;




