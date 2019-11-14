Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E1DFBDC9
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 03:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfKNCMc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Nov 2019 21:12:32 -0500
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:10124 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfKNCMc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 13 Nov 2019 21:12:32 -0500
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAAnjWcNuMxddEXKAw--.246S2;
        Thu, 14 Nov 2019 10:12:29 +0800 (CST)
Subject: Re: [PATCH] rbd: silence bogus uninitialized warning in
 rbd_object_map_update_finish()
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20191113192954.29732-1-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5DCCB80C.80508@easystack.cn>
Date:   Thu, 14 Nov 2019 10:12:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20191113192954.29732-1-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAAnjWcNuMxddEXKAw--.246S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRGPfHDUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiaQ1tellZu3FelAAAsz
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 11/14/2019 03:29 AM, Ilya Dryomov wrote:
> Some versions of gcc (so far 6.3 and 7.4) throw a warning:
>
>    drivers/block/rbd.c: In function 'rbd_object_map_callback':
>    drivers/block/rbd.c:2124:21: warning: 'current_state' may be used uninitialized in this function [-Wmaybe-uninitialized]
>          (current_state == OBJECT_EXISTS && state == OBJECT_EXISTS_CLEAN))
>    drivers/block/rbd.c:2092:23: note: 'current_state' was declared here
>      u8 state, new_state, current_state;
>                            ^~~~~~~~~~~~~
>
> It's bogus because all current_state accesses are guarded by
> has_current_state.
>
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>   drivers/block/rbd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 395410b0d335..2aaa56e4cec9 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -2070,7 +2070,7 @@ static int rbd_object_map_update_finish(struct rbd_obj_request *obj_req,
>   	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>   	struct ceph_osd_data *osd_data;
>   	u64 objno;
> -	u8 state, new_state, current_state;
> +	u8 state, new_state, uninitialized_var(current_state);
>   	bool has_current_state;
>   	void *p;
>   
Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>

Thanx


