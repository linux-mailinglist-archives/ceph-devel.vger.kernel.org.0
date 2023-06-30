Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D912174338F
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Jun 2023 06:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjF3E14 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Jun 2023 00:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjF3E1z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 30 Jun 2023 00:27:55 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2021.outbound.protection.outlook.com [40.92.99.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DC61FF9
        for <ceph-devel@vger.kernel.org>; Thu, 29 Jun 2023 21:27:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6pK7e7h+llzSr8HN7uR0YHzWrxAdERLGrnC/vsr8Yfn2szdtzwkoWn4SCSs68RcbiQ2XEYip/+h804w0wS9xzXpvl7mcWLowgfGRxdmPzl0VPUecff0rWoySKv3bAjuiFcpHVOlwy/JAhVGPsN2E4gFcaLSk2k4jHca6XCmiRYRmcg2HjUkWfzZtHjaZtDREjUFA6xoBzTWKNTINxzrc+NwPElqebRyUQF79g7t/H9q4TMchAPiIfvv6xKmKomS2+G78DWfZfXB8s15QkT6cQPYNEoy8Qe3Qujbhtxrf/JwHXBRg/4gVotV6o4GNFAYQ5igpVxXYHGQaN+CLraxZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lMfM5gVB7hELYWxWyWGAkSsOZ5IpqDp0m2dklpUfTuc=;
 b=Ut3S+oVLfKSSLBBYyzJfEqaZeV33vPEgdeK4rCpHdxaRmg6nTQjjIbSk9nu/cE8jXe2d0ThZjbBEZrefLxikJGO7BPETTStsN9oNnlDOXTvpMKArZewCoLQ10N73lQm1NCqsT2NS+ifu4DBZ0VQBrKemdkGxLu2X8gI5FfsT19php6Ij1huw9KRgOq1yHN6FYm8D3cLgPkacoCZik51wJE5zIjA1BuHzyKz+1vnGFVjfyS8Jzz3WDX9bL5VA966nD5f2QBA9Ny+1sLNZUBAA+ovIDVm+i7O24aDcINfp7QPe5gyG89pXUJ/mdcpAbXMvF/EgpZNTROD5k9Oy/ohFHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMfM5gVB7hELYWxWyWGAkSsOZ5IpqDp0m2dklpUfTuc=;
 b=Ln7YJj8zU6lg+6ncXJ2J18cusorv2/XjCDr3lah8BZaovq+qDjxVgN1wynhOAq2QYRk+vSmKsuFz7U9nGgWRL/IY3/BDyLZz+3rQO/5snIAO0+LjP7LYmN0uJ8Zyo03RkEifOpRDhUEjf7y4aLGCTxtx4+bNaWlMCe5++SQIRhp3gK69/xbcpKdeJHiv9PM6CMEWRY2lortAlwVYWLPQ9Qz7OYxSrzL5c+3vWanLLSa4ECV7CHbKdTjlAkC7dSN+Uw4eUQe5Buk9YS+m8xT93Jx199VzUsYN+Tui1KHTbnj8EUnWO/FtmfBzh6qPBOgLgNbQyNOtQHK/FHY9K3xPoQ==
Received: from OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:180::6)
 by TYVP286MB3104.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:2ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Fri, 30 Jun
 2023 04:27:50 +0000
Received: from OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 ([fe80::3bed:4407:7f3d:7387]) by OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 ([fe80::3bed:4407:7f3d:7387%7]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 04:27:50 +0000
From:   Hu Weiwen <huww98@outlook.com>
To:     ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Milind Changire <mchangir@redhat.com>,
        Hu Weiwen <huww98@outlook.com>
Subject: [PATCH v2 0/4] ceph: account for name and fsid in new device spec
Date:   Fri, 30 Jun 2023 12:26:26 +0800
Message-ID: <OSZP286MB2061AF068B5B9462B1A8E461C02AA@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.37.0.windows.1
In-Reply-To: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [PBU2KvWzf+lcP/y/9Q/bJOo12cWaWgi9v9BRfVBj/FQWsmTnbSbp+AjpAkZeI7++]
X-ClientProxiedBy: TYCPR01CA0044.jpnprd01.prod.outlook.com
 (2603:1096:405:1::32) To OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:180::6)
