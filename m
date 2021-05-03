Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FC2371DC7
	for <lists+ceph-devel@lfdr.de>; Mon,  3 May 2021 19:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbhECRDO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 May 2021 13:03:14 -0400
Received: from mail-db8eur05on2088.outbound.protection.outlook.com ([40.107.20.88]:45024
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232168AbhECRB2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 3 May 2021 13:01:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmMcGXbVliO8LBG+m5fWAcZsgvdfxTpgjITKPvstjl79OzCNQH+c0DFcH7gtEmfKLYDidDCkhp2tCd1w2AHznDO0LfNUDqyyTt/dQeFTNCg2fAYAHR4dcyVuEck7fvKudNVIf9bx0+m9mANsDwajqABwE6kgjHfeGjE7mihRAYrRyAHpbexLRy6/ZhCV0zsYaNg4USV+usAMFls+MMyw41NygNq49pXndEyRqry1gACP/7T6UMaa3lbzW1lTCMJ1TzEK7K7n3ocSZlHaY1wbDHioLafvR7l1k12APZzwTBQJmgQZ7RIOwtPolygaUlEQjgfJOfa5fZC0pBJ2KxB5pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YKaYElrDeZg07qxa2i0n8c1Y0QXJXc2Lm58vTjNon4U=;
 b=JJoCwsaiPcrHBYLHWeVkcQqi+SVtnS9G4x7PH+Qd/7bcE6eLXLWsDORBGI1G/KPLhB8mz82lLjcxxvJL8DobZxI1NsvRGFI9coNWsHkYlhHzPjPCJUcEHjRqwBQdL11rVJ29x0PKznZhjGL/HJhVgu+nBSxkOA23d7fRWZjZI5U4x1GQvJzNnAFgvc0UpcMiaiZ1A0uCrWiP+IvNUS1AEs3aYeZu9HQcttbcWrBOsf6BDRzHCLtj9YbxVAOKYbXgWM5g+a2vNM5rvpfVX6VeyJLw05z5SBI8D2/+unooyXHmZPoqkboXpCpiaXk3FJf0OKOXlQbYR1tN7iszoEep4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.38.82.194) smtp.rcpttodomain=redhat.com smtp.mailfrom=dtu.dk; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=dtu.dk;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dtu.dk; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YKaYElrDeZg07qxa2i0n8c1Y0QXJXc2Lm58vTjNon4U=;
 b=tMhm2rZ9fHdGjCDnLQfKJjK7u2/MEWB5zWUyWhS3L3oB6kKTDhSQ3gHkqgnO7pZCwjKV0FyV5PiFWltqsvtZ8sD2d5xfJwW9swM7O8Wrxmx1zQ7eiMA7BBeHOQ6flBj781DZTUjrRiPBuBOEvufWwoRfRwXfNI+DW9BykAeT/nI=
Received: from AM6PR05CA0015.eurprd05.prod.outlook.com (2603:10a6:20b:2e::28)
 by PR3P192MB0601.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:44::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Mon, 3 May
 2021 17:00:32 +0000
Received: from HE1EUR01FT059.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:20b:2e:cafe::b2) by AM6PR05CA0015.outlook.office365.com
 (2603:10a6:20b:2e::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend
 Transport; Mon, 3 May 2021 17:00:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 192.38.82.194)
 smtp.mailfrom=dtu.dk; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=dtu.dk;
