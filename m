Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D979721E9B
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jun 2023 08:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjFEG44 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jun 2023 02:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjFEG4y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jun 2023 02:56:54 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2084.outbound.protection.outlook.com [40.92.98.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD11AD;
        Sun,  4 Jun 2023 23:56:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWMnYYiX+MymdyExNphg4dyF0NkMd/B7q44YuJ5mFfLOXHGZrvk5s147FT9DS8aGCFkmZ72C29oSUK/nDN3t+pmuPtpyHEnyFZnJUDgYF7Gj833NnyBzKUy08175ckqUA5RtldmmYoJAK85q97E6HTbWXUYHGI7dAkgOkmxguoSSe1bvswjWlNRLmRY4ydf29ij1I8GXegOQQ+Pu4vd/xBspvA4sRGhncg20XTNNsAJcFszP4B7v+N4Pb1kj7CEACzxB2OSrRbHF06bk39j7fHAL3fW+UuxsCI5URR6drIMwD3V1tVUt3t2Vy7zbRYn15EAsN4cNGUAPK7wQsfiBQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7/ThjDF1I5nExQfL09ymnXGnKaqPCeidK35m9SPNq2E=;
 b=kjCFaSLr231hzbdwhYM6dDz25CyI8X7fO66llls6A0exa7U3rH8ayL/u3mOqHhiEhnSxAELCgo4UI2OflLIQftd3EpE9MsJ2KuJduo49luat2vTmVNY+bqo/cjuuN0bOVjXBz5+D8JXjD3H2FQM07D/XzUn4VJz1apXzp5PASQDXqBWRDSq1jLQsE5qh+FFw6cK9UDJaQsh0wlsyoGYZYTjpRyW1m3GRgy/yKIUf7dUAf7tfNgL26fTFV6bay4bvrvVwRqeHMgMS2h6VPLoHEeE8G26/g9zNc3W7sLENKY84cLNPb0AVjgvyUwVlAyTCd5DqPOkdjsPlXCr2Wu/EAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/ThjDF1I5nExQfL09ymnXGnKaqPCeidK35m9SPNq2E=;
 b=nmu9Gmi1YLkuRK5IbsnT6l+1LHp8rbrjMTrCpVKKWsmgONStVepBq7CbiCvcVwGCmk4CpgDNJcQlIjaP+z37KtP4FO5ocxqOoxDK6bz+IGii1gsa7v/cU3EtvelHAstIvFyH9ylU+//rL+Y2LKzuzZRIkVbUv1Edr7KggoE5ubJVI/cnMujtCpneuywqt1VAsw3Z/1U3p9c8DQFg6CVZAf7cRGrKZ8yirBavronv8uC+77LYierI+NP8Dgcv2SDi7WlhI3E1ual0EfMGjAUYePbOj8INT+0J3z7eOvuY+2YmNp/N0aXF5ZWjT9lUFs9/uWBUBcWHP5hshJn7ysxYbA==
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:152::14)
 by TYCP286MB2163.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:15d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 06:56:49 +0000
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::b827:b97c:ae8b:6c97]) by TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::b827:b97c:ae8b:6c97%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 06:56:49 +0000
Date:   Mon, 5 Jun 2023 14:56:38 +0800
From:   =?utf-8?B?6IOh546u5paH?= <huww98@outlook.com>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, sehuww@mail.scut.edu.cn,
        stable@vger.kernel.org
Subject: Re: [PATCH v6 2/2] ceph: fix blindly expanding the readahead windows
Message-ID: <TYCP286MB206692566DDEE50F7AD00A49C04DA@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
References: <20230515012044.98096-1-xiubli@redhat.com>
 <20230515012044.98096-3-xiubli@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515012044.98096-3-xiubli@redhat.com>
