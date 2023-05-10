Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC84E6FD9D5
	for <lists+ceph-devel@lfdr.de>; Wed, 10 May 2023 10:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbjEJIp3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 May 2023 04:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236692AbjEJIpN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 10 May 2023 04:45:13 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2069.outbound.protection.outlook.com [40.92.99.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BD11FEB
        for <ceph-devel@vger.kernel.org>; Wed, 10 May 2023 01:45:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KMTDF5nV/+MRcLtWYpF68N+BzDWJXTemqeVbewjKHKhK5lAnHZ5aB4YCwCHYMzIqH2Rdb+TiNSqZK7H3LmZatdMdqjr0PG5jAZfE20fSdPLAqFyeiByfy9wPUTs7E+dFK5hizHwgLr1byk0jayhbm6A/8UZepIRTDBsgPRmbJu3HsdkZTJZt1aq3NY6z5BYk5VPRCKm21sDiY1Oif9u8ko6AuwAVmvftOqAjKO0it0g4NQ0Cn991fK0afQrvxooQxJlPkf+NLyBuRu8pAywHJeoEN+xypgjjs5hKyf6TlnFTWyZjZjgR24UJSO27aN1hkyemGZDnov3fW3q5kVCgmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYgfCh6piW5CSxdA9J/2H304XQxFCty0xCCdfnACjkY=;
 b=m/I4yQtIebCHj/Zw5hPHEJjfZXYv42eifLaohRR/4xBPZMX6yIJyNmZgH9G+ZI52nkca/3TSqQZ8ife4ydP6jAYybgohGWTTvW5zHHDZK9DtBfdznnTUsD+Or9HgySHiyw0gwwD778T7WX8CTlW1eLwzZxId9GxSZSBlvi/A+6sOxy8ZM6lRWGYzMOU2aqjO/hHtJs2jI+aaFwgwdzQzW/F2FKYuTtw7VhbHxY9yDxLr0GZ5LLyqykyohEuQqFTbPsGd3OO6iynIaKegIciWjzM2ykJPYkTf3HLzCqkZ5gkYn5anD9ZAZGwGxWm/kExIm+lQBpJJxeqewGmaKprBrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYgfCh6piW5CSxdA9J/2H304XQxFCty0xCCdfnACjkY=;
 b=VMHt6eBKb4huQ5p4U4Emqb/TEJ9s9YQ9J/+7CtsrxZ1C6P3cnlNLbBiWi4j/cRxlw+mDjza6+IV1Zy+8sTEHKUDyYbhsB5QESMEywJVQHY9tbSXuQjjRBdqa42mT8CRt6Ug/sSfdeG2/drjIbUFuwDvt+94LbVqdbjK3qwRQ9Eo6l4gKp/R0qnyQyhFUluDAMwG055Z6JKwHxh6fbBR+KYFCaYjiYpRT7f3I1lcciAhl2MMeTYi2CsVeejxylg4RzFbFTXRmqJMsTYk9CI/r2lLsUFeQqHp5IWyEwdz0KEZKtN3u4PgbHVx8dOiRD9kXM+yxjIi0Oqrd7ZPoR3VwaQ==
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:152::14)
 by OS3P286MB1980.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 08:45:05 +0000
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44]) by TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44%6]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 08:45:05 +0000
Date:   Wed, 10 May 2023 16:44:56 +0800
From:   =?utf-8?B?6IOh546u5paH?= <huww98@outlook.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: Re: [PATCH 3/3] libceph: reject mismatching name and fsid
Message-ID: <TYCP286MB2066015566DE132BA5B3CF06C0779@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <TYCP286MB2066D19A68A9176E289BB4FDC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <00479efd-529e-0b98-7f45-3d6c97f0e281@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00479efd-529e-0b98-7f45-3d6c97f0e281@redhat.com>
X-TMN:  [2d50xZxAaxBotsB87zGuUntAkSeci1AU]
X-ClientProxiedBy: BYAPR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:a03:74::23) To TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:152::14)
X-Microsoft-Original-Message-ID: <ZFtZiLe2kvboxwZj@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCP286MB2066:EE_|OS3P286MB1980:EE_
X-MS-Office365-Filtering-Correlation-Id: 06818bb6-7c83-4a43-d135-08db5132d9fd
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 02LAetPa5Yr2huxbU1fr42VkCR/t2cB6+u2nvR2xEPIX7msB5WZc20GS9L6jfwnGhCTLJsFtCE7G+ZI6zI9V6BXDJu5+HD9bfVox54dJkwQx48EmnmynDgEToAhdtihD9NnNajvFNS7i+xbh4PBFf9sg3c9x8JBV5n1RgUyEzjkvfH5Ks9dIOzE70UntNDuzDjzgtaPMM5qiMlhRxkAHHMBz7Sl0fZcxa/b+7Q59bKUckUBAXZ33qbsE2t5WxOMoiz47SL4DUMZ5G8Suo4COBjK7DseSX034+5LK+fsr5awAwCFlALDhMdw2yyUsrH7a32h4Jrf0iGPmW1NgJ/n3ZWQMI267rJYmUq+9D/hu8ZxUDuC5YesKDCYcmD+fQcpiYWnFpjzosx0Hcrh6Nq9R/czc+lBLGR7F/YOqsYek+RRhpr2sZ7i+620Ot7PJJLURckbfnadMt9Cm13ybnpoZMNe+fq/J8+CQrNxicWGhh9nt01UAz+1xZJXHBDNpTLmx93Pt989K/HLjtPDfqiNZ6+SOcaNxcY+BLJb5T94hCjcFLb6d1HyUnWasd1phN9ieRFaoe4iLjQBuktYc5ap8ijixQLN/5b0xfhOHQZzx+rU=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g8xOx6m5omH3HEFDYRufrC0US/l7hmMXbwfvY6QgvGZaVBSfH8Q7Xs0q1KTV?=
 =?us-ascii?Q?JrpBJEGrGjaolGa4dGV4tqH6nGoO23Fk0geeSLqhXkVjTUhJaXOWT3BGY9BD?=
 =?us-ascii?Q?tDczGDq1sr/VoDxxAFn7OzlJmu9Sr1oQgATZlJ8KXbYZrVAV29+5pIN4i2Wa?=
 =?us-ascii?Q?2yQMVAUVPhyavIEnVjoOieA2V9FFHMfUTAgl5K1hSLouH0bxoXYwl7pSfXRo?=
 =?us-ascii?Q?VwJlv3QwWTHFZSXUk2oT8bKbP1Vpv5veZA1hmr0ctJCtmCEvGyHBzb5HEJ39?=
 =?us-ascii?Q?BuOm68+mnmW6cP5O2U22Ive1ZXJ2O+T4zXrpw/nALKR1YRevnMlJjnhQAsAL?=
 =?us-ascii?Q?SndJpBCwSgSjPpOyZxortBlDBPY0NB6/vp9O1fAXGDpo6BV45hcFtdspDumJ?=
 =?us-ascii?Q?d53rLmRCnJ6y3JS0k7tGf83wCQXmibowIRAafB+WiC6GbAhsPoR1IiudPRPV?=
 =?us-ascii?Q?j0oFzQGu9kPBgEhLXtyQQ685SJiBDqVRfgDrdJMxBlyYKnGjLDE4/DFF3l+g?=
 =?us-ascii?Q?n5rQrBhWV8WgsCB0tSzH4Q9GR3juIbRsU7CkTuDnJP/QA13ZhHHSAHA2b4VU?=
 =?us-ascii?Q?nZsKuF+6IpXxCspnpUl3w4rJjx4BOglqVg1654MNcaGE/sHm0RLtm6Yr1Y+t?=
 =?us-ascii?Q?YYkbpqPVyLE7VA0cP/Vei7hJk5GqnApUoLAQQLW6wTVaJn8oNNyXxtd8G4CQ?=
 =?us-ascii?Q?2+JH4GKiGLL1Z7m3P4g4R8lHj53rVnNP7JpKa/ygMlTWIOVNgazSnVlgety8?=
 =?us-ascii?Q?8pfL9nuZe9w+vH6JeOEq7hMjrKR1Mo4TxzAYSRLE2x72N/PrFidFdf6oCIey?=
 =?us-ascii?Q?vunCLvvkdYgM+xaruH2c8vcbmN31TyIX8dntT5xjdY3qATJdF+iaVRmG8jLt?=
 =?us-ascii?Q?QgvrQuNxFAiCAuPkvnHoUoqkMw9De5n2oQgi/v7s5JGg4M4aVspWd6zqSD0x?=
 =?us-ascii?Q?a3uZJ4HaWXul+ga2+JBks30r1iUIAaFzXIN0QEpagKwGwcjESnnA9FHMnp0i?=
 =?us-ascii?Q?1B0MC1d5hs31xJG+EI9aJK++/XW5dzPrkZ2yuh/nQRxWYTGn+G25IUY/oKeK?=
 =?us-ascii?Q?4+xU2oCZ2p0KyNN5fna3HyV4a1sbAPBLJ4R5RMhiQkECvlYVMWEv8aMSqubZ?=
 =?us-ascii?Q?Z4Odh8B4+2caA3IkBVYQ64Ant1LMsKcU9aIKDjga+G9ZxYbTI8JX8GX0Tx7f?=
 =?us-ascii?Q?MHlOS9IYhcC1TBlhOj6unKaMcFEvhMmLq/c1pw=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06818bb6-7c83-4a43-d135-08db5132d9fd
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 08:45:05.8648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3P286MB1980
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

