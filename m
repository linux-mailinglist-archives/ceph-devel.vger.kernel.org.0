Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CD77433B6
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Jun 2023 06:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjF3Eoj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Jun 2023 00:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjF3Eoi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 30 Jun 2023 00:44:38 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2046.outbound.protection.outlook.com [40.92.98.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA702116
        for <ceph-devel@vger.kernel.org>; Thu, 29 Jun 2023 21:44:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHw+VkmLihhtzoRmT3uTBL4y4bWhkjBK2hqKacD+ihwhJYxO5Yg27fCPXdQMZCR99Xi4H8SG81rsiXZzvBcMLSX3TX4JozDU7bQbGEzlOgn1BOvcXBhD5Ls+8KJWtvBYhLyydaTpXQrFNCdEC/40/8rh8xzAQcV1oadQyQ1InQGEVC6TrNGOqoAzJAR/TZsATULgUx5uBeejV08HAnLp5g03GL54PA+VgQZwym3L1jbIDETqAze97bHfri9GX/QCXXtKDpJxYUdCuj8yczJZdWG5BPJC2Y4z4D2hO8kb/MTSs93bKukyPC/M3Dj6KZn3zYCBz3mFgYEV0g55OJtyzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aIXBsLBp57D5SooHz5v9IftuX4KxdMx2KZdSGzWAdag=;
 b=bMDxnjnzyzMlq5PkwrYEX+zxlUilBouyIm+rg6ePFgQmoLM1z7KhcqprqUjmWaA39zoSANl8Y/Mlcf9PWqhfCYIL/ON8vHmVxofoktQEV/cD3ZWQlxeYawI2oNzHOKKLlPeNWKXxwWZzaEDXiqL8iLyxvdXncAV1HWFTd2JZ4nKfok8x8OFwhvM7AWd/JIFRciEdWDQRFFU15z1hf/xSveMEdFjxRsWLZjita0EhfhvX9pFlxdP6zxoMUd6GfErDfIy8XhMk+yZkTlSLvm6C7839VchqnFhSTrdRrbZNt1L/ydoIUWbr0pfrj2vOO7fIT6dpkKA5ApdcVBwtVzN4dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIXBsLBp57D5SooHz5v9IftuX4KxdMx2KZdSGzWAdag=;
 b=kQhHd0DZJtyBfIaQCyFqRfDyHgjvCfkYyo4hGWZjsX1JWkZM/Oe0qptsS/5taaGhMwWVXFuMHtx24eK1TDAlgxsFu+dkfgpM7nH/PFxnUA4XkM5LmvgPMYZvjEvIEIkcbTKnZodETw9rpQywKVqri+jCPv8YerZFVwK0tj2cTRoCpWWtTvr/QLD7lx+fsh9TLrBIunCKMPj/+anDYjFxjLvy2cmyloD1zirv7WVkgxkg3OdBf1nyv53uESJukhiIh14KX+hjRt2AUBWUgnRavikzpKpfRgA7RANozbB4addsYTJMcLuaxC6mHp18kKkQsiS1EQU1vInmzre/byvTHw==
Received: from OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:180::6)
 by TYCP286MB3283.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:2cf::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.19; Fri, 30 Jun
 2023 04:44:33 +0000
