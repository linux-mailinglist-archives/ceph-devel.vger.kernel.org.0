Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16142700A02
	for <lists+ceph-devel@lfdr.de>; Fri, 12 May 2023 16:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241210AbjELONz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 12 May 2023 10:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240231AbjELONx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 12 May 2023 10:13:53 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2030.outbound.protection.outlook.com [40.92.98.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6998F86BE;
        Fri, 12 May 2023 07:13:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8gMnZA7M+BJnc7GgrkWReAyZgbuRDsthS4XANfd5PuQ9e8SMJYjHRmsI26spb5pf9zBWwXOs7y3L4oZ8UnJzKwo2MKoEt8LN4/m2HTOLXShHk0H7xksS5Ql2JqHTkf16ASFIl5SxbBAiSFnIeOgKdgg8tPytj9UZyxKE8TMFXu+zHSbRFkHwrij0cELUE57GUAaPiLTduD+EgKDU+gtYvDDPasoi5RHYBuubx/cFS4OkqWMBI7x/byD9SivuN4Xfeo+HpaTmO+aAV9nIzgPWuaN2OukWs3dgnGlaWyfWz9ja58HNdy4F9TMYbiLSzDHL+9b9dtmHNCI2KSfGMj1tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mef+IAOhXo+Rly5Y1Ga7JmwLSmanzp7ASgPHYOPO86A=;
 b=fQj1P6zrGzwY7/c865uKuYgV7O539X5Te7KaKSGkO0tB9K4dkxeCzOVnZqXsd2lEzAFYJTsc+zZIODdPq5aqqIBQE8NeStH7hqfsvEaREhHnK0315mX/rlUScMIf78hcatlqBj+U0ToVS/kqtRjtc29X3A/hrvpcnbTZ8vglgS0AvnxtlZ+V5DbECtVQdkTX/203s+ZO8Pc8pzqfCUHl2F+MEZYuNDFav1evo3YGil6B+UWNnpz1iJ3IE8N0aYn0KB8HTJf0ZKi7pDIudvRbfbpyYYn6i7cVXG5+j7EVSZwxU4pEmg0inMjrAlnciudt93UqqWvQnZGIm96GTznsxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mef+IAOhXo+Rly5Y1Ga7JmwLSmanzp7ASgPHYOPO86A=;
 b=j+1czSvuf2AZbti+1Oc5QdHGvueN0cXVvZjZR/IKjf6BxjF613JvjyrJn1I3nSAA5RqhRxd+DxlaX8z+As2woSz1xBYz/TQxJ114vTUbfTcDbNvWQvtjNi/RTivMML/CQe4He0m4Xc6Hs/IbyUN35jjf2tfU7p2U614a5VvLuzF4Om/Oa3snWXcMexmKBN8FxAqOmBEeEZjW1gzJt4QYhS0DXRFy2QY7yd03Vwlsq/H532q/kooeF7U24wbxQQG+JG+/OiULQihoiWYf347pRv7zHKbHde1hjMEvySf2e6evwyMT6H2RGlYDW4LEU560BPcF5JlIS2Ej1DdKzw2viQ==
Received: from OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:180::6)
 by TYCP286MB2113.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:151::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24; Fri, 12 May
 2023 14:13:48 +0000
Received: from OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 ([fe80::b4f8:4693:7f59:55db]) by OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 ([fe80::b4f8:4693:7f59:55db%6]) with mapi id 15.20.6387.023; Fri, 12 May 2023
 14:13:48 +0000
Date:   Fri, 12 May 2023 22:13:38 +0800
From:   =?utf-8?B?6IOh546u5paH?= <huww98@outlook.com>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, sehuww@mail.scut.edu.cn,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 1/2] ceph: add a dedicated private data for netfs rreq
Message-ID: <OSZP286MB2061BC99F3651AD6E2F3625EC0759@OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM>
References: <20230511030335.337094-1-xiubli@redhat.com>
 <20230511030335.337094-2-xiubli@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511030335.337094-2-xiubli@redhat.com>
