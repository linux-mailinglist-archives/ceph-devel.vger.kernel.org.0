Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE0E83419
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Aug 2019 16:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733043AbfHFOjW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Aug 2019 10:39:22 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:47587 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbfHFOjW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Aug 2019 10:39:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id C98AF15F8E1;
        Tue,  6 Aug 2019 07:39:19 -0700 (PDT)
Date:   Tue, 6 Aug 2019 14:39:17 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Jeff Layton <jlayton@kernel.org>
cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, ukernel@gmail.com
Subject: Re: [PATCH] ceph: add buffered/direct exclusionary locking for reads
 and writes
In-Reply-To: <8f07d620c5147e579f1bb5e005a68b47a087cee0.camel@kernel.org>
Message-ID: <alpine.DEB.2.11.1908061431070.16820@piezo.novalocal>
References: <20190805200501.17905-1-jlayton@kernel.org>          <alpine.DEB.2.11.1908060326400.25659@piezo.novalocal>         <a0db7ebed3aef86f4e6d0cb4f47d5f3f93a9c04a.camel@kernel.org>         <alpine.DEB.2.11.1908061322300.16820@piezo.novalocal>
 <8f07d620c5147e579f1bb5e005a68b47a087cee0.camel@kernel.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddruddutddgjeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffujgfkfhgfgggtsehttdertddtredvnecuhfhrohhmpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqnecukfhppeduvdejrddtrddtrddunecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopehukhgvrhhnvghlsehgmhgrihhlrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 6 Aug 2019, Jeff Layton wrote:
> On Tue, 2019-08-06 at 13:25 +0000, Sage Weil wrote:
> > On Tue, 6 Aug 2019, Jeff Layton wrote:
> > > On Tue, 2019-08-06 at 03:27 +0000, Sage Weil wrote:
> > > > On Mon, 5 Aug 2019, Jeff Layton wrote:
> > > > > xfstest generic/451 intermittently fails. The test does O_DIRECT writes
> > > > > to a file, and then reads back the result using buffered I/O, while
> > > > > running a separate set of tasks that are also doing buffered reads.
> > > > > 
> > > > > The client will invalidate the cache prior to a direct write, but it's
> > > > > easy for one of the other readers' replies to race in and reinstantiate
> > > > > the invalidated range with stale data.
> > > > 
> > > > Maybe a silly question, but: what if the write path did the invalidation 
> > > > after the write instead of before?  Then any racing read will see the new 
> > > > data on disk.
> > > > 
> > > 
> > > I tried that originally. It reduces the race window somewhat, but it's
> > > still present since a reply to a concurrent read can get in just after
> > > the invalidation occurs. You really do have to serialize them to fix
> > > this, AFAICT.
> > 
> > I've always assumed that viewing the ordering for concurrent operations as 
> > non-deterministic is the only sane approach.  If the read initiates before 
> > the write completes you have no obligation to reflect the result of the 
> > write.
> > 
> > Is that what you're trying to do?
> > 
> 
> Not exactly.
> 
> In this testcase, we have one thread that is alternating between DIO
> writes and buffered reads. Logically, the buffered read should always
> reflect the result of the DIO write...and indeed if we run that program
> in isolation it always does, since the cache is invalidated just prior
> to the DIO write.
> 
> The issue occurs when other tasks are doing buffered reads at the same
> time. Sometimes the reply to one of those will come in after the
> invalidation but before the subsequent buffered read by the writing
> task. If that OSD read occurs before the OSD write then it'll populate

This part confuses me.  Let's say the DIO thread does 'write a', 'read 
(a)', 'write b', then 'read (b)'.  And the interfering buffered reader 
thread does a 'read (a)'.  In order for that to pollute the cache, the 
reply has to arrive *after* the 'write b' ack is received and the 
invalidation happens.  However, I don't think it's possible for a read ack 
to arrive *after* a write and not reflect that write, since the reply 
delivery from the osd to client is ordered.

Am I misunderstanding the sequence of events?

1: write a
1: get write ack, invalidate
1: read (sees a)
1: write b
2: start buffered read
1: get write ack, invalidate
2: get buffered read reply, cache 'b'
1: read (sees cached b)

If the buffered read starts earlier, then we would get the reply before 
the write ack, and the cached result would get invalidated when the direct 
write completes.

It's sometimes possible for reads that race with writes to complete 
*sooner* (i.e., return pre-write value, because they don't wait for things 
degraded objects to be repaired, which writes do wait for), but then the 
read completes first.  There is a flag you can set to force reads to be 
ordered like writes (RWORDERED), which means they will take at least as 
long as racing writes. But IIRC reads never take longer than writes.

sage


> the pagecache with stale data. The subsequent read by the writing thread
> then ends up reading that stale data out of the cache.
> 
> Doing the invalidation after the DIO write reduces this race window to
> some degree, but doesn't fully close it. You have to serialize things
> such that buffered read requests aren't dispatched until all of the DIO
> write replies have come in.
> -- 
> Jeff Layton <jlayton@kernel.org>
> 
> 
