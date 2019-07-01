Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC2C5B433
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfGAFe2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:34:28 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:23793 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbfGAFe2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:34:28 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAAXj2slmhldhH3wAA--.1263S2;
        Mon, 01 Jul 2019 13:29:10 +0800 (CST)
Subject: Re: [PATCH 10/20] rbd: rename rbd_obj_setup_*() to rbd_obj_init_*()
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-11-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D199A25.5060108@easystack.cn>
Date:   Mon, 1 Jul 2019 13:29:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-11-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAAXj2slmhldhH3wAA--.1263S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxuF48ZF47JryrtFW3CF43trb_yoW5Ww1rpF
        4DGF4UKw1DXwnrWws0v3yUZr1UGF4xA3y7X3yxK397GFs7WwnYkFy8A3429a47CFyrJF4x
        Ka1jvrn3Ww47KrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pR66wtUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiZQbkeli2k60r4AAAsm
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:41 PM, Ilya Dryomov wrote:
> These functions don't allocate and set up OSD requests anymore.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 26 +++++++++++++-------------
>   1 file changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 61bc20cf1c29..2bafdee61dbd 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -1819,12 +1819,6 @@ static void rbd_osd_setup_data(struct ceph_osd_request *osd_req, int which)
>   	}
>   }
>   
> -static int rbd_obj_setup_read(struct rbd_obj_request *obj_req)
> -{
> -	obj_req->read_state = RBD_OBJ_READ_START;
> -	return 0;
> -}
> -
>   static int rbd_osd_setup_stat(struct ceph_osd_request *osd_req, int which)
>   {
>   	struct page **pages;
> @@ -1863,6 +1857,12 @@ static int rbd_osd_setup_copyup(struct ceph_osd_request *osd_req, int which,
>   	return 0;
>   }
>   
> +static int rbd_obj_init_read(struct rbd_obj_request *obj_req)
> +{
> +	obj_req->read_state = RBD_OBJ_READ_START;
> +	return 0;
> +}
> +
>   static void __rbd_osd_setup_write_ops(struct ceph_osd_request *osd_req,
>   				      int which)
>   {
> @@ -1884,7 +1884,7 @@ static void __rbd_osd_setup_write_ops(struct ceph_osd_request *osd_req,
>   	rbd_osd_setup_data(osd_req, which);
>   }
>   
> -static int rbd_obj_setup_write(struct rbd_obj_request *obj_req)
> +static int rbd_obj_init_write(struct rbd_obj_request *obj_req)
>   {
>   	int ret;
>   
> @@ -1922,7 +1922,7 @@ static void __rbd_osd_setup_discard_ops(struct ceph_osd_request *osd_req,
>   	}
>   }
>   
> -static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
> +static int rbd_obj_init_discard(struct rbd_obj_request *obj_req)
>   {
>   	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>   	u64 off, next_off;
> @@ -1991,7 +1991,7 @@ static void __rbd_osd_setup_zeroout_ops(struct ceph_osd_request *osd_req,
>   				       0, 0);
>   }
>   
> -static int rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req)
> +static int rbd_obj_init_zeroout(struct rbd_obj_request *obj_req)
>   {
>   	int ret;
>   
> @@ -2062,16 +2062,16 @@ static int __rbd_img_fill_request(struct rbd_img_request *img_req)
>   	for_each_obj_request_safe(img_req, obj_req, next_obj_req) {
>   		switch (img_req->op_type) {
>   		case OBJ_OP_READ:
> -			ret = rbd_obj_setup_read(obj_req);
> +			ret = rbd_obj_init_read(obj_req);
>   			break;
>   		case OBJ_OP_WRITE:
> -			ret = rbd_obj_setup_write(obj_req);
> +			ret = rbd_obj_init_write(obj_req);
>   			break;
>   		case OBJ_OP_DISCARD:
> -			ret = rbd_obj_setup_discard(obj_req);
> +			ret = rbd_obj_init_discard(obj_req);
>   			break;
>   		case OBJ_OP_ZEROOUT:
> -			ret = rbd_obj_setup_zeroout(obj_req);
> +			ret = rbd_obj_init_zeroout(obj_req);
>   			break;
>   		default:
>   			BUG();


