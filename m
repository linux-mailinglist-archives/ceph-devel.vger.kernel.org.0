Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E5C83301
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Aug 2019 15:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbfHFNm1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Aug 2019 09:42:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfHFNm1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 09:42:27 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0914B208C3;
        Tue,  6 Aug 2019 13:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565098946;
        bh=Wzj4qxvd05PG7YhooVdzgoa5Dheg3uT/gLOLMgz78OY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pRS7O3HomNlMKhmv66fV5i3sJ41n44Loq0g+4XluBfMF0yVITxXWxOZVZ9iT0QyPe
         vXOgnRfCAyYW85rd2yJJrQrqnwxwRfCa63PqoG4XAKD84j0aS6PQWQyFWze+oROgsl
         bJ4z7u+M581Ced4aqaPRZHZmqRPjpycDhoF9hotk=
Message-ID: <8f07d620c5147e579f1bb5e005a68b47a087cee0.camel@kernel.org>
Subject: Re: [PATCH] ceph: add buffered/direct exclusionary locking for
 reads and writes
From:   Jeff Layton <jlayton@kernel.org>
To:     Sage Weil <sage@newdream.net>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, ukernel@gmail.com
Date:   Tue, 06 Aug 2019 09:42:24 -0400
In-Reply-To: <alpine.DEB.2.11.1908061322300.16820@piezo.novalocal>
References: <20190805200501.17905-1-jlayton@kernel.org>
          <alpine.DEB.2.11.1908060326400.25659@piezo.novalocal>
         <a0db7ebed3aef86f4e6d0cb4f47d5f3f93a9c04a.camel@kernel.org>
         <alpine.DEB.2.11.1908061322300.16820@piezo.novalocal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-08-06 at 13:25 +0000, Sage Weil wrote:
> On Tue, 6 Aug 2019, Jeff Layton wrote:
> > On Tue, 2019-08-06 at 03:27 +0000, Sage Weil wrote:
> > > On Mon, 5 Aug 2019, Jeff Layton wrote:
> > > > xfstest generic/451 intermittently fails. The test does O_DIRECT writes
> > > > to a file, and then reads back the result using buffered I/O, while
> > > > running a separate set of tasks that are also doing buffered reads.
> > > > 
> > > > The client will invalidate the cache prior to a direct write, but it's
> > > > easy for one of the other readers' replies to race in and reinstantiate
> > > > the invalidated range with stale data.
> > > 
> > > Maybe a silly question, but: what if the write path did the invalidation 
> > > after the write instead of before?  Then any racing read will see the new 
> > > data on disk.
> > > 
> > 
> > I tried that originally. It reduces the race window somewhat, but it's
> > still present since a reply to a concurrent read can get in just after
> > the invalidation occurs. You really do have to serialize them to fix
> > this, AFAICT.
> 
> I've always assumed that viewing the ordering for concurrent operations as 
> non-deterministic is the only sane approach.  If the read initiates before 
> the write completes you have no obligation to reflect the result of the 
> write.
> 
> Is that what you're trying to do?
> 

Not exactly.

In this testcase, we have one thread that is alternating between DIO
writes and buffered reads. Logically, the buffered read should always
reflect the result of the DIO write...and indeed if we run that program
in isolation it always does, since the cache is invalidated just prior
to the DIO write.

The issue occurs when other tasks are doing buffered reads at the same
time. Sometimes the reply to one of those will come in after the
invalidation but before the subsequent buffered read by the writing
task. If that OSD read occurs before the OSD write then it'll populate
the pagecache with stale data. The subsequent read by the writing thread
then ends up reading that stale data out of the cache.

Doing the invalidation after the DIO write reduces this race window to
some degree, but doesn't fully close it. You have to serialize things
such that buffered read requests aren't dispatched until all of the DIO
write replies have come in.
-- 
Jeff Layton <jlayton@kernel.org>

