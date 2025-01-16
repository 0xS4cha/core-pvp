
import React, { useState, useRef, useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import { Divider } from "@mantine/core";

import SquadSCSS from "./Squad.module.scss";

debugData([
    {
      action: "showSquad",
      data: true
    },
]);
const Squad = () => {
    const [opened, setOpened] = useState(false);
    const [dataSelector, setDataSelector] = useState<any>([]);
    const [translation, setTranslation] = useState<any>({});
    const [tab, setTab] = useState<number>(1);

    useEffect(() => {
      const handleMessage = (event: MessageEvent) => {
  
        if (event.data.action === "showSquad") {
          setOpened(event.data);
        }
      };
      window.addEventListener("message", handleMessage);
  
      return () => {
        window.removeEventListener("message", handleMessage);
      };
    });
  
      useEffect(() => {
          const handleKeyDown = (event: any) => {
            if (event.key === "Escape" && opened) {
              fetchNui("spawnSelector:Close")
  
            }
          };
    
          window.addEventListener("keydown", handleKeyDown);
    
          return () => {
            window.removeEventListener("keydown", handleKeyDown);
          };
        
      });
  
    return opened && (
        <>
        <div className={SquadSCSS["gfxsquan-menu-contain"]}>
        <div className={SquadSCSS["gfxsquan-menu-header"]}>
            <div className={SquadSCSS["header-title"]}><p>PUBLIC</p><h1>SQUAD</h1></div>
            <button className={SquadSCSS["header-create"]}><p>+</p></button>
        </div>
        <div className={SquadSCSS["gfxsquan-menu-content"]}>
          
        </div> 
        <div className={SquadSCSS["gfxsquan-squadmenu-content"]}>
            <div className={SquadSCSS["squadmenu-members-contain"]}>
                <div className={SquadSCSS["squadmenu-members-title"]}>
                    <p>SQUAD</p>
                    <h1>MEMBERS</h1>
                </div>
                <div className={SquadSCSS["squadmenu-members"]}>
                    <div className={SquadSCSS["member"]}>
                        <img src="https://cdn.discordapp.com/attachments/804881334438854657/1026324900295753808/peeposnack.png" alt=""/>
                        <div className={SquadSCSS["members-informations"]}>
                            <h1>NITROS</h1>
                            <div className={SquadSCSS["members-progressbars"]}>
                                <div className={SquadSCSS["members-armor-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                                <div className={SquadSCSS["members-hp-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                            </div>
                            <div className={SquadSCSS["buttons-div"]}>
                                <div className={SquadSCSS["button"]}><p>KICK</p></div>
                            </div>
                        </div>
                    </div>
                    <div className={SquadSCSS["member"]}>
                        <img src="https://cdn.discordapp.com/attachments/804881334438854657/1026324900295753808/peeposnack.png" alt=""/>
                        <div className={SquadSCSS["members-informations"]}>
                            <h1>NITROS</h1>
                            <div className={SquadSCSS["members-progressbars"]}>
                                <div className={SquadSCSS["members-armor-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                                <div className={SquadSCSS["members-hp-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                            </div>
                            <div className={SquadSCSS["buttons-div"]}>
                                <div className={SquadSCSS["button"]}><p>KICK</p></div>
                            </div>
                        </div>
                    </div>
                    <div className={SquadSCSS["member"]}>
                        <img src="https://cdn.discordapp.com/attachments/804881334438854657/1026324900295753808/peeposnack.png" alt=""/>
                        <div className={SquadSCSS["members-informations"]}>
                            <h1>NITROS</h1>
                            <div className={SquadSCSS["members-progressbars"]}>
                                <div className={SquadSCSS["members-armor-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                                <div className={SquadSCSS["members-hp-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                            </div>
                            <div className={SquadSCSS["buttons-div"]}>
                                <div className={SquadSCSS["button"]}><p>KICK</p></div>
                            </div>
                        </div>
                    </div>
                    <div className={SquadSCSS["member"]}>
                        <img src="https://cdn.discordapp.com/attachments/804881334438854657/1026324900295753808/peeposnack.png" alt=""/>
                        <div className={SquadSCSS["members-informations"]}>
                            <h1>NITROS</h1>
                            <div className={SquadSCSS["members-progressbars"]}>
                                <div className={SquadSCSS["members-armor-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                                <div className={SquadSCSS["members-hp-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                            </div>
                            <div className={SquadSCSS["buttons-div"]}>
                                <div className={SquadSCSS["button"]}><p>KICK</p></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div style={{marginTop: '.8vh !important'}} className={SquadSCSS["squadmenu-members-contain"]}>
                <div className={SquadSCSS["squadmenu-members-title"]}>
                    <p>SQUAD</p>
                    <h1>SETTINGS</h1>
                </div>
                <div className={SquadSCSS["squadmenu-setting"]}>
                    <div className={SquadSCSS["setting"]}>
                        <div className={SquadSCSS["setting-info"]}>
                            <h1>SQUAD HUD</h1>
                            <p>Show/Hide squad hud</p>
                        </div>
                        <div className={SquadSCSS["setting-check"]}>
                            <label className={SquadSCSS["toggleSwitch nolabel"]}>
								<input type="checkbox" id="hudVar" checked/>
								<span>
								</span>
								<a></a>
							</label>
                        </div>
                    </div>
                    <div className={SquadSCSS["setting"]}>
                        <div className={SquadSCSS["setting-info"]}>
                            <h1>PRIVATE</h1>
                            <p>Set squad private/public</p>
                        </div>
                        <div className={SquadSCSS["setting-check"]}>
                            <label className={SquadSCSS["toggleSwitch nolabel"]}>
								<input type="checkbox" id="private" />
								<span>
								</span>
								<a></a>
							</label>
                        </div>
                    </div>
                    <div className={SquadSCSS["setting"]}>
                        <div className={SquadSCSS["setting-info"]}>
                            <h1>YOUR SQUAD</h1>
                            <p>You can delete your squad</p>
                        </div>
                        <button id="disband" className={SquadSCSS["setting-button"]}><p>DISBAND</p></button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div className={SquadSCSS["gfxsquad"]}>
        <div className={SquadSCSS["squad-member"]}>
            <img src="https://cdn.discordapp.com/attachments/804881334438854657/1026324900295753808/peeposnack.png" alt=""/>
                <div className={SquadSCSS["members-informations"]}>
                    <h1>NITROS</h1>
                    <div className={SquadSCSS["members-progressbars"]}>
                        <div className={SquadSCSS["members-armor-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                        <div className={SquadSCSS["members-hp-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                    </div>
                </div>
        </div>
        <div className={SquadSCSS["squad-member"]}>
            <img src="https://cdn.discordapp.com/attachments/804881334438854657/1026324900295753808/peeposnack.png" alt=""/>
                <div className={SquadSCSS["members-informations"]}>
                    <h1>NITROSdasasddassdadsasda</h1>
                    <div className={SquadSCSS["members-progressbars"]}>
                        <div className={SquadSCSS["members-armor-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                        <div className={SquadSCSS["members-hp-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                    </div>
                </div>
        </div>
        <div className={SquadSCSS["squad-member"]}>
            <img src="https://cdn.discordapp.com/attachments/804881334438854657/1026324900295753808/peeposnack.png" alt=""/>
                <div className={SquadSCSS["members-informations"]}>
                    <h1>fds</h1>
                    <div className={SquadSCSS["members-progressbars"]}>
                        <div className={SquadSCSS["members-armor-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                        <div className={SquadSCSS["members-hp-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                    </div>
                </div>
        </div>
        <div className={SquadSCSS["squad-member"]}>
            <img src="https://cdn.discordapp.com/attachments/804881334438854657/1026324900295753808/peeposnack.png" alt=""/>
                <div className={SquadSCSS["members-informations"]}>
                    <h1>NITROSdasasddassdadsasda</h1>
                    <div className={SquadSCSS["members-progressbars"]}>
                        <div className={SquadSCSS["members-armor-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                        <div className={SquadSCSS["members-hp-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                    </div>
                </div>
        </div>
        
        <div className={SquadSCSS["squad-member"]}>
            <img src="https://cdn.discordapp.com/attachments/804881334438854657/1026324900295753808/peeposnack.png" alt=""/>
                <div className={SquadSCSS["members-informations"]}>
                    <h1>NITROS</h1>
                    <div className={SquadSCSS["members-progressbars"]}>
                        <div className={SquadSCSS["members-armor-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                        <div className={SquadSCSS["members-hp-bar"]}><div className={SquadSCSS["fill"]}></div></div>
                    </div>
                </div>
        </div>
    </div>
    </>
    )
  };
  
  export default Squad;
  