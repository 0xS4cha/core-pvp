import React from "react";
import { useDrag } from "react-dnd";
import InventorySCSS from "./Inventory.module.scss";

const DraggableSlot: React.FC<{ item: any }> = ({ item }) => {
  const [{ isDragging }, dragRef] = useDrag(() => ({
    type: "ITEM",
    item,
    collect: (monitor) => ({ isDragging: monitor.isDragging() }),
  }));

  return (
    <div
      ref={dragRef}
      className={InventorySCSS["slot"]}
      style={{ opacity: isDragging ? 0.5 : 1 }}
    >
      <div
        className={InventorySCSS["item"]}
        style={{
          backgroundImage: `url(https://sacha-dev.fr/${item.name}.png)`,
        }}
      >
        <div className={InventorySCSS["item-count"]}>{item.count}</div>
        <div className={InventorySCSS["item-name"]}>{item.label}</div>
      </div>
    </div>
  );
};

export default DraggableSlot;
