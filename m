Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89FF6FC843
	for <lists+ceph-devel@lfdr.de>; Tue,  9 May 2023 15:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbjEINz6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 May 2023 09:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbjEINz5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 May 2023 09:55:57 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2022.outbound.protection.outlook.com [40.92.99.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C59421B
        for <ceph-devel@vger.kernel.org>; Tue,  9 May 2023 06:55:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KruXLyvjJKwfYI4dzbaBuLROFAu/6a3c4lLuIRtEmFpq7FqWSDOwmZFDNwEgEQfJovgcvQc/EwS/gp2uXgpCqtiWA7F7q9lGvEiDKZem1ti/BBtCnP0SE7BjiLgQOCRCbYGe5FC3IQxD9+jTYDzhatP25sMzNcH6pAcjz+9Wz6mKpE2vJVV+UnDuLs5X3zMgdqs/Ab4x2jI/NLTH0cs4w6hI+NzCzFmP4OCQjG+05xKw2DdsWiyaFTUz+TDTThnqr2VNkNNJcf6RybJ0Q0J9CXhl7x3fIzxtn8bDDttu//PyXtE/ShoQCUt/twe9kipZmXmBGqD/r4v6RGCqshjT8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=89Zcs84vF/XzYjwUfvP8cOf9bg0i7LiyrpM8PVrVQ8U=;
 b=hdyDKm6WTxgzVjuFRUSgyh1fuCrPyGKDTtUpCM6Cf2kiXS3q6ipeqMqhCIp93znK/YkPa107491joa1urbjFaGFW4HLRIAIeLmB6YaRctaqcapxOr9rtF/2XMvQDaf14YhCHeVzxXVyKZ2x12Fif5a5s09YeL6JBQF0b9OFc+17e50VR817zq6euV8W58E1Du6aBAd37l5INzsKmXIOJKIC/Vzdy/uqqjvoV1+yegDF+y5wR2aKU09Jv8WQvUMZ5EEJ+aGNq8R5ubxbPdKeYxKRcmb2M/hLu25J4HwbKA7g3D9LHSOfoCw0f0O8As1hORl14ETsBJdaBA+GshCgBDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89Zcs84vF/XzYjwUfvP8cOf9bg0i7LiyrpM8PVrVQ8U=;
 b=Ul1nHCy/ezixVv0bC6NaseizMxiM6Jlm4t8NP3B4dNSiUWhS0vTa3Hsla8PWAQk5IMRRmVHuH6cXSPVydcFYqF/RqeaN0EO81KTkSrt+vCDyXR5czN4vzyzB7mywPa3qzUtK9JNCGxqfa3cMbb4v3tuLz0Qtsrjg7TaE71GbtT4k2f+yy9C5JwAnM6W4nfQnX40jHQmn6AEYYeE0+CP4/HXDmDX/yo+2hdloWHivBnJ3BPbJguXTIvZ/VZVfxsFL7O3t/mxIbz2E7zAqkCXYjCp9PLhI28Ge5nr517cqEA0yTZXkGRdxG926pYzmUctnZJ+Asy4uCER0gAkVFNsu9w==
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:152::14)
 by OS3P286MB3324.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:20c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Tue, 9 May
 2023 13:55:52 +0000
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44]) by TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44%6]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 13:55:52 +0000
Date:   Tue, 9 May 2023 21:55:42 +0800
From:   =?utf-8?B?6IOh546u5paH?= <huww98@outlook.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: Re: [PATCH 2/3] ceph: save name and fsid in mount source
Message-ID: <TYCP286MB20667D17632479D0BFCD48B5C0769@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <TYCP286MB206604655F7CAB7C50C6218FC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <1c6da9b7-f424-1713-23a6-15999d954f28@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c6da9b7-f424-1713-23a6-15999d954f28@redhat.com>
X-TMN:  [nwpTcbiNqmgN1oZJKmM4UarGgVomkCk9]
X-ClientProxiedBy: BYAPR05CA0002.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::15) To TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:152::14)
X-Microsoft-Original-Message-ID: <ZFpQ3vG2BC0j0xBV@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCP286MB2066:EE_|OS3P286MB3324:EE_
X-MS-Office365-Filtering-Correlation-Id: eb690026-b047-47bb-37e0-08db509519d3
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ut/VzUE3UK7VCWaSKEJLvU0LNJtEVn0+WUvT1Uash6NYGtJR4QD3ReCb97ax6xkT/Bzrc3jmwfXWLNjA6y6K7a+8ve5XRtafoEuCIyFaWrBHeLXXmk8LwG7Hxlh7Roo6NA6/Yz0Pv2782HhaLyYTD9l74BenmIA9d7d0Map+tlMI6WS7f0iyUNhJJmubCkKsOwCAXl3LXFBDQFJfalSWkZU0xbdVV2+ZgrQ2ou2MZhqONmyDD6acUvjIpJlAnxEUgpXSgb4uYtkwG7YHgMtShsVdyJ525tDjkuIBnOMBD0e2TgkYHz8T27riH9mrIOsJ0INOjQDPQUisrkdgK8++K7x/AKXG8cQlDa5IryGpcOaZokneWbLHk2wzNUeijydQhCvqXmkw0Y3/eN0O1eDpoI1Tk/dCXvE0XKBUvwXa4IdRCGdORMbcO2BoOIUpTnjqSk3tiveMaYjiCTCuTINvG5ujxdnz4ds7ndFRGTKWC416VhVk4i9tiJ2ey8iTnTckKEuh59lRFMG0QygHKvvDtVoQkXXXGSijpOzUX9KwfsXUJ5G1Efn+VVjDQHMlrUH2t+3iug/OGIN5XldJ5gD4gCilHeoBzXtELA8iOPr6qfcDF6pbIop2SjGUBe7XE8o7
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jGpDJ+Ifrwa3WYb9oFb9cy1J9glc6dzoQNLNyXilIOYjnpuUlDMYyeHH7Hv1?=
 =?us-ascii?Q?Zp7QZxiS+WwYI0Trt+XdUJHEi0WOZRgFkGsrtc/JT5iRK3icbAP9ypvLhHF+?=
 =?us-ascii?Q?uKqN0Kw8NW6DVVfxTonSaL11Tcjo/pIKhsO9jR5WzWV46Lz+fOulr7AQlbbr?=
 =?us-ascii?Q?3UjURaPwtkwwkduRMFphjmacRv2AqNugYIfV2UqkYeXoMF8GmM7qa8HliaGd?=
 =?us-ascii?Q?gdpPhKzNXmifzvUZflr+5K1h8eXXB0XssyfIoU/FUR/sSbQ9xU16ccpfK/53?=
 =?us-ascii?Q?JlbMol35PvC9rEIk2bDBeTWYM9HjhKGifrI9gBMjaxQLPFmnaAdo63Buwllb?=
 =?us-ascii?Q?SymQBMLyCnfsryNYryK4J1pxiyrqt8hxeE/q1oxLLQD4ChqP4QyxDcBdhmnq?=
 =?us-ascii?Q?2+5yRTGdnfjQq53WrDDTrHFIPOjDt6AxcFc0NoYwE3O2n7+kMBHpFNvnwYGu?=
 =?us-ascii?Q?Udp/Nr5/GBxFbULRCO2n2DWmwgM3LhOl/JvUc94K7cvPboBl4HHpKeDstWS7?=
 =?us-ascii?Q?6RpEaBaX91mfQ6ynU6y7jko7f0zNc2VMBlk3IZ2tn3ueoXRdSvDbOYFcd4GE?=
 =?us-ascii?Q?mFs7/y2rUDyfnQ7K7kwz7dKsUxmNTFWkcViOLi+TzmrfuO/DdRGC/6tU4Oi0?=
 =?us-ascii?Q?YLnPXDQ3kaylTMg8YiCzgq3izeCEvbyXP1RW8bi/h3SKzmeVhplqMgnG4OVQ?=
 =?us-ascii?Q?ymmjuhNohENtbDBAa8D6ECSr9aW9tkaEbjdOUEiq1TV0fFholdblJzmnTmoV?=
 =?us-ascii?Q?RLpUavr2pQVAFoIzJBS5XnNpeK31NXg913rXhdimW9hHP9aJjbomaCVZmxZa?=
 =?us-ascii?Q?+j/EtmqxAWc1uGRjXvLIAqgPYrUeLfrzwpA/VDHWxU3Y0hRCzxA1h6Y50XBF?=
 =?us-ascii?Q?97MLJrvVd/LbHzfg8emV7jYPlhEiyzRy8miGicO6JCVa2f7DT5gbc92UGxfc?=
 =?us-ascii?Q?q1KSA6ZRttrHqtWdbqI/AezrIU1Ukui+Ps9HZ076uhqJxzGs3FeX0u8iXDtB?=
 =?us-ascii?Q?QFHi8gaLKWr4czQob4GfJGpRuFU2ukaXsLytU7onsXM+mUdnZNY7Dds3gsOu?=
 =?us-ascii?Q?8fo3M7ak9iFbi/nej3O63v72r+cMZlG6AuclQ8Xbagi54QHEbVGCKzi2EB4N?=
 =?us-ascii?Q?d9Mzb+wYCQKXl+dKTjD7wIfQtDGS+WVAgVKTlI2w3jLBD/Ytz0DM8ct5rXo4?=
 =?us-ascii?Q?oem4Ti+P9UwIgqiQ87l9CFgRIyAYLlj82BxcSQ=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb690026-b047-47bb-37e0-08db509519d3
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 13:55:52.2971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3P286MB3324
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

