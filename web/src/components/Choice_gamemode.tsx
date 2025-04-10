import React, { useState, useCallback, useMemo } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { debugData } from "../utils/debugData";
import scss from "./Choice_gamemode.module.css";

import ShinyText from "./Utils/ShinyText";
import Squares from "./Utils/Squares";
import FadeContent from "./Utils/FadeContent";
import Carousel from "./Utils/Carousel";
import { VscHome, VscError, VscLock } from "react-icons/vsc";
import Dock from "./Utils/Dock";

type GameInstance = {
  Name: string;
  instanceId: number;
  image: string;
};

type GameMode = {
  id: number;
  name: string;
  matchmaking: boolean;
  image: string;
  instance?: Record<number, GameInstance>;
};

type PlayerData = {
  permid: number;
  tempid: number;
  name: string;
  canClose: boolean;
  pfp: string;
  games: Record<string, GameMode>;
};

debugData([
  {
    action: "showLobbySelector",
    data: {
      show: true,
      data: {
        canClose: false,
        permid: 1,
        tempid: 2,
        name: "Sxcha",
        pfp: "pfp",
        games: {
          1: {
            id: 1,
            name: "Freeroam",
            matchmaking: false,
            instance: {
              1: { Name: "Friendly", instanceId: 10, image: "Image-Friendly" },
              2: { Name: "No rules", instanceId: 12, image: "Image-Armes" },
            },
            image: "Image-Freeroam",
          },
          2: {
            id: 2,
            name: "Gunfight",
            matchmaking: true,
            image: "Image-Gunfight",
          },
          3: { id: 3, name: "Drop", matchmaking: true, image: "Image-Drop" },
          4: {
            id: 4,
            name: "Course poursuite",
            matchmaking: true,
            image: "Image-Course-Poursuite",
          },
        },
      },
    },
  },
]);