X-Microsoft-Original-Message-ID: <20230630042626.1653-1-huww98@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZP286MB2061:EE_|TYVP286MB3104:EE_
X-MS-Office365-Filtering-Correlation-Id: 002319f9-fcc2-4de7-a539-08db79225cf5
X-MS-Exchange-SLBlob-MailProps: znQPCv1HvwUykhYCLh9DY1CjAm5WozgfdufPHlfgLwzWMjbxIQIAGwzFW2xEhd7AxQXjYz+vkLkpSkafRFhe6Q+HUrjN+GpsoD/9jxJwaBBhW9uJw5az6ft9xTR3hQh1HBPSO3b7jR2ravdlV0gL5c/5+YuZac95PpmAr36H4RDE68PH7HwYGAm2XFgg4K/zHoVmamifaliDgqI7bJMjj43duS3Qt9xTXcyH43HV3hQN4WN6VX1nBjpit8xlX50OavvpzEGvg6CW7M+ESRS7qxpBft00fnkh0ahRAad+usYWITPcHbsXobsEqsErLZT47HIXRmj6Rd++g+OK16ke6Ea4k0vEGoqIg4T4NdtZRucMzqE0Mf6vMr0hdBz7bh0G7cI/7zti3lyTBRm8ypqgZOmWAUCx1FL7ErxS/tiFBxjeBsXKVM2WsfoHB27ir7xDBKwr2/UUd3AwciPeePDeVKmPnP6/i0IpfCXQtshAFS9D2wCYPXZLPFLxV2TetVuY+hIhSWLrwubWWggHbcJaDjR6mZQC/+1Z/a6IUh+8dcTOdbkULFex6yLepB10MqLA726GQWqQk3U57RCNl0zDx0GQTtfBruVO4/DDVva9EBk3kPty4io7p+8Mg5L0kiDI/RktTn9UIptdsB8n4dqfUG9eru1mSaXLlPad/UR8AnuZ2QtBHcEipR3n3u8HlXPvsNIdVa3tFqysMe7Cg2mve2NoQ658HR2rEee9D4JHKHOf8r4utr4xDvdvfpmMHVF+kHGy8FE5LRo=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kQE8MK9X1Z1aJBVNAbFGvE5fNJtCi6oyfeuzwgmYGG83JLDIi4U9T9OV20Kykx3wjRqKF/LfCsMvkPXoUkCNp1KnBH3NsLuQc6wXke/ssd+x0qyAGwQTfNRH5IZLx767k3dPl6i9GKQ/KWewm2T4VI1zrvT8so6L/03ETpwG5JSHY3zwDH9NDDNwTGLG0gFWZkMFbMae1qW9kXVHWKShsQ14n2eDsw1ukYHQVEuYZV86bDIvY9ZJiVarj7nR50/9XC7D32v31W/d7/FbwqRl4SBL2ZALFaAJHrD/cZGQacVUCBpThwvCwCaiM5caJxSj/VQmW+RfEpd9k2aJPODDa+TaHAXhmUTycMTYFMJkt74Jivr8Zh5o4xlSCRhv6sk1t75uVMapJ8ylEuha9SXIH1F5sa1H3tPJoZLxsfmjcYPWXvd41YqFpzu8cSbPvbQ2eCAAs36Jxd9q4C+5ccrPd/O2f2LeerxtKM+buLc1dR9jCpvB5BKAmXkh5kD50XwKKbzxYqWpCzI+W7O/NT7PyOM0z+Hm3w5xE2vBcLOxDO17GDvbEalDH1Nqt/bhruTD2XwnfpvkRpVkQi365yGyV82nKZ24+6LpkbNTCCitGD9IA8c14NqzxLP8FBE1rHBa
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B2Cuviu2/YrMLGwpsedxJUlUhWuyX9rYre6fh/mnbv8wVhYGKeqKJAcFKM+8?=
 =?us-ascii?Q?Oh2VefB2HAMe8+nPQEBlAvmm+M2X6FCFoXSZ0lQY/OJZERRlurUl2Ho9uc4j?=
 =?us-ascii?Q?alxvMBIA9mhLHcx/kCJGx3d4Xv9syuXXc8hT23eLxITj0cMQSOZymRKHYcqo?=
 =?us-ascii?Q?RQMA+luyKhoTejFyJnkaZ1pdMGsasIk60Vt5QXyhhEhC8cYRaHUHXfm1UzcS?=
 =?us-ascii?Q?/Nh55UHBh2hEQWuxsmYiVIDSKgp/Y78eVcSG9iHD/XCYE618CZsHBpW/VoWQ?=
 =?us-ascii?Q?s/nL0dvwoRnko9V+VmPJJlineO8p+QRJC4CNPgGt7pNN076I2/VEq+rqRJI5?=
 =?us-ascii?Q?JG3JZPwEi/jEKRfj5nnNaVoiZ/sjaI+zniOR8rRJpSUY+iipMZFK3k9WNOwU?=
 =?us-ascii?Q?yzTZsKkXLJUtFJUipmE90q70WtcnJ/z2p6rM2LLPUD/5Npo0DCTPTS+ECweD?=
 =?us-ascii?Q?zE1uhSZYLKpvjwTeyrChI1y+Q0RrUeCFd/hm01GgVvI6dGnhJJSXm3YAVvo/?=
 =?us-ascii?Q?IoNsuN0PvxGdyRfx0cAjRkcXMmeEyTsudYgeHTtR4ZUn4dVsZWuF0rVqgxjR?=
 =?us-ascii?Q?c/ArSEDQMObeBXDmeUChQdkP7FTVDbjUP9zsDytzJ2Pqax9Jp740cXkAAR6O?=
 =?us-ascii?Q?hC1zXJckeNMB0i3qaS3xa6p8Ts8mJa4zPX3gvoCHSmjAXqx40loSqeU3EGop?=
 =?us-ascii?Q?XxzkJ3Zr19MFxa1qe0O+qU3uMwqR/q7Drsb2pEY9wF7gezXGdAmtj/ajVx8N?=
 =?us-ascii?Q?k1fSmXE9/CNKh/iDtnpAKcKuU/SIbqLDBJUObactM6zFJWyGs2anwLXa0OA/?=
 =?us-ascii?Q?Z0Pg+OA9uOaQ1IySm08ZwYQ5h3hexZ1W4yVYS7yqE3qpIdllOFauE4SccuYW?=
 =?us-ascii?Q?Wu7zxvMo6XI1noC0SCKzJ96lFnWD3a72fINnmw1kIz2+dBGsIuMvKEPcZgqa?=
 =?us-ascii?Q?1Nm4WFbY6D2zbGDZK7/N25cX0LDR2o2oeOYiFfwb9a5lY/BBulDRAog5pPMS?=
 =?us-ascii?Q?O3W7hGcmXNK79O0sSeIf4YGlgXZRv+M7jl4NVlzw2+W+JHchUG9t9tkWuxVC?=
 =?us-ascii?Q?5YxTJAbl3PnghTRMRwTlcMXqMBFRaEIIWAJ3EPvW6XuKJa0i+GgpnOhD/jNM?=
 =?us-ascii?Q?Mf92VXidCt4t50ROB3W9OUkLE6XltwEsnQvTQgkwBouxtlyFQKai4qctukgv?=
 =?us-ascii?Q?6dMi8+HjRy3Oa8CCVSdXzC6YPqU70Qml8+HL/pkSEvFLE3Q9jVoMd3ksRK1x?=
 =?us-ascii?Q?uMKlZDGyBHSRdr/dHsHpezUscy4eYgot5xs5yq7k0Q=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 002319f9-fcc2-4de7-a539-08db79225cf5
X-MS-Exchange-CrossTenant-AuthSource: OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 04:27:50.4440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYVP286MB3104
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

We have name and fsid in the new device spec format, but kernel just
discard them.  Instead of relying on the mount.ceph helper, we should do
this directly in kernel to ensure the options and device spec are
consistent.  And also avoid any confusion.

Changes since v1:
* Changed my email address, since I have graduated from university.
* A slightly more efficient `strstrn_equals' implementation.
* Make the mismatching error message more clear.
* As suggested by Ilya, rewrite patch 3. Now it does not touch code in
  net/ceph, I now allow options to be overridable, and check the device
  spec is consistent with the final resolved options.
* Added patch 4.

Hu Weiwen (4):
  ceph: refactor mds_namespace comparing
  ceph: save name and fsid in mount source
  ceph: delay parsing of source after all options
  ceph: allow mds_namespace to appear multiple times

 fs/ceph/super.c | 68 ++++++++++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 29 deletions(-)

-- 
2.25.1

