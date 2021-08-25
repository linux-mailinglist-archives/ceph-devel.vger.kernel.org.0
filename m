Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9073F7B61
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Aug 2021 19:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbhHYRRb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Aug 2021 13:17:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232659AbhHYRRb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 13:17:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 021BB61076;
        Wed, 25 Aug 2021 17:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629911805;
        bh=WcSo5oP5/H1O4jKOK02STfK4JSaJCwvYT2KvHgjsgo0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Qx4sma0Hs82p3HKy5xOvcApwzQJvs3sW4gZ5zXeRk85tkDY2xJtomPIUrybDf3WM6
         BOrpCaAfHhpoYkDao2AiiI6d/ulnVFWES7OuB0SYCN+zMxHz3RzKAtkZ6q4eq83iIY
         lsps5VkB4pG09s9CDxhthmVlmCruq4ShBz3vxGUjfyrBor7L/ADQu+/CmXypNRd9IJ
         xExf81exr4Xr+VbBSnOVr32Z/X/jrCLbAoL94+6wD4r9GDPw7+kJVR5XHlUCG2QLFd
         1lddPHfpMTkxYGtwUEp2QVRrGcXsKFAX+LQPM2yAQdiVOWpwv5gWH0dzRECGbJQT5H
         RLPlePQrqmUyQ==
Message-ID: <b8e8fb45f9a34dc24b3db66dc26dd55dfb70efd4.camel@kernel.org>
Subject: Re: [PATCH v3 0/3] ceph: remove the capsnaps when removing the caps
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Wed, 25 Aug 2021 13:16:43 -0400
In-Reply-To: <20210825134545.117521-1-xiubli@redhat.com>
References: <20210825134545.117521-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-08-25 at 21:45 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> V3:
> - fix one crash bug in the first patch.
> 
> V2:
> - minor fixes to clean up the code from Jeff's comments, thanks
> - swith to use lockdep_assert_held().
> 
> 
> 
> Test this for around 5 hours and this patch series worked well for me, my test script is:
> 
> $ while [ 1 ]; do date; for d in A B C; do (for i in {1..3}; do ./bin/mount.ceph :/ /mnt/kcephfs.$d -o noshare; rm -rf /mnt/kcephfs.$d/file$i.txt; rmdir /mnt/kcephfs.$d/.snap/snap$i; dd if=/dev/zero of=/mnt/kcephfs.$d/file$i.txt bs=1M count=8; mkdir -p /mnt/kcephfs.$d/.snap/snap$i; umount -fl /mnt/kcephfs.$d; done ) & done; wait; date; done
> 
> 
> 
> Xiubo Li (3):
>   ceph: remove the capsnaps when removing the caps
>   ceph: don't WARN if we're force umounting
>   ceph: don't WARN if we're iterate removing the session caps
> 
>  fs/ceph/caps.c       | 106 ++++++++++++++++++++++++++++++++-----------
>  fs/ceph/mds_client.c |  40 ++++++++++++++--
>  fs/ceph/super.h      |   7 +++
>  3 files changed, 123 insertions(+), 30 deletions(-)
> 

This looks good overall. I made a small change to the first patch to
turn the old BUG_ON into a WARN_ON_ONCE. I didn't see the need to crash
the box in that case.

Also, I revised the changelogs and a couple of comments. Let me know if
you see any issues with the changes I merged into "testing".

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

