Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF2644F222
	for <lists+ceph-devel@lfdr.de>; Sat, 13 Nov 2021 09:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhKMIVD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 13 Nov 2021 03:21:03 -0500
Received: from mail-psaapc01on2096.outbound.protection.outlook.com ([40.107.255.96]:33441
        "EHLO APC01-PSA-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230095AbhKMIVC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 13 Nov 2021 03:21:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzV2sADezXnaz42pYTwpjHVIg1bRjAguaAAfYCo8wqyqQbmxhW9hTeJJbZQkyFs0OVWp4w1jjxsyEuYkSzpz3Tcv+vzaeKtcUBkBrfX79hLAy0/xM5pbCVOm/MJBj76bmiyUK0NCcfmhOBZ3lBUOdct3pbPEg12xXvPXxHTdS+Oem+lNUpgr3eyk5VgjN8kcKytqHVgLK1FDkQWRaIdkd9+2w4pyFN5l1XY+ZwkGEfn4vk014AfvhPo+mmmLsQtLgPBfzE15N5kTvKosoHbuzJwsa//FhB6uJc4b7dht81pUF1CYhGoufhAJPeZMxi+z7MEge0ICWN++tzMIY2zUog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OK2ZMnCOYnPnS54wVo2JXZGgFfl7pjC2gSp+IoVqAg8=;
 b=Sh3Y4jJjlMM5fxOSGvdA8Hip6EF2rEr2CaVJkCIw+Va+/UODPN/2/VZHhrL6M6b+AhxbP9cNdJ/O47Pn8W2pnHah6AZbwqVaFWDWD5Sp33O2VW0MYkF9bIJhoFM60UagSOZd6ATj+7BpIITRLho7BKmGpeZ0BGjdyB9j0ZyVlaFjE0RyVO+zuF2uOfAT091oKA/tT8QLk7KFmxLD3Xerb70tS8kKgmu+/0oZAkxbV7vo04sMbNCEPsCxSVjuGc0Ogs4XOs76XcA552cYqerIzUy2nvV80kFJ22Njv4e6g8ydhEfjcFkFW40C67lEplmY1Bb6DjX0QbQ7b140HuuXRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=u.nus.edu; dmarc=pass action=none header.from=u.nus.edu;
 dkim=pass header.d=u.nus.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nusu.onmicrosoft.com;
 s=selector1-nusu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OK2ZMnCOYnPnS54wVo2JXZGgFfl7pjC2gSp+IoVqAg8=;
 b=jRxY2rL77z86IXNMYCYRwiTM2A6opJDjPgZaQ7nScbeVESgo+D1u48uwpVC2okDx7rcmir8tOhiCzajTCiHKzys7nknBUq6T4WcMox4ZF4WPckrMPj1hPh6MDOcsty1K44/OCDAGxQrF2BP0sVWdTlyYlDLfLUJczI1FdCzfMvA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=u.nus.edu;
Received: from TY2PR06MB3056.apcprd06.prod.outlook.com (2603:1096:404:a0::20)
 by TY2PR06MB3007.apcprd06.prod.outlook.com (2603:1096:404:9d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Sat, 13 Nov
 2021 08:17:48 +0000
Received: from TY2PR06MB3056.apcprd06.prod.outlook.com
 ([fe80::d867:20cb:7dab:ab1c]) by TY2PR06MB3056.apcprd06.prod.outlook.com
 ([fe80::d867:20cb:7dab:ab1c%5]) with mapi id 15.20.4669.015; Sat, 13 Nov 2021
 08:17:48 +0000
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Deng Kaisheng <kaisheng.deng@u.nus.edu>
Date:   Sat, 13 Nov 2021 16:17:45 +0800
Subject: Anything I can contribute?
Message-Id: <F6563AD9-DE29-4174-9863-BF9B9D32052C@u.nus.edu>
To:     ceph-devel@vger.kernel.org
X-Mailer: iPhone Mail (18F72)
X-ClientProxiedBy: SG2PR04CA0204.apcprd04.prod.outlook.com
 (2603:1096:4:187::16) To TY2PR06MB3056.apcprd06.prod.outlook.com
 (2603:1096:404:a0::20)
MIME-Version: 1.0
Received: from smtpclient.apple (2401:7400:6004:e7db:d8c3:f270:6738:18b2) by SG2PR04CA0204.apcprd04.prod.outlook.com (2603:1096:4:187::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Sat, 13 Nov 2021 08:17:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e181f60a-b608-415d-201f-08d9a67e1412
X-MS-TrafficTypeDiagnostic: TY2PR06MB3007:
X-Microsoft-Antispam-PRVS: <TY2PR06MB3007D23AE0809FB01F5288B2A1969@TY2PR06MB3007.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AKxTrVD9KWtrWbatdMMSpXEtMivtHCHwkSurinmC6Y0yxsmUkcrN+QO4dVCepjG1SDfGg4L9uwTtVJDpCC+1oDbVx9l48gNLAr6z5PaJAK066Ra5SBL1mftBmTkUFnDBLcxIf6Ff/ReHNubPWeEXxW6XBCSOswCKqQ3R4MoVRGQs2aFu04E0tygrJ+uKGOJ2FmEMqcEvVUI8Z5TyGp38zSP7qng3gZjreLhAwfgC3LFIsgjpCZf9GxtkGmK5eNmgMPZvKFFKpoFJTDGNjHdmOSqzJ4UqNNJ5xDE7cgyf0iID+/Nd+ow9Zr8xp1bM6esuMd42egN4W8oEC4+yAo0SDOVKOvjibHLsFjp+927iZOPHogLRdguOFxWDT0LFRuLhj32tIPtpGiUTrk8bBrv00kICPjKBDHzNEogYd0Pl9l5n+gUrrOu3s3rOrEsWTA7V3HE7c5wLgkdEzjSvxlLgGj0yO+Vjtzw0wLt2hNVktyaQvl9a+jRAQR/FBIL5E2xeANvWOYNmVFcJw7APNgz4VUGMSZsGcQFTaJ56S4DUwnVJBA7u+TZlnOhVHPwfL2yZgFilmbglHY0uQkJk3KIw/ygTg6f/4xvIzWd86casuf+eA4CYRFQfYXcvDNBUQnxljCJniNepFPoPVXxs4SW1/SbDBaZwvxIzxXw6z57MpKRCvv2+OPRO62M8B5vs9IAp8gAYfM+/z8qsDCLJztLQ/Oc68LxSKlOoCf9GkCOFdCc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR06MB3056.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(316002)(786003)(6506007)(2616005)(4744005)(52116002)(33656002)(6666004)(5660300002)(186003)(3480700007)(508600001)(6486002)(6512007)(2906002)(6916009)(8676002)(66556008)(8936002)(66946007)(75432002)(66476007)(38100700002)(45980500001)(36394004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?arVjVdZfIQ0cdsnAKlP/WOvmIaiT7ph8pCjv8OZsPAjiFgQRKPbD2Tos0gD9?=
 =?us-ascii?Q?jbpnPlkVHQQ5elU1iJNC5fp7v+munixaVutqW343UjHmlJE5RcXnFwcq1Dcg?=
 =?us-ascii?Q?W/mAldU18wMWLlKipX+ZWImW2Lk3dtiQhSp2xFt/KpMNIRLiKH1xGU4zVk7g?=
 =?us-ascii?Q?qdHvPsBGDvm3dM/grTYMOWZa/Ei64EPxBhI6l97LfybA+lXuJYzswQ1ftRKc?=
 =?us-ascii?Q?CHYFx8U6VIZ/7DY1zuHeA64OImDx3cQhZyuOqtjiTs0JYEOynJyVVo4H380o?=
 =?us-ascii?Q?Z/GJ2YO0p/Dg+UvZ88UFQUnccJgbVvzZ8Tx69gD3PD9q2yZZNWjpoRZF7Ffv?=
 =?us-ascii?Q?YWbG4RKSbkacoLqImTNmcNG4SbphN7+dejIY5kqO2wpGz18CKggTJN4C37Kv?=
 =?us-ascii?Q?+uvxIE6gRqUgaksmK+Sk7jRoFMwjUEY9WRjFI5XMF89A3HXv1/GdWaKS+j/I?=
 =?us-ascii?Q?HmhE5Y/BZrh9tm6vJ33ITcFh5Jxn12+zEX8tpWk0BmRoqtLm23nWhCvb9Cry?=
 =?us-ascii?Q?dvWipSrzuOF2X0nL0omQlCwJbTMKScnM/186bDiZVHVGp0x+w41DB0orVi2B?=
 =?us-ascii?Q?phs8GA8/kfFE7QKu8AtZpXIXioInEvReajU5lACGQaPcqZ7iWQUKDYS3rBCv?=
 =?us-ascii?Q?SkinkAofHX06wbRpoiLqrec0WWEYQj/Hd+qMO8IgwR6Bl1EZbUFW1ZLEQGgF?=
 =?us-ascii?Q?87EUlAJYqQWbNyYPNyidLJnCgmdHrl85ZLlFOXsBdWdE5b7Bqz9Qheotxouo?=
 =?us-ascii?Q?GRjIW5NY4aT6KilX1rlnIKD+C/rMupQNzqcRxawLvoqMpqkwYMMDxqRf42k/?=
 =?us-ascii?Q?fhNJMhCbnuWvdiRzSgvCQHk9S7FYO61gGlJJ8rpIWFS27h5578exfp+dM0Ja?=
 =?us-ascii?Q?hvGOkpdmngJGiPPsK8cKGhq6J197+AWCOyY1cdBte1aU94Ox8JRMouJ4RIVZ?=
 =?us-ascii?Q?eG4G2nbCWRYumMT4BXkUi7QCKaHg9yVZRyGuvXr54xCM22/VaMKLam9C3Ob8?=
 =?us-ascii?Q?NpQvSVPzqql/abIVokh6DBP+rL0Le8x3/a6SWyqBLa0/8oFfIjpRDgnRLMOC?=
 =?us-ascii?Q?KPoadvKKyFXG+nqKsrc/ZLqO5kYIGPMBrdPqOox+hDPAGZgUNaOP7+cp58hS?=
 =?us-ascii?Q?BCNAtcHP+UYuSHGGkTeDjbraY2TFW39Si1V2JlM19wAZ+N+d2PkAWmGLOnTl?=
 =?us-ascii?Q?bm1gALCsscJE3jBH9beDrCN3h8h62R4xk+/ZQ+6gPyq+aJJlm1eDDD664/np?=
 =?us-ascii?Q?pX+KaDV8kD8XHhsOi0oKTGvL8Epvkn0gQWOLvnTq3+Vkjq2Al8s5QUW2MHSI?=
 =?us-ascii?Q?xo2RFl9iS8vIE28/kQGBzEldA+dxgBnA2T+E8MReILyiW7VwlQBBRf+Env3r?=
 =?us-ascii?Q?5/n44VglUJfFvzjxH+1wTWBFueQAZYv+74slGDXhfwMijuUoATfiG+GMLzA9?=
 =?us-ascii?Q?1OmRSctZrVzOeUbjK289oyped4CNb/mIdMQ2jowztF61ddPrpTXnsGm9JDVU?=
 =?us-ascii?Q?7igB19LRtonebWOX95am+MmzBu6H0/McS2uMgItGsM10ETPXaLMMkDkv/yQM?=
 =?us-ascii?Q?+WFygfYPmmT7mOBXzr6dvRkbIpt1rL0tFb930Q1n6bbR5EnRyLSFA/mTOtCG?=
 =?us-ascii?Q?sVKTRW9KHx/4ZnVYsXSzwXgiRkz2MJ5wZzxAoVyELlGskH50GrCwzMhVycyf?=
 =?us-ascii?Q?Yb2hL2FLtkvPi6aV2I6y/WO6BqA=3D?=
X-OriginatorOrg: u.nus.edu
X-MS-Exchange-CrossTenant-Network-Message-Id: e181f60a-b608-415d-201f-08d9a67e1412
X-MS-Exchange-CrossTenant-AuthSource: TY2PR06MB3056.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2021 08:17:48.3407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5ba5ef5e-3109-4e77-85bd-cfeb0d347e82
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b71BSZSbLX7tBOuwNxEZ7qc0rr2b7iMXfmvj7rwBhG6UPO/R7lcsfDx3E8qSmlrQrTF6EbanpQosdEkF9vBKcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB3007
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

My name is Deng Kaisheng, a graduate student in National University of Sina=
pore (NUS) now major in computer science. I've read the introduction of you=
r organization and I'm quite interested in what you're doing.

I want to do something and contribute to the community, and I wonder if the=
re is something I can do. I major in computer science since undergraduate w=
ith a solid foundation in CS, and I'm also confident in my fast-learning sk=
ills. I have programming skills in C++, Python, Java, Objective-C, etc., an=
d database skills in MySQL and Cassandra.=20

I wonder if your organization is going to take part in the GSoC 2022, if po=
ssible, I would like to contribute to your project in GSOC 2022.

I am looking forward to your reply!

Best regards,

Kaisheng=
