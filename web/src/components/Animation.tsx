import React, { useState, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import scss from "./Choice_gamemode.module.scss";

import ShinyText from "./Utils/ShinyText";
import Squares from "./Utils/Squares";
import Carousel from "./Utils/Carousel";
import { VscHome } from "react-icons/vsc";
import Dock from "./Utils/Dock";

const Animation: React.FC = () => {
  const [opened, setOpened] = useState<boolean>(false);

  return (
    opened && (
      <>
        <div className="box-wrapper">
          <div className="panel" id="top-panel">
            <div className="notification" id="notification">
              Notifcation
            </div>
            <div className="search-bar">
              <i className="fas fa-search"></i>
              <input type="text" />
            </div>
            <div className="panel-options">
              <div className="option" id="favourite">
                Favoris
              </div>
              <span className="option material-icons" id="setting-stop">
                <i className="fa-solid fa-xmark"></i>
              </span>
            </div>
          </div>
          <div className="panel" id="bottom-panel">
            <div
              className="option"
              id="categories"
              style={{ width: "100%" }}
            ></div>
          </div>
          <div className="box">
            <div className="item"></div>
          </div>
        </div>

        <div className="popup" id="popup">
          Lire l'animation en boucle
        </div>
      </>
    )
  );
};

export default Animation;
