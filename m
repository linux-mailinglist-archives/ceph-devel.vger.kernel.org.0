Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 333FA83513
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Aug 2019 17:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732735AbfHFPVZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Aug 2019 11:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfHFPVZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 11:21:25 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E063320717;
        Tue,  6 Aug 2019 15:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565104884;
        bh=obSfjZlspHkV57zakoXFh4geCByxjiPINqMbEoc7jYI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JaQkachx3miIVuZneHxPK4/w/WFWx3CTOItPZHi2o182S7kzcb4iiKEwPhXlPQC7a
         B9H9kpsAPZWtsyP6Gr9myi+SaqBDyF+F14Z42beKvD+GpnnZGxjbUMZHoLNHB5kpC/
         zLONuX6TlGglmdYPoGrgTW2161auPqr9VZJzJNvI=
Message-ID: <412a75a35a19d60fbbbc3dcfb2aff169847a354f.camel@kernel.org>
Subject: Re: [PATCH] ceph: add buffered/direct exclusionary locking for
 reads and writes
From:   Jeff Layton <jlayton@kernel.org>
To:     Sage Weil <sage@newdream.net>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, ukernel@gmail.com
Date:   Tue, 06 Aug 2019 11:21:22 -0400
In-Reply-To: <alpine.DEB.2.11.1908061431070.16820@piezo.novalocal>
References: <20190805200501.17905-1-jlayton@kernel.org>
                  <alpine.DEB.2.11.1908060326400.25659@piezo.novalocal>
                 <a0db7ebed3aef86f4e6d0cb4f47d5f3f93a9c04a.camel@kernel.org>
                 <alpine.DEB.2.11.1908061322300.16820@piezo.novalocal>
         <8f07d620c5147e579f1bb5e005a68b47a087cee0.camel@kernel.org>
         <alpine.DEB.2.11.1908061431070.16820@piezo.novalocal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-08-06 at 14:39 +0000, Sage Weil wrote:
> On Tue, 6 Aug 2019, Jeff Layton wrote:
> > On Tue, 2019-08-06 at 13:25 +0000, Sage Weil wrote:
> > > On Tue, 6 Aug 2019, Jeff Layton wrote:
> > > > On Tue, 2019-08-06 at 03:27 +0000, Sage Weil wrote:
> > > > > On Mon, 5 Aug 2019, Jeff Layton wrote:
> > > > > > xfstest generic/451 intermittently fails. The test does O_DIRECT writes
> > > > > > to a file, and then reads back the result using buffered I/O, while
> > > > > > running a separate set of tasks that are also doing buffered reads.
> > > > > > 
> > > > > > The client will invalidate the cache prior to a direct write, but it's
> > > > > > easy for one of the other readers' replies to race in and reinstantiate
> > > > > > the invalidated range with stale data.
> > > > > 
> > > > > Maybe a silly question, but: what if the write path did the invalidation 
> > > > > after the write instead of before?  Then any racing read will see the new 
> > > > > data on disk.
> > > > > 
> > > > 
> > > > I tried that originally. It reduces the race window somewhat, but it's
> > > > still present since a reply to a concurrent read can get in just after
> > > > the invalidation occurs. You really do have to serialize them to fix
> > > > this, AFAICT.
> > > 
> > > I've always assumed that viewing the ordering for concurrent operations as 
> > > non-deterministic is the only sane approach.  If the read initiates before 
> > > the write completes you have no obligation to reflect the result of the 
> > > write.
> > > 
> > > Is that what you're trying to do?
> > > 
> > 
> > Not exactly.
> > 
> > In this testcase, we have one thread that is alternating between DIO
> > writes and buffered reads. Logically, the buffered read should always
> > reflect the result of the DIO write...and indeed if we run that program
> > in isolation it always does, since the cache is invalidated just prior
> > to the DIO write.
> > 
> > The issue occurs when other tasks are doing buffered reads at the same
> > time. Sometimes the reply to one of those will come in after the
> > invalidation but before the subsequent buffered read by the writing
> > task. If that OSD read occurs before the OSD write then it'll populate
> 
> This part confuses me.  Let's say the DIO thread does 'write a', 'read 
> (a)', 'write b', then 'read (b)'.  And the interfering buffered reader 
> thread does a 'read (a)'.  In order for that to pollute the cache, the 
> reply has to arrive *after* the 'write b' ack is received and the 
> invalidation happens.  However, I don't think it's possible for a read ack 
> to arrive *after* a write and not reflect that write, since the reply 
> delivery from the osd to client is ordered.
> 
> Am I misunderstanding the sequence of events?
> 
> 1: write a
> 1: get write ack, invalidate
> 1: read (sees a)
> 1: write b
> 2: start buffered read
> 1: get write ack, invalidate
> 2: get buffered read reply, cache 'b'
> 1: read (sees cached b)
>
> If the buffered read starts earlier, then we would get the reply before 
> the write ack, and the cached result would get invalidated when the direct 
> write completes.
> 

The problem here though (IIUC) is that we don't have a strict guarantee
on the ordering of the reply processing, in particular between buffered
and direct I/O. We issue requests to libceph's OSD infrastructure, but
the readpages machinery is mostly done in the context of the task that
initiated it.

When we get the reply from the OSD, the pagevec is populated and then
the initiating task is awoken, but nothing ensures that the initiating
tasks doing the postprocessing end up serialized in the "correct" order.

IOW, even though the read reply came in before the write reply, the
writing task ended up getting scheduled first when they were both
awoken.

> It's sometimes possible for reads that race with writes to complete 
> *sooner* (i.e., return pre-write value, because they don't wait for things 
> degraded objects to be repaired, which writes do wait for), but then the 
> read completes first.  There is a flag you can set to force reads to be 
> ordered like writes (RWORDERED), which means they will take at least as 
> long as racing writes. But IIRC reads never take longer than writes.
> 
>
> > the pagecache with stale data. The subsequent read by the writing thread
> > then ends up reading that stale data out of the cache.
> > 
> > Doing the invalidation after the DIO write reduces this race window to
> > some degree, but doesn't fully close it. You have to serialize things
> > such that buffered read requests aren't dispatched until all of the DIO
> > write replies have come in.
> > -- 
> > Jeff Layton <jlayton@kernel.org>
> > 
> > 

-- 
Jeff Layton <jlayton@kernel.org>

