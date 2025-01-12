import React, { useState, useEffect, useRef } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import DeathSCSS from "./Death.module.scss";

debugData([
  {
    action: "showDeath",
    data: {
      show: true,
      timeleft: 4,
      killer: {
        killerName: "Amine",
        killerImage: "https://cdn.discordapp.com/attachments/1276573907192774656/1323782003190923284/image.jpg?ex=6782f290&is=6781a110&hm=38e00232245c8dcf8bcdc598008c20e935e7c52c2b36c3870a281eff97bc9a84&",
        killerVip: true,
      }
    },
  },
]);

const Death = () => {
  const [openedDeath, setOpenedDeath] = useState(false);
  const [timeLeft, setTimeLeft] = useState(300); // Initialisation à 5 minutes (300 secondes)
  const [killer, setKiller] = useState<any>({ killerName: "Sacha", killerImage: "", killerVip: false, hit: 1, apDamage: 3, hpDamage: 1 });
  const intervalRef = useRef<NodeJS.Timeout | null>(null);

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      const data2 = event.data;
      if (data2.action === "showDeath") {
        setOpenedDeath(data2.data.show);
        setKiller(data2.data.killer);

        // Redémarrer le timer si la mort est affichée
        if (data2.data.show) {
          setTimeLeft(data2.data.timeleft); // Réinitialiser à 5 minutes
        }
      }
    };
    window.addEventListener("message", handleMessage);

    return () => {
      window.removeEventListener("message", handleMessage);
    };
  }, []);

  useEffect(() => {
    if (openedDeath) {
      intervalRef.current = setInterval(() => {
        setTimeLeft((prevTime) => {
          if (prevTime <= 0) {
            clearInterval(intervalRef.current as NodeJS.Timeout);
            return 0;
          }
          return prevTime - 1;
        });
      }, 1000);
    } else {
      // Arrêter le minuteur si `openedDeath` est désactivé
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
    }

    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
    };
  }, [openedDeath]);

  const formatTime = (time: number): string => {
    const minutes = Math.floor(time / 60).toString().padStart(2, "0");
    const seconds = (time % 60).toString().padStart(2, "0");
    return `${minutes}:${seconds}`;
  };

  return (
    openedDeath && (
      <div>
        <div className={DeathSCSS["v14_250"]}>
          <span className={DeathSCSS["v14_216"]}>
            Vous êtes <span className={DeathSCSS["incon"]}>inconscient</span>...
          </span>
          <div className={DeathSCSS["v14_249"]}>
            <div className={DeathSCSS["v14_246"]}>

            {/*<div className={DeathSCSS["v14_217"]}></div>*/}
              <div
                className={
                  timeLeft === 0
                    ? DeathSCSS["v14_225"] // Classe appliquée si le temps est 0
                    : DeathSCSS["v14_244"] // Classe par défaut
                }
              >
                <span className={DeathSCSS["v14_223"]}>RÉAPPARAÎTRE</span>
              </div>

            </div>
            
            <div className={DeathSCSS["v14_248"]}>
              <div className={DeathSCSS["v14_215"]}></div>
              <span className={DeathSCSS["v14_224"]} id="timer">
                {formatTime(timeLeft)}
              </span>
              <div className={DeathSCSS["v14_233"]}>
                <img
                  src="../assets/images/death/timer.svg"
                  alt=""
                  className={DeathSCSS["v14_241"]}
                />
              </div>
            </div>
          </div>
        </div>
        <div className={DeathSCSS["killerInformation"]}>
          <div className={DeathSCSS["top"]}>
          <div
            className={`${DeathSCSS["img"]} ${killer.killerVip ? DeathSCSS["imgVip"] : ""}`}
              >
              <img src={killer.killerImage} alt=""/>
            </div>
            <div className={DeathSCSS["info"]}>
                    <div className={DeathSCSS["description"]}>
                        <div className={DeathSCSS["killer"]}>
                            <h1>
                                KILLER NAME
                            </h1>
                            <h2 className={`${killer.killerVip ? DeathSCSS["textVip"] : ""}`}>
                                {killer.killerName}
                            </h2>
                        </div>
                        <div className={DeathSCSS["damage"]}>
                        {killer.hpDamage}HP - {killer.apDamage}AP in {killer.hit} hit 
                        </div>
                    </div>
                    </div>

          </div>
        </div>
      </div>
    )
  );
};

export default Death;
