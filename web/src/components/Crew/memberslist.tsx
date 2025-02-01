import React, { useEffect, useState } from "react";
import {
  Card,
  Text,
  ScrollArea,
  Badge,
  Button,
  Flex,
  Title,
  Select,
  ActionIcon,
  Grid,
  Loader,
} from "@mantine/core";
import {
  IconAlertCircle,
  IconCheckbox,
  IconInfoCircle,
  IconSkull,
  IconUxCircle,
  IconBrandCodepen,
  IconUser,
  IconWorld,
  IconUsersGroup,
  IconWebhook,
} from "@tabler/icons-react";
import { fetchNui } from "../../utils/fetchNui";

interface SimulatedConsoleProps {
  playersList: any;
  ranksInformation: any;
  ranksData: any;
  permission: any;
}

const SimulatedConsole: React.FC<SimulatedConsoleProps> = ({
  playersList,
  ranksInformation,
  ranksData,
  permission,
}) => {
  const [showContent, setShowContent] = useState(false);
  const [selectedPlayers, setSelectedPlayers] = useState<any>({});
  useEffect(() => {
    const timer = setTimeout(() => setShowContent(true), 1500);
    return () => clearTimeout(timer);
  }, []);

  if (!showContent) {
    return (
      <div
        style={{
          textAlign: "center",
          marginTop: 350,
          padding: "20px",
          color: "white",
        }}
      >
        <Loader size="xl" color="gray" variant="bars" />
        <Text weight={800} size="sm" tt="uppercase" color="gray">
          Loading memberslist...
        </Text>
      </div>
    );
  }
  const HandleChangeRank = (id: number) => {
    setSelectedPlayers((prev: any) => ({
      ...prev,
      id_rank: id,
    }));
  };
  const handleKickMembers = () => {
    playersList = fetchNui('crew:manage:kickmembers', selectedPlayers), //@ts-ignore
    setSelectedPlayers({})
  }
  const HandleSaveMembers = () => {
        playersList = fetchNui('crew:manage:savemembers', //@ts-ignore
        selectedPlayers)
  };
  return (
    <Flex
      justify="center"
      align="flex-start"
      style={{ gap: "20px", width: "100%" }}
    >
      <div style={{ width: "100%" }}>
        <Title
          tt="uppercase"
          order={2}
          style={{ marginBottom: "15px", color: "white" }}
        >
          Members List
        </Title>
        <Card
          shadow="xs"
          radius="md"
          padding="sm"
          style={{
            backgroundColor: "rgba(35, 45, 61, 0.8)",
            border: "1px solid rgba(255, 255, 255, 0.1)",
            boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
          }}
        >
          <Flex
            gap="xs"
            justify="flex-start"
            align="center"
            direction="row"
            wrap="wrap"
            mb={20}
          >
            <ActionIcon
              variant="light"
              style={{
                width: "40px",
                height: "40px",
                borderRadius: "10px",

                backgroundColor: "rgba(55, 65, 81, 0.85)",
                pointerEvents: "none",
                display: "flex",
                justifyContent: "center",
                alignItems: "center",
              }}
              color="yellow"
            >
              <IconWebhook size={24} />
            </ActionIcon>
            <Flex
              justify="flex-start"
              align="flex-start"
              direction="column"
              wrap="wrap"
            >
              <Title
                tt="uppercase"
                order={3}
                style={{ color: "white", marginTop: 0 }}
              >
                Liste des membres
              </Title>
              <Text color="dimmed" size="sm">
                Liste de tout les membres de votre crew
              </Text>
            </Flex>
          </Flex>
          <ScrollArea scrollbarSize={1} style={{ height: 623 }}>
            <Grid gutter="xs" style={{ width: "100%" }}>
              {playersList.map((player: any, index: number) => (
                <Grid.Col span={12} key={index}>
                  <Card
                    shadow="xs"
                    radius="sm"
                    padding="xs"
                    onClick={() => setSelectedPlayers(player)}
                    style={{
                      backgroundColor: "rgba(25, 35, 51, 0.8)",
                      border: "1px solid rgba(255, 255, 255, 0.2)",
                      boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
                      marginBottom: 10,
                    }}
                  >
                    <Flex justify="space-between" align="center" gap="xs">
                      <Flex gap="xs" align="center">
                        <ActionIcon
                          radius="xs"
                          size="lg"
                          variant="light"
                          style={{
                            backgroundColor: "rgba(55, 65, 81, 0.85)",
                            pointerEvents: "none",
                            border: "1px solid rgba(255, 255, 255, 0.1)",
                          }}
                        >
                          {player.id_player}
                        </ActionIcon>
                        <Text
                          tt="uppercase"
                          size="sm"
                          weight={600}
                          color="white"
                        >
                          {player.label}
                        </Text>
                      </Flex>
                      <Flex gap="xs" align="center">
                        <Badge variant="dot" color="red" size="sm" radius="sm">
                          {ranksData[player.id_rank - 1].name}
                        </Badge>
                      </Flex>
                    </Flex>
                  </Card>
                </Grid.Col>
              ))}
            </Grid>
          </ScrollArea>
        </Card>
      </div>
      {selectedPlayers.id_player && (
        <div style={{ width: "40%", marginTop: 50 }}>
          <Flex direction="column" gap="xs">
            <Card
              shadow="xs"
              radius="md"
              padding="sm"
              style={{
                backgroundColor: "rgba(35, 45, 61, 0.8)",
                border: "1px solid rgba(255, 255, 255, 0.1)",
                boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
                height: "100%",
              }}
            >
              <Flex
                gap="xs"
                justify="flex-start"
                align="center"
                direction="row"
                wrap="wrap"
                mb={20}
              >
                <ActionIcon
                  variant="light"
                  style={{
                    width: "40px",
                    height: "40px",
                    borderRadius: "10px",
                    backgroundColor: "rgba(55, 65, 81, 0.85)",
                    pointerEvents: "none",
                    display: "flex",
                    justifyContent: "center",
                    alignItems: "center",
                  }}
                  color="violet"
                >
                  <IconUsersGroup size={24} />
                </ActionIcon>
                <Flex
                  justify="flex-start"
                  align="flex-start"
                  direction="column"
                  wrap="wrap"
                >
                  <Title
                    tt="uppercase"
                    order={3}
                    style={{ color: "white", marginTop: 0 }}
                  >
                    Joueur séléctionné
                  </Title>
                  <Text color="dimmed" size="sm">
                    Information sur le joueur
                  </Text>
                </Flex>
              </Flex>
              <Card
                shadow="xs"
                radius="sm"
                padding="xs"
                style={{
                  backgroundColor: "rgba(25, 35, 51, 0.8)",
                  border: "1px solid rgba(255, 255, 255, 0.2)",
                  boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
                  marginBottom: 10,
                }}
              >
                <Flex justify="space-between" align="center" gap="xs">
                  <Flex gap="xs" align="center">
                    <Text tt="uppercase" size="sm" weight={600} color="white">
                      Pseudonyme
                    </Text>
                  </Flex>
                  <Flex gap="xs" align="center">
                    <Badge variant="dot" color="red" size="sm" radius="sm">
                      {selectedPlayers.label}
                    </Badge>
                  </Flex>
                </Flex>
              </Card>

              <Card
                shadow="xs"
                radius="sm"
                padding="xs"
                style={{
                  backgroundColor: "rgba(25, 35, 51, 0.8)",
                  border: "1px solid rgba(255, 255, 255, 0.2)",
                  boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
                  marginBottom: 10,
                }}
              >
                <Flex justify="space-between" align="center" gap="xs">
                  <Flex gap="xs" align="center">
                    <Text tt="uppercase" size="sm" weight={600} color="white">
                      UUID
                    </Text>
                  </Flex>
                  <Flex gap="xs" align="center">
                    <Badge variant="dot" color="blue" size="sm" radius="sm">
                      {selectedPlayers.id_player}
                    </Badge>
                  </Flex>
                </Flex>
              </Card>

              <Card
                shadow="xs"
                radius="sm"
                padding="xs"
                style={{
                  backgroundColor: "rgba(25, 35, 51, 0.8)",
                  border: "1px solid rgba(255, 255, 255, 0.2)",
                  boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
                  marginBottom: 10,
                }}
              >
                <Flex
                  justify="space-between"
                  align="center"
                  gap="xs"
                  style={{ height: "100%" }}
                >
                  <Flex gap="xs" align="center">
                    <Text tt="uppercase" size="sm" weight={600} color="white">
                      Rank
                    </Text>
                  </Flex>
                  <Flex gap="xs" align="center">
                    <Badge variant="dot" color="blue" size="sm" radius="sm">
                      {selectedPlayers.id_rank}
                    </Badge>
                  </Flex>
                </Flex>
              </Card>
              {permission['changeRank'] && (
              <Select
                style={{ marginBottom: 10 }}
                data={ranksInformation}
                //@ts-ignore
                value={selectedPlayers.id_rank ? selectedPlayers.id_rank : null}
                //@ts-ignore
                onChange={(_value, option) => HandleChangeRank(_value)}
                allowDeselect={false}
              />
              )}
              {permission['removePlayer'] && (
              <Button
                style={{
                  background: "var(--degrade-radial-rouge)",
                  border: "1px solid rgba(255, 255, 255, 0.2)",
                  boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
                  marginBottom: 10,
                }}
                fullWidth
                onClick={handleKickMembers}
              >
                Kick
              </Button>)}
              {permission['changeRank'] && (
              <Button
                style={{
                  background: "var(--degrade-radial-vert)",
                  border: "1px solid rgba(255, 255, 255, 0.2)",
                  boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
                  marginBottom: 10,
                }}
                fullWidth
                onClick={HandleSaveMembers}
              >
                Sauvegarder
              </Button>)}
            </Card>
          </Flex>
        </div>
      )}
    </Flex>
  );
};

export default SimulatedConsole;
