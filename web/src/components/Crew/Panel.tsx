import React, { useState, useEffect, useRef } from "react";
import {
  Avatar,
  Tabs,
  useMantineTheme,
  Text,
  Flex,
  ActionIcon,
  Tooltip,
} from "@mantine/core";
import {
  IconPhoto,
  IconCode,
  IconTerminal,
  IconCreativeCommons,
  IconDeviceFloppy,
  IconBox,
  IconDashboard,
  IconArrowBack,
  IconBan,
  IconHelp,
  IconHelpHexagon,
} from "@tabler/icons-react";

import Dashboard from "./dashboard";
import Memberslist from "./memberslist";
import Ranklist from "./ranklist";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { fetchNui } from "../../utils/fetchNui";

interface ScoreboardProps {
  visible: boolean;
  playersData: any;
  deaths: any;
  kills: any;
  ranksId: any;
  ranks: any;
  permission: any;
  PlayerLogo: any;
  CrewName: any;
  playerName: any;
}

interface TabItem {
  value: string;
  label: string;
  icon: React.ReactNode;
  disabled: boolean;
}

const Scoreboard: React.FC<ScoreboardProps> = ({
  visible,
  playersData,
  deaths,
  kills,
  ranksId,
  ranks,
  permission,
  PlayerLogo,
  CrewName,
  playerName,
}) => {
  const [activeTab, setActiveTab] = useState<string>("dashboard");
  const [isTabsVisible, setIsTabsVisible] = useState<boolean>(true);
  const [shouldRenderContent, setShouldRenderContent] = useState<boolean>(true);

  const theme = useMantineTheme();
  const previousTab = useRef<string>(activeTab);

  useEffect(() => {
    if (!visible) {
      setShouldRenderContent(false);
      setIsTabsVisible(false);
      setActiveTab("dashboard");
    } else {
      setShouldRenderContent(true);
      setIsTabsVisible(true);
    }
  }, [visible]);

  useEffect(() => {
    if (previousTab.current === "rapidAction" && activeTab !== "rapidAction") {
      fetchNui("LGF_ToolDebug.NUI.activeTabDebugger", { entered: false });
      setIsTabsVisible(false);
      setTimeout(() => {
        setIsTabsVisible(true);
        setShouldRenderContent(true);
      }, 500);
    }

    if (activeTab === "rapidAction") {
      fetchNui("LGF_ToolDebug.NUI.activeTabDebugger", { entered: true });
      setShouldRenderContent(false);
    }

    previousTab.current = activeTab;
  }, [activeTab]);
  /*
  const tabsData: TabItem[] = [
    {
      value: "dashboard",
      label: "Dashboard",
      icon: <IconDashboard size="1rem" />,
      disabled: !pagesAllowed.dashboard, 
    },
    {
      value: "entitySpawner",
      label: "Entity Spawner",
      icon: <IconCreativeCommons size="1rem" />,
      disabled: !pagesAllowed.entitySpawner,
    },
    {
      value: "executor",
      label: "Code Runner",
      icon: <IconTerminal size="1rem" />,
      disabled: !pagesAllowed.executor, 
    },
    {
      value: "resourceManager",
      label: "Resource Manager",
      icon: <IconDeviceFloppy size="1rem" />,
      disabled: !pagesAllowed.resourceManager, 
    },
    {
      value: "inventory",
      label: "Inventory",
      icon: <IconBox size="1rem" />,
      disabled: !pagesAllowed.inventory,
    },
    {
      value: "rapidAction",
      label: "Entity Debug",
      icon: <IconCode size="1rem" />,
      disabled: !pagesAllowed.rapidAction, 
    },
    {
      value: "mapWorld",
      label: "Map World",
      icon: <IconPhoto size="1rem" />,
      disabled: !pagesAllowed.mapWorld,
    },
    {
      value: "help",
      label: "Help",
      icon: <IconHelpHexagon size="1rem" />,
      disabled: !pagesAllowed.help,
    },
  ];

*/
  const tabsData: TabItem[] = [
    {
      value: "dashboard",
      label: "Dashboard",
      icon: <IconDashboard size="1rem" />,
      disabled: false,
    },
    {
      value: "memberslist",
      label: "Members List",
      icon: <IconDashboard size="1rem" />,
      disabled: false,
    },
    {
      value: "rankslist",
      label: "Ranks list",
      icon: <IconDashboard size="1rem" />,
      disabled: false,
    },
  ];
  const menuWidth = activeTab === "rapidAction" ? "500px" : "1450px";
  const menuLeft = activeTab === "rapidAction" ? `15%` : "50%";

  return (
    <div
      className={`container ${visible ? "slide-in" : "slide-out"}`}
      style={{
        width: menuWidth,
        opacity: visible ? 1 : 0,
        transition:
          "width 1.3s ease, opacity 0.4s ease, left 1.3s ease, height 1.3s ease",
        left: menuLeft,
        height: activeTab === "rapidAction" ? "400px" : "810px",
      }}
    >
      {activeTab === "rapidAction" && (
        <Tooltip
          withinPortal
          color="dark"
          radius="md"
          label="Back to Dashboard"
          position="bottom"
        >
          <ActionIcon
            onClick={() => setActiveTab("dashboard")}
            variant="light"
            style={{
              border: "3px solid rgba(255, 255, 255, 0.2)",
              backgroundColor: "rgba(55, 65, 81, 0.85)",
              position: "absolute",
              top: "10px",
              right: "10px",
            }}
            color="teal"
            size={40}
            radius="md"
          >
            <IconArrowBack size={23} />
          </ActionIcon>
        </Tooltip>
      )}

      {activeTab !== "rapidAction" && (
        <div className="sidebar left">
          <Flex
            gap="xs"
            justify="center"
            align="center"
            direction="row"
            wrap="wrap"
          >
            <Avatar
              src={PlayerLogo}
              radius="sm"
              size={50}
              mb={4}
              style={{
                border: "2px solid rgba(255, 255, 255, 0.2)",
              }}
            />
            <Flex
              justify="flex-start"
              align="flex-start"
              direction="column"
              wrap="wrap"
            >
              <Text color="white" size="xs" weight={600}>
                {CrewName}
              </Text>
              <Text color="dimmed" size="xs">
                {playerName}
              </Text>
            </Flex>
          </Flex>

          {shouldRenderContent && isTabsVisible && (
            <Tabs
              orientation="vertical"
              value={activeTab}
              variant="none"
              color="gray" //@ts-ignore
              onTabChange={setActiveTab}
              defaultValue="executor"
              styles={{
                tab: {
                  marginTop: 10,
                  borderRadius: "4px",
                  padding: "15px 15px",
                  background: "var(--degrade-radial-sombre2)",
                  color: "white",

                  transition: "background-color 0.3s ease",
                  "&:hover": {
                    background: "var(--degrade-linear-bleu-full)",
                    cursor: "pointer",
                  },
                  "&[data-active]": {
                    background: "var(--degrade-linear-bleu-full)",
                    color: theme.white,
                  },
                },
              }}
            >
              <Tabs.List>
                {tabsData.map((tab) => (
                  <Tabs.Tab
                    disabled={tab.disabled}
                    key={tab.value}
                    value={tab.value}
                    icon={tab.disabled ? <IconBan size={23} /> : tab.icon}
                  >
                    {tab.disabled ? "Access Denied" : tab.label}
                  </Tabs.Tab>
                ))}
              </Tabs.List>
            </Tabs>
          )}
        </div>
      )}

      <div className="tab-content">
        {activeTab === "memberslist" && (
          <Memberslist
            permission={permission}
            ranksData={ranks}
            ranksInformation={ranksId}
            playersList={playersData}
          />
        )}
        {activeTab === "rankslist" && (
          <Ranklist ranksData={ranks} ranksInformation={ranksId} permission={permission} />
        )}
        {shouldRenderContent && activeTab === "dashboard" && (
          <Dashboard
            ranksData={ranks}
            ranksInformation={ranksId}
            playersList={playersData}
            deaths={deaths}
            kills={kills}
          />
        )}
      </div>
    </div>
  );
};

export default Scoreboard;