On Tue, May 09, 2023 at 09:36:16AM +0800, Xiubo Li wrote:
> 
> On 5/8/23 01:55, Hu Weiwen wrote:
> > From: Hu Weiwen <sehuww@mail.scut.edu.cn>
> > 
> > We have name and fsid in the new device syntax.  It is confusing that
> > the kernel accept these info but do not take them into account when
> > connecting to the cluster.
> > 
> > Although the mount.ceph helper program will extract the name from device
> > spec and pass it as name options, these changes are still useful if we
> > don't have that program installed, or if we want to call `mount()'
> > directly.
> > 
> > Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> > ---
> >   fs/ceph/super.c | 17 +++++++++++++++++
> >   1 file changed, 17 insertions(+)
> > 
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 4e1f4031e888..74636b9383b8 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -267,6 +267,7 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
> >   	struct ceph_fsid fsid;
> >   	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> >   	struct ceph_mount_options *fsopt = pctx->opts;
> > +	struct ceph_options *copts = pctx->copts;
> >   	char *fsid_start, *fs_name_start;
> >   	if (*dev_name_end != '=') {
> > @@ -285,6 +286,12 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
> >   	if (ceph_parse_fsid(fsid_start, &fsid))
> >   		return invalfc(fc, "Invalid FSID");
> > +	if (!(copts->flags & CEPH_OPT_FSID)) {
> > +		copts->fsid = fsid;
> > +		copts->flags |= CEPH_OPT_FSID;
> > +	} else if (ceph_fsid_compare(&fsid, &copts->fsid)) {
> > +		return invalfc(fc, "Mismatching cluster FSID");
> > +	}
> >   	++fs_name_start; /* start of file system name */
> >   	len = dev_name_end - fs_name_start;
> > @@ -298,6 +305,16 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
> >   	}
> >   	dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
> > +	len = fsid_start - dev_name - 1;
> > +	if (!copts->name) {
> > +		copts->name = kstrndup(dev_name, len, GFP_KERNEL);
> > +		if (!copts->name)
> > +			return -ENOMEM;
> 
> Shouldn't we kfree the 'copts->mds_namespace' here ?

Seems not necessary.  ceph_free_fc() will take care of releasing the
whole 'struct ceph_parse_opts_ctx', including 'copts->mds_namespace'.
Besides, the mds_namespace may already be set before we parse the source
here.

ceph_free_fc() is called from:
put_fs_context
do_new_mount
do_mount

> > +	} else if (!strstrn_equals(copts->name, dev_name, len)) {
> > +		return invalfc(fc, "Mismatching cephx name");
> > +	}
> > +	dout("cephx name '%s'\n", copts->name);
> > +
> >   	fsopt->new_dev_syntax = true;
> >   	return 0;
> >   }
> 
