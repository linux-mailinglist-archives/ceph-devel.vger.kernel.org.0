Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DD183017
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Aug 2019 12:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730928AbfHFKyT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Aug 2019 06:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728845AbfHFKyT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 06:54:19 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 638ED2054F;
        Tue,  6 Aug 2019 10:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565088859;
        bh=YQEikljZ/tBZV3ebX8JTkum7tqmMxMu9IWg5yTvOpVE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rNga8k+zxaSPvL2JwPsvR8fV5qbMdps9Lk8PRiDAtCbEsGAeicXuTTPIWcZvuV8Ut
         MWQKwOEsjmpac9VklhXGdTFbCconPg5ZSdpmqOvT8ZDSpwNkNyBO84h4oOh7LrRJ/A
         zgtavgcPGLQdXniozp3riMjYmn9i+W2JWkkjbC7c=
Message-ID: <1277d93a52a5c25f4c81f3c34eebced13bf3266d.camel@kernel.org>
Subject: Re: [PATCH] ceph: add buffered/direct exclusionary locking for
 reads and writes
From:   Jeff Layton <jlayton@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, sage@redhat.com,
        ukernel@gmail.com
Date:   Tue, 06 Aug 2019 06:54:17 -0400
In-Reply-To: <20190806082520.GA30230@infradead.org>
References: <20190805200501.17905-1-jlayton@kernel.org>
         <20190806082520.GA30230@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-08-06 at 01:25 -0700, Christoph Hellwig wrote:
> On Mon, Aug 05, 2019 at 04:05:01PM -0400, Jeff Layton wrote:
> > Instead, borrow the scheme used by nfs.ko. Buffered writes take the
> > i_rwsem exclusively, but buffered reads and all O_DIRECT requests
> > take a shared lock, allowing them to run in parallel.
> 
> Note that you'll still need an exclusive lock to guard against cache
> invalidation for direct writes.  And instead of adding a new lock you
> might want to look at the i_rwsem based scheme in XFS (whіch also
> happens to be where O_DIRECT originally came from).

Thanks, Christoph.

That part of the patch description is unclear. I'll fix that up, but
this patch does ensure that no buffered I/O can take place while any
direct I/O is in flight. Only operations of the same "flavor" can run
in parallel. Note that we _do_ use the i_rwsem here, but there is also
an additional per-inode flag that handles the buffered read/direct I/O
exclusion.

I did take a look at the xfs_ilock* code this morning. That's quite a
bit more complex than this. It's possible that ceph doesn't serialize
mmap I/O and O_DIRECT properly. I'll have to look over xfstests and see
whether there is a good test for that as well and whether it passes.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

