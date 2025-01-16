import React, { useState, useRef, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import { Divider } from "@mantine/core";

import RentalSCSS from "./Rental.module.scss";

debugData([
  {
    action: "showRental",
    data: {
      show: true,
      data: [
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        { name: "test", type: "FREE", image: "revolter.png" },
        

        
      ],
    },
  },
]);
const Rental = () => {
  const [opened, setOpened] = useState(true);
  const [data, setData] = useState<any>([]);
  const [car, setCar] = useState<any>([]);

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
        fetchNui("spawnSelector:Close");
      }
    };

    window.addEventListener("keydown", handleKeyDown);

    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  });
  const handleSelectCar = (car: any) => {
    setCar(car);
  };

  return (
    opened &&
    data.length > 0 && (
      <>
        <div className={RentalSCSS["background"]}></div>
        <div className={RentalSCSS["container"]}>
          <div className={RentalSCSS["con1"]}>
            <div className={RentalSCSS["con1_1"]}>
              <h2 className={RentalSCSS["vert"]}>CAR RENTAL</h2>
              <p>RENT A VEHICLE</p>
            </div>

            <div className={RentalSCSS["con1_3"]}>
              <button className={RentalSCSS["exit"]}>Exit</button>
            </div>
          </div>
          <div className={RentalSCSS["con2"]}>
            <div className={RentalSCSS["con2_2"]} id="carContainer">
              {Object.entries(data).map(([key, value]) => (
                <div
                  className={RentalSCSS["car"]}
                  onClick={() => handleSelectCar(value)}
                >
                  <p>{//@ts-ignore
                  value.name}</p>
                  <div className={RentalSCSS["image-container"]}>
                    <img
                      src={`../assets/images/vehicle/${//@ts-ignore
                        value.image}`}
                      alt="${car.name}"
                    />
                  </div>
                  <p className={RentalSCSS["line"]}>{//@ts-ignore
                  value.type}</p>
                </div>
              ))}
            </div>
          </div>

          <div className={RentalSCSS["con4"]}>
            <p className={RentalSCSS["vert"]}>Payment</p>
            <p>Total Price</p>
            <div>
              <button id="bankingCardBtn">Banking Card</button>
              <button id="cashBtn">Pay via Cash</button>
            </div>
          </div>
        </div>
      </>
    )
  );
};

export default Rental;
