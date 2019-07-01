Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52ED5B42B
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfGAFdv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:33:51 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22902 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbfGAFdv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:33:51 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowABHo2k9mxld1ojwAA--.1389S2;
        Mon, 01 Jul 2019 13:33:49 +0800 (CST)
Subject: Re: [PATCH 20/20] rbd: setallochint only if object doesn't exist
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-21-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D199B3D.8010203@easystack.cn>
Date:   Mon, 1 Jul 2019 13:33:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-21-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowABHo2k9mxld1ojwAA--.1389S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTi_Ma2UUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiHx3keluyG6630wAAsk
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:41 PM, Ilya Dryomov wrote:
> setallochint is really only useful on object creation.  Continue
> hinting unconditionally if object map cannot be used.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>


Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 19 ++++++++++++++-----
>   1 file changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 756595f5fbc9..5dc217530f0f 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -2366,9 +2366,12 @@ static void __rbd_osd_setup_write_ops(struct ceph_osd_request *osd_req,
>   	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>   	u16 opcode;
>   
> -	osd_req_op_alloc_hint_init(osd_req, which++,
> -				   rbd_dev->layout.object_size,
> -				   rbd_dev->layout.object_size);
> +	if (!use_object_map(rbd_dev) ||
> +	    !(obj_req->flags & RBD_OBJ_FLAG_MAY_EXIST)) {
> +		osd_req_op_alloc_hint_init(osd_req, which++,
> +					   rbd_dev->layout.object_size,
> +					   rbd_dev->layout.object_size);
> +	}
>   
>   	if (rbd_obj_is_entire(obj_req))
>   		opcode = CEPH_OSD_OP_WRITEFULL;
> @@ -2511,9 +2514,15 @@ static int rbd_obj_init_zeroout(struct rbd_obj_request *obj_req)
>   
>   static int count_write_ops(struct rbd_obj_request *obj_req)
>   {
> -	switch (obj_req->img_request->op_type) {
> +	struct rbd_img_request *img_req = obj_req->img_request;
> +
> +	switch (img_req->op_type) {
>   	case OBJ_OP_WRITE:
> -		return 2; /* setallochint + write/writefull */
> +		if (!use_object_map(img_req->rbd_dev) ||
> +		    !(obj_req->flags & RBD_OBJ_FLAG_MAY_EXIST))
> +			return 2; /* setallochint + write/writefull */
> +
> +		return 1; /* write/writefull */
>   	case OBJ_OP_DISCARD:
>   		return 1; /* delete/truncate/zero */
>   	case OBJ_OP_ZEROOUT:


