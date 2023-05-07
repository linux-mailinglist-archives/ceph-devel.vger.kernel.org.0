Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510436F9ABF
	for <lists+ceph-devel@lfdr.de>; Sun,  7 May 2023 19:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbjEGRxo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 7 May 2023 13:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjEGRxn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 7 May 2023 13:53:43 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2101.outbound.protection.outlook.com [40.92.99.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953802D57
        for <ceph-devel@vger.kernel.org>; Sun,  7 May 2023 10:53:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cR8WBqlxlJqI7UEj77R47so7hR5blckm6Q2+4LbmwW7sTFjEAuRCooJwJ7wH8LbCjpostOc06fs1cdJQCJr19qhNPWn49XfUVFPIWl5YA3fR+csDaXAsqtXFLAXReRDi1ws3maU0zW5gm0K607IV9B2VpwVQkjiKy9CO8NuBWFA8imF2NQpbKwhx3rpg3Dk5/UpEZAKf4Ma+ugMO4vYd7bc74O8AEc4tvJIy0gGGKUsFhnZMxmzBQwVAmMQo7zwbvMk+Gy6DlqSapS4Ez10eBSUaJ6yFmu7EYYMIIwpwjho5sa2eopKd9vy6/N8BJpLgGRFRNb0JWlNvGbCVFIcxqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rT1DJOD7FmvJT0n3mxAb+uknX/WG7ithkJTMQvCrr1k=;
 b=NXfyGxPBoGi3g6D9UAjQh6opDPImV8usoQaQKmBWX6vJO3XxVORor8OuMBO0TpBi9qgUuq11sbyr4mv5NkFgJH/WoM7XsgU9vr9+R9Yl8QIoj3aGtcS8jUO1REQGhX4Gi03YqXLrZYJ8ivftcA1bCzJlyd1TuN/yQg402lr4zQErN5TCgSuvnfZ9zftchJIKid0GuI1o+nxvO6g2irq0D3ijwWxY4tsRQSC/TFi/9fPTDUjFb/QULRGUgl0rI8jbmADD7PBTuvu7b1me1RftMBCqnxvS3m9dTI6pmSENYuxiD1Dsdri5M2rDFnQ6Fmw3VyYLrBlSImKyk04lKI6X0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rT1DJOD7FmvJT0n3mxAb+uknX/WG7ithkJTMQvCrr1k=;
 b=H93IGqLDpXjfF40lpVdNmEaNBoorqSTbC86pQ1zfbUUcYmWh8dFh5nRwgaIibkWUiJuNEInI3AE7C/BhBmarWuBWhnOBx/aty5ADO7bJbqAw2HCjDjtYRtgz6H+FoSZI3H7JbjmWuK4BXLkphEo802vv/TQwz8P7tYtWUZ9qoZmxTKreSBKWDUdZ/9sKj9r8zXN/CGjPwjTitKQ3sVzXIVGVxqCSCrC5PLWLU0K/Hrcy+fHctfSVGoT+I9EfabUK1oSoUHtSjMzUlgdJzQF77vXU+Xgk6W1wTBlOSs+bDIViWmQ+4YHHdlT7RTmRhfmlGuuVoLHEvhSZtTzvE+gVwg==
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:152::14)
 by OS3P286MB2567.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:1fa::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Sun, 7 May
 2023 17:53:39 +0000
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44]) by TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44%6]) with mapi id 15.20.6363.032; Sun, 7 May 2023
 17:53:39 +0000
From:   Hu Weiwen <huww98@outlook.com>
To:     ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: [PATCH 0/3] ceph: account for name and fsid in new device spec
Date:   Mon,  8 May 2023 01:53:00 +0800
Message-ID: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [66Atucu1z4JHINj6O5s/sj5qYwFaqOXN]
X-ClientProxiedBy: BYAPR01CA0028.prod.exchangelabs.com (2603:10b6:a02:80::41)
 To TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:152::14)
X-Microsoft-Original-Message-ID: <20230507175300.2253-1-huww98@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCP286MB2066:EE_|OS3P286MB2567:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d958035-973c-4a7f-0ba0-08db4f23fc16
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r0rAteu7/TbY12BkI942j5oBHqM0vm0mIHcb+HoZEHXxNQmpCLPq9ZfaBKX0+BE8Jjxv7ucKTAwaCq1ks6EVxwfz4NTg4m4pzWa1C2Ie0rLPIt4/KO3WieDQw1KDazPOvys+FAUnayyew2ug26MijI5B9QfOAg86n/1fGPX6E8V7rJq25o9SLH//urrutpqBgNl1Qf5FCJ8bvS4rbavNXZU4KG4F3r7hWFKxIGfT5+JoL5fQySbEgfjPkURK8uWQQRMa5+lU4QF1LpEOs0iqo4Bd2XylR5rExes8LXnKDgwgB6erZTXQZerKmtjGppWApv47hVFf8sA/dCgyEWJlg+HnE7vy+11dzGaoz/7lRj+qlLycNrAJOMaSXpX9Tmh0U08qSFSvpLFR0S4yEf1sTzSqxDfUf+7fML1O0zikdgyP7y3k6jvCc2OLDx8+DVKMcN9VOgW6wk3HuyqeRhFZsVBidt9Al2CWkyMrgJ9B9VLbt8hBg9l2yZbaxKB3nLducNxCZoGMauwxGaQh6vfZ9TsqPH6UZHuMyRwmk7D2HZAjnmdCHaQuSRyh2u1TboMe
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZAbarix9NhC83Db612tmLBSyNKgkKuA7zdAOHMDsV5v2XH0IwfKiRBH0mEXQ?=
 =?us-ascii?Q?id/JpIkfX+iwfXIjGUFFYqDdJBHCc+TjMu/B3hQHjwkhw9aQPodHwgCd8dkQ?=
 =?us-ascii?Q?afsaVP0sp67m3wojvOB4HgBzy23+69nVsuS87vpB1jWO+VdYMbYyrJoRlKHF?=
 =?us-ascii?Q?Kjkd9KU8+cY1T3GQJHAlyJnYPt7sb7ofNg3qesSLQufzo9p65r6xoQLW9cDk?=
 =?us-ascii?Q?tLxqWuoJzxEgduuAbmBOSwUNAtvn8y/Km5dr9H4a+OXJ0lqnii80Y86xZZBn?=
 =?us-ascii?Q?zytv4F6H1kYbB3Pr7jJVWtjQKUDP35Bq6aktcEWiOnk+f0KZzWH4Jd5oqDCO?=
 =?us-ascii?Q?Jo7HnbkqaPzlMBocuI2ZttvTmv2aC806eruzJU+DVhlKpnqmmAO+8g5M8OED?=
 =?us-ascii?Q?AZF0h7w1KOFYqW0KSstqMLZ8b+EjF39iBTjg+KN7hofCc5CZCJtIc6LbxnzX?=
 =?us-ascii?Q?S080php4gZzXhYo+LgWn49lStp6UDETl2lPTVfsJQMG51m56Z3mvL8d9/Pkh?=
 =?us-ascii?Q?lNwr70+kACErLEmkHoL/wUjccMxLjYQfKHaCdl4AM6CUlyOdd7DNRW1xSh1i?=
 =?us-ascii?Q?wiaEPT09P/ddAsUY+HLda/ucpjnam87LMoyQrYNk0wYNVaMH5jV0nTlwSTzd?=
 =?us-ascii?Q?R8uYrFqlJw4pX7TX7+KNFWlihFROrwalXSf5hPBUKo9zMTHZ5GHqE8hd6wow?=
 =?us-ascii?Q?/OydZ4hvF9FHyIp7wINbRkgxajtFK+6WhfyRTixHXE7Wj4CgYQO5iWD1Z6c6?=
 =?us-ascii?Q?TTXzevvSQfGu/wsqfmjQvaehSRvizIbE+UlUr5Glt9TIc14pdEn3ObBF/JCU?=
 =?us-ascii?Q?u0SoATB6oIP3GNnwceoVf7mXzpX+EvMPH0CaqZigTlcEJZAhnvCyntsUezhe?=
 =?us-ascii?Q?jUkFG+XhybGkbR9/pLAHQjFs2R5MyCDwKMcAmIrtg/G5VQsuZLLSnAfERrxq?=
 =?us-ascii?Q?ibh9LFCm3cVVSrEzR12utzEoLfOmQLK5wf3atvQ6xgJknlOvwt1RIBXl+reH?=
 =?us-ascii?Q?4BS5JAgDNsM8JMo8hNvLjPU/skJ25cqFqt6FE+IYXBmu27xVsxXvGxaPiRzu?=
 =?us-ascii?Q?lj+rPZPk4ba74Ayhl7RDnn0K6UpGXQ4vpFgxB6B8NuSUgFsWK/7sCYh8In1y?=
 =?us-ascii?Q?e5rUd4t9SB5tU65V4YkJIUtAug8aFH9leWRslYWJGD9u+C1jBjmc/2TUFwyH?=
 =?us-ascii?Q?lnhFwGfbLpu943AJB/yWEfJTgTWe3Wye56Fy8g=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d958035-973c-4a7f-0ba0-08db4f23fc16
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2023 17:53:39.4510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3P286MB2567
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Hu Weiwen <sehuww@mail.scut.edu.cn>

We have name and fsid in the new device spec format, but kernel just
discard them.  Instead of relying on the mount.ceph helper, we should do
this directly in kernel to ensure the options and device spec are
consistent.  And also avoid any confusion.

Hu Weiwen (3):
  ceph: refactor mds_namespace comparing
  ceph: save name and fsid in mount source
  libceph: reject mismatching name and fsid

 fs/ceph/super.c        | 51 +++++++++++++++++++++++++-----------------
 net/ceph/ceph_common.c | 26 ++++++++++++++++-----
 2 files changed, 52 insertions(+), 25 deletions(-)

-- 
2.25.1

