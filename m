Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCC51266A8
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Dec 2019 17:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfLSQTT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Dec 2019 11:19:19 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:32909 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbfLSQTS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 19 Dec 2019 11:19:18 -0500
Received: by mail-il1-f194.google.com with SMTP id v15so5362775iln.0
        for <ceph-devel@vger.kernel.org>; Thu, 19 Dec 2019 08:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=yWJEsXtNWZDOzVcWxb9L6pCtXF7AS5GaRwBQfaUqIWU=;
        b=Vn4kcLVloxWrOVtn+anSGNrdKK29YeUnYbgVkUrrOmfJ6ijPetDNRgMwNBDarGW9BV
         jFD2YAsGWpYLo8WxfdpdQ4bfUT9+5r1tlUjVeLd5J5LQRIJiUlUGvsE+08Zi3jP0iFmz
         yPh8EdDtSqgIX++Ocn/Bebot2cI8lSo3YGB+noTaAMnUDtl5IxW51m8ll62ON8mD5ExB
         7dbEfSYNmxZGpVyjU1ZFU0u8x+mSQ4kFOu96q+MzvoThVziw3c/ZxCUfZMcpAvLFSASK
         nO3mcTVpC3vBX+qkXi7hMWntVj5NkDBDS8dbup+tkReDG45Ko/ZI2NW13RrdyPXqS5Vi
         Q5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=yWJEsXtNWZDOzVcWxb9L6pCtXF7AS5GaRwBQfaUqIWU=;
        b=exSRxe0FMVS5Unac9jHng+HrWiOYKwzW+tgTLqFOEjBYliFtUUMQ1H0JqkwkCsh1La
         5xR7HGDrsOQOXlSnLEtlfHdwNIbeX0qEgnAwB9svkjcE41/xy0fmvt2rRd1sYW+nEWtX
         DPawAtIXX0YURVT/QArfdW0hmTLmSB5EuuXB9qPohukbGA7PFogf6egcRMw9+IKLnyBH
         BJYuhuwsrydEbtIYEp6rZUKvllnc6zeQ5XbaefusGcsx6ywYH16pPFViMW2lVyjJQtxR
         L+aB9xJ1gIJJYLULJzL2PHxvrjEqqbZCbx5ciUizE798aZu8rtDobf/n2+qNYbGN92uI
         r7mQ==
X-Gm-Message-State: APjAAAUrPp0Vrx4C4pCIjkX9aEN/v7Dj8cZ+ENe1wEdgwNfyyKnthgQd
        H8XG4XwLehCD547QGj9CdPFxZtxo9tFRNZJqoB4f+SXT0gM=
X-Google-Smtp-Source: APXvYqxvHo9FuMkPTYcQ7EJcKmJsiAwzRZ3G3BaDwJIKOGSJ0V0meTGx1W1pcMQ7+Ghx8qz+O2JMmikwf+QWulwTSI0=
X-Received: by 2002:a92:cb10:: with SMTP id s16mr7266766ilo.176.1576772357268;
 Thu, 19 Dec 2019 08:19:17 -0800 (PST)
MIME-Version: 1.0
From:   VHPC 20 <vhpc.dist@gmail.com>
Date:   Thu, 19 Dec 2019 17:19:06 +0100
Message-ID: <CAF05tLNAo6G5LfrJBSUeQEM_FEjsizTZ2=FpUSm18+wnfgAGYQ@mail.gmail.com>
Subject: CfP VHPC20: HPC Containers-Kubernetes
To:     ceph-users@ceph.com, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
CALL FOR PAPERSa

15th Workshop on Virtualization in High-Performance Cloud Computing
(VHPC 20) held in conjunction with the International Supercomputing
Conference - High Performance, June 21-25, 2020, Frankfurt, Germany.
(Springer LNCS Proceedings)

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


Date: June 25, 2020
Workshop URL: vhpc[dot]org


Abstract registration Deadline: Jan 31st, 2020
Paper Submission Deadline: Apr 05th, 2020
Springer LNCS



Call for Papers


