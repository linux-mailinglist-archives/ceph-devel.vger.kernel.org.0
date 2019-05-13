Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2391B6C3
	for <lists+ceph-devel@lfdr.de>; Mon, 13 May 2019 15:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbfEMNLB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 May 2019 09:11:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45722 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbfEMNLA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 May 2019 09:11:00 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8DAF046202;
        Mon, 13 May 2019 13:11:00 +0000 (UTC)
Received: from [10.72.12.50] (ovpn-12-50.pek2.redhat.com [10.72.12.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DFB15D706;
        Mon, 13 May 2019 13:10:55 +0000 (UTC)
Subject: Re: [PATCH] ceph: fix ceph_mdsc_build_path to not stop on first
 component
To:     Jeff Layton <jlayton@kernel.org>, sage@redhat.com,
        idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
References: <20190509140147.20755-1-jlayton@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <9d0d8dc2-2b69-549b-f9a1-902073049fb5@redhat.com>
Date:   Mon, 13 May 2019 21:10:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509140147.20755-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 13 May 2019 13:11:00 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 5/9/19 10:01 PM, Jeff Layton wrote:
> When ceph_mdsc_build_path is handed a positive dentry, it will return a
> zero-length path string with the base set to that dentry. This is not
> what we want. Always include at least one path component in the string.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/mds_client.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> I found this while testing my asynchronous unlink patches. We have
> to do the unlink in this case without the parent being locked, and
> that showed that we got a bogus path built in this case.
> 
> This seems to work correctly, but it's a little unclear whether the
> existing behavior is desirable in some cases. Is this the right thing
> to do here?
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 66eae336a68a..39f5bd2eafda 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2114,9 +2114,10 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
>   		if (inode && ceph_snap(inode) == CEPH_SNAPDIR) {
>   			dout("build_path path+%d: %p SNAPDIR\n",
>   			     pos, temp);
> -		} else if (stop_on_nosnap && inode &&
> +		} else if (stop_on_nosnap && inode && dentry != temp &&
>   			   ceph_snap(inode) == CEPH_NOSNAP) {
>   			spin_unlock(&temp->d_lock);
> +			pos++; /* get rid of any prepended '/' */
>   			break;
>   		} else {
>   			pos -= temp->d_name.len;
> 

Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
