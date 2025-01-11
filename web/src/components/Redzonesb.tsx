import React, { useState, useEffect } from "react";
import { Divider } from "@mantine/core";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faRotate,
  faTrash,
} from "@fortawesome/free-solid-svg-icons";
import { debugData } from "../utils/debugData";
import RedZoneSCSS from "./Redzone.module.scss";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import './Redzone.css';

debugData([
    {
      action: "showRedzone",
      data: {
        show: true,
        scoreboard: {
          identifier: "steam:11000010",
          myRank: 4,
          zone: {
            leader: {
              name: "Danny Brian",
              kill: 20,
            },
            totalKills: 100,
            players: {

            },
          },
        }
      }

    }
]);





const Redzonesb = () => {
  const [openedRedzone, setOpenedRedzone] = useState(false);
  const [dataRedzone, setDataRedzone] = useState<any>({});

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      if (event.data.action === "showRedzone") {
        setDataRedzone(event.data.data.scoreboard);
        setOpenedRedzone(event.data.data.show);
      }
    };
    window.addEventListener("message", handleMessage);

    return () => {
      window.removeEventListener("message", handleMessage);
    };
  }, []);


  return (
    openedRedzone && Object.keys(dataRedzone).length > 0 && (
<>

      <div className="redzone-container pb-3">
      {/* Redzone Leader Section */}
      <div className="redzone-border relative">
        <div className="relative w-full">
          <div className="relative w-full h-full flex items-center justify-center" style={{ zIndex: 3 }}>
            <h2 className="whitetext2">REDZONE LEADER</h2>
          </div>
        </div>
      </div>
      <Divider my="5px" variant="dashed" color="var(--red)" />
      {/* Player Section */}
      <div className="mx-auto player mt-2">
        <p>{`1. ${//@ts-ignore
          dataRedzone.zone.leader.name}`}</p>
        <div className="flex items-center you3">
          <img className="mr-2" src="../assets/images/redzone/kills.png" alt="Kills icon" />
          <p className="leader-kills">{//@ts-ignore
          dataRedzone.zone.leader.kill}</p>
        </div>
      </div>
 
      {/* Total Kills Section */}
      <div className="redzone-border mt-3 relative">
        <div className="relative w-full">
          <div className="relative w-full h-full flex items-center justify-center" style={{ zIndex: 3 }}>
            <h2 className="whitetext2">TOTAL KILLS</h2>
          </div>

        </div>
      </div>
      <Divider my="5px" variant="dashed" color="var(--red)" />
      {/* Total Kills Display */}
      <div className="mx-auto  mt-2">
        <div className="you2">
          <img className="mr-2" src="../assets/images/redzone/kills.png" alt="Kills icon" />
          <p className="total-kills text-center">{//@ts-ignore
          dataRedzone.zone.totalKills}</p>
        </div>
      </div>
   

    </div>
    <div className="redzonepersonnalinformation">
      <div className="Kills">
        
        <div className='IconImage'> <img src="https://sacha-dev.fr/armor.webp"  alt=""/></div>
        <div className='Information'>test</div>
      </div>
      <div className="Position">
      <div className='IconImage'> <img src="https://sacha-dev.fr/armor.webp"  alt=""/></div>
      <div className='Information'>test</div>
      </div>
      
    </div>
    </>
    
    )
  );
};

/*

      <div className="redzone-border mt-3 relative">
        <div className="relative w-full">
          <div className="relative w-full h-full flex items-center justify-center" style={{ zIndex: 3 }}>
            <h2 className="whitetext2">YOU</h2>
          </div>

        </div>
      </div>
      <Divider my="5px" variant="dashed" color="var(--red)" />

      <div className="mx-auto you mt-2">
        <p>KILLED PLAYERS</p>
        <div className="flex items-center you3">
          <img className="mr-2" src="../assets/images/redzone/kills.png" alt="Kills icon" />
          <p className="your-kills">{//@ts-ignore
          dataRedzone.zone.players[dataRedzone.identifier] ? dataRedzone.zone.players[dataRedzone.identifier].kill : 0}</p>
        </div>
      </div>
      <Divider my="2px" variant="dashed" color="var(--red)" />

      <div className="mx-auto you mt-2">
        <p>LEADERBOARD PLACE</p>
        <div className="flex items-center ">
          <p className="leaderboard-place">{`${//@ts-ignore
          dataRedzone.myRank}.`}</p>
        </div>
      </div>*/


export default Redzonesb;
