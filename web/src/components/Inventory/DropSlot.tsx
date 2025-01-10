import React, { useState, useEffect } from "react";
import { DndProvider, useDrag, useDrop } from "react-dnd";

import InventorySCSS from "./../Inventory.module.scss";

const DropSlot: React.FC<{
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
      className={InventorySCSS["slot"]}
      style={{
        background: isOver ? "var(--degrade-linear-bleu)" : "",
      }}
    >
      <div
        className={InventorySCSS["item"]}
        style={{
          backgroundImage: `url(https://sacha-dev.fr/${item.name}.png)`,
        }}
      >
        <div className={InventorySCSS["item-count"]}>{slotKey}</div>
        <div className={InventorySCSS["item-name"]}>{item.label}</div>
        <div className={InventorySCSS["item-name-bg"]}></div>
      </div>
    </div>
  );
};

export default DropSlot;
