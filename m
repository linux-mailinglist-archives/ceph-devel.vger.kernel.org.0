Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC0F721E31
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jun 2023 08:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjFEGgU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jun 2023 02:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjFEGgS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jun 2023 02:36:18 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2019.outbound.protection.outlook.com [40.92.99.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99165F3;
        Sun,  4 Jun 2023 23:36:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvpExuaZ/sY7+K02oTvoLrXaCefzlxgqspKg4Jf3DtNxBZPpkePagBI/xhaO+8DN/Q1zLqSCDWuPaXp2c7NQc0umQA1hpMX2I9dGQNrLODUVlYgniDdCfrPVxy+NUVcNvISHYK6rxgyabZfjmMjEtF960HT+T7xoEdd/i+5nMwQOemlCYJ42jLEX3fxMyNQXQRdNqI7zh4Q/Z/WDESkrokoHdYFuW/kYq6zlKySBA7DyS8a1KgNjDF6JCleQL7+dfjeVTSoJPYko4zREZfBvYIIjRUbmSfAYb7dQn/NC1EwKxrwWYcBqnqmz2Wa3yGSgdgk6emNvhEu1Nl58X9KeFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zIwnN3TdV4ujUe0pFlf5VFqCTF+CjscwA+KyZkFizNs=;
 b=cRBaB8VUpmiVUj7kRmogHBSvXI2PQhnE55pCIrnHItYoxPUYcpSmfTFumfDceVVe3ihGQIcTZHi9eQR7/Si1JrIO4EaA5oI8Fjox+ughALhio1XSlk1jDG1WGVKW7zR/r9wQWgDNi3qzT8mFuQCM9gniImTRU1eTWB2VeIYyO7e+9ZnhoBidsNpZbUROTgSROKv+5vTpS75kNEPWdYcZ0pRaXCcnYZYPcHg0bsVFJUre5jpwi7JY4DyZZrXMFNtp/0hK/vK5r0D7gnre6gRhEi2QgqW8pmdYaPDC5JYa3ko4h2yW1qaSWy/Rt09HKZaka2xLWwfZtJjHaQjEbwonaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIwnN3TdV4ujUe0pFlf5VFqCTF+CjscwA+KyZkFizNs=;
 b=osOs6/j3VyeCcrs7uALUHHjhfrBZzwM1FvIk0nt3Z08MRMcKolnLFgxJcp9AC3BnaOeNPGyX9ocZWWYIy5D9ZQdlohOpI1M+GuO4iMosmk04D++eEoxGC1Wmb85UTAfZvwxYwMxfc5mcKkZAD2HgqoFiCNozOqq1zgmO582Rl8fmfpQ96VNvbXu90Zesx3BD7bdn0vcUAx0X5LvR3ribMDnJGojxfudMeprKgsqeFiswCLicI4X6T+Vjf8AbnBu4gioxALrLsy7wJCbAsDyJYbuBxmNCCWAbzmLXX/p8C+OhBL2wfOyriHeS23J/S1xNFqi+n6ehLkhhIhrDTz8d6A==
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:152::14)
 by OSZP286MB1966.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:185::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 06:36:09 +0000
Received: from TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::b827:b97c:ae8b:6c97]) by TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 ([fe80::b827:b97c:ae8b:6c97%6]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 06:36:09 +0000
Date:   Mon, 5 Jun 2023 14:35:58 +0800
From:   =?utf-8?B?6IOh546u5paH?= <huww98@outlook.com>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, sehuww@mail.scut.edu.cn,
        stable@vger.kernel.org
Subject: Re: [PATCH v6 1/2] ceph: add a dedicated private data for netfs rreq
Message-ID: <TYCP286MB2066E12AB6A3B92B0A4C2C50C04DA@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
References: <20230515012044.98096-1-xiubli@redhat.com>
 <20230515012044.98096-2-xiubli@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515012044.98096-2-xiubli@redhat.com>
X-TMN:  [tuiPQ6+5faC8BOE5KUz4gpf4EosiH+qx]
X-ClientProxiedBy: BY5PR17CA0064.namprd17.prod.outlook.com
 (2603:10b6:a03:167::41) To TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:152::14)