const Lobbymenu: React.FC = () => {
  const [opened, setOpened] = useState<boolean>(false);
  const [data, setData] = useState<PlayerData | null>(null);
  const [isModalOpen, setIsModalOpen] = useState<boolean>(false);
  const [isMatchmakingModalOpen, setIsMatchmakingModalOpen] =
    useState<boolean>(false);
  const [isMatchmaking, setIsMatchmaking] = useState<boolean>(false);
  const [selectedGame, setSelectedGame] = useState<GameMode | null>(null);
  const [selectedGameId, setSelectedGameId] = useState<string>("");

  const defaultItems = useMemo(
    () => [
      {
        icon: <VscError size={18} />,
        label: "Quitter",
        onClick: () => fetchNui("lobbyselector_quit"),
      },
    ],
    []
  );

  const [items, setItems] = useState(defaultItems);

  const handleLobbySelector = useCallback(
    (eventData: { show: boolean; data: PlayerData }) => {
      setIsModalOpen(false);
      setIsMatchmakingModalOpen(false);
      setItems(
        eventData.data.canClose
          ? [
              {
                icon: <VscHome size={18} />,
                label: "Fermer",
                onClick: () => fetchNui("lobbyselector_close"),
              },
              ...defaultItems,
            ]
          : defaultItems
      );
      setData(eventData.data);
      setOpened(eventData.show);
    },
    [defaultItems]
  );

  useNuiEvent("showLobbySelector", handleLobbySelector);

  const handleGameSelection = useCallback(
    (index: string) => {
      if (!data?.games[index]) return;
      const game = data.games[index];

      if (game.matchmaking) {
        setSelectedGame(game);
        setSelectedGameId(index);
        setIsMatchmakingModalOpen(true);
        return;
      }

      if (
        !game.matchmaking &&
        game.instance &&
        Object.keys(game.instance).length > 1
      ) {
        setSelectedGame(game);
        setSelectedGameId(index);
        setIsModalOpen(true);
        return;
      }

      fetchNui("lobbyselector_games", {
        game: index,
        type: !game.matchmaking && game.instance ? 1 : undefined,
      });
    },
    [data]
  );
  const handleMatchmakingScreen = useCallback(() => {
    setSelectedGame(null);
    setSelectedGameId("");
    setIsModalOpen(false);
    setIsMatchmaking(true);
  }, []);

  useNuiEvent("showMatchmakingScreen", handleMatchmakingScreen);

  const handleMatchmakingCancel = useCallback(() => {
    fetchNui("lobbyselector_stop_matchmaking");
    setIsMatchmaking(false);
  }, []);

  const handleModalClose = useCallback(() => {
    setSelectedGame(null);
    setSelectedGameId("");
    setIsModalOpen(false);
    setIsMatchmakingModalOpen(false);
  }, []);

  if (!opened) return null;

  return (
    <div className={scss["global"]}>
      <div className={scss["background"]} />
      {/*
      <Squares
        speed={0.5}
        squareSize={10}
        direction="diagonal"
        borderColor="#423700"
        hoverFillColor="#ffd607"
      />*/}
      {isMatchmaking && (
        <div className={scss["modal-overlay"]}>
          <FadeContent
            blur={false}
            duration={200}
            easing="ease-out"
            className={scss["modal-content"]}
            initialOpacity={0}
          >
            <h2>Matchmaking en cours...</h2>
            <button
              className={scss["modal-close"]}
              onClick={handleMatchmakingCancel}
            >
              ANNULER
            </button>
          </FadeContent>
        </div>
      )}
      {isModalOpen && selectedGame && (
        <div className={scss["modal-overlay"]}>
          <FadeContent
            blur={false}
            duration={200}
            easing="ease-out"
            className={scss["modal-content"]}
            initialOpacity={0}
          >
            <h2>Choix du mode</h2>
            <div className={scss["modal-gamelist"]}>
              {selectedGame.instance &&
                Object.entries(selectedGame.instance).map(([key, value]) => (
                  <div className={scss["modal-image"]} key={key}>
                    <img
                      src={`../assets/images/games/${value.image}.webp`}
                      alt=""
                      onClick={() =>
                        fetchNui("lobbyselector_games", {
                          game: selectedGameId,
                          type: key,
                        })
                      }
                    />
                  </div>
                ))}
            </div>
            <button className={scss["modal-close"]} onClick={handleModalClose}>
              FERMER
            </button>
          </FadeContent>
        </div>
      )}

      {isMatchmakingModalOpen && selectedGame && (
        <div className={scss["modal-overlay"]}>
          <FadeContent
            blur={false}
            duration={200}
            easing="ease-out"
            className={scss["modal-content"]}
            initialOpacity={0}
          >
            <h2>Matchmaking</h2>
            <div className={scss["modal-gamelist"]}>
              <div className={scss["modal-image"]}>
                <img
                  src={`../assets/images/games/${selectedGame.image}.webp`}
                  alt=""
                  onClick={() =>
                    fetchNui("lobbyselector_games", { game: selectedGameId })
                  }
                />
              </div>
              <div className={`${scss["modal-image"]} ${scss["locked"]}`}>
                <img
                  src={`../assets/images/games/${selectedGame.image}.webp`}
                  alt=""
                />
                <div className={scss["diagonal-lines"]}>
                  <div className={scss["line"]} />
                  <div className={scss["line"]} />
                </div>
                <div className={scss["lock-icon"]}>
                  <VscLock size={48} />
                </div>
              </div>
            </div>
            <button className={scss["modal-close"]} onClick={handleModalClose}>
              FERMER
            </button>
          </FadeContent>
        </div>
      )}

      <div
        className={scss["menu"]}
        id="glassmorphism"
        >
        <div className={scss["news"]}>
          {data && (
            <div className={scss["playersInformation"]}>
              <div className={scss["imageContainer"]}>
                <img src={data.pfp} alt="Joueur" />
              </div>
              <div className={scss["textContainer"]}>
                <div>
                  <p>Pseudonyme :</p>
                  <ShinyText
                    text={data.name}
                    disabled={false}
                    speed={3}
                    className="custom-class"
                  />
                </div>
                <div>
                  <p>ID joueur :</p>
                  <ShinyText
                    text={data.permid.toString()}
                    disabled={false}
                    speed={3}
                    className="custom-class"
                  />
                </div>
                <div>
                  <p>ID server :</p>
                  <ShinyText
                    text={data.tempid.toString()}
                    disabled={false}
                    speed={3}
                    className="custom-class"
                  />
                </div>
              </div>
            </div>
          )}
          <Carousel
            baseWidth={500}
            autoplay={true}
            autoplayDelay={10000}
            pauseOnHover={true}
            loop={true}
            round={false}
          />
        </div>
        <div className={scss["news"]} />
        <div className={scss["game"]}>
          {data &&
            Object.entries(data.games).map(([key, value]) => (
              <div className={scss["box_game"]} key={key}>
                <img
                  src={`../assets/images/games/${value.image}.webp`}
                  alt=""
                />
                <div className={scss["button_container"]}>
                  <button
                    className={scss["button"]}
                    onClick={() => handleGameSelection(key)}
                  >
                    {value.name}
                  </button>
                </div>
              </div>
            ))}
        </div>
        <div className={scss["news"]} />
        <Dock
          items={items}
          panelHeight={68}
          baseItemSize={50}
          magnification={70}
        />
      </div>
    </div>
  );
};

export default Lobbymenu;
