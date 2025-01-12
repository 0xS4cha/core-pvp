import React, { useState, useEffect } from "react";
import { DndProvider } from "react-dnd";
import { HTML5Backend } from "react-dnd-html5-backend";
import { TouchBackend } from "react-dnd-touch-backend";
import DraggableSlot from "./DraggableSlot";
import DroppableSlot from "./DroppableSlot";
import DroppableSlotFast from "./DroppableSlotFast";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
    faRotate,
    faTrash,
  } from "@fortawesome/free-solid-svg-icons";
import { debugData } from "../../utils/debugData";
import { fetchNui } from "../../utils/fetchNui";
import InventorySCSS from "./Inventory.module.scss";

/*
debugData([
    {
      action: "showInventory",
      data: {
        show: true,
        maximumCase: 30,
        inventory: {
        Items: [
            { label: "Pain", name: "bread", count: 5, slot: 1 },
            { label: "Argent", name: "money", count: 2800, slot: 2},
            { label: "Eau", name: "water", count: 5, slot: 3 },
            { label: "GPS", name: "gps", count: 1, slot: 4 },
            { label: "Téléphone", name: "phone", count: 1, slot: 11 },
     
     
         ],
         fastItems: {
           "1": { label: "", name: "", slot: 1 },
           "2": { label: "", name: "", slot: 2 },
           "3": { label: "", name: "",  slot: 3 },
           "4": { label: "", name: "", slot: 4 },
     
         },
        },
        },
    },
]);*/

const Inventory = () => {
  const [openedInventory, setOpenedInventory] = useState(false);
  const [dataInventory, setDataInventory] = useState<any>({ Items: {}, fastItems: {} });
  const [visibleItems, setVisibleItems] = useState<number[]>([]);
  const [page, setPage] = useState(1);

  useEffect(() => {
    const handleKeyPress = (event: KeyboardEvent) => {
      if (["Escape", "Tab"].includes(event.key) && openedInventory) {
        fetchNui("closeInventory");
      }
    };
    window.addEventListener("keydown", handleKeyPress);
    return () => window.removeEventListener("keydown", handleKeyPress);
  }, [openedInventory]);

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      if (event.data.action === "showInventory") {
        setDataInventory(event.data.data.inventory);
        setOpenedInventory(event.data.data.show);
      }
    };
    window.addEventListener("message", handleMessage);
    return () => window.removeEventListener("message", handleMessage);
  }, []);

  const handleDrop = (slotKey: string, droppedItem: any) => {
    fetchNui("dropItem", { item: droppedItem, slot: slotKey });
  };

  const itemsPerPage = 20;
  const maxItems = 30;

  useEffect(() => {
    const loadItems = () => {
      const nextItems = Array.from({ length: maxItems }, (_, i) => i + 1).slice(0, page * itemsPerPage);
      setVisibleItems(nextItems);
    };
    loadItems();
  }, [page, maxItems]);

  const handleScroll = () => {
    if (window.innerHeight + document.documentElement.scrollTop === document.documentElement.offsetHeight) {
      setPage((prevPage) => prevPage + 1);
    }
  };

  useEffect(() => {
    window.addEventListener("wheel", handleScroll);
    return () => window.removeEventListener("wheel", handleScroll);
  }, []);

  return (
    openedInventory && (
        <DndProvider backend={TouchBackend} options={{ enableMouseEvents: true }}>
        <div className={InventorySCSS["ui"]}>
        <div className={InventorySCSS["inventory"]}>
        <div id={InventorySCSS["weight"]} className={InventorySCSS["text-xs self-end"]}></div>
            <div id={InventorySCSS["playerInventory"]}>
              {visibleItems.map((index) => {
                const matchingItem = Object.values(dataInventory.Items).find((value: any) => value.slot === index);
                return matchingItem ? (
                  <DraggableSlot key={index} item={matchingItem} />
                ) : (
                  <DroppableSlot key={index} slotKey={String(index)} onDrop={handleDrop} />
                );
              })}
            </div>
            <div id={InventorySCSS["playerInventoryFastItems"]}>
              {Object.entries(dataInventory.fastItems).map(([key, value]) => (
                <DroppableSlotFast key={key} slotKey={key} item={value} onDrop={handleDrop} />
              ))}
                              </div>
                <div className={InventorySCSS["controls-div"]}>
                    <input type="number" className={InventorySCSS["control"]} id={InventorySCSS["count"]} value="1"/>
                    <div className={InventorySCSS["control2"]} id={InventorySCSS["give"]}>
                        <FontAwesomeIcon icon={faRotate}/>
                    </div>
                    <div className={InventorySCSS["control3"]} id={InventorySCSS["drop"]}>
                        <FontAwesomeIcon icon={faTrash}/>
                    </div>
                </div>
                <div id={InventorySCSS["controlstrunk"]}>
                    <div className={InventorySCSS["autourname"]}>Autour</div>
                    <div className={InventorySCSS["weighttrunk-div"]}></div>
                    <div className={InventorySCSS["controlstrunk-div"]}>
                        <div id={InventorySCSS["controlrename"]}>
                        </div>
                    </div >
                    
                </div>
    
                
                <div id={InventorySCSS["otherInventory"]}>
                    <div id={InventorySCSS["noSecondInventoryMessage"]}>
                    </div>
                </div>
                <div style={{width: "100%", bottom: "0", top: "auto"}}>
                    
                    <span className={InventorySCSS["info-div2"]} style={{float: "left"}}></span>
                    <span className={InventorySCSS["info-div"]} style={{float: "right"}}></span>
                </div>
    
            </div>
            <div className={InventorySCSS["raccourci2"]}>   
                <div className={InventorySCSS["raccours10"]}>Sac à dos</div>
            </div>
        </div>
        <div className={InventorySCSS["cloth-inv"]}>
        <div className={InventorySCSS["cloth-items"]}>
            <div id={InventorySCSS["hat"]} className={InventorySCSS["item-box"]}>
                <img src="../assets/images/inventaire/hat-cowboy-side-solid.svg"></img>
            </div>
            <div id={InventorySCSS["vest"]} className={InventorySCSS["item-box"]}>
            <img src="../assets/images/inventaire/vest-solid.svg"></img>
    
    
            </div>
            <div id={InventorySCSS["pants"]} className={InventorySCSS["item-box"]}>
                <img src="../assets/images/inventaire/pant.png"></img>
            </div>
            <div id={InventorySCSS["bag"]} className={InventorySCSS["item-box"]}>
                <img src="../assets/images/inventaire/bag.png"></img>
            </div>
        </div>
    </div>
    <div className={InventorySCSS["cloth-inv"]}>
        <div className={InventorySCSS["cloth-items2"]}>
            <div id={InventorySCSS["mask"]} className={InventorySCSS["item-box2"]}>
                <img src="../assets/images/inventaire/mask.png"></img>
            </div>
            <div id={InventorySCSS["glasses"]} className={InventorySCSS["item-box2"]}>
                <img src="../assets/images/inventaire/glasses.png"></img>
            </div>
            <div id={InventorySCSS["shirt"]} className={InventorySCSS["item-box2"]}>
                <img src="../assets/images/inventaire/shirt-solid.svg"></img>
            </div>
            <div id={InventorySCSS["shoes"]} className={InventorySCSS["item-box2"]}>
                <img src="../assets/images/inventaire/shoes.png"></img>
            </div>
        </div>
    </div>
      

      </DndProvider>
    )
  );
};

export default Inventory;