X-Microsoft-Original-Message-ID: <ZH2CTqTvTV/pNuWJ@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCP286MB2066:EE_|OSZP286MB1966:EE_
X-MS-Office365-Filtering-Correlation-Id: c374f289-b4e6-4509-2e88-08db658f2520
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H4RXUeLmGMEHPZ904W2Q71UElOwJRyg0xB6cGhbrkCSmqLlrpQCDT8a+l8DaHxfUMQu4TvwAaDrek9lCtNnG4l7SRNs2ztxjsMf63ZOfiil/9Qbd6VAA8sTkF+pnPihexRm7VNgSF+iQUegcqyRNmOaNtYW3J28KXOtn2Vr1wak756TuKF65qdtwy4NNWQB221THL2k7x4qLquRZg2GEaPek49OofcpZCWLc7DbyqY2ARjBmQClSqzsN2Ntl5JzdHO4xYNC5eo4FCRFETHVF7e75DiCLZCtmanKpmhbW4TuMdLzW2TEYgeaffP2IQ0qau8VI3IDIkDTMMBELO2P235d/XdoGHFkwCDnSWFbETTNpHFq+o43BVVYR4tSMZuxPg2SxSIEsMvFVHbs0HM2uoiOzloIvBoS753PV2joVhY3UsLJLwP7lbBF0/5lG1QUZgOTnJDKRSwXw0l9xF4A5a2q9GiB0wQgmk376xMXWeYCJpFCLb3MN412/yPGPDSTVXh7JTBZMF2S0KMtYmJ4FGdNYDuIWm2nknetXCCiPLBPyH/s5blACkCNxRCXW++Ni74j35YyyoTygrWqWAaCmxFL9xZXsA0lkCvYLg0tWJFc=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?anXJtjlhCN74TWhAg4u/49IAl0bh9mFOCNdqNIa/wZzzcw5OMNZlzKL2bA+h?=
 =?us-ascii?Q?+4wjitzqtExg7guHuDOgCHFRVNIKK0Xaxwz8RMa/wfQbesKRPD1Ll3fXUrAZ?=
 =?us-ascii?Q?XV1uue1RkpxZ/sStVRGUr8lE26eKVJA6+vgtaobZqmqziFpWzPoY2izfj+9T?=
 =?us-ascii?Q?GB0K2GdpNNQqfdqdoyZML6WQga25zkdXj2iNDg/KcURgBxTpAeKNxJsHfxks?=
 =?us-ascii?Q?ljaBmR0HMkLIBfvNl6/G+NicCZHIHl2W71LRgec/c0fM7jUCbOlw86U1EuEW?=
 =?us-ascii?Q?eF0X3Wxmqcozxo8wCrrgU82dSd7gd7KgUxISm1CWD3347C8ulP5ONeB54Ve5?=
 =?us-ascii?Q?4vvkc2y2sSDBeKIewFhd0kSDXhn5hljnf/DzXS8C/YhvCqDrkKKV/6YrCkOK?=
 =?us-ascii?Q?MCWWqldBR+fsDS9ZTun6v8gDsPeUnjDPREXgrfahcsCXOMZGdM7587MIvmu2?=
 =?us-ascii?Q?jw1kraLYOrxpqZY7n7u/Xl+0f4nPo0LhSGPWDmMtEhdf+dAWrauj7SRDmoiw?=
 =?us-ascii?Q?H3br6eleE7lzVyhNTRrK7pn9zf9ehKdFm9lnvO0afq8XQMGwNRr9VRY+Wx+C?=
 =?us-ascii?Q?CYJGmmgYP/t9BiMAPtbkHOKXDx+aPR9eymlA7yEl/E0MmhfxO1IXm3P1fwDI?=
 =?us-ascii?Q?WPvJ8VjHMu8G0iPu9HMOhT+UUEU3dBKbVTVJG8tPp1QPmjYXt1V+aCRqiY98?=
 =?us-ascii?Q?g5+bIsO4rTGMCOD0vs07qJoonVVkVioo7z8kOMcUMCqAuMEaOVPGNoA8dHHU?=
 =?us-ascii?Q?VMCyZAUYKXQp5SkzrnDf41+CkQj24kSltWxPIHouQVSX01rfuASNGGETl746?=
 =?us-ascii?Q?FBZu+yR9a3TQDZv+UGxtkgCunNmXCve/9hDb8kDfSxen8jZ8XGrwCHPr4ZM6?=
 =?us-ascii?Q?Y9N20qtianCLR+EDsGrTj8zhynMAUuGFEDfKM3OHH8PsumcmJ3PNkU/9QIAg?=
 =?us-ascii?Q?lq+DcHTefeVmUq0TV79apmSU5Zem8F7LsJ8ggyvPGEbIYopw5wzwtknPEmGl?=
 =?us-ascii?Q?GhcZbyJNNq04I1IZ6e6pYxJijEERoovqU+KtO7mqnzDpFPynNzSA12Uft1OK?=
 =?us-ascii?Q?DLD6COVBmmRmy17y9zcDE4+NXAZKTLkXmyIdThnQYzKPiABWuUPEBDF1+uN0?=
 =?us-ascii?Q?KQ3Y6IttbJr3dVlHxX+uqrBqLMThZEVPwbgEv4nw5KeUU8SptwOgwaGjuTPv?=
 =?us-ascii?Q?KTfMr7UpXEUTlrYkvZiZHeGXKABMiojUAZinmg=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c374f289-b4e6-4509-2e88-08db658f2520
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 06:36:08.9727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZP286MB1966
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, May 15, 2023 at 09:20:43AM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> We need to save the 'f_ra.ra_pages' to expand the readahead window
> later.
> 
> Cc: stable@vger.kernel.org
> Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
> URL: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.scut.edu.cn
> URL: https://www.spinics.net/lists/ceph-users/msg76183.html
> Cc: Hu Weiwen <sehuww@mail.scut.edu.cn>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c  | 45 ++++++++++++++++++++++++++++++++++-----------
>  fs/ceph/super.h | 13 +++++++++++++
>  2 files changed, 47 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 3b20873733af..93fff1a7373f 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -404,18 +404,28 @@ static int ceph_init_request(struct netfs_io_request *rreq, struct file *file)
>  {
>  	struct inode *inode = rreq->inode;
>  	int got = 0, want = CEPH_CAP_FILE_CACHE;
> +	struct ceph_netfs_request_data *priv;
>  	int ret = 0;
>  
>  	if (rreq->origin != NETFS_READAHEAD)
>  		return 0;
>  
> +	priv = kzalloc(sizeof(*priv), GFP_NOFS);
> +	if (!priv)
> +		return -ENOMEM;
> +
>  	if (file) {
>  		struct ceph_rw_context *rw_ctx;
>  		struct ceph_file_info *fi = file->private_data;
>  
> +		priv->file_ra_pages = file->f_ra.ra_pages;
> +		priv->file_ra_disabled = file->f_mode & FMODE_RANDOM;
> +
>  		rw_ctx = ceph_find_rw_context(fi);
> -		if (rw_ctx)
> +		if (rw_ctx) {
> +			rreq->netfs_priv = priv;
>  			return 0;
> +		}
>  	}
>  
>  	/*
> @@ -425,27 +435,40 @@ static int ceph_init_request(struct netfs_io_request *rreq, struct file *file)
>  	ret = ceph_try_get_caps(inode, CEPH_CAP_FILE_RD, want, true, &got);
>  	if (ret < 0) {
>  		dout("start_read %p, error getting cap\n", inode);
> -		return ret;
> +		goto out;
>  	}
>  
>  	if (!(got & want)) {
>  		dout("start_read %p, no cache cap\n", inode);
> -		return -EACCES;
> +		ret = -EACCES;
> +		goto out;
> +	}
> +	if (ret == 0) {
> +		ret = -EACCES;
> +		goto out;
>  	}
> -	if (ret == 0)
> -		return -EACCES;
>  
> -	rreq->netfs_priv = (void *)(uintptr_t)got;
> -	return 0;
> +	priv->caps = got;
> +	rreq->netfs_priv = priv;
> +
> +out:
> +	if (ret < 0)
> +		kfree(priv);
> +
> +	return ret;
>  }
>  
>  static void ceph_netfs_free_request(struct netfs_io_request *rreq)
>  {
> -	struct ceph_inode_info *ci = ceph_inode(rreq->inode);
> -	int got = (uintptr_t)rreq->netfs_priv;
> +	struct ceph_netfs_request_data *priv = rreq->netfs_priv;
> +
> +	if (!priv)
> +		return;
>  
> -	if (got)
> -		ceph_put_cap_refs(ci, got);
> +	if (priv->caps)
> +		ceph_put_cap_refs(ceph_inode(rreq->inode), priv->caps);
> +	kfree(priv);
> +	rreq->netfs_priv = NULL;
>  }
>  
>  const struct netfs_request_ops ceph_netfs_ops = {
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index a226d36b3ecb..3a24b7974d46 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -470,6 +470,19 @@ struct ceph_inode_info {
>  #endif
>  };
>  
> +struct ceph_netfs_request_data {
> +	int caps;
> +
> +	/*
> +	 * Maximum size of a file readahead request.
> +	 * The fadvise could update the bdi's default ra_pages.
> +	 */
> +	unsigned int file_ra_pages;
> +
> +	/* Set it if fadvise disables file readahead entirely */
> +	bool file_ra_disabled;
> +};
> +
>  static inline struct ceph_inode_info *
>  ceph_inode(const struct inode *inode)
>  {
> -- 
> 2.40.1
> 
LGTM.

Reviewed-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
