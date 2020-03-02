Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4CC517645E
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Mar 2020 20:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgCBTxx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Mar 2020 14:53:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:32896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgCBTxw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 14:53:52 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC4E42086A;
        Mon,  2 Mar 2020 19:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583178832;
        bh=Z2gEqSEvxdxoI7FwMvRJzKVk1KM2sLhR8s1toJQnGWc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IvKHHzIQYa2X1SWChXiH6clg3jFkIOsh1LJUjDvJjADK9kYAqKkU4Hugnn3tUMM3J
         h6ugmnJ10XKimdOHfhK+MJ8rfKGLhVFb9eZuidT+LgidKvUEahxfqn0RfcmdcLcfuD
         0tblJMgLU5avRAat+idGrmU8zO+OaQOExBibPxyg=
Message-ID: <186bfc2278dbdd4eac21f6ce03108c53e3f574b3.camel@kernel.org>
Subject: Re: [PATCH v3 0/6] ceph: don't request caps for idle open files
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Mon, 02 Mar 2020 14:53:50 -0500
In-Reply-To: <20200228115550.6904-1-zyan@redhat.com>
References: <20200228115550.6904-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-02-28 at 19:55 +0800, Yan, Zheng wrote:
> This series make cephfs client not request caps for open files that
> idle for a long time. For the case that one active client and multiple
> standby clients open the same file, this increase the possibility that
> mds issues exclusive caps to the active client.
> 
> Yan, Zheng (4):
>   ceph: always renew caps if mds_wanted is insufficient
>   ceph: consider inode's last read/write when calculating wanted caps
>   ceph: simplify calling of ceph_get_fmode()
>   ceph: remove delay check logic from ceph_check_caps()
> 
>  fs/ceph/caps.c               | 324 +++++++++++++++--------------------
>  fs/ceph/file.c               |  39 ++---
>  fs/ceph/inode.c              |  19 +-
>  fs/ceph/ioctl.c              |   2 +
>  fs/ceph/mds_client.c         |   5 -
>  fs/ceph/super.h              |  35 ++--
>  include/linux/ceph/ceph_fs.h |   1 +
>  7 files changed, 188 insertions(+), 237 deletions(-)
> 
> changes since v2
>  - make __ceph_caps_file_wanted more readable
>  - add patch 5 and 6, which fix hung write during testing patch 1~4
> 

This patch series causes some serious slowdown in the async dirops
patches that I've not yet fully tracked down, and I suspect that they
may also be the culprit in these bugs:

    https://tracker.ceph.com/issues/44381
    https://tracker.ceph.com/issues/44382

I'm going to drop this series from the testing branch for now, until we
can track down the issue.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

