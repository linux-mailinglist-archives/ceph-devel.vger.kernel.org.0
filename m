Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2435B6FDB35
	for <lists+ceph-devel@lfdr.de>; Wed, 10 May 2023 12:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbjEJKBW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 May 2023 06:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjEJKBU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 10 May 2023 06:01:20 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2106.outbound.protection.outlook.com [40.92.98.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AD14203;
        Wed, 10 May 2023 03:01:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RElQMFI4V4DvijN+UUO8oGQle6d9BuX7TMu0LUjCEnkiqTD8iF1m3f7RGVjeW/hETrvrOKqnVKyos+HrVwOSgxZvQJDQlqk8AlMt53R4vbhMrsmW907m6NUSl3ytnvroh3BsgzaIOkEoz7/e1kKtgPlq0HTFbqBoVtnH14I0mkuppcFhiSTKsv4dWylgzMc1Ph3bl1e2xNH+McJxMtzcKbwGvkFeEkMuEIAbqgBAP+Z/2xuB2cHePE0IVCQQ6mI5mf8c6pcm/CNPKsci+P0DxhATbmDvN6Sng4V/AiRBNeDuylohqcZu5cUo42CNecTdGPM2Cyv1I13rnaiUkNw89w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pl1yQcvov1eUB7acamziCo/fgSAdOKq314GCjTM81/0=;
 b=Gp1/PUJv4KTTRrd5oOgfLHJ7r9fcoWlratXagBD/3oTIFuqL1cEHyVU6WbslHfsyzyFyMXkQi3nLn28gTvnmPilqrbgMjqMUdbLzTGnQtLm2QaEB11GbWerkF3bfXZT7ZACBoq5yIIY1q5IlkG37R8P9x88HGP29LI33UuM14QH1mxuksSJhUadLCD1nWWLgc20Ot3gJ0Hq10gMW4ahhJQia6wqRaf8pTAU0zwO7Z8Nnx9uVkSXLE+YKPGIaM1gowaJB01+tByKQmW5/jfUS0Y7cSUTzwMwKzxc31SFIx4GPEYUgL36o3OOk8/daNF4jjz69atujx5kTAwUzF4+VyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pl1yQcvov1eUB7acamziCo/fgSAdOKq314GCjTM81/0=;
 b=GX+PFXhJNuyg4fKojO9q302vuoM+nBCaW1MUkK5hq7H6Wc3boJK+7kIpfXvAMEXQO0wSOjsGFs3ESmfz2d8Dt+HtC5I7fltvdC0eWzPbSZ9BUCzkEuRApLXJcinqFfSKEWN0mPvhvldL0ZzBoSFkB/T7DpSfmy+o8hFm6r4m2bVvHKu3zD15Wy8xYUtCAEmE8ZHifQI/EDZrhEJwkQHCi55rfj+0t5sdGRjRhECV5Zykh3MpMgaqdit0grlUPjeLDArOMrXHN52szIpKkg1IanpU8XWcZiPG67CaBnEr539ooFX4Xymuw8n00Bytr1WT/Uf10J9fAaT51D8rr+XT6A==
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:152::14)
 by TYWP286MB2153.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:176::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 10:01:15 +0000
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44]) by TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44%6]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 10:01:15 +0000
Date:   Wed, 10 May 2023 18:01:05 +0800
From:   =?utf-8?B?6IOh546u5paH?= <huww98@outlook.com>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: Re: [PATCH v4] ceph: fix blindly expanding the readahead windows
Message-ID: <TYCP286MB2066E72A82760E96D328A420C0779@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
References: <20230509005703.155321-1-xiubli@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509005703.155321-1-xiubli@redhat.com>
X-TMN:  [Itfjt5MfWPDgin1nqX8iXnrv/Zznccxq]
X-ClientProxiedBy: SJ0PR03CA0203.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::28) To TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:152::14)
X-Microsoft-Original-Message-ID: <ZFtrYbApiUm525Z8@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCP286MB2066:EE_|TYWP286MB2153:EE_
X-MS-Office365-Filtering-Correlation-Id: aa38f2f3-4bd0-4fb3-352d-08db513d7d9b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G3TRrf5JK4GiSMX5XZoSVFEehK2wa2h1Z4BX4+IJOICYc3dj+EWMLkdcGKljPF1uFCdg06igWiwMT/5d910ufINbkeB9wtDMq7Mt/Swup8xArEx2N6C7tO9Mmprli7lh124M4y2kznZStf7J//ttwnSeOiG1ftk66Og1cX85/oT+jhFVAu4Zx9Meqgq4rDqxcJ7LGLzBvL4W3Tdd8AMBePaj09zNT5Io3AHf1nBP2IADuxKEI5b+kzMBW29w8Ug3Mej78y1UxblGMnktqAPsAodZM7uRoCpNmmK94cRsqEGgwytiUT0WL4GQMDe5Pm3ch5INFcv1qqMdUoHsVsQpB+IwvXJLSN8bR9ocO5NIxtiITTdJtuZRyek5agMv3V8B6yzizAEESXvFMsZNz6IW8aF1mNvzkufO5ck9M0zIeERBKzgjCApeYwMyqKesfCqPjoFgo1M6jm6Hpu7oNUu91AGA6pXHrpqeBU5Ydz1n4MIavYDhqEh3M8s95sV3SmckU2U1DKHdxKea+QH1U5TLTZ8oAnys/9fRQWro6vR5nxGjHM7AhqgoywoV7c6TXG9PT6QT3qVIdBTz6feMGACczCvJ8rEj9qbc0/TYHKLf4Q8=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nejwOdusc7vSsKptXPv87/CQzHBedW1gsCd3R5mGrUn7akqXBF094GAwGkGH?=
 =?us-ascii?Q?5P3Xu0VU/jSMlBLvzRbyLZ6mbk+lmPPrX8XrtPa9iiWXXddgDEIGqKh7IXhx?=
 =?us-ascii?Q?qd1M90oSKOx0BrlXHHeizJ23awhE26tk/aUvychaI2B4wP26N9pG1SMcuiMi?=
 =?us-ascii?Q?pKGLtD2QNyf5Qc0nAEcPvuAizueHWbwfH3f+RG5KT4XnO4er3YPmKe/4cnJP?=
 =?us-ascii?Q?ZcHohJWdqWIQCOgE+RVFgpm0NPd3TckBpViN6Rs3dt/LOj7OREIP9bvO/pRY?=
 =?us-ascii?Q?NerHqNDzeJoCM1BZLRxc3svkUvgwWVOx9UFjyI1OqbpgXbDGIM40GFFfZo/x?=
 =?us-ascii?Q?LD9aZ6LC/G5TAWkvUHQo+plh8bkGYws7AHRxhM58WvS1xicwoxKPK7opNOYF?=
 =?us-ascii?Q?Zuhv8oGQQVMr1F7FoXrYpwP8ktBug0GUS0hgLXNFmvmY6uP6AuBSvKcM6FNT?=
 =?us-ascii?Q?dTdu/rXSO9bPd8cKjhuupu8fOTr4U/Hy9nvedH/EEyw2wQXB5beC5Hj2/6TZ?=
 =?us-ascii?Q?wklpl4J9RzgwuNs+5eiagJv/yEpOaNT1cu40aJeZPNOFX3GBntOzMtCqlAdi?=
 =?us-ascii?Q?sVvQq16bs0lSQb9ythYO2fVppKW5W4jINfAInlLwzucI2iq3Csp49vfzSaaJ?=
 =?us-ascii?Q?sbUTu9WxGXDOEnVZFBw/7oGPdoynxRuu2BbkqI2LCcJxuQqOw8n/4ns0Ma/Q?=
 =?us-ascii?Q?5gCbqHXeXC3Vln/bWTPwKU9tTRSX7U/4RhtnZDphQjxQoODBnKj5ae6H2sst?=
 =?us-ascii?Q?S2mVbxD6PL8udtcSwSwioe4Cy6ot03hZ9V1kI06TdWJ5ZkghmrSK03fu9KbF?=
 =?us-ascii?Q?hlGv0ZQnynlu37Pg15k0C2KSN7/yEOBDkkU4gMg+SRv44RaH9nsD5KR43PRD?=
 =?us-ascii?Q?9tEzRhWuT5e2BYViqIV49xtBSiirwxZ8yV4R3nwcxO/qp52n06A+ydf8qX5P?=
 =?us-ascii?Q?25Emy4chE61cxNzNd2WS54RoCmv398X9RqRkyLwX7c/qC823UeGI15hGLRNt?=
 =?us-ascii?Q?iTdVW6JEG9ObH7pCP73NysJ1vO0eIufNz+i7FCrSNsMWFkDaxwyzdq/gi6bN?=
 =?us-ascii?Q?S8bTb+SBhgdfSvSIyv5QsZZdVmWFFkwIIMBTFutsbeOYr0bZRw6+UlJpmZG7?=
 =?us-ascii?Q?UMBG3SpUFy+cBO9xRm+ImFcdjPLUt3c8SkzzLlO03GrnzZtL4xpDx+VPFKXi?=
 =?us-ascii?Q?AQWRjttp4Mpbtg9BcvqsSISoTt8G5mUPdTZIYQ=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa38f2f3-4bd0-4fb3-352d-08db513d7d9b
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 10:01:15.3509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWP286MB2153
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, May 09, 2023 at 08:57:03AM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Blindly expanding the readahead windows will cause unneccessary
> pagecache thrashing and also will introdue the network workload.
                                    ^^^^^^^^
                                    introduce

