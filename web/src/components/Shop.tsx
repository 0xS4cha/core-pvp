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
      translation: {
        cash: "Cash",
        quit: "Quit",
      },
      data: {
        weapons: {
          label: "Weapons",
          img: "weapons",
          list: [
            { item: "weapon_pistol", label: "Pistol", price: 10 },
            { item: "bread", label: "Pistol", price: 10 },
            { item: "WEAPON_COMBATPISTOL", label: "WEAPON_COMBATPISTOL", price: 10 },
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
  const [translation, setTranslation] = useState<any>({});
  const [subMenu, setSubMenu] = useState<string>("");
  const [purshasedItems, setPurshasedItems] = useState<
    Array<{ item: string; price: number; label: string; quantity: number }>
  >([]);
  const [price, setPrice] = useState<number>(0);
  useNuiEvent<any>("showShop", (data2) => {
    setDataSHOP(data2.data);
    setTranslation(data2.translation);
    setOpenedSHOP(data2.show);
  });
  useEffect(() => {
    let total = 0;
    Object.entries(purshasedItems || {}).forEach(([key, value]) => {
      // @ts-ignore
      total += value.price * value.quantity;
    });
    setPrice(total);
  }, [purshasedItems]);
  const removeItem = (name: string) => {
    setPurshasedItems((prevState) => {
      return prevState.filter((item) => item.item !== name);
    });
  };
  const HandleConfirm = () => {
    fetchNui("shop:Buy", purshasedItems);
  }
  const HandleQuantity = (name: any, number: any) => {
    setPurshasedItems((prevState) => 
      prevState.map((item) =>
        item.item === name ? { ...item, quantity: number } : item
      )
    );
  };
  const pushased = (data: any) => {
    setPurshasedItems((prevState) => {
      const exists = prevState.some((item) => item.item === data.item);

      if (exists) {
        return prevState.filter((item) => item.item !== data.item);
      }

      return [
        ...prevState,
        { label: data.label, item: data.item, price: data.price, quantity: 1 },
      ];
    });
  };
  const CloseShop = () => {
    fetchNui("shop:Close");
  };
  useEffect(() => {
    const handleKeyDown = (event: any) => {
      if (event.key === "Escape" && openedSHOP) {
        CloseShop();
      }
    };

    window.addEventListener("keydown", handleKeyDown);

    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  });
  return (
    openedSHOP &&
    Object.keys(dataSHOP).length > 0 && (
      <div className={ShopCSS["GlobalShop"]}>
        <div className={ShopCSS["BackgroundShop"]}>
          <div className={ShopCSS["ContentShop"]}>
            <div className={ShopCSS["TitleShop"]}>
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
                  <div className={ShopCSS["clothingrightclose_text"]}>{translation.quit}</div>
                  <div
                    className={ShopCSS["clothingrightclose_icon"]}
                    onClick={CloseShop}
                  >
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
                          <div
                            className={
                              purshasedItems.some(
                                (item) =>
                                  item.item === //@ts-ignore
                                  value.item
                              )
                                ? ShopCSS["itemslt"]
                                : ShopCSS["item"]
                            }
                            onClick={() => pushased(value)}
                          >
                            <p>
                              {
                                //@ts-ignore
                                value.label
                              }
                            </p>
                            <div className={ShopCSS["image-container"]}>
                              <img
                                src={`../assets/images/inventaire/items/${
                                  //@ts-ignore
                                  value.item
                                }.png.webp`}
                              />
                            </div>
                            <p className={ShopCSS["line"]}>
                              $
                              {
                                //@ts-ignore
                                value.price
                              }
                            </p>
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
              <div className={ShopCSS["submenuList2"]}>
                <div className={ShopCSS["listPurshased"]}>
                  {Object.entries(purshasedItems).map(([key, value]) => (
                    <div
                      key={key}
                      className={ShopCSS["storerightmenu_center_item"]}
                    >
                      <div
                        className={ShopCSS["storerightmenu_center_item_text"]}
                      >
                        {value?.label}
                      </div>
                      <input
                        type="number"
                        className={ShopCSS["control"]}
                        value={value?.quantity}
                        onChange={(e) =>
                          HandleQuantity(value?.item, e.target.value)
                        }
                      />
                      <div
                        className={ShopCSS["storerightmenu_center_item_text2"]}
                      >
                        <span
                          style={{
                            color: "#3AFF89",
                            width: "100%",
                            marginLeft: "5px",
                          }}
                        >
                          $ {value?.price || 0}
                        </span>
                      </div>
                      <div
                        className={ShopCSS["storerightmenu_center_item_remove"]}
                        onClick={() => removeItem(value?.item)}
                      >
                        <img
                          src="../assets/images/clothingstore/remove.svg"
                          alt=""
                        />
                      </div>
                    </div>
                  ))}
                </div>
                <div className={ShopCSS["ConfirmationPart"]}>
                  <div className={ShopCSS["storerightmenu_bottom1"]}>
                    <div className={ShopCSS["storerightmenu_bottom1_text"]}>
                      Total :
                    </div>
                    <div
                      className={ShopCSS["storerightmenu_bottom1_text2"]}
                      id="totalinsert"
                    >
                      $ {price}
                    </div>
                  </div>
                  <div className={ShopCSS["storerightmenu_bottom2"]}>
                    <div
                      onClick={HandleConfirm}
                      className={`${ShopCSS["storerightmenu_bottom2_button1"]} ${ShopCSS["green"]}`}
                    >
                      <div
                        className={
                          ShopCSS["storerightmenu_bottom2_button1_img"]
                        }
                        style={{ marginLeft: "35px" }}
                      >
                        <img
                          src="../assets/images/clothingstore/cash.svg"
                          alt=""
                        />
                      </div>
                      <div
                        className={
                          ShopCSS["storerightmenu_bottom2_button1_text"]
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
        </div>
      </div>
    )
  );
};

export default Shop;
