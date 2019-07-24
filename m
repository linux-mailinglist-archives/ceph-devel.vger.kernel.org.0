Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AFD732C7
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2019 17:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfGXPb0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jul 2019 11:31:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:55430 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727491AbfGXPb0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 11:31:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A3CAAB0E2;
        Wed, 24 Jul 2019 15:31:25 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     "Jeff Layton" <jlayton@kernel.org>
Cc:     <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH] ceph: have copy op fall back when src_inode == dst_inode
References: <20190724120542.26391-1-jlayton@kernel.org>
        <87tvbb4lke.fsf@suse.com>
Date:   Wed, 24 Jul 2019 16:31:24 +0100
In-Reply-To: <87tvbb4lke.fsf@suse.com> (Luis Henriques's message of "Wed, 24
        Jul 2019 14:19:13 +0100")
Message-ID: <87pnlz4fg3.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Luis Henriques <lhenriques@suse.com> writes:

> "Jeff Layton" <jlayton@kernel.org> writes:
>
>> Currently this just fails, but the fallback implementation can handle
>> this case. Change it to return -EOPNOTSUPP instead of -EINVAL when
>> copying data to a different spot in the same inode.
>
> Thanks, Jeff!
>
> So, just FTR (we had a quick chat on IRC already): I have a slightly
> different patch sitting on my tree for a while.  The difference is that
> my patch still allows to use the 'copy-from' operation in some cases,
> even when src == dst.
>
> I'll run a few more tests on it and send it out soon.

So, after looking at my local patch I realised it was a bit outdated.
After commit 96e6e8f4a68d ("vfs: add missing checks to copy_file_range")
we only need to remove the 'if' statement -- the only other thing I had
locally was to return -EOPNOTSUPP if there were overlaps, which is now
handled in the VFS generic code.

I've tested this (i.e. dropping the 2nd hunk in your patch), and it
seems to be working fine.  Feel free to add my Acked-by to this
(modified) patch.

My next move was going to allow cross-filesystem copies, but I won't be
looking into that while https://github.com/ceph/ceph/pull/25374 isn't
merged (my initial pull-request is from December 2018!!!).

Cheers,
-- 
Luis
