Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964721EB36E
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Jun 2020 04:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgFBCmH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jun 2020 22:42:07 -0400
Received: from m9783.mail.qiye.163.com ([220.181.97.83]:58940 "EHLO
        m9783.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgFBCmF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jun 2020 22:42:05 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jun 2020 22:42:03 EDT
Received: from [10.0.2.15] (unknown [218.94.118.90])
        by m9783.mail.qiye.163.com (Hmail) with ESMTPA id 4C133C17D7;
        Tue,  2 Jun 2020 10:34:24 +0800 (CST)
Subject: Re: [PATCH 2/2] rbd: compression_hint option
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Jason Dillaman <jdillama@redhat.com>
References: <20200601195826.17159-1-idryomov@gmail.com>
 <20200601195826.17159-3-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <e3446fba-65e9-89b4-9687-6735f6935196@easystack.cn>
Date:   Tue, 2 Jun 2020 10:34:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200601195826.17159-3-idryomov@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVS0lCS0tLSUNJSUNMTVlXWShZQU
        lCN1dZLVlBSVdZDwkaFQgSH1lBWR0iNQs4HDgzDikoDA4PLR4rPjk6OhxWVlVOTEMoSVlXWQkOFx
        4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBA6Syo6Tjg2DT0VECNMFhkW
        PQ0wCxJVSlVKTkJKS01OSU1PTkNCVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
        V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0NNSDcG
X-HM-Tid: 0a7272e141412085kuqy4c133c17d7
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Ilya,

ÔÚ 6/2/2020 3:58 AM, Ilya Dryomov Ð´µÀ:
> Allow hinting to bluestore if the data should/should not be compressed.
> The default is to not hint (compression_hint=none).
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>   drivers/block/rbd.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 42 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index b1cd41e671d1..e02089d550a4 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -836,6 +836,7 @@ enum {
>   	Opt_lock_timeout,
>   	/* int args above */
>   	Opt_pool_ns,
> +	Opt_compression_hint,
>   	/* string args above */
>   	Opt_read_only,
>   	Opt_read_write,
> @@ -844,8 +845,23 @@ enum {
>   	Opt_notrim,
>   };
>   
> +enum {
> +	Opt_compression_hint_none,
> +	Opt_compression_hint_compressible,
> +	Opt_compression_hint_incompressible,
> +};
> +
> +static const struct constant_table rbd_param_compression_hint[] = {
> +	{"none",		Opt_compression_hint_none},
> +	{"compressible",	Opt_compression_hint_compressible},
> +	{"incompressible",	Opt_compression_hint_incompressible},
> +	{}
> +};
> +
>   static const struct fs_parameter_spec rbd_parameters[] = {
>   	fsparam_u32	("alloc_size",			Opt_alloc_size),
> +	fsparam_enum	("compression_hint",		Opt_compression_hint,
> +			 rbd_param_compression_hint),
>   	fsparam_flag	("exclusive",			Opt_exclusive),
>   	fsparam_flag	("lock_on_read",		Opt_lock_on_read),
>   	fsparam_u32	("lock_timeout",		Opt_lock_timeout),
> @@ -867,6 +883,8 @@ struct rbd_options {
>   	bool	lock_on_read;
>   	bool	exclusive;
>   	bool	trim;
> +
> +	u32 alloc_hint_flags;  /* CEPH_OSD_OP_ALLOC_HINT_FLAG_* */
>   };
>   
>   #define RBD_QUEUE_DEPTH_DEFAULT	BLKDEV_MAX_RQ
> @@ -2254,7 +2272,7 @@ static void __rbd_osd_setup_write_ops(struct ceph_osd_request *osd_req,
>   		osd_req_op_alloc_hint_init(osd_req, which++,
>   					   rbd_dev->layout.object_size,
>   					   rbd_dev->layout.object_size,
> -					   0);
> +					   rbd_dev->opts->alloc_hint_flags);
>   	}
>   
>   	if (rbd_obj_is_entire(obj_req))
> @@ -6332,6 +6350,29 @@ static int rbd_parse_param(struct fs_parameter *param,
>   		pctx->spec->pool_ns = param->string;
>   		param->string = NULL;
>   		break;
> +	case Opt_compression_hint:
> +		switch (result.uint_32) {
> +		case Opt_compression_hint_none:
> +			opt->alloc_hint_flags &=
> +			    ~(CEPH_OSD_ALLOC_HINT_FLAG_COMPRESSIBLE |
> +			      CEPH_OSD_ALLOC_HINT_FLAG_INCOMPRESSIBLE);
> +			break;
> +		case Opt_compression_hint_compressible:
> +			opt->alloc_hint_flags |=
> +			    CEPH_OSD_ALLOC_HINT_FLAG_COMPRESSIBLE;
> +			opt->alloc_hint_flags &=
> +			    ~CEPH_OSD_ALLOC_HINT_FLAG_INCOMPRESSIBLE;
> +			break;
> +		case Opt_compression_hint_incompressible:
> +			opt->alloc_hint_flags |=
> +			    CEPH_OSD_ALLOC_HINT_FLAG_INCOMPRESSIBLE;
> +			opt->alloc_hint_flags &=
> +			    ~CEPH_OSD_ALLOC_HINT_FLAG_COMPRESSIBLE;
> +			break;


Just one little question here,

(1) none opt means clear compressible related bits in hint flags, then 
lets the compressor in bluestore to decide compress or not.

(2) compressible opt means set compressible bit and clear incompressible bit

(3) incompressible opt means set incompressible bit and clear 
compressible bit


Is there any scenario that alloc_hint_flags is not zero filled before 
rbd_parse_param(), then we have to clear the unexpected bit?


Thanx

Yang

> +		default:
> +			BUG();
> +		}
> +		break;
>   	case Opt_read_only:
>   		opt->read_only = true;
>   		break;