Containers and virtualization technologies constitute key enabling
factors for flexible resource management in modern data centers, and
particularly in cloud environments. Cloud providers need to manage
complex infrastructures in a seamless fashion to support the highly
dynamic and heterogeneous workloads and hosted applications customers
deploy. Similarly, HPC environments have been increasingly adopting
techniques that enable flexible management of vast computing and
networking resources, close to marginal provisioning cost, which is
unprecedented in the history of scientific and commercial computing.
Most recently, Function as a Service (Faas) and Serverless computing,
utilizing lightweight VMs-containers widens the spectrum of
applications that can be deployed in a cloud environment, especially
in an HPC context. Here, HPC-provided services can be become
accessible to distributed workloads outside of large cluster
environments.

Various virtualization-containerization technologies contribute to the
overall picture in different ways: machine virtualization, with its
capability to enable consolidation of multiple under=C2=ADutilized servers
with heterogeneous software and operating systems (OSes), and its
capability to live=C2=AD-migrate a fully operating virtual machine (VM)
with a very short downtime, enables novel and dynamic ways to manage
physical servers; OS-=C2=ADlevel virtualization (i.e., containerization),
with its capability to isolate multiple user=C2=AD-space environments and
to allow for their co=C2=ADexistence within the same OS kernel, promises to
provide many of the advantages of machine virtualization with high
levels of responsiveness and performance; lastly, unikernels provide
for many virtualization benefits with a minimized OS/library surface.
I/O Virtualization in turn allows physical network interfaces to take
traffic from multiple VMs or containers; network virtualization, with
its capability to create logical network overlays that are independent
of the underlying physical topology is furthermore enabling
virtualization of HPC infrastructures.


Publication


Accepted papers will be published in a Springer LNCS proceedings
volume.


Topics of Interest


The VHPC program committee solicits original, high-quality submissions
related to virtualization across the entire software stack with a
special focus on the intersection of HPC, containers-virtualization
and the cloud.


Major Topics:
- HPC workload orchestration (Kubernetes)
- Kubernetes HPC batch
- HPC Container Environments Landscape
- HW Heterogeneity
- Container ecosystem (Docker alternatives)
- Networking
- Lightweight Virtualization
- Unikernels / LibOS
- State-of-the-art processor virtualization (RISC-V, EPI)
- Containerizing HPC Stacks/Apps/Codes:
  Climate model containers


each major topic encompassing design/architecture, management,
performance management, modeling and configuration/tooling.
Specifically, we invite papers that deal with the following topics:

- HPC orchestration (Kubernetes)
   - Virtualizing Kubernetes for HPC
   - Deployment paradigms
   - Multitenancy
   - Serverless
   - Declerative data center integration
   - Network provisioning
   - Storage
   - OCI i.a. images
   - Isolation/security
- HW Accelerators, including GPUs, FPGAs, AI, and others
   - State-of-practice/art, including transition to cloud
   - Frameworks, system software
   - Programming models, runtime systems, and APIs to facilitate cloud
     adoption
   - Edge use-cases
   - Application adaptation, success stories
- Kubernetes Batch
   - Scheduling, job management
   - Execution paradigm - workflow
   - Data management
   - Deployment paradigm
   - Multi-cluster/scalability
   - Performance improvement
   - Workflow / execution paradigm
- Podman: end-to-end Docker alternative container environment & use-cases
   - Creating, Running containers as non-root (rootless)
   - Running rootless containers with MPI
   - Container live migration
   - Running containers in restricted environments without setuid
- Networking
   - Software defined networks and network virtualization
   - New virtualization NICs/Nitro alike ASICs for the data center?
   - Kubernetes SDN policy (Calico i.a.)
   - Kubernetes network provisioning (Flannel i.a.)
- Lightweight Virtualization
   - Micro VMMs (Rust-VMM, Firecracker, solo5)
   - Xen
   - Nitro hypervisor (KVM)
   - RVirt
   - Cloud Hypervisor
- Unikernels / LibOS
- HPC Storage in Virtualization
   - HPC container storage
   - Cloud-native storage
   - Hypervisors in storage virtualization
