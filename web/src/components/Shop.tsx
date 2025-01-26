import React, { useState, useRef, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import ShopCSS from "./Shop.module.scss";
import { Divider } from "@mantine/core";
/***/
debugData([
  {
    action: "showShop",
    data: {
      show: true,
      data: {
        weapons: {
          label: "Weapons",
          img: "weapons",
          list: [
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "bread", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
          ],
        },
        items: {
          label: "Items",
          img: "items",
          list: [
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "bread", label: "Pistol", price: 10 },
            { item: "weapon_pistol", label: "Pistol", price: 10 },
          ],
        },
      },
    },
  },
]);

const Shop = () => {
  const [openedSHOP, setOpenedSHOP] = useState(false);
  const [dataSHOP, setDataSHOP] = useState<any>({});
  const [subMenu, setSubMenu] = useState<string>("");
  const [purshasedItems, setPurshasedItems] = useState<Array<{ item: string, price: number, label: string, quantity: number }>>([]);
  const [price, setPrice] = useState<number>(0);
  useNuiEvent<any>("showShop", (data2) => {
    setDataSHOP(data2.data);
    setOpenedSHOP(data2.show);
  });
  useEffect(() => {
    let total = 0;
    Object.entries(purshasedItems || {}).forEach(([key, value]) => {
      // @ts-ignore
      total += value.price ?? 0;
    });
    setPrice(total);
  }, [purshasedItems]);

  const pushased = (data: any) => {
    setPurshasedItems((prevState) => {
      const exists = prevState.some(item => item.item === data.item);
  
      if (exists) {
        return prevState.filter(item => item.item !== data.item);
      }
  
      return [...prevState, {label: data.label, item: data.item, price: data.price, quantity: 1}];
    });
  };
  return (
    openedSHOP &&
    Object.keys(dataSHOP).length > 0 && (
      <div className={ShopCSS["GlobalShop"]}>
        <div className={ShopCSS["BackgroundShop"]}>
          <div className={ShopCSS["ContentShop"]}>
            <div className={ShopCSS["TitleShop"]}>
              {/* Nouvelle structure pour aligner les éléments */}
              <div className={ShopCSS["TitleShopHeader"]}>
                <h1>Shop</h1>
                <div className={ShopCSS["categories"]}>
                  {Object.entries(dataSHOP).map(([key, value]) => (
                    <button
                      className={
                        subMenu === key
                          ? ShopCSS["active-btn"]
                          : ShopCSS["menu-btn"]
                      }
                      onClick={() => setSubMenu(key)}
                    >
                      {
                        //@ts-ignore
                        value.label
                      }
                    </button>
                  ))}
                </div>
                <div className={ShopCSS["clothingrightclose"]}>
                  <div className={ShopCSS["clothingrightclose_text"]}>Quit</div>
                  <div className={ShopCSS["clothingrightclose_icon"]}>
                    <img
                      src="../assets/images/clothingstore/close.svg"
                      alt=""
                      style={{ margin: "10px" }}
                    />
                  </div>
                </div>
              </div>

              <div style={{ display: "flex", gap: "10px" }}>
                <Divider
                  style={{ flexBasis: "74%" }}
                  variant="dashed"
                  color="var(--white-30)"
                  label="List"
                  labelPosition="center"
                />
                <Divider
                  style={{ flexBasis: "26%" }}
                  variant="dashed"
                  color="var(--white-30)"
                  label="Shopping Card"
                  labelPosition="center"
                />
              </div>
            </div>
            <div className={ShopCSS["content2"]}>
              <div className={ShopCSS["submenuList"]}>
                <div className={ShopCSS["itemList"]}>
                  {dataSHOP[subMenu] && (
                    <>
                      {Object.entries(dataSHOP[subMenu].list).map(
                        ([key, value]) => (
                          <div className={(purshasedItems.some(item => item.item === value.item)) ? ShopCSS["itemslt"] : ShopCSS["item"] }
                           onClick={() => pushased(value)}>
                            <p>{value.label}</p>
                            <div className={ShopCSS["image-container"]}>
                              <img
                                src={`../assets/images/inventaire/items/${value.item}.png.webp`}
                              />
                            </div>
                            <p className={ShopCSS["line"]}>${value.price}</p>
                          </div>
                        )
                      )}
                    </>
                  )}
                </div>
              </div>
              <div style={{ height: "100px" }}>
                <Divider
                  orientation="vertical"
                  variant="dashed"
                  color="var(--white-30)"
                  style={{ height: "600%", width: "1px" }}
                />
              </div>
              <div className={ShopCSS["submenuList2"]}>Autre contenu ici</div>
            </div>
          </div>
        </div>
      </div>
    )
  );
};

export default Shop;