X-TMN:  [/lT/LNCLlxJSLHvsBWt1zz+xwYY9a68K]
X-ClientProxiedBy: BYAPR11CA0079.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::20) To TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:152::14)
X-Microsoft-Original-Message-ID: <ZH2HJkQaqJs4ANzr@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCP286MB2066:EE_|TYCP286MB2163:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ed68614-e86d-42ce-4eb8-08db65920882
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YcafnBb4NquNOzlggKZwtY2P+lQbqKOnUusjGjynd+TMVXloMaKKFlBuMaR1JSESW78jZ+CHHLiXwLxCew5XqOVY24G7fSHiOAniiZGjLRUspYXZTEAignsZ7QTmM+U0zlBiZtObti5+BbeoDKvdfmdqRcuF2GnbMNIgCuq2FADUaA2ny7tZyEZes1TucARoLYfZ4akCLdwG1WW+IsRk2uxFcUABcKMuXI11jsQjASrVZ/XxPUXg+fJNz/yaQF886Lwiu9S1O/Z1SKmX3/PsQCI4aIeqAuxnkeoAeI8KUTm2On4eMthjCdtUsvC77QcBJZt3xdpStakDHzypr+N0EFujkTqdTR2iMk31yvXOGTI8kEvRoUS3wEiB0Xwi/v1EL/XvgV+ZnKKX+EPXSPDJdR8kwWw30V/NwR8+uN9T5E56LWZ6krOEa+EkOKvj96SlIl7V2giWVLQYY02wTrhQW/ToZdb69nAfV6mql9rrCVDtyCIVnYc8+amYn6qucjWA4ByOnCkiofywQTzCvEvP9Q81D/cL9yUlGHLyALBzKtrQfXGQVdkjko+MQNjxwTKZKhtwKK04BOfobLLSpF1lrcOVePSGGcdF5PMq4TM7rSg=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zLSZqRWP6np5nPe2aXcot7skIW5Lxqp79b3wroAbdKe9gXF0qRB+3YtPXhuw?=
 =?us-ascii?Q?UDC51JH62H2MrDJ8D1lASrpP4FPdhY3kt87TTizpXvsBXHaF9miUxQTDI6GT?=
 =?us-ascii?Q?LJX07UQvFXKAVCwlOFA9YFrPyfcU0Gn9juQByJYm5xINFitxxuLVXRRcISJQ?=
 =?us-ascii?Q?gf8jHVVzrP8mvXuRiHSjHKYax9xysW3jj6+MnEpirhwfiLXzuhTvXusrJgs/?=
 =?us-ascii?Q?wtj5CuJCdm2q+Vl6eS9gcZIsX3w0y9SQhh5jaMs9glw2f9H/JQAIQfdLhTOZ?=
 =?us-ascii?Q?8GKy+sFAvruvXTTSWZbztmVtgYrg4AfUXt7a0D5a/fCoPgQ/uWeNw/hUWAVe?=
 =?us-ascii?Q?ZNhZo7fwp1wbh3AqkKjOhbFqw+Fyb1H5zRLh+z1EiX6Yv+/8FXhJRpcIv3L6?=
 =?us-ascii?Q?l/QUHqs9VS/xZOQS605qeAkCBx84u4L6CtJ6mR+/YKG+kuJm8onnDst+JqMD?=
 =?us-ascii?Q?cyM7gnIxK+VQ/zMMj1qRzvRmoSMQyZElEi1LkP3vFxKZDZ15+TnD3yaXQEv/?=
 =?us-ascii?Q?rvr0dEtUOhmLTHaTG6NztD8FQVlR4uONy0uYwLBNvBurSzwnY18wLQA9Hocq?=
 =?us-ascii?Q?gR6O6V6oqb9DmPKpPrLr/TcgHPyKZ0JGCgx4zZk7AjWDzQ/OZHEgPNi+/GYp?=
 =?us-ascii?Q?99imMLCWPLZSu4oD9odIWxbF4TKKwknEFCZTdeWamxf/HdepOw4FOTyBx28O?=
 =?us-ascii?Q?KQP4bhes/XMIuosO4bQa0h6IUNF5vXxVsXV5LcUz0nnu7+wyvTo3Wt8E31u8?=
 =?us-ascii?Q?VL1K68P1YJhRVBAhJ3/r67HHFJwG9ChSjSJ21p8ipBiBotNhGR5jRE+9xIxv?=
 =?us-ascii?Q?tEu/fa+gSRZUWmDRqXGOM+KmOfdhLm5w8LIL53jyX9M658eb1LhTy4LUw7qX?=
 =?us-ascii?Q?RaNjKcRIT3WsKpcdwPhqXR7zFeN+fWMjhor4WmewSopALPo0Zej54BiD4U/5?=
 =?us-ascii?Q?LqK70AUb35QLPpLXnGRxjhlTJ/HMjhzxV5shRjxvq1lXwhx/FOHCJ3po/JO1?=
 =?us-ascii?Q?2FZKvue9UeQ7GCG9Ub2gfaLwguzW24P9BkwuAYlJmiHrsKR1wO2vdK+wS3/F?=
 =?us-ascii?Q?yR+1z/k44U734aYvnRS97BbTiOk2VDnzg7NLsFA4LnjQfNLaURY2p2vTJpsg?=
 =?us-ascii?Q?9L8XRj+lPDPZrMPMJMk0g8DfaTVoWuNhpvy9g92L/7cI+qDswNS81O8ZI4eD?=
 =?us-ascii?Q?Oh9pQHgOAbEQy2wP943CWZ8/yL+wVXoVbAyxYA=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ed68614-e86d-42ce-4eb8-08db65920882
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 06:56:49.2874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCP286MB2163
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, May 15, 2023 at 09:20:44AM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Blindly expanding the readahead windows will cause unneccessary
> pagecache thrashing and also will introdue the network workload.

