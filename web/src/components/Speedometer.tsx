import React, { useState } from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import scss from "./Speedometer.module.scss";

debugData([
  {
    action: "showSpeedometer",
    data: {
      show: false,
      data: { speed: 200, speedUnit: "KM/H" },
    },
  },
]);

interface HudData {
  speed: number;
  speedUnit: string;
}

const Speedometer: React.FC = () => {
  const [opened, setOpened] = useState<boolean>(false);
  const [hudData, setHudData] = useState<HudData>({
    speed: 0,
    speedUnit: "km/h",
  });

  useNuiEvent(
    "showSpeedometer",
    (eventData: { show: boolean; data: HudData }) => {
      setHudData(eventData.data);
      setOpened(eventData.show);
    }
  );

  const radius = 20; // Rayon du cercle
  const circumference = 2 * Math.PI * radius; // Circonférence complète

  // Calculer l'offset pour que le cercle se remplisse progressivement
  const strokeOffset = circumference - (hudData.speed / 220) * circumference;

  return (
    opened && (
      <div className={scss["huds"]}>
        <div className={scss["hud"] + " " + scss["dashboard"]}>
          {/* Speedometer */}
          <div className={scss["speedometer"]}>
            <svg className={scss["circle"]} width="50" height="50">
              {/* Fond du cercle */}
              <circle
                className={scss["background"]}
                stroke="#FFFFFF"
                strokeWidth="4"
                style={{ strokeOpacity: 0.2 }}
                fill="transparent"
                r={radius}
                cx="25"
                cy="25"
              />
              {/* Cercle progressif */}
              <circle
                className={`${scss["progress"]} ${scss["progress-speed"]}`}
                stroke="url(#gradient)"
                strokeWidth="4"
                fill="transparent"
                r={radius}
                cx="25"
                cy="25"
                strokeDasharray={circumference}
                strokeDashoffset={strokeOffset}
                style={{
                  transition: "stroke-dashoffset 0.2s ease-in-out", // Animation fluide
                }}
              />
              <defs>
                <linearGradient id="gradient">
                  <stop offset="30%" stopColor="#FF0245" />
                  <stop offset="100%" stopColor="#BBFFFE" />
                </linearGradient>
              </defs>
            </svg>
            <div className={scss["text"]}>
            <span className={scss["speed"]}>{hudData.speed}</span>
              
              <div className={scss["kmh"]}>{hudData.speedUnit}</div>
            </div>
          </div>
        </div>
      </div>
    )
  );
};

export default Speedometer;
