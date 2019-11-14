Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C01A7FBD82
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 02:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfKNBdE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Nov 2019 20:33:04 -0500
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:44244 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfKNBdE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 13 Nov 2019 20:33:04 -0500
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Nov 2019 20:33:03 EST
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADH_WRmrcxdqczJAw--.7196S2;
        Thu, 14 Nov 2019 09:27:02 +0800 (CST)
Subject: Re: [PATCH] rbd: update MAINTAINERS info
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20191113200151.30674-1-idryomov@gmail.com>
Cc:     Alex Elder <elder@kernel.org>, Sage Weil <sage@redhat.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5DCCAD65.50007@easystack.cn>
Date:   Thu, 14 Nov 2019 09:27:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20191113200151.30674-1-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowADH_WRmrcxdqczJAw--.7196S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRZUUUDUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbibgttellZuxXmGQAAsj
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Ilya,

On 11/14/2019 04:01 AM, Ilya Dryomov wrote:
> Alex has got plenty on his plate aside from rbd and hasn't really been
> active in recent years.  Remove his maintainership entry.
>
> Dongsheng is very familiar with the code base and has been reviewing rbd
> patches for a while now.  Add him as a reviewer.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index eb19fad370d7..073cacc1b23c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13582,7 +13582,7 @@ F:	drivers/media/radio/radio-tea5777.c
>   RADOS BLOCK DEVICE (RBD)
>   M:	Ilya Dryomov <idryomov@gmail.com>
>   M:	Sage Weil <sage@redhat.com>
> -M:	Alex Elder <elder@kernel.org>
> +R:	Dongsheng Yang <dongsheng.yang@easystack.cn>

Acked-by: Dongsheng Yang<dongsheng.yang@easystack.cn>


Thanx
>   L:	ceph-devel@vger.kernel.org
>   W:	http://ceph.com/
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git


