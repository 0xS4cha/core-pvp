import React, { useState, useEffect } from "react";
import { DndProvider } from "react-dnd";
import { HTML5Backend } from "react-dnd-html5-backend";
import { TouchBackend } from "react-dnd-touch-backend";



import DraggableSlot from "./DraggableSlot";
import DroppableSlot from "./DroppableSlot";
import DroppableSlotFast from "./DroppableSlotFast";
import TradeButton from "./DroppableTrade";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faRotate, faTrash } from "@fortawesome/free-solid-svg-icons";
import { debugData } from "../../utils/debugData";
import { fetchNui } from "../../utils/fetchNui";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import InventorySCSS from "./Inventory.module.scss";

debugData([
  {
    action: "showInventory",
    data: {
      show: true,
      maximumCase: 30,
      secondInventory: true,
      translation: {
        backpack: '2',
      },
      Inventory2: {
        name: "Trunk",
        canLoot: true,
        canTrade: false,
        Items: [
          { label: "Pain", name: "bread", count: 5, slot: 1 },
          { label: "Argent", name: "money", count: 2800, slot: 2 },
          { label: "Eau", name: "water", count: 5, slot: 3 },
          { label: "GPS", name: "gps", count: 1, slot: 4 },
          { label: "Téléphone", name: "phone", count: 1, slot: 11 },
        ],
      },
      inventory: {
        Items: [
          { label: "Pain", name: "bread", count: 5, slot: 1 },
          { label: "Argent", name: "money", count: 2800, slot: 2 },
          { label: "Eau", name: "water", count: 5, slot: 3 },
          { label: "GPS", name: "gps", count: 1, slot: 4 },
          { label: "Téléphone", name: "phone", count: 1, slot: 11 },
        ],
        fastItems: {
          "1": { label: "", name: "", slot: 1 },
          "2": { label: "", name: "", slot: 2 },
          "3": { label: "", name: "", slot: 3 },
          "4": { label: "", name: "", slot: 4 },
        },
      },
    },
  },
]);