Received-SPF: Pass (protection.outlook.com: domain of dtu.dk designates
 192.38.82.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.38.82.194; helo=mail.win.dtu.dk;
Received: from mail.win.dtu.dk (192.38.82.194) by
 HE1EUR01FT059.mail.protection.outlook.com (10.152.0.241) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.20.4087.27 via Frontend Transport; Mon, 3 May 2021 17:00:31 +0000
Received: from ait-pexsrv03.win.dtu.dk (192.38.82.196) by
 ait-pexsrv01.win.dtu.dk (192.38.82.194) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 3 May 2021 19:00:31 +0200
Received: from ait-pexsrv03.win.dtu.dk (192.38.82.196) by
 ait-pexsrv03.win.dtu.dk (192.38.82.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 3 May 2021 19:00:31 +0200
Received: from ait-pexsrv03.win.dtu.dk ([192.38.82.196]) by
 ait-pexsrv03.win.dtu.dk ([192.38.82.196]) with mapi id 15.01.2176.012; Mon, 3
 May 2021 19:00:31 +0200
From:   Frank Schilder <frans@dtu.dk>
To:     Patrick Donnelly <pdonnell@redhat.com>,
        Lokendra Rathour <lokendrarathour@gmail.com>
CC:     Ceph Development <ceph-devel@vger.kernel.org>, dev <dev@ceph.io>,
        ceph-users <ceph-users@ceph.io>
Subject: Re: [ceph-users] Re: [ Ceph MDS MON Config Variables ] Failover Delay
 issue
Thread-Topic: [ceph-users] Re: [ Ceph MDS MON Config Variables ] Failover
 Delay issue
Thread-Index: AQHXQDADzLNi6UZYukWYctrBDhTslKrR+PDZ
Date:   Mon, 3 May 2021 17:00:31 +0000
Message-ID: <6d07b36589f5493785d036dc4026f214@dtu.dk>
References: <CAJm6b-741TRptPWOqoqEJG6m00auekTkcWUD+z3sxH1-34THgA@mail.gmail.com>,<CA+2bHPaotXm-SK7Pi0WqL1wb4=MD+xvJr4hQGprk897LHt5qCQ@mail.gmail.com>
In-Reply-To: <CA+2bHPaotXm-SK7Pi0WqL1wb4=MD+xvJr4hQGprk897LHt5qCQ@mail.gmail.com>
Accept-Language: en-GB, da-DK, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.38.82.8]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cbef800-3a65-48f4-23ae-08d90e54f611
X-MS-TrafficTypeDiagnostic: PR3P192MB0601:
X-Microsoft-Antispam-PRVS: <PR3P192MB06012D81B90C2D6A0F528115D65B9@PR3P192MB0601.EURP192.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kANcYmCD4OSnc14g1wDh7L86OEwpMqB/gA+6tEIWbcMaOadMn2tgugDpwIoLa38C7iaeqadOwq3W35V7Ks/eT5ZrPp+NnpVR/uGkZHw8vWcm6QCW/oIpVqhFHn/xVRoEyeOcNyY2PqPPX31nw1ij0NKIIfEr+LCJAA5tijNf6y7BS0L9FdpLdjcRsXbNm+MWEzeh+xshVvnpdd8aD2tiUzb1NefZ0ygDuVh4zgxzxDjKC38RiqpbnEg9omFitBKbs0khmoyJV8CDf77XxWvCfHczNTZKkUIyH+doshgLjEjbz9HqvKpvQ1TU81JTpMMWBNSye6uS3iLI52miInh8Bi7MzyDGsk+Yy9YCqbgCw2Cn/BEIzXb2TdxEKgCgXN8VnuKSHwMLpXDm8l9qyJ9k08tCcXWxl9cNAzQvrkljhnYSibcz22N7FYZ34b7+SnyY2IWM4PQKBZKP80tRUwtPWTZj3rrfyg7vkGA0AURm3JOOzYxIS0zmI2ZfDw2g2yk0whaEoMc5XEXxTBs/ueaN1HJK1mfD9Ch41CHM7xQ+9hjzowOSnkD7p3MWf+BkPkbJ9OT8F4Ec5XQzWT+Nd8HQPQvghQf4dZiSCNOSgswN2BA1SsoxSbLM+VoCobB6kT4cuz9RtTPFSyJBvSqopSG2zgpRI911ilL/xjFUiUTM8r8=
X-Forefront-Antispam-Report: CIP:192.38.82.194;CTRY:DK;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.win.dtu.dk;PTR:ait-pexsrv01.win.dtu.dk;CAT:NONE;SFS:(346002)(136003)(39840400004)(396003)(376002)(36840700001)(46966006)(36860700001)(2616005)(4326008)(426003)(70206006)(956004)(86362001)(7696005)(5660300002)(47076005)(70586007)(786003)(8676002)(8976002)(36756003)(478600001)(108616005)(24736004)(83380400001)(54906003)(26005)(110136005)(186003)(356005)(53546011)(316002)(2906002)(8936002)(336012)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: dtu.dk
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2021 17:00:31.7626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cbef800-3a65-48f4-23ae-08d90e54f611
X-MS-Exchange-CrossTenant-Id: f251f123-c9ce-448e-9277-34bb285911d9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f251f123-c9ce-448e-9277-34bb285911d9;Ip=[192.38.82.194];Helo=[mail.win.dtu.dk]
X-MS-Exchange-CrossTenant-AuthSource: HE1EUR01FT059.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P192MB0601
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Following up on this and other comments, there are 2 different time delays.=
 One (1)  is the time it takes from killing an MDS until a stand-by is made=
 an active rank, and (2) the time it takes for the new active rank to resto=
re all client sessions. My experience is that (1) takes close to 0 seconds =
while (2) can take between 20-30 seconds depending on how busy the clients =
are; the MDS will go through various states before reaching active. We usua=
lly have ca. 1600 client connections to our FS. With fewer clients, MDS fai=
l-over is practically instantaneous. We are using latest mimic.

From what you write, you seem to have a 40 seconds window for (1), which po=
ints to a problem different to MON config values. This is supported by your=
 description including a MON election (??? this should never happen). Do yo=
u have have services co-located? Which of the times (1) or (2) are you refe=
rring to? How many FS clients do you have?

Best regards,
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Frank Schilder
AIT Ris=F8 Campus
Bygning 109, rum S14

________________________________________
From: Patrick Donnelly <pdonnell@redhat.com>
Sent: 03 May 2021 17:19:37
To: Lokendra Rathour
Cc: Ceph Development; dev; ceph-users
Subject: [ceph-users] Re: [ Ceph MDS MON Config Variables ] Failover Delay =
issue

On Mon, May 3, 2021 at 6:36 AM Lokendra Rathour
<lokendrarathour@gmail.com> wrote:
>
> Hi Team,
> I was setting up the ceph cluster with
>
>    - Node Details:3 Mon,2 MDS, 2 Mgr, 2 RGW
>    - Deployment Type: Active Standby
>    - Testing Mode: Failover of MDS Node
>    - Setup : Octopus (15.2.7)
>    - OS: centos 8.3
>    - hardware: HP
>    - Ram:  128 GB on each Node
>    - OSD: 2 ( 1 tb each)
>    - Operation: Normal I/O with mkdir on every 1 second.
>
> T*est Case: Power-off any active MDS Node for failover to happen*
>
> *Observation:*
> We have observed that whenever an active MDS Node is down it takes around=
*
> 40 seconds* to activate the standby MDS Node.
> on further checking the logs for the new-handover MDS Node we have seen
> delay on the basis of following inputs:
>
>    1. 10 second delay after which Mon calls for new Monitor election
>       1.  [log]  0 log_channel(cluster) log [INF] : mon.cephnode1 calling
>       monitor election

In the process of killing the active MDS, are you also killing a monitor?

--
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
_______________________________________________
ceph-users mailing list -- ceph-users@ceph.io
To unsubscribe send an email to ceph-users-leave@ceph.io
