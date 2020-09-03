Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1449925C25F
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Sep 2020 16:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbgICOVO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Sep 2020 10:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729246AbgICOST (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 3 Sep 2020 10:18:19 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80DEC2071B;
        Thu,  3 Sep 2020 14:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599142699;
        bh=cv8UHKW3oNrs0wlsgDC+FxPJPODMyV53tPpm1nSz7Kc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZvMvhwdce6lwefJhulx01jcM3Y8dHJfRjYFNvUph0J2Ngxq/4dn3zHQLOITtT8peo
         9NkeIIt42uGUr3jTOBlrOgpRY38VzRlma6JE4VhkphzGjvaSiHB0Nv/jGl1En72e5b
         gompd390bJsRANtpsDqJztR9A+4NpmSEsR8lgVOA=
Message-ID: <449a56624f3dd4e2a4a4cf95cd24d69c53700b6d.camel@kernel.org>
Subject: Re: [PATCH v5 0/2] ceph: metrics for opened files, pinned caps and
 opened inodes
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Thu, 03 Sep 2020 10:18:17 -0400
In-Reply-To: <20200903130140.799392-1-xiubli@redhat.com>
References: <20200903130140.799392-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-09-03 at 09:01 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Changed in V5:
> - Remove mdsc parsing helpers except the ceph_sb_to_mdsc()
> - Remove the is_opened member.
> 
> Changed in V4:
> - A small fix about the total_inodes.
> 
> Changed in V3:
> - Resend for V2 just forgot one patch, which is adding some helpers
> support to simplify the code.
> 
> Changed in V2:
> - Add number of inodes that have opened files.
> - Remove the dir metrics and fold into files.
> 
> 
> 
> Xiubo Li (2):
>   ceph: add ceph_sb_to_mdsc helper support to parse the mdsc
>   ceph: metrics for opened files, pinned caps and opened inodes
> 
>  fs/ceph/caps.c    | 41 +++++++++++++++++++++++++++++++++++++----
>  fs/ceph/debugfs.c | 11 +++++++++++
>  fs/ceph/dir.c     | 20 +++++++-------------
>  fs/ceph/file.c    | 13 ++++++-------
>  fs/ceph/inode.c   | 11 ++++++++---
>  fs/ceph/locks.c   |  2 +-
>  fs/ceph/metric.c  | 14 ++++++++++++++
>  fs/ceph/metric.h  |  7 +++++++
>  fs/ceph/quota.c   | 10 +++++-----
>  fs/ceph/snap.c    |  2 +-
>  fs/ceph/super.h   |  6 ++++++
>  11 files changed, 103 insertions(+), 34 deletions(-)
> 

Looks good. I went ahead and merge this into testing.

Small merge conflict in quota.c, which I guess is probably due to not
basing this on testing branch. I also dropped what looks like an
unrelated hunk in the second patch.

In the future, if you can be sure that patches you post apply cleanly to
testing branch then that would make things easier.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