X-TMN:  [q43gs0l9K4lvwTN7m+vE2OlUmxCqipdg]
X-ClientProxiedBy: BYAPR07CA0096.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::37) To OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:180::6)
X-Microsoft-Original-Message-ID: <ZF5JkpBLRacHhqGb@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSZP286MB2061:EE_|TYCP286MB2113:EE_
X-MS-Office365-Filtering-Correlation-Id: f4db8799-ae88-45fe-f345-08db52f31a35
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: txL/MYdrpn1q4jljpvpky4ZPMrmd5KWpY6ARCAhdV6gR5PtmMLpbx1l1ZN88ypMQIvCrlxqTslWhT2CLONmLaNLflh43Wz2EW0jPPYJoHoZqf5PIQvR1X5b1gqpFLgdCbdeIdrhr8JsW7Qj5BeKJ/ryf7nD8vGJVmL1kpDRVLJOzeNNj72IOHV7wK6ybgjeZdHmc+hMKwqP3rcLbTrRb06Oxgneodc/f3Xs8fLCHiXQLDGt85pniEXpCoBCpyVVeH9rs0xFRdK+2WI4yFc9jgojbbOfZv+nVtQ+z+Pshzb+iVvrGYYehU4jOfXPNNoQjlpPMOWgpbRN+Ub+2VWdv3yRTvK9ybXIzjoGwvACjcMXlj6n1pi8Pct5un3T1M+aDjpBnXtONmGXlrcaxtY3USjWTC6B1O+yCnqZOZV+G7AHU/xIxPFMxaJ0ZpK+EaIxbuMKnUmsX7SDz+V9ZPPO6yalIQkN/L/gKMvcXbYKoznod+alGsPAbRrwqt3J/L7Gu8iYbWjyBKnPR4zVjWWRQNspzqxZPaYkcov/lGayIHBwHMfz2FtHg/rT1p8GVB/wS4UqglNMP+YLxAWWpAXqRvzEUb4XWXdGm6X2yV/fQ9uM=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8h+YFcdgvktuLuyMbk6DhefaBrGB+frbB+0nzllOfT/NJAn/DrULq2ivwBCR?=
 =?us-ascii?Q?7XyHKUU5yehyloFHXGUe7Pvot8HPnO5r3/ml+2UHVzuZz5rIiDlGdqYrdnyN?=
 =?us-ascii?Q?QJt845gKjCHU6C4VjsScBJjkK/Vzrk4QzTXxPQCWeh4CnAMfDCUhkD/9eSoT?=
 =?us-ascii?Q?JkWiO+7hAsfHB8ci9jSXSUNNbAsd3/xyevH+CMpOmHQTE7ADVPJvH02R6bga?=
 =?us-ascii?Q?QGjV5Su5ljwlluZE5R6h2alkkundiNdkhepmElsockGw4Bcx4NbQdb79bHhw?=
 =?us-ascii?Q?2YbCDdFNVsQUvraDV5O5Z9fni0nZaeaFhJzKkYaADyTPMYMFYKtqNNvCpm9U?=
 =?us-ascii?Q?Csg9fMlGEJE484Pus/hiYbcK53CkbmFbigSH18IcCRiXMfEmFzzNHvJJo/ZX?=
 =?us-ascii?Q?lYn+vyy+8vjsRuaWDTdJEmM5YPs3Lq8zh+Ir7/AgAQBotAvTpi2QxZUo3BQR?=
 =?us-ascii?Q?F6621Lnwu4pLPDWNFUoDVfHDcVwZhJXMnrL1fra1wbKQ/xqHpPn979C51+y7?=
 =?us-ascii?Q?V3fyeBlhA0P2xg9gEP9K/bElzpYRM99BcN8k0YM89aRE+XUFF8pv9XDydmqs?=
 =?us-ascii?Q?iZOswX+/1iu/AS+a/65OL0hFRH+ffU+JX11SfJnqz/Mi6Myw43RkSJ97Ecec?=
 =?us-ascii?Q?1ukUFoiSkVvGb74d+COl3DmVD8YwKXDV0hBMiyEJlNIzLN2lqW0JChER9Ys7?=
 =?us-ascii?Q?NmFkQa0c/iT2fnSp2JZ65NVPXG8JJzrqIMFO2KSSCv5UMrskBvW0IDm9bSDc?=
 =?us-ascii?Q?U/P81nhBVc/6dLTDauPmpjtjqa7B8BVRx8+1jV7WrFnW+U4qMMj0SdPvsqZS?=
 =?us-ascii?Q?vslSzgsQTNEKY7r3vvtFmBqxvCa4Warh2r+DYEVgjCOKXrkdH4XfXrUCLIcE?=
 =?us-ascii?Q?D4T2xb5P88S/ZxY39puuGljfm7cSz7rmnnjFln+P9U+bn78zwdwl91nZXZvr?=
 =?us-ascii?Q?M/68uy1q/2nSAT44SGNOsb5F9D7wqh/edEfMU7cDIoJVdjNlwhR0o/x7dAgY?=
 =?us-ascii?Q?uEI4YWglCJ/9IC/HDjvDyUrBbyU001dsf8zsuWQn5z8OK3dgQO5vh4dcgpx3?=
 =?us-ascii?Q?WB7417pWeDE0h2cr7NC3FVBfv45tD28Ap1c5muWXDqvhRrWN4rWfq5sY94G/?=
 =?us-ascii?Q?H+ZtKxWZjKNihXkgp2auiFFcRIooTP9NWSgTKQEuckORyCOdCXkjfqlO0ZdE?=
 =?us-ascii?Q?UBfSSahL2VBNxJ9c3nbezLu87kwoFc08JaJmiw=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4db8799-ae88-45fe-f345-08db52f31a35
