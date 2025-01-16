import React, { useState, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { isEnvBrowser } from "../utils/misc";
import { debugData } from "../utils/debugData";
import ClothingStore from "./ClothingStore";
import GroupCreaComponent from "./group_creator";
import HudComponent from "./Hudui";
import SpawnSelector from "./SpawnSelector";
import InputComponent from "./Input";
import Redzoneui  from "./Redzonesb";
import CharCreator from "./CharCreator";
import Inventory from "./Inventory/Inventory";
import Squad from "./Squad";
import Rental from "./Rental";
import PinComponent from "./Pin";
import PromptComponent from "./Prompt";
import Death from "./Death";

import Copy from "./Copy";

const App: React.FC = () => {
  const [contextVisible, setContextVisible] = useState(false);
  const [currentMenuID, setCurrentMenuID] = useState<string | null>(null);
  const [buttonVisible, setButtonVisible] = useState(false);
  const [binderControls, setBinderControls] = useState<any>({});
  const [schema, setSchema] = useState<any>({});



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
      <Copy/>
      <HudComponent/>
      <CharCreator/>
      <Rental />
      {/*<Squad/>*/}
      <ClothingStore />
      <SpawnSelector/>
      <Redzoneui />
      <Inventory />
      <Death/>
      <PromptComponent />
      <PinComponent />

      <GroupCreaComponent />
      <InputComponent />






    </>
  );
};

export default App;




