import React, { useState, useRef, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import ShopCSS from "./Shop.module.scss";

debugData([
  {
    action: "showShop",
    data: {
      show: true,
      data: {},
    },
  },
]);

const Shop = () => {
  const [openedSHOP, setOpenedSHOP] = useState(false);
  const [dataSHOP, setDataSHOP] = useState<any>({});
  useNuiEvent<any>("showShop", (data2) => {
    //setDataSHOP(data2.data.data);
    setOpenedSHOP(data2.show);
  });

  return openedSHOP && (<div className={ShopCSS['GlobalShop']}>
    <div className={ShopCSS['BackgroundShop']}></div>
  </div>);
};

export default Shop;