Received: from OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 ([fe80::3bed:4407:7f3d:7387]) by OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 ([fe80::3bed:4407:7f3d:7387%7]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 04:44:33 +0000
Date:   Fri, 30 Jun 2023 12:44:29 +0800
From:   =?utf-8?B?6IOh546u5paH?= <huww98@outlook.com>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: Re: [PATCH 3/3] libceph: reject mismatching name and fsid
Message-ID: <OSZP286MB2061223922A5ACB181D34336C02AA@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <TYCP286MB2066D19A68A9176E289BB4FDC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <CAOi1vP_zuTMh2jE9uc89EfTroxkY1YBfOPCMBreKNtDMXa2nRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP_zuTMh2jE9uc89EfTroxkY1YBfOPCMBreKNtDMXa2nRQ@mail.gmail.com>
X-TMN:  [ZExteFWFkLYYM/D4NdIBtAFvxJojOg6Kpaxnnzg/f6Q=]
X-ClientProxiedBy: TYAPR01CA0085.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::25) To OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:180::6)
X-Microsoft-Original-Message-ID: <ZJ5dreps2ypD2JsG@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZP286MB2061:EE_|TYCP286MB3283:EE_
X-MS-Office365-Filtering-Correlation-Id: 576b1147-ba50-4703-7eb4-08db7924b2ed
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3gYHtzLXpYEGB/J0XY1zQOLvkNY7RPEgPBZhoqIe57ygbTu67Lei0Va7GywLyPOK58noKEHJ6KLLeB/XbeSVh5e/E8Go56GwSLZtvTjED0Nfdajs1N8CoH6l2pJxh/kFo6bTIoUmV7Z5Bkka8rPmEA3cKu2427uHd/ZwmySmYn29bGzrH5d+PUokr5edb6SIltsAtPcjWWhlQ68uFW+1Zis9/lHfONAmuVU9G5UEUZTFJCx/aRyCqU6yqcs5vRukQinbUKMre/F06evnBxamB2CLq9W5qHg05LHkVwtSvSTtbJnbU5xawqvYRGpXgPC8tsp/aO152zEugHm+jjM708e7Y0B4mYUqNpxz7Ipfs00/MkAImCB5S0kiEbHUM4G4Teu81nhaYHGknV8TplTJaBgMNP8aqgV+Dj4LKrQUepJtygadY2pmskDL9t/fky2aK8DBiH9lY1H0L5cUp4S9jWTUC/SfJdvBZ3da9weA4FMraObuvaTL98J2WJJwob73zyTysoXl3TqE0MmDt9MM/+WpyEPxSMf09M3aih/23HSwQfK2G0PvYfHCjOmDTOvg
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDkzK09hYlF2RmRodHJpQU16cGVYLzB5VU44THJRL2xEMlZVVFJkd01XS25F?=
 =?utf-8?B?c1hIYTFGd3Vjc2k0Y1JycE9xMC9iaEZFZWo2elNFVUFkaW90RVR6a3NQYmFF?=
 =?utf-8?B?ZWF2OG5SY01Oa0VuSjZITEg1UkF6RUFJemlKbjdCUk0zSlNNYjZRbis0emsw?=
 =?utf-8?B?ZkVBNHJtS3h4TVlPNE5XbFNqZnBOMEZzcElzWGFoZHE3ZnRIaTNmZkFmL292?=
 =?utf-8?B?aUhzM3NVQ0FFMG4vbHp3dE9uTXhKcHY2b1FDajZzN2pjbzV6Q0xBWVFKRGk0?=
 =?utf-8?B?aFVKYkw0czl1OGFjcnQzYzhSeXc1RVVTN2drWHoxWUdzYkxmMHp4UTFiWXhr?=
 =?utf-8?B?VmIwWGdPaWJrZ29JampnLzViN1pXMlFaTVpsQ2NYOExEek5wU2VVNGY0VzRy?=
 =?utf-8?B?TmpBT2ZOZkNYQktUU3ZPREk2em9LN2MyUXdweXNVWWhZeUI4YnN6b3JFWk9R?=
 =?utf-8?B?R3R1RjVDWk9uSi8vL3dxSnFUZGZPbjVnL3ZZVUJEWkNFWXZlRENmdXlZVlRO?=
 =?utf-8?B?WWFUTEpPVGlYMmJHb21PS0ExZGJ5REhEU1pUNmE5enZWZWJRVldDQkUzbFA1?=
 =?utf-8?B?Zmp2LzZESUxDZ1luV3VmYVNXUEZ4ZTNXUldUL3cvUkcwMUlkREVFa3pEWFlL?=
 =?utf-8?B?SkZ3NTJFd0RZeE8yN1dMcW1ydTdUMmsxUkU1emN3V0NVK3JVb1lXU3FVckNz?=
 =?utf-8?B?MDBnSGpGT2loSDZkNStZQlBpSWZEb0xyK0lxTjJRTVdPM3BZem9UV3dYNUY0?=
 =?utf-8?B?aUdVSHlMTTRKYXBRcVRiQnRFdXNDbWxuNUduK1FBTDU4L1NyZS9TSzNvMmpT?=
 =?utf-8?B?V1hrSml3N1I3ditvcWpKTTRrdGVBSHhPVXhhYkNWbUtwZHUwUHY2L21STjcv?=
 =?utf-8?B?enhqN2d1ZDdFbDRTK040T2syUTFaZi9rRUFublFDV3phYlF2bE54RDE5MzMz?=
 =?utf-8?B?Y1pCbGlRak1HNnNISTFZNGxZdGdRNnUvUUp2cEFqY09Ra1c2TUtNVk1uR00x?=
 =?utf-8?B?bHJlcjMrd1I1QkNjSnl5TlQwNkREUW9VMGlUdHpMckdHZnY2US9TT1RLUGNP?=
 =?utf-8?B?aHhSWngxNTZqWEc1c2pHRk1idFpNcVJUaGNTSGxRYmdQaEpMaUtMWndnTmpG?=
 =?utf-8?B?RGxnblFQejk2V09EeHhWaUJQZ3Evai9mOXhYSTVjUWpzYzlEOFk3NDBqSWFI?=
 =?utf-8?B?Wng3enRxVlY1d0M3RStxM2pIVzN5VzZ6bnkyS3NyaXZUWTlpMWYwT2lsT1ox?=
 =?utf-8?B?UEJEZnBoVmJPM0swZ3JRS0FDNnd5R1ZKM0tRajFlRFFhL24xN1MvWXpTK3U4?=
 =?utf-8?B?Z0ZDVlM0QVZqSmlKMElYK2s4RGdmSzFoVXQyVkRKOGVTUE1HYXdVdHU5UWdv?=
 =?utf-8?B?QkRRTHFyRGxSeFVBNS9icHpNOXlTS1lycG1lY041VXk1NWg0MWU0Q1RaeTZL?=
 =?utf-8?B?OFBNc0hlWlNFbE11ZkFiYjlNVkhzaUhaR3JWandsMWQ4NUdPV0k2UzUxakEr?=
 =?utf-8?B?L01URzQxWEFpLy93cUpjQytvN21CZmhGYk5PSy9Ucngybmp1OXpwbUZ6TzZE?=
 =?utf-8?B?VlVHU202SWx0Y3ZvbWFreThPQ2JjUFpWenlmeExzaXg1MC9EaEFIT2hPR3ZD?=
 =?utf-8?B?bUhHQzZJV1gzN3JpRUFHaUFOU0FYOUE9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 576b1147-ba50-4703-7eb4-08db7924b2ed