s/introdue/introduce/

> We should disable expanding the windows if the readahead is disabled
> and also shouldn't expand the windows too much.
> 
> Expanding forward firstly instead of expanding backward for possible
> sequential reads.
> 
> Bound `rreq->len` to the actual file size to restore the previous page
> cache usage.
> 
> The posix_fadvise may change the maximum size of a file readahead.
> 
> Cc: stable@vger.kernel.org
> Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
> URL: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.scut.edu.cn
> URL: https://www.spinics.net/lists/ceph-users/msg76183.html
> Cc: Hu Weiwen <sehuww@mail.scut.edu.cn>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c | 40 +++++++++++++++++++++++++++++++++-------
>  1 file changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 93fff1a7373f..4b29777c01d7 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -188,16 +188,42 @@ static void ceph_netfs_expand_readahead(struct netfs_io_request *rreq)
>  	struct inode *inode = rreq->inode;
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_file_layout *lo = &ci->i_layout;
> +	unsigned long max_pages = inode->i_sb->s_bdi->ra_pages;
> +	loff_t end = rreq->start + rreq->len, new_end;
> +	struct ceph_netfs_request_data *priv = rreq->netfs_priv;
> +	unsigned long max_len;
>  	u32 blockoff;
> -	u64 blockno;
>  
> -	/* Expand the start downward */
> -	blockno = div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
> -	rreq->start = blockno * lo->stripe_unit;
> -	rreq->len += blockoff;
> +	if (priv) {
> +		/* Readahead is disabled by posix_fadvise POSIX_FADV_RANDOM */
> +		if (priv->file_ra_disabled)
> +			max_pages = 0;
> +		else
> +			max_pages = priv->file_ra_pages;
> +
> +	}
> +
> +	/* Readahead is disabled */
> +	if (!max_pages)
> +		return;
>  
> -	/* Now, round up the length to the next block */
> -	rreq->len = roundup(rreq->len, lo->stripe_unit);
> +	max_len = max_pages << PAGE_SHIFT;
> +
> +	/*
> +	 * Try to expand the length forward by rounding  up it to the next

An extra space between "rounding  up".

Apart from above two typo, LGTM.

Reviewed-by: Hu Weiwen <sehuww@mail.scut.edu.cn>

I also tested this patch with our workload. Reading the first 16k images
from ImageNet dataset (1.69GiB) takes about 1.8Gi page cache (as
reported by `free -h'). This is expected.

For the fadvise use-case, I use `fio' to do the test:
$ fio --name=rand --size=32M --fadvise_hint=1 --ioengine=libaio --iodepth=128 --rw=randread --bs=4k --filesize=2G

after the test, page cache increased by about 35Mi, which is expected.
So if appropriate:

Tested-by: Hu Weiwen <sehuww@mail.scut.edu.cn>

However, also note random reading to a large file without fadvise still
suffers from degradation. e.g., this test:
$ fio --name=rand --size=32M --fadvise_hint=0 --ioengine=libaio --iodepth=128 --rw=randread --bs=4k --filesize=2G

will load nearly every page of the 2Gi test file into page cache,
although I only need 32Mi of them.

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
> 2.40.1
> 
