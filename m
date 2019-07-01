Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1765B43B
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfGAFet (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:34:49 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:24371 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfGAFet (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:34:49 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowABX8rRHmhldpn7wAA--.1286S2;
        Mon, 01 Jul 2019 13:29:43 +0800 (CST)
Subject: Re: [PATCH 15/20] libceph: bump CEPH_MSG_MAX_DATA_LEN (again)
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-16-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D199A47.9030103@easystack.cn>
Date:   Mon, 1 Jul 2019 13:29:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-16-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowABX8rRHmhldpn7wAA--.1286S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRAjjkUUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbihAfkelsfm2zu7QAAst
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:41 PM, Ilya Dryomov wrote:
> This time for rbd object map.  Object maps are limited in size to
> 256000000 objects, two bits per object.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   include/linux/ceph/libceph.h | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index 337d5049ff93..0ae60b55e55a 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -84,11 +84,13 @@ struct ceph_options {
>   #define CEPH_MSG_MAX_MIDDLE_LEN	(16*1024*1024)
>   
>   /*
> - * Handle the largest possible rbd object in one message.
> + * The largest possible rbd data object is 32M.
> + * The largest possible rbd object map object is 64M.
> + *
>    * There is no limit on the size of cephfs objects, but it has to obey
>    * rsize and wsize mount options anyway.
>    */
> -#define CEPH_MSG_MAX_DATA_LEN	(32*1024*1024)
> +#define CEPH_MSG_MAX_DATA_LEN	(64*1024*1024)
>   
>   #define CEPH_AUTH_NAME_DEFAULT   "guest"
>   


