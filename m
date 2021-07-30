Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5116D3DB95C
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Jul 2021 15:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238952AbhG3Nc6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Jul 2021 09:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238981AbhG3Nc5 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 30 Jul 2021 09:32:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B831160F94;
        Fri, 30 Jul 2021 13:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627651966;
        bh=ZpxUS4AVT9B7A+pRNCkFB1vOzuByS/dH8yO8JdtNab4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DCnJN1B80CBhnsOmQsuDxER1nK9w1LqQN0kxSqb2wTYu4y3KKNL/QRMzwUybiafuE
         bQQzAQjDTYZVmBqPPGhCy0y8J2aLh+0HMpngf7d01rTP8dvGhKy5k3Ae8nDABjQ9dc
         TsS48/XkZDFxCigvkbuHm2RAaL2MERgNz8dC5xOtSV0lVa2YVPnsuoikp8wOQ1VeXu
         s1pVzcoRj3ruQVjEep4OmdJYt0gVN30eF51+eWuTE9DiasnavRYZOE5As79cb1L5Oa
         7q7dBK0j3d2HbqbkbDfroC6vGwyP5DKUx346EvrHHG2dczJ4VuV7/g6wDLOmU2BidJ
         qAV+AYi/PdocQ==
Message-ID: <8d91e032b65b06807c2ef07fee2590e5a0adad4d.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: dump info about cap flushes when we're waiting
 too long for them
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, pdonnell@redhat.com, idryomov@gmail.com
Date:   Fri, 30 Jul 2021 09:32:44 -0400
In-Reply-To: <87zgu4m7un.fsf@suse.de>
References: <20210729180442.177399-1-jlayton@kernel.org>
         <87zgu4m7un.fsf@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-07-30 at 11:09 +0100, Luis Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
> 
> > We've had some cases of hung umounts in teuthology testing. It looks
> > like client is waiting for cap flushes to complete, but they aren't.
> > 
> > Add a field to the inode to track the highest cap flush tid seen for
> > that inode. Also, add a backpointer to the inode to the ceph_cap_flush
> > struct.
> > 
> > Change wait_caps_flush to wait 60s, and then dump info about the
> > condition of the list.
> > 
> > Also, print pr_info messages if we end up dropping a FLUSH_ACK for an
> > inode onto the floor.
> > 
> > Reported-by: Patrick Donnelly <pdonnell@redhat.com>
> > URL: https://tracker.ceph.com/issues/51279
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/caps.c       | 17 +++++++++++++++--
> >  fs/ceph/inode.c      |  1 +
> >  fs/ceph/mds_client.c | 31 +++++++++++++++++++++++++++++--
> >  fs/ceph/super.h      |  2 ++
> >  4 files changed, 47 insertions(+), 4 deletions(-)
> > 
> > v3: more debugging has shown the client waiting on FLUSH_ACK messages
> >     that seem to never have come. Add some new printks if we end up
> >     dropping a FLUSH_ACK onto the floor.
> 
> Since you're adding debug printks, would it be worth to also add one in
> mds_dispatch(), when __verify_registered_session(mdsc, s) < 0?
> 
> It's a wild guess, but the FLUSH_ACK could be dropped in that case too.
> Not that I could spot any issue there, but since this seems to be
> happening during umount...
> 
> Cheers,

Good point. I had looked at that case and had sort of dismissed it in
this situation, but you're probably right. I've added a similar pr_info
for that case and pushed it to the repo after a little testing here. I
won't bother re-posting it though since the change is trivial.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