On Wed, May 10, 2023 at 03:02:09PM +0800, Xiubo Li wrote:
> 
> On 5/8/23 01:55, Hu Weiwen wrote:
> > From: Hu Weiwen <sehuww@mail.scut.edu.cn>
> > 
> > These are present in the device spec of cephfs. So they should be
> > treated as immutable.  Also reject `mount()' calls where options and
> > device spec are inconsistent.
> > 
> > Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> > ---
> >   net/ceph/ceph_common.c | 26 +++++++++++++++++++++-----
> >   1 file changed, 21 insertions(+), 5 deletions(-)
> > 
> > diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> > index 4c6441536d55..c59c5ccc23a8 100644
> > --- a/net/ceph/ceph_common.c
> > +++ b/net/ceph/ceph_common.c
> > @@ -440,17 +440,33 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
> >   		break;
> >   	case Opt_fsid:
> > -		err = ceph_parse_fsid(param->string, &opt->fsid);
> > +	{
> 
> BTW, do we need the '{}' here ?

I want to declare 'fsid' variable closer to its usage.  But a declaration
cannot follow a case label:
  
  error: a label can only be part of a statement and a declaration is not a statement

searching for 'case \w+:\n\s+\{' in the source tree reveals about 1400
such usage.  Should be pretty common.

> > +		struct ceph_fsid fsid;
> > +
> > +		err = ceph_parse_fsid(param->string, &fsid);
> >   		if (err) {
> >   			error_plog(&log, "Failed to parse fsid: %d", err);
> >   			return err;
> >   		}
> > -		opt->flags |= CEPH_OPT_FSID;
> > +
> > +		if (!(opt->flags & CEPH_OPT_FSID)) {
> > +			opt->fsid = fsid;
> > +			opt->flags |= CEPH_OPT_FSID;
> > +		} else if (ceph_fsid_compare(&opt->fsid, &fsid)) {
> > +			error_plog(&log, "fsid already set to %pU",
> > +				   &opt->fsid);
> > +			return -EINVAL;
> > +		}
> >   		break;
> > +	}
> >   	case Opt_name:
> > -		kfree(opt->name);
> > -		opt->name = param->string;
> > -		param->string = NULL;
> > +		if (!opt->name) {
> > +			opt->name = param->string;
> > +			param->string = NULL;
> > +		} else if (strcmp(opt->name, param->string)) {
> > +			error_plog(&log, "name already set to %s", opt->name);
> > +			return -EINVAL;
> > +		}
> >   		break;
> >   	case Opt_secret:
> >   		ceph_crypto_key_destroy(opt->key);
> 
