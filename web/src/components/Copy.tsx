import React, { useState, useRef, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";


const Copy = () => {
    const copyToClipboardFallback = (text: string) => {
        const textArea = document.createElement("textarea");
        textArea.value = text;
      
        // Rendre le textarea invisible
        textArea.style.position = "absolute";
        textArea.style.left = "-9999px";
      
        document.body.appendChild(textArea);
        textArea.select();
      
        try {
          const successful = document.execCommand("copy");
          if (successful) {
            console.log(text);
          } else {
            console.error(text);
          }
        } catch (err) {
          console.error(text, err);
        }
      
        document.body.removeChild(textArea);
      };

   useEffect(() => {
     const handleMessage = (event: MessageEvent) => {
       const data = event.data;
       if (data.action === "requestToCopy") {
        copyToClipboardFallback(data.data);
       }
     };
     window.addEventListener("message", handleMessage);
 
     return () => {
       window.removeEventListener("message", handleMessage);
     };
   });
return (<></>);
};

export default Copy;
