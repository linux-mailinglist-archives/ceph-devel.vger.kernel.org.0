Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64FCA2A452
	for <lists+ceph-devel@lfdr.de>; Sat, 25 May 2019 14:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfEYMHl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 25 May 2019 08:07:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60322 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726585AbfEYMHl (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 25 May 2019 08:07:41 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5EA3C308A9BE;
        Sat, 25 May 2019 12:07:41 +0000 (UTC)
Received: from [10.72.12.46] (ovpn-12-46.pek2.redhat.com [10.72.12.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDE322DE9E;
        Sat, 25 May 2019 12:07:36 +0000 (UTC)
Subject: Re: [PATCH] ceph: fix warning PTR_ERR_OR_ZERO can be used
To:     Hariprasad Kelam <hariprasad.kelam@gmail.com>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190525091559.GA14633@hari-Inspiron-1545>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <d17e2d82-81d2-2308-fef8-77b6a5204ad5@redhat.com>
Date:   Sat, 25 May 2019 20:07:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190525091559.GA14633@hari-Inspiron-1545>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Sat, 25 May 2019 12:07:41 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 5/25/19 5:15 PM, Hariprasad Kelam wrote:
> change1: fix below warning  reported by coccicheck
> 
> /fs/ceph/export.c:371:33-39: WARNING: PTR_ERR_OR_ZERO can be used
> 
> change2: typecasted PTR_ERR_OR_ZERO to long as dout expecting long
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> ---
>   fs/ceph/export.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index d3ef7ee42..15ff1b0 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -368,7 +368,7 @@ static struct dentry *ceph_get_parent(struct dentry *child)
>   	}
>   out:
>   	dout("get_parent %p ino %llx.%llx err=%ld\n",
> -	     child, ceph_vinop(inode), (IS_ERR(dn) ? PTR_ERR(dn) : 0));
> +	     child, ceph_vinop(inode), (long)PTR_ERR_OR_ZERO(dn));
>   	return dn;
>   }
>   
> 

Applied.

Thanks
Yan, Zheng
