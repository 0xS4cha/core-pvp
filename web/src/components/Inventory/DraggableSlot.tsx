import React, { useState, useEffect } from "react";
import { DndProvider, useDrag, useDrop } from "react-dnd";
import { HTML5Backend } from "react-dnd-html5-backend";
import { TouchBackend } from "react-dnd-touch-backend";
import InventorySCSS from "./../Inventory.module.scss";

const DraggableSlot: React.FC<{ item: any }> = ({ item }) => {
  const [{ isDragging }, dragRef] = useDrag(() => ({
    type: "ITEM",
    item,
    collect: (monitor) => ({
      isDragging: monitor.isDragging(),
    }),
  }));

  return (
    <div
      ref={dragRef}
      className={InventorySCSS["slot"]}
      style={{
        opacity: isDragging ? 0.5 : 1,
      }}
    >
      <div
        className={InventorySCSS["item"]}
        style={{
          backgroundImage: `url(https://sacha-dev.fr/${item.name}.png)`,
        }}
      >
        <div className={InventorySCSS["item-count"]}>{item.count}</div>
        <div className={InventorySCSS["item-name"]}>{item.label}</div>
        <div className={InventorySCSS["item-name-bg"]}></div>
      </div>
    </div>
  );
};

export default DraggableSlot;
