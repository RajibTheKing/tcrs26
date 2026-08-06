### Timeline
---

- Review Received: <b>03 August 2026</b>
- Deadline for Manuscript Revision: <b>17 August 2026 (Two weeks)</b>



### Reviews
---

- <b>Reviewer: 1</b>
    - This paper presents a case study on the design, implementation, and evaluation of a remote control system for train operations. The reviewer has the following comments:
        1. The target application is interesting with practical impacts.
            - <span style="color:green">We thank the reviewer for the positive assessment and for recognizing the practical relevance of the proposed application. <b>No changes to the manuscript were made in response to this comment.</b></span>

        2. The evaluation provides a proof of concept. It will be good to see how the system deals with (i) multiple trains with potential conflicts and (ii) more complicated network conditions, although the reviewer understands that it is not the focus of this paper.
            - <span style="color:green">We agree that evaluating the proposed system with multiple trains, including potential conflicts, and under more challenging network conditions would provide additional insights into its scalability and robustness. <b>We have added a statement in the conclusion indicating that multi-train operation and more diverse network conditions are important directions for future research.</b></span>

        3. Using WebTransport is well-justified. Is it possible to further justify the use of Lingua Franca?
            - <span style="color:green">We agree that the motivation for selecting Lingua Franca (LF) can be explained more clearly. In the introduction section, we briefly justified the use of LF by highlighting its deterministic execution model, which is particularly well suited for cyber-physical systems (CPS). Unlike the publish/subscribe paradigm, such as ROS 2, whose execution behavior can become non-deterministic due to asynchronous message scheduling, LF provides deterministic execution semantics. This advantage has also been proved and demonstrated in previous research.</span>

            - <span style="color:green">Furthermore, LF improves the modularity and maintainability of the system by encapsulating functionality into reactors with well-defined interfaces, making the overall architecture easier to develop, understand, and extend. As illustrated in our implementation, features such as connectivity monitoring(HeartbeatHandler) can be naturally implemented using LF's built-in modal reactors, logical time semantics, and deadline mechanisms, significantly simplifying the implementation of time-critical behaviors.</span>

            - <span style="color:green"><b>In the revised manuscript, we have expanded the introduction to provide a more comprehensive justification for the use of Lingua Franca in the proposed cyber-physical system.</b></span>