> We should disable expanding the windows if the readahead is disabled
> and also shouldn't expand the windows too much.
> 
> Expanding forward firstly instead of expanding backward for possible
> sequential reads.
> 
> Bound `rreq->len` to the actual file size to restore the previous page
> cache usage.
> 
> Cc: stable@vger.kernel.org
> Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
> URL: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.scut.edu.cn
> URL: https://www.spinics.net/lists/ceph-users/msg76183.html
> Cc: Hu Weiwen <sehuww@mail.scut.edu.cn>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V4:
> - two small cleanup from Ilya's comments. Thanks
> 
> 
>  fs/ceph/addr.c | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index ca4dc6450887..683ba9fbd590 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -188,16 +188,30 @@ static void ceph_netfs_expand_readahead(struct netfs_io_request *rreq)
>  	struct inode *inode = rreq->inode;
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_file_layout *lo = &ci->i_layout;
> +	unsigned long max_pages = inode->i_sb->s_bdi->ra_pages;

I think it is better to use `ractl->ra->ra_pages' instead of
`inode->i_sb->s_bdi->ra_pages'.  So that we can consider per-request ra
size config, e.g., posix_fadvise(POSIX_FADV_SEQUENTIAL) will double the
ra_pages.

But `ractl' is not passed to this function.  Can we just add this
argument?  ceph seems to be the only implementation of expand_readahead,
so it should be easy.  Or since this patch will be backported, maybe we
should keep it simple, and write another patch for this?

> +	unsigned long max_len = max_pages << PAGE_SHIFT;
> +	loff_t end = rreq->start + rreq->len, new_end;
>  	u32 blockoff;
> -	u64 blockno;
>  
> -	/* Expand the start downward */
> -	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
> -	rreq->start = blockno * lo->stripe_unit;
> -	rreq->len += blockoff;
> +	/* Readahead is disabled */
> +	if (!max_pages)
> +		return;

If we have access to ractl here, we can also skip expanding on
`ractl->file->f_mode & FMODE_RANDOM', which is set by
`posix_fadvise(POSIX_FADV_RANDOM)'.

>  
> -	/* Now, round up the length to the next block */
> -	rreq->len = roundup(rreq->len, lo->stripe_unit);
> +	/*
> +	 * Try to expand the length forward by rounding  up it to the next
                                                       ^^ an extra space

> +	 * block, but do not exceed the file size, unless the original
> +	 * request already exceeds it.
> +	 */
> +	new_end = min(round_up(end, lo->stripe_unit), rreq->i_size);
> +	if (new_end > end && new_end <= rreq->start + max_len)
> +		rreq->len = new_end - rreq->start;
> +
> +	/* Try to expand the start downward */
> +	div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
> +	if (rreq->len + blockoff <= max_len) {
> +		rreq->start -= blockoff;
> +		rreq->len += blockoff;
> +	}
>  }
>  
>  static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)
> -- 
> 2.40.0
> 
