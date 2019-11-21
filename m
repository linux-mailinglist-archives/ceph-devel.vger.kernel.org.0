Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01281105897
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Nov 2019 18:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfKURaT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Nov 2019 12:30:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726568AbfKURaS (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 12:30:18 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C86432067D;
        Thu, 21 Nov 2019 17:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574357418;
        bh=0ojH0IBj7T7q8pGWyRTYS+jkG7sG3ZRGDZBM3P9X/T0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=um9nacxgCl/FtgxgeqvG1Uy1h4LGx6lfy5cQyNkmfx6yVTZzGw8h3e9P/A/BiYBZ0
         HqG7yfmGDa69w75jUOYiO6c0+dXJBp6oujT75Natig/+Zh2i0AeH45yDwr0/rkTf79
         JsHRaKIRjDXEY7rA6tjQKkiepkM0rgy+U8oxqeU4=
Message-ID: <52135037d9009f678e1b05964f0d6a1366a77ed0.camel@kernel.org>
Subject: Re: [PATCH 2/3] mdsmap: fix mdsmap cluster available check based on
 laggy number
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 21 Nov 2019 12:30:17 -0500
In-Reply-To: <20191120082902.38666-3-xiubli@redhat.com>
References: <20191120082902.38666-1-xiubli@redhat.com>
         <20191120082902.38666-3-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-11-20 at 03:29 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> In case the max_mds > 1 in MDS cluster and there is no any standby
> MDS and all the max_mds MDSs are in up:active state, if one of the
> up:active MDSs is dead, the m->m_num_laggy in kclient will be 1.
> Then the mount will fail without considering other healthy MDSs.
> 
> Only when all the MDSs in the cluster are laggy will treat the
> cluster as not be available.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mdsmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 471bac335fae..8b4f93e5b468 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -396,7 +396,7 @@ bool ceph_mdsmap_is_cluster_available(struct ceph_mdsmap *m)
>  		return false;
>  	if (m->m_damaged)
>  		return false;
> -	if (m->m_num_laggy > 0)
> +	if (m->m_num_laggy == m->m_num_mds)
>  		return false;
>  	for (i = 0; i < m->m_num_mds; i++) {
>  		if (m->m_info[i].state == CEPH_MDS_STATE_ACTIVE)

Given that laggy servers are still expected to be "in" the cluster,
should we just eliminate this check altogether? It seems like we'd still
want to allow a mount to occur even if the cluster is lagging.
-- 
Jeff Layton <jlayton@kernel.org>

