import React, { useState, useRef, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import { Divider } from "@mantine/core";

import RentalSCSS from "./Rental.module.scss";
import { cp } from "fs";
/*
debugData([
  {
    action: "showRental",
    data: {
      show: true,
      data: [
        { name: "T20", type: "FREE", image: "revoltefdsr.png" },
        { name: "T20", type: "FREE", image: "revolter.png" },
        { name: "T20", type: "FREE", image: "revolter.png" },
        { name: "T20", type: "FREE", image: "revolter.png" },
        { name: "T20", type: "FREE", image: "revolter.png" },
        { name: "T20", type: "FREE", image: "revolter.png" },
        { name: "T20", type: "FREE", image: "revolter.png" },
        { name: "T20", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        

        
      ],
    },
  },
]);*/
const Rental = () => {
  const [opened, setOpened] = useState(false);
  const [data, setData] = useState<any>([]);

  const [car, setCar] = useState<any>(0);

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      if (event.data.action === "showRental") {
        setData(event.data.data.data);
        setOpened(event.data.data.show);
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
        fetchNui("vehicleSpawner:Close");
      }
    };

    window.addEventListener("keydown", handleKeyDown);

    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  });
  const handleSelectCar = (car2: any) => {
    setCar(car2);
  };

  const spawnCar = () => {
    if (car === 0) return;
    fetchNui("vehicleSpawner:Spawn", car);
  };
  const CloseSpawner = () => {
    fetchNui("vehicleSpawner:Close");
  }

  return (
    opened &&
    data.length > 0 && (
      <>
        <div className={RentalSCSS["background"]}></div>
        <div className={RentalSCSS["container"]}>
          <div className={RentalSCSS["con1"]}>
            <div className={RentalSCSS["con1_1"]}>
              <h1 className={RentalSCSS["vert"]}>CAR SPAWNER</h1>
              <h2>SPAWN A VEHICLE</h2>
            </div>


          </div>
          <div className={RentalSCSS["con2"]}>
            <div className={RentalSCSS["con2_2"]} id="carContainer">
              {Object.entries(data).map(([key, value]) => (
                <div
                  className={car === key ? RentalSCSS["carSlt"] : RentalSCSS["car"] }
                  onClick={() => handleSelectCar(key)}
                >
                  <p>{//@ts-ignore
                  value.name}</p>
                  <div className={RentalSCSS["image-container"]}>
                    <img
                      src={`../assets/images/vehicle/${//@ts-ignore
                        value.image}.png.webp`}
    
                    />
                  </div>
                  <p className={RentalSCSS["line"]}>{//@ts-ignore
                  value.type}</p>
                </div>
              ))}
            </div>
          </div>

          <div className={RentalSCSS["con4"]}>

            <div>
              <button  className={car !== 0 ? RentalSCSS["blueBtn"] : RentalSCSS["greyBtn"] } onClick={spawnCar}>SPAWN</button>
              <button className={RentalSCSS["CloseBtn"]} onClick={CloseSpawner}>Close</button>
            </div>
          </div>
        </div>
      </>
    )
  );
};

export default Rental;
