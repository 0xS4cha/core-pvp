import React, { useState, useRef, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";


import CardealerSCSS from "./Cardealer.module.scss";


debugData([
  {
    action: "showCardealer",
    data: {
      show: false,
      data: {
          'offroad': [
            { name: "T20", price: 2, image: "revolter", vehicle: 't20' },
          ],
          'sport': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
   
          ],
          'kuyf': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
   
          ],
          'jhgf': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
   
          ],
          'htrd': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
   
          ],
          'hre': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
   
          ],
          'gfdf': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
   
          ],
          'fds': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
          ],
          'fds2': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
          ],
          '3': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
          ],
          '4': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
          ],
          '5': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
          ],
          '6': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
          ],
          '7': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
          ],
          '8': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
          ],
          '9': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
          ],
          '19': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
          ],
          'ZAE': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
          ],
          'eAZR': [
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
            { name: "T20", price: 13321, image: "t20", vehicle: 't20' },
          ],
      },
        
    },
  },
]);
const Cardealer = () => {
  const [opened, setOpened] = useState(false);
  const [data, setData] = useState<any>({});
  const [tab, setTab] = useState<any>('');
  const [carTab, setCarTab] = useState<any>('');
  const [car, setCar] = useState<any>(0);

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      if (event.data.action === "showCardealer") {
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
        fetchNui("cardealer:Close");
      }
    };

    window.addEventListener("keydown", handleKeyDown);

    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  });
  const handleSelectCar = (car2: any, tab: any) => {
    if (car === car2 && carTab === tab) {
      setCar(0);
      setCarTab('');
    } else {
      setCarTab(tab);
      setCar(car2);
    }
  };

  const spawnCar = () => {
    if (car === 0) return;
    fetchNui("cardealer:buy", { car: car, tab: carTab });
  };
  const CloseSpawner = () => {
    fetchNui("cardealer:Close");
  }

  return (
    opened && Object.keys(data).length > 0 &&
     (
      <>
        <div className={CardealerSCSS["background"]}></div>
        <div className={CardealerSCSS["container"]}>
          <div className={CardealerSCSS["con1"]}>
            <div className={CardealerSCSS["con1_1"]}>
              <h1 className={CardealerSCSS["vert"]}>CARDEALER</h1>
              <h2>BUY A VEHICLE</h2>
            </div>


          </div>
          <div className={CardealerSCSS["con2"]}>
          <div className={CardealerSCSS["con2_1"]}>
                <ul id="categoryList">
                {Object.entries(data).map(([key, value]) => (
                <li><button className={tab === key ? CardealerSCSS["active-btn"] : CardealerSCSS["menu-btn"] } onClick={() => setTab(key)}>{key}</button></li>
              ))}
                </ul>
            </div>
            <div className={CardealerSCSS["con2_2"]} id="carContainer">
            {data[tab] && (
              <>
              {Object.entries(data[tab]).map(([key, value]) => (
                <div
                  className={(car === key && carTab == tab) ? CardealerSCSS["carSlt"] : CardealerSCSS["car"] }
                  onClick={() => handleSelectCar(key, tab)}
                >
                  <p>{//@ts-ignore
                  value.name}</p>
                  <div className={CardealerSCSS["image-container"]}>
                    <img
                      src={`../assets/images/vehicle/${//@ts-ignore
                        value.image}.png.webp`}
    
                    />
                  </div>
                  <p className={CardealerSCSS["line"]}>${//@ts-ignore
                  value.price}</p>
                </div>
              ))}
              </>
              )}
            </div>
          </div>

          <div className={CardealerSCSS["con4"]}>

            <div>
              <button  className={car !== 0 ? CardealerSCSS["blueBtn"] : CardealerSCSS["greyBtn"] } onClick={spawnCar}>BUY</button>
              <button className={CardealerSCSS["CloseBtn"]} onClick={CloseSpawner}>Close</button>
            </div>
          </div>
        </div>
      </>
    )
  );
};

export default Cardealer;
