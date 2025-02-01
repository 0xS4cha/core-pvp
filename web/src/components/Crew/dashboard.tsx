import React, { useEffect, useState } from "react";
import {
  Card,
  Text,
  ScrollArea,
  Badge,
  Flex,
  Title,
  ActionIcon,
  Grid,
  Loader,
} from "@mantine/core";
import { IconWorld, IconUsersGroup, IconWebhook } from "@tabler/icons-react";

interface SimulatedConsoleProps {
  playersList: any;
  ranksData: any;
  ranksInformation: any;
  deaths: any;
  kills: any;

}

const SimulatedConsole: React.FC<SimulatedConsoleProps> = ({
  ranksData,
  ranksInformation,
  playersList,
  deaths,
  kills,
}) => {
  const [showContent, setShowContent] = useState(false);
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
          Loading dashboard...
        </Text>
      </div>
    );
  }
  console.log(ranksData, playersList);
  return (
    <Flex
      justify="center"
      align="flex-start"
      style={{ gap: "20px", width: "100%" }}
    >
      <div style={{ width: "46%" }}>
        <Title
          tt="uppercase"
          order={2}
          style={{ marginBottom: "15px", color: "white" }}
        >
          Dashboard
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
              {playersList.map((value: any, index: number) => (
                <Grid.Col span={6} key={index}>
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
                          {value.id_player}
                        </ActionIcon>
                        <Text
                          tt="uppercase"
                          size="sm"
                          weight={600}
                          color="white"
                        >
                          {value.label}
                        </Text>
                      </Flex>
                      <Flex gap="xs" align="center">
                        <Badge variant="dot" color="red" size="sm" radius="sm">
                          {ranksData[value.id_rank - 1].name}
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

      <div style={{ width: "54%", marginTop: 50 }}>
        <Flex direction="column" gap="xs">
          <Card
            shadow="xs"
            radius="md"
            padding="sm"
            style={{
              backgroundColor: "rgba(35, 45, 61, 0.8)",
              border: "1px solid rgba(255, 255, 255, 0.1)",
              boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
              height: 480,
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
                  Liste des rangs
                </Title>
                <Text color="dimmed" size="sm">
                Liste de tout les rangs de votre crew
                </Text>
              </Flex>
            </Flex>
            <ScrollArea scrollbarSize={1} h={500}>
              <Grid gutter="xs" style={{ width: "100%" }}>
                {Object.entries(ranksData).map(([key, value]) => (
                  <Grid.Col span={6} key={key}>
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
                            {
                              //@ts-ignore
                              value.rank
                            }
                          </ActionIcon>
                          <Text
                            tt="uppercase"
                            size="sm"
                            weight={600}
                            color="white"
                          >
                            {
                              //@ts-ignore
                              value.name
                            }
                          </Text>
                        </Flex>
                      </Flex>
                    </Card>
                  </Grid.Col>
                ))}
              </Grid>
            </ScrollArea>
          </Card>

          <Card
            shadow="xs"
            radius="md"
            padding="sm"
            style={{
              backgroundColor: "rgba(35, 45, 61, 0.8)",
              border: "1px solid rgba(255, 255, 255, 0.1)",
              boxShadow: "0 4px 8px rgba(0, 0, 0, 0.1)",
              height: "230px",
            }}
          >
            <Flex
              gap="xs"
              justify="flex-start"
              align="center"
              direction="row"
              wrap="wrap"
            >
              <Flex justify="center" align="center" gap="xs">
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
                  color="teal"
                >
                  <IconWorld size={20} />
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
                    Statistiques
                  </Title>
                  <Text color="dimmed" size="sm">
                    Statistiques de votre crew
                  </Text>
                </Flex>
              </Flex>

              <Flex
                gap="lg"
                justify="center"
                align="center"
                mt={20}
                style={{ width: "100%" }}
              >
                <Flex direction="column" align="center" gap="xs">
                  <ActionIcon
                    variant="light"
                    style={{
                      width: "80px",
                      height: "80px",
                      borderRadius: "10px",
                      border: "2px solid rgba(255, 255, 255, 0.2)",
                      backgroundColor: "rgba(55, 65, 81, 0.85)",
                      pointerEvents: "none",
                      display: "flex",
                      justifyContent: "center",
                      alignItems: "center",
                    }}
                    color="pink"
                  >
                    <Text size="xl" color="white">
                      {kills}
                    </Text>
                  </ActionIcon>
                  <Text tt="uppercase" weight={600} color="white">
                    Kills
                  </Text>
                </Flex>

                <Flex direction="column" align="center" gap="xs">
                  <ActionIcon
                    variant="filled"
                    style={{
                      width: "80px",
                      height: "80px",
                      borderRadius: "10px",
                      border: "2px solid rgba(255, 255, 255, 0.2)",
                      backgroundColor: "rgba(55, 65, 81, 0.85)",
                      pointerEvents: "none",
                      display: "flex",
                      justifyContent: "center",
                      alignItems: "center",
                    }}
                    color="blue"
                  >
                    <Text size="xl" color="white">
                      {deaths}
                    </Text>
                  </ActionIcon>
                  <Text tt="uppercase" weight={600} color="white">
                    Death
                  </Text>
                </Flex>

                <Flex direction="column" align="center" gap="xs">
                  <ActionIcon
                    variant="filled"
                    style={{
                      width: "80px",
                      height: "80px",
                      borderRadius: "10px",
                      border: "2px solid rgba(255, 255, 255, 0.2)",
                      backgroundColor: "rgba(55, 65, 81, 0.85)",
                      pointerEvents: "none",
                      display: "flex",
                      justifyContent: "center",
                      alignItems: "center",
                    }}
                    color="green"
                  >
                    <Text size="xl" color="white">
                      {Math.round(kills / deaths)}
                    </Text>
                  </ActionIcon>
                  <Text tt="uppercase" weight={600} color="white">
                    Ratio
                  </Text>
                </Flex>
              </Flex>
            </Flex>
          </Card>
        </Flex>
      </div>
    </Flex>
  );
};

export default SimulatedConsole;