- <b>Reviewer: 2</b>
    - This paper presents a practical remote train-control architecture that uses WebTransport/QUIC for communication and Lingua Franca for deterministic coordination of system components. This paper is highly relevant to TCRS because it combines time-sensitive communication, control for a cyber-physical system, reactor-model-based software, and a realistic safety-critical CPS application. A notable strength of this paper is the evaluation on an actual test vehicle and railway test track using an embedded platform, a 5G connection, a cloud-hosted central server, and a remote-control station. The Lingua Franca model and heartbeat mechanism demonstrate a clear system architecture for connectivity monitoring and deterministic orchestration.
        - <span style="color:green">We thank the reviewer for the positive assessment and for recognizing the relevance, practical contribution, and strengths of our proposed architecture and evaluation approach. <b>No changes to the manuscript were made in response to this comment.</b></span>

    - My main feedback on the final submission concerns formatting and the depth of evaluation.
        - This manuscript does not appear to use the required IEEE ESL journal template available through the IEEE Template Selector (https://template-selector.ieee.org/) and should be reformatted.
            - <span style="color:green">The submitted manuscript was prepared using an earlier version of the IEEE ESL template. We downloaded the latest template from the IEEE Template Selector and reformatted the manuscript accordingly. In the revised manuscript, we use the IEEEtran document class with the options `\documentclass[10pt,journal,cspaper]{IEEEtran}`. The `10pt` option ensures the required font size, and the `cspaper` option configures paper format with the required trim size of 7.875 in × 10.75 in. <b>We fixed the formatting on revised manuscript</b></span>
        - The real-world experiment of the proposed approach is highly valuable, but the results are based on a single 580-second trip and are presented primarily via latency traces and a rolling average of video frame latency. Please explain precisely how the reported latencies were calculated, including which timestamps were recorded at the sender and receiver, how the ClockSynchronizer estimated the clock offset between the train and remote-control system, and what synchronization error remained after correction.
        - For the video frame latency measurements, please clarify whether Fig. 5 reports network transmission latency or the full capture-to-display latency.
        - This paper assumes approximately 50 ms for video processing and appears to use 150 ms as the network-latency budget under the 200 ms total requirement; this relationship should be stated explicitly.
        - Please also provide summary statistics for the measured control-command and video latencies.
        - Finally, the authors should clarify which WebTransport mechanisms are used for control commands and video, and distinguish the reliability and ordering guarantees of reliable streams from the behavior of unreliable datagrams. I believe these issues can be addressed before the final submission without changing the main contribution.

- <b>Reviewer: 3</b>
    - The following comments are suggestions rather than mandatory revisions. I hope the authors may consider them to further improve the manuscript.

    - The authors used Lingua Franca instead of ROS, and one of the motivations is the deterministic execution model. Can the authors either provide example scenario(s) to enhance this motivation or related evaluation to show the importance of such determinism? (Will adopting ROS instead of Lingua Franca for the current setup encounter other problems?)

    - Although CentralServer and RemoteControlClient are not the main interest of this paper, can the authors briefly add more information about them? (For example, what kind of software is running on them? It would be okay to skip if it is in-house software.)

    - The authors tested the proposed TrainClient with a test vehicle on a track, but it seems vehicle movement information is missing. Does the vehicle stay in the same position during the experiments? Or does it continuously move? And will such movement affect the communication quality between TrainClient and CentralServer?

    - "If the heartbeats stop signal is received or the timeout expires, a timeout signal is sent and the reactor switches to Stopped, indicating loss of connectivity or inactive remote control."
        - While the reaction in Lingua Franca is scheduled based on the logical time, the timeout expiration looks related to the physical time. Can authors add brief details to adjust this? For example, the deadline in Lingua Franca supports handling such physical deadline violations, but I'm not sure the authors used this feature or another feature.

    - I recommend adding an explicit label for the red line in Figure 5. And is it related to "German regulations require glass-to-glass latency for control commands and video transmission in remotely operated road-vehicles (cars/trucks) to remain below 200 ms [11]."? (The red dotted lines are at 150 ms).

    - Can authors provide details for the command in the TrainClient reactor? I guess this might include increasing/decreasing speed and stopping. In such a case, will all commands have the same time requirements? Or should some commands, such as stop, be processed early?

    - It seems one recent paper published by IEEE cites https://www.w3.org/TR/webtransport/ for WebTransport. Would authors check whether this is a valid citation and if so, would you add it as a reference? (Or add another proper reference?)
        - (The paper that cites WebTransport: Fauquex, J. (2026, April). DESK Web transport: a new medical web imaging alternative to DICOMweb for complex air networks. In 2026 IEEE Medical Measurements & Applications (MeMeA) (pp. 1-5). IEEE.)

    - Similarly, consider adding a citation for ROS
        - if ROS 1, probably "Quigley, M., Conley, K., Gerkey, B., Faust, J., Foote, T., Leibs, J., ... & Ng, A. Y. (2009, May). ROS: an open-source Robot Operating System. In ICRA workshop on open source software (Vol. 3, No. 3.2, p. 5)."
        - if ROS 2, probably "Macenski, S., Foote, T., Gerkey, B., Lalancette, C., & Woodall, W. (2022). Robot Operating System 2: Design, architecture, and uses in the wild. Science robotics, 7(66), eabm6074."

    - This is not mandatory, but it would be good to add additional information (camera and motor controller) on Figure 1 (TrainClient side).
        - <span style="color:green">We agree that including additional details about the camera and motor controller could provide further insight on Figure 1. <b>However, since Figure 1 is intended to provide a high-level overview of the proposed architecture and communication flow, we have decided to keep the figure unchanged.</b></span>

    - On page 2, atleast -> at least
        - <span style="color:green"><b> Fixed on revised Menuscript </b></span>