import React, { useState, useEffect } from "react";
import { DndProvider, useDrag, useDrop } from "react-dnd";
import { HTML5Backend } from "react-dnd-html5-backend";
import { TouchBackend } from "react-dnd-touch-backend";
import InventorySCSS from "./../Inventory.module.scss";

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
      <div
        className={InventorySCSS["item"]}
        style={{
          backgroundImage: `url(https://sacha-dev.fr/${item.name}.png)`,
        }}
      >
        <div className={InventorySCSS["keybind"]}>{slotKey}</div>
        <div className={InventorySCSS["item-count"]}>{item.count}</div>
        <div className={InventorySCSS["item-name"]}>{item.label}</div>
      </div>
    </div>
  );
};

export default DroppableSlotFast;
