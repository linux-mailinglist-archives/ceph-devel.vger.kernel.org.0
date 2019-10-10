Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2C9D2908
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Oct 2019 14:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732999AbfJJMKp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Oct 2019 08:10:45 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:38924 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728030AbfJJMKp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Oct 2019 08:10:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id BE08315F888;
        Thu, 10 Oct 2019 05:10:43 -0700 (PDT)
Date:   Thu, 10 Oct 2019 12:10:41 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Xuehan Xu <xxhdx1985126@gmail.com>
cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Subject: Re: Why BlueRocksDirectory::Fsync only sync metadata?
In-Reply-To: <CAJACTufO-wgKCmJtKs2N8fWwZaRjK7D3EvWMnxe0fgk+7_J-kA@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1910101207120.14245@piezo.novalocal>
References: <CAJACTufSmSphvg4-RDR65KOSWzZsL=3b8mn_yRxSE-YtvDhMAg@mail.gmail.com> <alpine.DEB.2.11.1909291528200.5147@piezo.novalocal> <CAJACTuf+_VC=zJxbNP5Au3VUTqSu=jPffRgOjPyQvaoXStLmFg@mail.gmail.com>
 <CAJACTufO-wgKCmJtKs2N8fWwZaRjK7D3EvWMnxe0fgk+7_J-kA@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrieefgdehudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffujgfkfhgfgggtsehttdertddtredvnecuhfhrohhmpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqnecukfhppeduvdejrddtrddtrddunecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopeguvghvsegtvghphhdrihhonecuvehluhhsthgvrhfuihiivgeptd
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 10 Oct 2019, Xuehan Xu wrote:
> > > My recollection is that rocksdb is always flushing, correct.  There are
> > > conveniently only a handful of writers in rocksdb, the main ones being log
> > > files and sst files.
> > >
> > > We could probably put an assertion in fsync() so ensure that the
> > > FileWriter buffer is empty and flushed...?
> >
> > Thanks for your reply, sage:-) I will do that:-)
> >
> > By the way, I've got another question here:
> >        It seems that BlueStore tries to provide some kind of atomic
> > I/O mechanism in which data and metadata are either both modified or
> > both untouched. To accomplish this, for modifications whose size is
> > larger than prefer_defer_size, BlueStore will allocate new space for
> > the modifications and release the old storage space. I think, in the
> > long run, a initially contiguous stored file in bluestore could become
> > scattered if there have been many random modifications to that file.
> > Actually, this is what we are experiencing in our test clusters. The
> > consequence is that after some period of random modification, the
> > sequential read performance of that file is significantly degraded.
> > Should we make this atomic I/O mechanism optional? It seems that most
> > hard disk only make sure that a sector is never half-modified, for
> > which, I think, the deferred I/O is enough. Am I right? Thanks:-)
> 
> I mean, in the scenario of RBD, since most real hard disk only
> guarantee that a sector is never half-modified, only providing atomic
> I/O guarantee for modifications whose are less than or equal to that
> of a disk sector, which is guaranteed by deferred io, should be
> enough. So, maybe, this atomic I/O guarantee for large size
> modifications should be made configurable.

The OSD needs to record both the data update *and* the metadata associated 
with it (pg log entry) atomically, so atomic sector updates aren't 
sufficient.

You might try looking at the bluestore_prefer_deferred_size, which will 
make writes take the deferred IO path.  This gets increasingly inefficient 
the larger the value is, though!

If we really find that fragmentation is a problem over the long term, we 
should make the deep scrub process rewrite the data it has read if/when it 
is too fragmented.

sage
