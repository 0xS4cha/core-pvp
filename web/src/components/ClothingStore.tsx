import React, { useState, useRef, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import { Divider } from "@mantine/core";
import PaginatedClothingItems from "./Clothing/ImageParent";
import clothingStore from "./ClothingStore.module.scss";

const clotheTypeIndex: { [key: string]: number } = {
  torso: 11,
  mask: 1,
  bags:5,
  tshirt: 8,
  pants: 4,
  shoes: 6,
  arms: 3,
};

debugData([
  {
    action: "Clothing:SendData",
    data: {
      gender: "male",
      show: false,
      clothesData: {
        torso: {
          label: "Torse",
          max: 523,
          defaultprice: 100,
          customprice: { 1: 1000, 2: 2400, 3: 300 },
          blacklist: [2, 3, 4, 5, 6, 8, 9, 10],
        },
        pants: {
          label: "Pantalon",
          max: 192,
          defaultprice: 100,
          customprice: { 1: 12345, 2: 200, 3: 300 },
          blacklist: [2, 3, 4, 5, 6, 7, 8, 9, 10],
        },
        shoes: {
          label: "Chaussures",
          max: 192,
          defaultprice: 100,
          customprice: { 1: 100, 2: 200, 3: 300 },
          blacklist: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        },
        mask: {
          label: "Masque",
          max: 192,
          defaultprice: 100,
          customprice: { 1: 100, 2: 200, 3: 300 },
          blacklist: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        },
        tshirt: {
          label: "tshirt",
          max: 192,
          defaultprice: 100,
          customprice: { 1: 100, 2: 200, 3: 300 },
          blacklist: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        },
        arms: {
          label: "Gant",
          max: 192,
          defaultprice: 100,
          customprice: { 1: 100, 2: 200, 3: 300 },
          blacklist: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        },

      },
      translation: {
        title: "ClothesShop",
        desc: 'test',
        price: "Price",
        cash: 'Cash',
        quit : "Quit",
        totalPrice: "Total price",
      },
    },
  },
]);
const ClothingStore = () => {
  const [opened, setOpened] = useState<boolean>(false);
  const [activeTab, setActiveTab] = useState<string>("torso");
  const [gender, setGender] = useState<string>("male");
  const [purshasedItems, setPurshasedItems] = useState<any>({});
  const [price, setPrice] = useState<number>(0);
  const [translation, setTranslation] = useState<any>({});
  const [data, setData] = useState<any>({
    torso: {
      label: "Torse",
      max: 523,
      defaultprice: 100,
      customprice: { 1: 1000, 2: 2400, 3: 300 },
      blacklist: [2, 3, 4, 5, 6, 8, 9, 10],
    },
    pants: {
      label: "Pantalon",
      max: 192,
      defaultprice: 100,
      customprice: { 1: 12345, 2: 200, 3: 300 },
      blacklist: [2, 3, 4, 5, 6, 7, 8, 9, 10],
    },
    shoes: {
      label: "Chaussures",
      max: 192,
      defaultprice: 100,
      customprice: { 1: 100, 2: 200, 3: 300 },
      blacklist: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    },
    mask: {
      label: "Masque",
      max: 192,
      defaultprice: 100,
      customprice: { 1: 100, 2: 200, 3: 300 },
      blacklist: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    },
    tshirt: {
      label: "tshirt",
      max: 192,
      defaultprice: 100,
      customprice: { 1: 100, 2: 200, 3: 300 },
      blacklist: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    },
    arms: {
      label: "Gant",
      max: 192,
      defaultprice: 100,
      customprice: { 1: 100, 2: 200, 3: 300 },
      blacklist: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    },

  });


 

    useEffect(() => {
        const handleKeyPress = (event: any) => {

          if (event.key === "ArrowLeft" && opened) {
            fetchNui("clothingStoreChangeVariation", 1);
          } else if (event.key === "ArrowRight" && opened) {
            fetchNui("clothingStoreChangeVariation", 2);
          }
        };
        window.addEventListener("keydown", handleKeyPress);
  
        return () => {
          window.removeEventListener("keydown", handleKeyPress);
        };
      
    });


    useEffect(() => {
      const handleKeyDown = (event: WheelEvent) => {
        // Vérifiez si l'utilisateur survole un élément avec la classe "no-scroll"
        if (
          (event.target as HTMLElement)?.className.includes("storeleftmenu") ||
          (event.target as HTMLElement)?.closest(".storeleftmenu_testbaba") || 
          ((event.target as HTMLElement)?.offsetParent as HTMLElement)?.classList.contains("storeleftmenu")
        ) {

          return;
        }

          if (event.deltaY > 0) {

            fetchNui("clothingStoreZoom", 1);
          } else if (event.deltaY < 0) {

            fetchNui("clothingStoreZoom", 2);
          }
        
      };
    
      window.addEventListener("wheel", handleKeyDown, { capture: true });
      return () => {
        window.removeEventListener("wheel", handleKeyDown, { capture: true });
      };
    }, []);
  

  useEffect(() => {
    let total = 0;
    Object.entries(purshasedItems || {}).forEach(([key, value]) => {
      // @ts-ignore
      total += value.price ?? 0;
    });
    setPrice(total);
  }, [purshasedItems]);

  useNuiEvent<any>("Clothing:SendData", (data2) => {
    setOpened(data2.show);
    setGender(data2.gender);
    setData(data2.clothesData);
    setTranslation(data2.translation);
  });


  const handleTabChange = (tab: string) => {
    setActiveTab(tab);
  };
  const handleValidBasket = () => {
    fetchNui("clothingStoreSaved", purshasedItems);
    setPurshasedItems({});
  }
  const pushased = (type: string, id: number, price: number) => {
    setPurshasedItems((prevState = {}) => ({
      ...prevState,
      [type]: { type: type, id: id, price: price },
    }));
    fetchNui("showcaseClothing", { type: type, id: id });
  };

  function removeItemAlt(key: string) {
    fetchNui("removeClothing", purshasedItems[key]);
    setPurshasedItems((prevState = {}) =>
      Object.fromEntries(Object.entries(prevState).filter(([k]) => k !== key))
    );
  }
  function closeClothingStore() {
    fetchNui("clothingStoreClosed");
  }



  return (
    opened &&
    Object.keys(data).length > 0 && Object.keys(translation).length > 0 && (
      <div>
       <div className={clothingStore["storeleftmenu_testbaba"]}></div>
        <div
          className={clothingStore["global"]}
          style={{ margin: 0, padding: 0, height: "100%", overflow: "hidden" }}
        >

          <div className={clothingStore["title"]}>
            <h1>{translation.title}</h1>
            <Divider my="10px" variant="dashed" color="var(--white-30)" />
            <h5>{translation.desc}</h5>
          </div>
          <div className={clothingStore["storeall"]}>
            <div className={clothingStore["storeleftmenu"]}>

              {/* Menu de gauche */}
              {Object.entries(data).map(([key, value]) => (
                <div>
                  <div
                    key={key}
                    className={clothingStore["storeleftmenu_item"]}
                    id={key}
                    onClick={() => handleTabChange(key)}
                  >
                    <div className={clothingStore["storeleftmenu_item_img"]}>
                      <img
                        src={`../assets/images/clothingstore/${key}.svg`}
                        alt=""
                      />
                    </div>
                  </div>
                  <div className={clothingStore["storeleftmenu_item_name"]}>
                    {
                      // @ts-ignore
                      value.label || "Unknow"
                    }
                  </div>
                </div>
              ))}
            </div>

            <PaginatedClothingItems
              data={data}
              gender={gender}
              activeTab={activeTab}
              // @ts-ignore
              clotheTypeIndex={clotheTypeIndex}
              onPurchase={pushased}
              clothingStore={{
                storeleftmenuclothingpart: ".storeleftmenuclothingpart_item",
              }}
            />

            {/* Bouton Quitter */}
            <div
              className={clothingStore["clothingrightclose"]}
              onClick={() => closeClothingStore()}
            >
              <div className={clothingStore["clothingrightclose_text"]}>
                {translation.quit}
              </div>
              <div className={clothingStore["clothingrightclose_icon"]}>
                <img
                  src="../assets/images/clothingstore/close.svg"
                  alt=""
                  style={{ margin: "10px" }}
                />
              </div>
            </div>

            
            <div className={clothingStore["storerightmenu"]}>
              <div className={clothingStore["storerightmenu_top"]}>
                <div className={clothingStore["storerightmenu_top_text"]}>{translation.title}<span style={{ marginTop: "-5px" }}><br/>basket</span></div>
                <div className={clothingStore["storerightmenu_top_img"]}>
                  <img
                    src="../assets/images/clothingstore/market.png"
                    alt=""
                    style={{ width: "70px", height: "70px" }}
                  />
                </div>
              </div>
              <div className={clothingStore["storerightmenu_center"]}>
                {Object.entries(purshasedItems).map(([key, value]) => (
                  <div
                    key={key}
                    className={clothingStore["storerightmenu_center_item"]}
                  >
                    <div
                      className={
                        clothingStore["storerightmenu_center_item_img"]
                      }
                    >
                      <img
                        src="../assets/images/clothingstore/bill.svg"
                        alt=""
                      />
                    </div>
                    <div
                      className={
                        clothingStore["storerightmenu_center_item_text"]
                      }
                    >
                      {
                        // @ts-ignore
                        data[key].label
                      }{" "}
                      
                      #{ // @ts-ignore
                      value?.id}
                    </div>
                    <div
                      className={
                        clothingStore["storerightmenu_center_item_text2"]
                      }
                    >
                      {translation.price}:{" "}
                      <span
                        style={{
                          color: "#3AFF89",
                          width: "100%",
                          marginLeft: "5px",
                        }}
                      >
                        ${" "}
                        {
                          // @ts-ignore
                          value?.price || 0
                        }
                      </span>
                    </div>
                    <div
                      className={
                        clothingStore["storerightmenu_center_item_remove"]
                      }
                      onClick={() => removeItemAlt(key)}
                    >
                      <img
                        src="../assets/images/clothingstore/remove.svg"
                        alt=""
                      />
                    </div>
                  </div>
                ))}
              </div>
              <div className={clothingStore["storerightmenu_bottom1"]}>
                <div className={clothingStore["storerightmenu_bottom1_text"]}>
                  {translation.totalPrice}
                </div>
                <div
                  className={clothingStore["storerightmenu_bottom1_text2"]}
                  id="totalinsert"
                >
                  $ {price}
                </div>
              </div>
              <div className={clothingStore["storerightmenu_bottom2"]}>

                <div
                  onClick={() => handleValidBasket()}
                  className={`${clothingStore["storerightmenu_bottom2_button1"]} ${clothingStore["green"]}`}
                >
                  <div
                    className={
                      clothingStore["storerightmenu_bottom2_button1_img"]
                    }
                    style={{ marginLeft: "35px" }}
                  >
                    <img src="../assets/images/clothingstore/cash.svg" alt="" />
                  </div>
                  <div
                    className={
                      clothingStore["storerightmenu_bottom2_button1_text"]
                    }
                  >
                    {translation.cash}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  );
};

export default ClothingStore;