- Processor Virtualization
   - RISC-V hypervisor extensions
   - RISC-V Hypervisor ports
   - EPI
- Composable HPC microservices
- Containerizing Scientific Codes
   - Building
   - Deploying
   - Securing
   - Storage
   - Monitoring
- Use case for containerizing HPC codes:
  Climate model containers for portability, reproducibility,
  traceability, immutability, provenance, data & software preservation



The Workshop on Virtualization in High=C2=AD-Performance Cloud Computing
(VHPC) aims to bring together researchers and industrial practitioners
facing the challenges posed by virtualization in order to foster
discussion, collaboration, mutual exchange of knowledge and
experience, enabling research to ultimately provide novel solutions
for virtualized computing systems of tomorrow.

The workshop will be one day in length, composed of 20 min paper
presentations, each followed by 10 min discussion sections, plus
lightning talks that are limited to 5 minutes. Presentations may be
accompanied by interactive demonstrations.


Important Dates

Jan 31st, 2020 - Abstract
Apr 5th, 2020 - Paper submission deadline (Springer LNCS)
Apr 26th, 2020 - Acceptance notification
June 25th, 2020 - Workshop Day
July 10th, 2020 - Camera-ready version due


Chair

Michael Alexander (chair), BOKU, Vienna, Austria
Anastassios Nanos (co-=C2=ADchair), Sunlight.io, UK


Program committee

Stergios Anastasiadis, University of Ioannina, Greece
Paolo Bonzini, Redhat, Italy
Jakob Blomer, CERN, Europe
Eduardo C=C3=A9sar, Universidad Autonoma de Barcelona, Spain
Taylor Childers, Argonne National Laboratory, USA
Stephen Crago, USC ISI, USA
Tommaso Cucinotta, St. Anna School of Advanced Studies, Italy
Fran=C3=A7ois Diakhat=C3=A9 CEA DAM Ile de France, France
Kyle Hale, Northwestern University, USA
Brian Kocoloski, Washington University, USA
John Lange, University of Pittsburgh, USA
Giuseppe Lettieri, University of Pisa, Italy
Klaus Ma, Huawei, China
Alberto Madonna, Swiss National Supercomputing Center, Switzerland
Nikos Parlavantzas, IRISA, France
Anup Patel, Western Digital, USA
Kevin Pedretti, Sandia National Laboratories, USA
Amer Qouneh, Western New England University, USA
Carlos Rea=C3=B1o, Queen=E2=80=99s University Belfast, UK
Adrian Reber, Redhat, Germany
Riccardo Rocha, CERN, Europe
Borja Sotomayor, University of Chicago, USA
Jonathan Sparks, Cray, USA
Kurt Tutschku, Blekinge Institute of Technology, Sweden
John Walters, USC ISI, USA
Yasuhiro Watashiba, Osaka University, Japan
Chao-Tung Yang, Tunghai University, Taiwan



Paper Submission-Publication

Papers submitted to the workshop will be reviewed by at least two
members of the program committee and external reviewers. Submissions
should include abstract, keywords, the e-mail address of the
corresponding author, and must not exceed 10 pages, including tables
and figures at a main font size no smaller than 11 point. Submission
of a paper should be regarded as a commitment that, should the paper
be accepted, at least one of the authors will register and attend the
conference to present the work. Accepted papers will be published in a
Springer LNCS volume.

The format must be according to the Springer LNCS Style. Initial
submissions are in PDF; authors of accepted papers will be requested
to provide source files.


Abstract, Paper Submission Link:
edas[dot]info/newPaper.php?c=3D26973


Lightning Talks

Lightning Talks are non-paper track, synoptical in nature and are
strictly limited to 5 minutes. They can be used to gain early
feedback on ongoing research, for demonstrations, to present research
results, early research ideas, perspectives and positions of interest
to the community. Submit abstract via the main submission link.

General Information

The workshop is one day in length and will be held in conjunction with
the International Supercomputing Conference - High Performance (ISC)
2019, June 21-25, Frankfurt, Germany.
