import React from "react";
import { useDrop } from "react-dnd";
import InventorySCSS from "./Inventory.module.scss";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faRotate, faTrash } from "@fortawesome/free-solid-svg-icons";
const DroppableTrade: React.FC<{
  onDrop: (droppedItem: any, itemType: any) => void;
}> = ({ onDrop }) => {
  const [{ isOver }, dropRef] = useDrop(() => ({
    accept: ["ITEM"],
    drop: (item, monitor) => {
      const itemType = monitor.getItemType(); // Récupérer le type de l'élément
      onDrop(item, itemType);
    },
    collect: (monitor) => ({ isOver: monitor.isOver() }),
  }));

  return (


  <div
  ref={dropRef}
  className={InventorySCSS["control2"]}
  style={{
    background: isOver ? "var(--degrade-linear-bleu)" : "",
  }}
  id={InventorySCSS["give"]}
  >
  <FontAwesomeIcon icon={faRotate} />
  </div>
  );
};

export default DroppableTrade;
