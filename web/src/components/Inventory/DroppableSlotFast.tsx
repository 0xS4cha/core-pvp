import React from "react";
import { useDrop } from "react-dnd";
import InventorySCSS from "./Inventory.module.scss";

const DroppableSlotFast: React.FC<{
  slotKey: string;
  item: any;
  onDrop: (slotKey: string, droppedItem: any) => void;
}> = ({ slotKey, item, onDrop }) => {
  const [{ isOver }, dropRef] = useDrop(() => ({
    accept: "ITEM",
    drop: (droppedItem) => onDrop(slotKey, droppedItem),
    collect: (monitor) => ({
      isOver: monitor.isOver(),
    }),
  }));

  return (
    <div
      ref={dropRef}
      className={InventorySCSS["slotFast"]}
      style={{
        background: isOver ? "var(--degrade-linear-vert2)" : "",
      }}
    >
      {item.name ? (
        <div
          className={InventorySCSS["item"]}
          style={{
            backgroundImage: `url(../assets/images/inventaire/${item.name}.png.webp)`,
          }}
        >
          <div className={InventorySCSS["keybind"]}>{slotKey}</div>
          <div className={InventorySCSS["item-count"]}>{item.count}</div>
          <div className={InventorySCSS["item-name"]}>{item.label}</div>
        </div>
      ) : (
        <div className={InventorySCSS["placeholder"]}>Slot {slotKey}</div>
      )}
    </div>
  );
};

export default DroppableSlotFast;
