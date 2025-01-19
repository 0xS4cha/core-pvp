import React from "react";
import { useDrop } from "react-dnd";
import InventorySCSS from "./Inventory.module.scss";

const DroppableSlot: React.FC<{
  slotKey: string;
  onDrop: (slotKey: string, droppedItem: any, itemType: any) => void;
}> = ({ slotKey, onDrop }) => {
  const [{ isOver }, dropRef] = useDrop(() => ({
    accept: ["ITEM", "LOOT"],
    drop: (item, monitor) => {
      const itemType = monitor.getItemType(); // Récupérer le type de l'élément
      onDrop(slotKey, item, itemType);
    },
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
      
    </div>
  );
};

export default DroppableSlot;