X-MS-Exchange-CrossTenant-AuthSource: OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 04:44:33.5756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCP286MB3283
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

On Tue, Jun 27, 2023 at 01:47:53PM +0200, Ilya Dryomov wrote:
> On Sun, May 7, 2023 at 7:56 PM Hu Weiwen <huww98@outlook.com> wrote:
> >
> > From: Hu Weiwen <sehuww@mail.scut.edu.cn>
> >
> > These are present in the device spec of cephfs. So they should be
> > treated as immutable.  Also reject `mount()' calls where options and
> > device spec are inconsistent.
> >
> > Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> > ---
> >  net/ceph/ceph_common.c | 26 +++++++++++++++++++++-----
> >  1 file changed, 21 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> > index 4c6441536d55..c59c5ccc23a8 100644
> > --- a/net/ceph/ceph_common.c
> > +++ b/net/ceph/ceph_common.c
> > @@ -440,17 +440,33 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
> >                 break;
> >
> >         case Opt_fsid:
> > -               err = ceph_parse_fsid(param->string, &opt->fsid);
> > +       {
> > +               struct ceph_fsid fsid;
> > +
> > +               err = ceph_parse_fsid(param->string, &fsid);
> >                 if (err) {
> >                         error_plog(&log, "Failed to parse fsid: %d", err);
> >                         return err;
> >                 }
> > -               opt->flags |= CEPH_OPT_FSID;
> > +
> > +               if (!(opt->flags & CEPH_OPT_FSID)) {
> > +                       opt->fsid = fsid;
> > +                       opt->flags |= CEPH_OPT_FSID;
> > +               } else if (ceph_fsid_compare(&opt->fsid, &fsid)) {
> > +                       error_plog(&log, "fsid already set to %pU",
> > +                                  &opt->fsid);
> > +                       return -EINVAL;
> > +               }
> >                 break;
> > +       }
> >         case Opt_name:
> > -               kfree(opt->name);
> > -               opt->name = param->string;
> > -               param->string = NULL;
> > +               if (!opt->name) {
> > +                       opt->name = param->string;
> > +                       param->string = NULL;
> > +               } else if (strcmp(opt->name, param->string)) {
> > +                       error_plog(&log, "name already set to %s", opt->name);
> > +                       return -EINVAL;
> > +               }
> >                 break;
> >         case Opt_secret:
> >                 ceph_crypto_key_destroy(opt->key);
> > --
> > 2.25.1
> >
> 
> Hi Hu,
> 
> I'm not following the reason for singling out "fsid" and "name" in
> ceph_parse_param() in net/ceph.  All options are overridable in the
> sense that the last setting wins on purpose, this is a long-standing
> behavior.  Allowing "key" or "secret" to be overridden while rejecting
> the corresponding override for "name" is weird.
> 
> If there is a desire to treat "fsid" and "name" specially in CephFS
> because they are coming from the device spec and aren't considered to
> be mount options in the usual sense, I would suggest enforcing this
> behavior in fs/ceph (and only when the device spec syntax is used).
> 
> Thanks,
> 
>                 Ilya
Hi Ilya,

I agree. Thank you for your advise. Please see my patch v2.

Hu Weiwen