const Inventory = () => {
  const [openedInventory, setOpenedInventory] = useState(false);
  const [secondInventory, setSecondInventory] = useState(false);
  const [Quantity, setQuantity] = useState<string>("0");
  const [Translation, setTranslation] = useState<any>({});
  const [dataInventory, setDataInventory] = useState<any>({
    Items: {},
    fastItems: {},
  });
  const [dataInventory2, setDataInventory2] = useState<any>({
    Items: {},
    name: "",
  });
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
        setSecondInventory(event.data.data.secondInventory);
        setDataInventory2(event.data.data.Inventory2);
        setTranslation(event.data.data.translation);
        setDataInventory(event.data.data.inventory);
        setOpenedInventory(event.data.data.show);
      }
    };
    window.addEventListener("message", handleMessage);
    return () => window.removeEventListener("message", handleMessage);
  }, []);

  const handleDrop = (slotKey: string, droppedItem: any, type: any) => {
    setQuantity((prevQuantity) => {
      if (type === "ITEM") {
        fetchNui("dropItem", {
          item: droppedItem,
          slot: slotKey,
          quantity: prevQuantity,
        });
      } else if (type === "LOOT") {
        fetchNui("lootItem", {
          item: droppedItem,
          slot: slotKey,
          quantity: prevQuantity,
        });
      } else if (type === "STORAGE") {
        fetchNui("dropStorage", {
          item: droppedItem,
          slot: slotKey,
          quantity: prevQuantity,
        });
      }
      return prevQuantity; // S'assurer que la dernière valeur est bien utilisée
    });
  };

  const handleTrade = (droppedItem: any, type: any) => {
    setQuantity((prevQuantity) => {
      fetchNui("SendTrade", {
        item: droppedItem,
        quantity: prevQuantity,
      });
      return prevQuantity; 
    });
  }

  const handleDropStorage = (slotKey: string, droppedItem: any, type: any) => {
    setQuantity((prevQuantity) => {
      fetchNui("dropStorage", {
        item: droppedItem,
        slot: slotKey,
        quantity: prevQuantity,
      });
      return prevQuantity; // S'assurer que la dernière valeur est bien utilisée
    });
  };
  const handleUse = (slotKey: string, droppedItem: any) => {
    fetchNui("inventory-use-item", { item: droppedItem, slot: slotKey });
  };
  const handleFastDrop = (slotKey: string, droppedItem: any) => {
    fetchNui("dropFastItem", { item: droppedItem, slot: slotKey });
  };
  const HandleQuantity = (quantity2: string) => {
    setQuantity(quantity2);
  };
  useNuiEvent<any>("updateInventory", (data2) => {
    setDataInventory(data2.inventory);
  });

  useNuiEvent<any>("updateInventory2", (data2) => {
    setDataInventory2(data2.inventory);
  });

  return (
    openedInventory && (
      
      <DndProvider backend={TouchBackend} options={{ enableMouseEvents: true}}>
       
        <div className={InventorySCSS["ui"]}>
          <div className={InventorySCSS["inventory"]}>
            <div id={InventorySCSS["playerInventory"]}>
              {Array.from({ length: 30 }, (_, index) => {
                const matchingItem = Object.values(dataInventory.Items).find(
                  (value: any) => value.slot === index
                );
                return matchingItem ? (

                    <DraggableSlot
                      key={index}
                      itemType="ITEM"
                      item={matchingItem}
                      onContextMenu={handleUse}
                    />


                    
                ) : (
                  <DroppableSlot
                    key={index}
                    slotKey={String(index)}
                    onDrop={handleDrop}
                  />
                );
              })}
            </div>
            <div id={InventorySCSS["playerInventoryFastItems"]}>
              {Object.entries(dataInventory.fastItems).map(([key, value]) => (
                <DroppableSlotFast
                  key={key}
                  slotKey={key}
                  item={value}
                  onDrop={handleFastDrop}
                />
              ))}
            </div>
            <div className={InventorySCSS["controls-div"]}>
              <input
                type="number"
                className={InventorySCSS["control"]}
                id={InventorySCSS["count"]}
                value={Quantity}
                onChange={(e) => HandleQuantity(e.target.value)}
              />
              <TradeButton onDrop={handleTrade} />

              <div
                className={InventorySCSS["control3"]}
                id={InventorySCSS["drop"]}
              >
                <FontAwesomeIcon icon={faTrash} />
              </div>
            </div>
            {secondInventory && (
              <>
                <div id={InventorySCSS["controlstrunk"]}>
                  <div className={InventorySCSS["autourname"]}>
                    {dataInventory2.name}
                  </div>
                </div>
                <div id={InventorySCSS["otherInventory"]}>
                  {Array.from({ length: 30 }, (_, index) => {
                    const matchingItem = Object.values(
                      dataInventory2.Items
                    ).find((value: any) => value.slot === index);
                    return matchingItem ? (
                      <>
                        {dataInventory2.canLoot ? (
                          <DraggableSlot
                            key={index}
                            item={matchingItem}
                            itemType="LOOT"
                          />
                        ) : (
                          <DraggableSlot
                            key={index}
                            item={matchingItem}
                            itemType="NOLOOT"
                          />
                        )}
                      </>
                    ) : (
                      <>
                        {dataInventory2.canTrade ? (
                          <DroppableSlot
                            key={index}
                            slotKey={String(index)}
                            onDrop={handleDropStorage}
                          />
                        ) : (
                          <div className={InventorySCSS["slot"]}></div>
                        )}
                      </>
                    );
                  })}
                </div>
                <div style={{ width: "100%", bottom: "0", top: "auto" }}>
                  <span
                    className={InventorySCSS["info-div2"]}
                    style={{ float: "left" }}
                  ></span>
                  <span
                    className={InventorySCSS["info-div"]}
                    style={{ float: "right" }}
                  ></span>
                </div>
              </>
            )}
          </div>

          <div className={InventorySCSS["raccourci2"]}>
            <div className={InventorySCSS["raccours10"]}>{Translation.backpack}</div>
          </div>
        </div>
      </DndProvider>
    )
  );
};

export default Inventory;
