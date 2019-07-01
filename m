Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD965B42F
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfGAFeP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:34:15 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:23539 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbfGAFeP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:34:15 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAAHAnUamhldCX3wAA--.1302S2;
        Mon, 01 Jul 2019 13:28:58 +0800 (CST)
Subject: Re: [PATCH 08/20] rbd: factor out __rbd_osd_setup_discard_ops()
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-9-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D199A1A.6070001@easystack.cn>
Date:   Mon, 1 Jul 2019 13:28:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-9-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAAHAnUamhldCX3wAA--.1302S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZr4xtr1xGw4ftr45Gr1rZwb_yoW5Zw4Upr
        ZrJay5tas8KwnrJws0va15ZrZ8Ja18Aa4xXa4IkFn3Can3WF1kAF18ta42qFy7GFWfJr43
        tF4FvFZ3Gw12grDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRkpndUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbibRvkellZul2W+wAAsi
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:40 PM, Ilya Dryomov wrote:
> With obj_req->xferred removed, obj_req->ex.oe_off and obj_req->ex.oe_len
> can be updated if required for alignment.  Previously the new offset and
> length weren't stored anywhere beyond rbd_obj_setup_discard().
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>


Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 43 +++++++++++++++++++++++++++----------------
>   1 file changed, 27 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index e059a8139e4f..acc9017034d7 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -1943,12 +1943,27 @@ static u16 truncate_or_zero_opcode(struct rbd_obj_request *obj_req)
>   					  CEPH_OSD_OP_ZERO;
>   }
>   
> +static void __rbd_osd_setup_discard_ops(struct ceph_osd_request *osd_req,
> +					int which)
> +{
> +	struct rbd_obj_request *obj_req = osd_req->r_priv;
> +
> +	if (rbd_obj_is_entire(obj_req) && !obj_req->num_img_extents) {
> +		rbd_assert(obj_req->flags & RBD_OBJ_FLAG_DELETION);
> +		osd_req_op_init(osd_req, which, CEPH_OSD_OP_DELETE, 0);
> +	} else {
> +		osd_req_op_extent_init(osd_req, which,
> +				       truncate_or_zero_opcode(obj_req),
> +				       obj_req->ex.oe_off, obj_req->ex.oe_len,
> +				       0, 0);
> +	}
> +}
> +
>   static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
>   {
>   	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>   	struct ceph_osd_request *osd_req;
> -	u64 off = obj_req->ex.oe_off;
> -	u64 next_off = obj_req->ex.oe_off + obj_req->ex.oe_len;
> +	u64 off, next_off;
>   	int ret;
>   
>   	/*
> @@ -1961,10 +1976,17 @@ static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
>   	 */
>   	if (rbd_dev->opts->alloc_size != rbd_dev->layout.object_size ||
>   	    !rbd_obj_is_tail(obj_req)) {
> -		off = round_up(off, rbd_dev->opts->alloc_size);
> -		next_off = round_down(next_off, rbd_dev->opts->alloc_size);
> +		off = round_up(obj_req->ex.oe_off, rbd_dev->opts->alloc_size);
> +		next_off = round_down(obj_req->ex.oe_off + obj_req->ex.oe_len,
> +				      rbd_dev->opts->alloc_size);
>   		if (off >= next_off)
>   			return 1;
> +
> +		dout("%s %p %llu~%llu -> %llu~%llu\n", __func__,
> +		     obj_req, obj_req->ex.oe_off, obj_req->ex.oe_len,
> +		     off, next_off - off);
> +		obj_req->ex.oe_off = off;
> +		obj_req->ex.oe_len = next_off - off;
>   	}
>   
>   	/* reverse map the entire object onto the parent */
> @@ -1979,19 +2001,8 @@ static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
>   	if (IS_ERR(osd_req))
>   		return PTR_ERR(osd_req);
>   
> -	if (rbd_obj_is_entire(obj_req) && !obj_req->num_img_extents) {
> -		rbd_assert(obj_req->flags & RBD_OBJ_FLAG_DELETION);
> -		osd_req_op_init(osd_req, 0, CEPH_OSD_OP_DELETE, 0);
> -	} else {
> -		dout("%s %p %llu~%llu -> %llu~%llu\n", __func__,
> -		     obj_req, obj_req->ex.oe_off, obj_req->ex.oe_len,
> -		     off, next_off - off);
> -		osd_req_op_extent_init(osd_req, 0,
> -				       truncate_or_zero_opcode(obj_req),
> -				       off, next_off - off, 0, 0);
> -	}
> -
>   	obj_req->write_state = RBD_OBJ_WRITE_START;
> +	__rbd_osd_setup_discard_ops(osd_req, 0);
>   	rbd_osd_format_write(osd_req);
>   	return 0;
>   }


