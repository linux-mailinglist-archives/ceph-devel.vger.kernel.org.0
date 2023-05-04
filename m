Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EC06F68EA
	for <lists+ceph-devel@lfdr.de>; Thu,  4 May 2023 12:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjEDKNU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 May 2023 06:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjEDKNS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 May 2023 06:13:18 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2043.outbound.protection.outlook.com [40.92.98.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB924EC8
        for <ceph-devel@vger.kernel.org>; Thu,  4 May 2023 03:13:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V4TGFtl5A1xHKxWGidA6G88KaaEetuq50mwjZPeofK3329dXFhhBii3dTVZdIEcAcOO2lTlRRwFjb0q5Ew9Zd9u8rifvaMc4Gw+AQYUDQmVB30/0nEo5JTSrf/15bEsr698g/tSptZfMUtcg13Ax/dMcN751/WbRlvK55Y3eNjA7zEy5QNgcIM3X21aUD/eQscRkWi6xZ2BTfqP8Rp4VfDuD/l6ihLNbW7UMNv3muI7SbdjXGJnz62u8oNpZ3OI38ccPCs6dRXn1usPH87lllJbK5qY+Em6vU6thx4DVJajCg+7woCDvDjKN2zO5vwIWljpvWUisczA3fZ9cNFj97g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4upqVRXhyeX5Fk1VAs3Qg5t+PFYzpLGdH1998V4Yg48=;
 b=NpztK92KObDZKq00MIpBaE7kKhhQKDeBE0VzvbHMxuTeCc7gF3IoPFZiB2qi2aAY63FQ7hSASYaYuZZMRLYbY7R69Wcmo8o10kv1TEpE25xItu/4EbJhhYVNcPvoi0M/iSel9rM6O4TinKpv0+R63sZz9JdvQbG/Vfx2G3UiyYHgJajJ0/ilGxnTOaYirtFfG+GMvGpyre0wZGGQ3yFtZWZQ0zBtPLGzldXkvjbi2r5G6Jlc6xZoW5eydOIiT3FAVVpKPZbQSLGhH9jdt+hUJZg7ADio1sEJb/yDwKxIqNffnZBUVMDBv+QqrCz0vRPS/3WlT1cOTsTSCZnrcSGjOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4upqVRXhyeX5Fk1VAs3Qg5t+PFYzpLGdH1998V4Yg48=;
 b=GKqnIcoJZ/CN4Fs4emL8fu2ZrOq6XL1+RZvF3PbQijgQ9zkeM47mEBDP3zLwYKRMmWZnMvV58P9P2Jj9KLmRW5fnwtbQvaULh+PgeWUnGSNOCEmETFD3LEBHm4t29ZgrN4kvpwGeg320H4TCaeEQ6O+O0dgSLjWR26w0WyOnDfm+SJlnRAYkE9u7laU0/kCht4EdE4jLqFtbRlb4m28cWbA6zFFcWOXVocFB2UbHUEXQOWAkJE7xog0ze7KxOhjsRajWMkFXQKp8/MCEdW+u/C+7kkm/kp1Mw0IOQjVOKVC3sEV7pgjHdgymtFJDTljBjahvMwlxF+QZiNhmsWn7Bw==
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:152::14)
 by OS3P286MB2325.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:152::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 10:13:08 +0000
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44]) by TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::d9fd:1e8f:2bf4:e44%6]) with mapi id 15.20.6363.026; Thu, 4 May 2023
 10:13:08 +0000
Date:   Thu, 4 May 2023 18:12:57 +0800
From:   =?utf-8?B?6IOh546u5paH?= <huww98@outlook.com>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, lhenriques@suse.de, mchangir@redhat.com
Subject: Re: [PATCH v2] ceph: fix blindly expanding the readahead windows
Message-ID: <TYCP286MB20667D76B7353C3E409849AFC06D9@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
References: <20230504052306.405208-1-xiubli@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504052306.405208-1-xiubli@redhat.com>
X-TMN:  [hJzm9X+5PMh98XsoXQ4ojXRJVOYWgceD]
X-ClientProxiedBy: BYAPR06CA0048.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::25) To TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:152::14)
X-Microsoft-Original-Message-ID: <ZFOA1rdeHlbi+ciG@DESKTOP-L6QKPAF.>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCP286MB2066:EE_|OS3P286MB2325:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dc1121c-d418-4250-3415-08db4c88285f
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2/Bld5wgO4kITdxbH8YjM6aAB8WuffjwZbH2PQ4tTvQZjPWPKC6kN1f+4LDKzi36od0HOjbAB/pK8lj5zHBwHDqbQ3hN8z9/40CvTRjCh/m8ZBHvL3Wo5U9c2pCkK2VwKjeW7hwquUB60ZlgQoORkCVfkUdO6NIFG6MDGzF4MNbG2ZH9BG01lWFyriKesj7p6xhUrSETnQuAkTj7kn1Nodf+gYR21/57jlj1iw3H7pDhiRmaPmHl6piOR7zrNx4b8Twmf4/RTAigInWNipIPnYA3vGu81ZhmGfNRq9lFS23W7+adeAag/I3rFMhTqq/gzE+cf0dPsG2U/8avl0aOWIdqCoX/Or7jF2oI2aLV9MqqfmSsy3NnaETsf8exMHbaJh2rkzt6ZztYDnGMo3k0kRohcyELy1hUDGAJqfIdkK4/19RgccRwlE4ukjeif+KMu6iZ0iKQpu9TiUIbNQyGUHOfxylUNQGz+DS68hjiM4pdWEyeac0aha7IHAdictEyh7NGyfDKTVNV1YoWnyFa+Gf8r6+RLMXiyrZ62YRGXuy5wFb2Z7Cusi57uEtHD6oJxz523IQiE/rGg5Cbi/bOq96BezbhrhwTv/x3Y2NGl/o=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AJzwytsrxwLeH1WiGNZVwZ5NDf63YaKJxQZaNlKsW/EWr3wAZ6FKsLNkfF6j?=
 =?us-ascii?Q?beh/ctn7BMfsCy7E17PfB6bNI1IveMRT9netZCVigNowWJafcj4pj8K+bCKN?=
 =?us-ascii?Q?dWgqap0stIOH8LRcKqwM1bRFl6vNH5tG9cdeRCUGr/B0h9+I2Eda/sHbiGn4?=
 =?us-ascii?Q?eG5FBAmMI2JhKvVMoHzl9xaqgm9XXQPCpvtkWg0jyWSpto8vfqtYMznzwg81?=
 =?us-ascii?Q?pfwmwcbyKMvy4CGaGi02qsAskuG7R4ayjauXNtA9oHxQFyuGutUU0e+RjpKV?=
 =?us-ascii?Q?4WLJlharT1G8VX+9rmAcOe8JeGcumZYLLe92ikAZBo66Zj7eJkKBZ2y7yh0+?=
 =?us-ascii?Q?1daLde5QE3jLAUdBwlbopkU8ZjkYjyXlXVvPknAykIh0yDEs5Ewf77Tw/sC+?=
 =?us-ascii?Q?nt+ZPWiZvcZ6J4wdtUGVrcHV4uqYA+ko/7hFusWM6bQ4AR4a3ZxssgOgibYP?=
 =?us-ascii?Q?K/LLNifP/9wSkevhC5+5K920z1ZhRaZQX9Ic6hB02lBeyN1mnXVfPzDDcHhk?=
 =?us-ascii?Q?vS4SiywUItobLEJ2rJL/0Qt9cVTgythUAf93ONJbseFAIizZdTOcFr3MojJ+?=
 =?us-ascii?Q?/w3FE/Z9PuxwSCHOaWfga49Mp9O7goUdPng0upl6SacYGm58VEsP+TciDD7L?=
 =?us-ascii?Q?MeTGO7UJh5cq455X2SSrfSXe9yFw0QVNKcXrBwU16+slD8w/gE7Rh+UIW61G?=
 =?us-ascii?Q?cl+NrfHSJKm7TKnM58yp4ZNY/NKs+SBRJIjKs24hkxft1N+0xdn8neNvoJX1?=
 =?us-ascii?Q?KDdIWq8tQZ3oMoU3gyRifWZSQChF6/2adVSNl8T4uw72aVNnXEHrRifjR4NE?=
 =?us-ascii?Q?tr1Lvk3Y/fcQbRZ5dBa4TeUoo/wFIa9J7vo9d/08GV6xPcCZdHXt+75yCv1E?=
 =?us-ascii?Q?WS6LgYYYIX4xGjf5dxQW4vcMNaDNxmdXFTsDnZeratXxYmGSujS7u3KmRb/K?=
 =?us-ascii?Q?5kx1htaRFoLnWMlGCnLLKIXOYpIcSZTcQG/4YsMexhAj2fSNdJuAX3pVwerE?=
 =?us-ascii?Q?qz+GUi8tp8rKIiZK6vdZvDXitZrDR6lcRrUFHXtMeiCiGnGNwz2p5FJEa+N4?=
 =?us-ascii?Q?pQtI4HJpm3UYhZ2tnb/R5WrkVXxSSDDAV27mnLPtpqCshclboWl98dalKX6x?=
 =?us-ascii?Q?K/4fBsfNZcQLWXNNuj0m4G3P8TPVyTf8G8roOIRhCqemrESU/EoqG5oXTxIR?=
 =?us-ascii?Q?YDCvXCNPuZgkUaZogNT+xWncpxuNr/Vk/+l1GA=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dc1121c-d418-4250-3415-08db4c88285f
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 10:13:08.7825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3P286MB2325
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

