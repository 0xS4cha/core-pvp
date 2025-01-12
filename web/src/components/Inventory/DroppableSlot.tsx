import React from "react";
import { useDrop } from "react-dnd";
import InventorySCSS from "./Inventory.module.scss";

const DroppableSlot: React.FC<{
  slotKey: string;
  onDrop: (slotKey: string, droppedItem: any) => void;
}> = ({ slotKey, onDrop }) => {
  const [{ isOver }, dropRef] = useDrop(() => ({
    accept: "ITEM",
    drop: (item) => onDrop(slotKey, item),
    collect: (monitor) => ({ isOver: monitor.isOver() }),
  }));

  return (
    <div
      ref={dropRef}
      className={InventorySCSS["slot"]}
      style={{
        background: isOver ? "var(--degrade-linear-bleu)" : "",
      }}
    >
      <div className={InventorySCSS["item-placeholder"]}>Slot {slotKey}</div>
    </div>
  );
};

export default DroppableSlot;
