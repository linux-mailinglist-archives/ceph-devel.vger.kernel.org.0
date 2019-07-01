Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B922F5B42E
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfGAFeD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:34:03 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:23242 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbfGAFeD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:34:03 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHybwXmhld8XzwAA--.1375S2;
        Mon, 01 Jul 2019 13:28:55 +0800 (CST)
Subject: Re: [PATCH 07/20] rbd: factor out rbd_osd_setup_copyup()
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-8-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D199A17.4080703@easystack.cn>
Date:   Mon, 1 Jul 2019 13:28:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-8-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowADHybwXmhld8XzwAA--.1375S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRZyCGUUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbicBfkellZuqgLTwAAsv
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:40 PM, Ilya Dryomov wrote:
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Missing a commit message. Otherwise,

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 29 +++++++++++++++++------------
>   1 file changed, 17 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 5c34fe215c63..e059a8139e4f 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -1861,6 +1861,21 @@ static int rbd_osd_setup_stat(struct ceph_osd_request *osd_req, int which)
>   	return 0;
>   }
>   
> +static int rbd_osd_setup_copyup(struct ceph_osd_request *osd_req, int which,
> +				u32 bytes)
> +{
> +	struct rbd_obj_request *obj_req = osd_req->r_priv;
> +	int ret;
> +
> +	ret = osd_req_op_cls_init(osd_req, which, "rbd", "copyup");
> +	if (ret)
> +		return ret;
> +
> +	osd_req_op_cls_request_data_bvecs(osd_req, which, obj_req->copyup_bvecs,
> +					  obj_req->copyup_bvec_count, bytes);
> +	return 0;
> +}
> +
>   static int count_write_ops(struct rbd_obj_request *obj_req)
>   {
>   	return 2; /* setallochint + write/writefull */
> @@ -2560,14 +2575,10 @@ static int rbd_obj_issue_copyup_empty_snapc(struct rbd_obj_request *obj_req,
>   	if (IS_ERR(osd_req))
>   		return PTR_ERR(osd_req);
>   
> -	ret = osd_req_op_cls_init(osd_req, 0, "rbd", "copyup");
> +	ret = rbd_osd_setup_copyup(osd_req, 0, bytes);
>   	if (ret)
>   		return ret;
>   
> -	osd_req_op_cls_request_data_bvecs(osd_req, 0,
> -					  obj_req->copyup_bvecs,
> -					  obj_req->copyup_bvec_count,
> -					  bytes);
>   	rbd_osd_format_write(osd_req);
>   
>   	ret = ceph_osdc_alloc_messages(osd_req, GFP_NOIO);
> @@ -2604,15 +2615,9 @@ static int rbd_obj_issue_copyup_ops(struct rbd_obj_request *obj_req, u32 bytes)
>   		return PTR_ERR(osd_req);
>   
>   	if (bytes != MODS_ONLY) {
> -		ret = osd_req_op_cls_init(osd_req, which, "rbd",
> -					  "copyup");
> +		ret = rbd_osd_setup_copyup(osd_req, which++, bytes);
>   		if (ret)
>   			return ret;
> -
> -		osd_req_op_cls_request_data_bvecs(osd_req, which++,
> -						  obj_req->copyup_bvecs,
> -						  obj_req->copyup_bvec_count,
> -						  bytes);
>   	}
>   
>   	switch (img_req->op_type) {


