import React, { useEffect, useState } from "react";
import clothingStore from "./../ClothingStore.module.scss";
type ClothingItemProps = {
  data: Record<
    string,
    {
      label: string;
      max: number;
      defaultprice: number;
      customprice: Record<number, number>;
      blacklist: number[];
    }
  >;
  gender: string;
  activeTab: string;
  clotheTypeIndex: Record<string, string>;
  onPurchase: (type: string, id: number, price: number) => void;

};

const PaginatedClothingItems: React.FC<ClothingItemProps> = ({
  data,
  gender,
  activeTab,
  clotheTypeIndex,
  onPurchase,
 
}) => {
  const [visibleItems, setVisibleItems] = useState<number[]>([]);
  const [page, setPage] = useState(1);
  const itemsPerPage = 20;

  const maxItems = data[activeTab]?.max ?? 0;

  useEffect(() => {
    const loadItems = () => {
      const nextItems = Array.from(
        { length: maxItems },
        (_, i) => i + 1
      ).slice(0, page * itemsPerPage);
      setVisibleItems(nextItems);
    };
    loadItems();

  }, [page, activeTab, maxItems]);

  const handleScroll = () => {
    if (

      window.innerHeight + document.documentElement.scrollTop !==
      document.documentElement.offsetHeight
    )
      return;
    setPage((prevPage) => prevPage + 1);
  };

  useEffect(() => {
    window.addEventListener("wheel", handleScroll);
    return () => window.removeEventListener("wheel", handleScroll);
  }, []);

  return (
    <div className={clothingStore["storeleftmenuclothingpart"]}>
      {visibleItems.map((index) =>

          <div
            key={index}
            className={clothingStore["storeleftmenuclothingpart_item"]}
            onClick={() =>
              onPurchase(
                activeTab,
                index,
                data[activeTab].customprice[index] ??
                  data[activeTab].defaultprice
              )
            }
          >
            <div className={clothingStore["storeleftmenuclothingpart_item_img"]}>
              <img className={clothingStore["storeleftmenu_mmenu_ngfdgfd"]}
                src={`../assets/images/clothing/${gender}_${clotheTypeIndex[activeTab]}_${index}.png.webp`}
                alt={`Item ${index}`}
              />
            </div>
            <div className={clothingStore["storeleftmenuclothingpart_item_text"]}>
              {data[activeTab].label} #{index}
            </div>
            <div className={clothingStore["storeleftmenuclothingpart_item_bottom"]}>
              <div className={clothingStore["storeleftmenuclothingpart_item_bottom_1"]}>
                <div className={clothingStore["storeleftmenuprice"]}>
                  $ {data[activeTab].customprice[index] ?? data[activeTab].defaultprice}
                </div>
              </div>
            </div>
          </div>

      )}
    </div>
  );
};

export default PaginatedClothingItems;
