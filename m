Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C27B55B43E
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfGAFfC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:35:02 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:24641 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfGAFfB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:35:01 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAAXj2tNmhld1n7wAA--.1275S2;
        Mon, 01 Jul 2019 13:29:50 +0800 (CST)
Subject: Re: [PATCH 17/20] libceph: export osd_req_op_data() macro
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-18-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D199A4D.3070802@easystack.cn>
Date:   Mon, 1 Jul 2019 13:29:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-18-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAAXj2tNmhld1n7wAA--.1275S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRAjjkUUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbieQ7kelqrhuoWcQAAsT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:41 PM, Ilya Dryomov wrote:
> We already have one exported wrapper around it for extent.osd_data and
> rbd_object_map_update_finish() needs another one for cls.request_data.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>


Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   include/linux/ceph/osd_client.h | 8 ++++++++
>   net/ceph/osd_client.c           | 8 --------
>   2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index edb191c40a5c..44100a4f0808 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -389,6 +389,14 @@ extern void ceph_osdc_handle_map(struct ceph_osd_client *osdc,
>   void ceph_osdc_update_epoch_barrier(struct ceph_osd_client *osdc, u32 eb);
>   void ceph_osdc_abort_requests(struct ceph_osd_client *osdc, int err);
>   
> +#define osd_req_op_data(oreq, whch, typ, fld)				\
> +({									\
> +	struct ceph_osd_request *__oreq = (oreq);			\
> +	unsigned int __whch = (whch);					\
> +	BUG_ON(__whch >= __oreq->r_num_ops);				\
> +	&__oreq->r_ops[__whch].typ.fld;					\
> +})
> +
>   extern void osd_req_op_init(struct ceph_osd_request *osd_req,
>   			    unsigned int which, u16 opcode, u32 flags);
>   
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index cc2bf296583d..22e8ccc1f975 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -171,14 +171,6 @@ static void ceph_osd_data_bvecs_init(struct ceph_osd_data *osd_data,
>   	osd_data->num_bvecs = num_bvecs;
>   }
>   
> -#define osd_req_op_data(oreq, whch, typ, fld)				\
> -({									\
> -	struct ceph_osd_request *__oreq = (oreq);			\
> -	unsigned int __whch = (whch);					\
> -	BUG_ON(__whch >= __oreq->r_num_ops);				\
> -	&__oreq->r_ops[__whch].typ.fld;					\
> -})
> -
>   static struct ceph_osd_data *
>   osd_req_op_raw_data_in(struct ceph_osd_request *osd_req, unsigned int which)
>   {