X-MS-Exchange-CrossTenant-AuthSource: OSZP286MB2061.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 14:13:48.2817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCP286MB2113
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

On Thu, May 11, 2023 at 11:03:34AM +0800, xiubli@redhat.com wrote:
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
>  fs/ceph/addr.c  | 43 ++++++++++++++++++++++++++++++++-----------
>  fs/ceph/super.h | 13 +++++++++++++
>  2 files changed, 45 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 3b20873733af..db55fce13324 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -404,18 +404,27 @@ static int ceph_init_request(struct netfs_io_request *rreq, struct file *file)
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
>  		rw_ctx = ceph_find_rw_context(fi);
> -		if (rw_ctx)
> +		if (rw_ctx) {
> +			kfree(priv);
>  			return 0;

This is not working. When reaching here by read() system call, we always
have non-null rw_ctx.  (As I read the code and also verified with gdb)
ceph_add_rw_context() is invoked in ceph_read_iter().

> +		}
> +		priv->file_ra_pages = file->f_ra.ra_pages;
> +		priv->file_ra_disabled = !!(file->f_mode & FMODE_RANDOM);

'!!' is not needed. From coding-style.rst: "When using bool types the
!! construction is not needed, which eliminates a class of bugs".

Thanks
Hu Weiwen

>  	}
>  
>  	/*
> @@ -425,27 +434,39 @@ static int ceph_init_request(struct netfs_io_request *rreq, struct file *file)
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
> +	if (ret)
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
> +	ceph_put_cap_refs(ceph_inode(rreq->inode), priv->caps);
> +	kfree(priv);
> +	rreq->netfs_priv = NULL;
>  }
>  
>  const struct netfs_request_ops ceph_netfs_ops = {
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index a226d36b3ecb..1233f53f6e0b 100644
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
> +	 * The posix_fadvise could update the bdi's default ra_pages.
> +	 */
> +	unsigned int file_ra_pages;
> +
> +	/* Set it if posix_fadvise disables file readahead entirely */
> +	bool file_ra_disabled;
> +};
> +
>  static inline struct ceph_inode_info *
>  ceph_inode(const struct inode *inode)
>  {
> -- 
> 2.40.0
> 