Hi Xiubo,

I just send a patch to solve the same issue[1].  My patch bound the
request by i_size, which is orthogonal to your changes. To incorporate
both, I propose the following patch.

Also, since this is a performance regression, I think we should backport
it to stable versions?

Another comment inline.

Hu Weiwen

[1]: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.scut.edu.cn/

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6bb251a4d613..d1d8e2562182 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -187,16 +187,30 @@ static void ceph_netfs_expand_readahead(struct netfs_io_request *rreq)
 	struct inode *inode = rreq->inode;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_layout *lo = &ci->i_layout;
+	unsigned long max_pages = inode->i_sb->s_bdi->ra_pages;
+	unsigned long max_len = max_pages << PAGE_SHIFT;
+	loff_t end = rreq->start + rreq->len, new_end;
 	u32 blockoff;
 	u64 blockno;

-	/* Expand the start downward */
-	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
-	rreq->start = blockno * lo->stripe_unit;
-	rreq->len += blockoff;
+	/* Readahead is disabled */
+	if (!max_pages)
+		return;
+
+	/* Try to expand the length forward by rounding up it to the next block */
+	new_end = round_up(end, lo->stripe_unit);
+	/* But do not exceed the file size,
+	 * unless the original request already exceeds it. */
+	new_end = min(new_end, rreq->i_size);
+	if (new_end > end && new_end <= rreq->start + max_len)
+		rreq->len = new_end - rreq->start;

-	/* Now, round up the length to the next block */
-	rreq->len = roundup(rreq->len, lo->stripe_unit);
+	/* Try to expand the start downward */
+	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
+	if (rreq->len + blockoff <= max_len) {
+		rreq->start = blockno * lo->stripe_unit;
+		rreq->len += blockoff;
+	}
 }

 static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)


On Thu, May 04, 2023 at 01:23:06PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Blindly expanding the readahead windows will cause unneccessary
> pagecache thrashing and also will introdue the network workload.
> We should disable expanding the windows if the readahead is disabled
> and also shouldn't expand the windows too much.
> 
> Expanding forward firstly instead of expanding backward for possible
> sequential reads.
> 
> URL: https://www.spinics.net/lists/ceph-users/msg76183.html
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V2:
> - fix possible cross-block issue pointed out by Ilya.
> 
> 
>  fs/ceph/addr.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index ca4dc6450887..03a326da8fd8 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -188,16 +188,28 @@ static void ceph_netfs_expand_readahead(struct netfs_io_request *rreq)
>  	struct inode *inode = rreq->inode;
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_file_layout *lo = &ci->i_layout;
> +	unsigned long max_pages = inode->i_sb->s_bdi->ra_pages;
> +	unsigned long max_len = max_pages << PAGE_SHIFT;
> +	unsigned long len;
>  	u32 blockoff;
>  	u64 blockno;
>  
> -	/* Expand the start downward */
> -	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
> -	rreq->start = blockno * lo->stripe_unit;
> -	rreq->len += blockoff;
> +	/* Readahead is disabled */
> +	if (!max_pages)
> +		return;
> +
> +	/* Try to expand the length forward by rounding up it to the next block */
> +	div_u64_rem(rreq->start + rreq->len, lo->stripe_unit, &blockoff);
> +	len = lo->stripe_unit - blockoff;
This would expand the request by a whole block, if the original request
is already aligned (blockoff == 0).
> +	if (rreq->len + len <= max_len)
> +		rreq->len += len;
>  
> -	/* Now, round up the length to the next block */
> -	rreq->len = roundup(rreq->len, lo->stripe_unit);
> +	/* Try to expand the start downward */
> +	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
> +	if (rreq->len + blockoff <= max_len) {
> +		rreq->start = blockno * lo->stripe_unit;
> +		rreq->len += blockoff;
> +	}
>  }
>  
>  static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)
> -- 
> 2.40.0
> 
