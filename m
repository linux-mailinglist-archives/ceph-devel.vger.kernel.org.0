Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C791D948C
	for <lists+ceph-devel@lfdr.de>; Tue, 19 May 2020 12:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgESKnN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 May 2020 06:43:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgESKnN (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 19 May 2020 06:43:13 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D16F20674;
        Tue, 19 May 2020 10:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589884992;
        bh=L/14AxOpD03Run3O+IBY+gN9A7FJED5ePKYXqAc56ws=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=yu54AhMcabq+AvDj6KUaIZzm3VsU3sxprdYjdyBn4/dTgi6hv+V+fb5zg98nfd0c7
         S4KRXKLI2BF7HS9+UnY87jbiO+9sb5WkqjNckH6HhvEHhOsL4iBfllNifxeTl4GyFq
         m9nsqEJDYV8sFa4C82IJh/xWQU8YATQrG1pz8cqM=
Message-ID: <cc459ce1b7314919eaa506a82b9c28df6f41a169.camel@kernel.org>
Subject: Re: [PATCH] ceph: don't return -ESTALE if there's still an open file
From:   Jeff Layton <jlayton@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>
Cc:     Luis Henriques <lhenriques@suse.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 19 May 2020 06:43:10 -0400
In-Reply-To: <CAOQ4uxjdu7=wXNBHZBQmtNexcG3qfu=XQov9HsRNi=os+QHAUg@mail.gmail.com>
References: <20200514111453.GA99187@suse.com>
         <8497fe9a11ac1837813ee5f14b6ebae8fa6bf707.camel@kernel.org>
         <20200514124845.GA12559@suse.com>
         <4e5bf0e3bf055e53a342b19d168f6cf441781973.camel@kernel.org>
         <CAOQ4uxhireZBRvcPQzTS8yOoO4gQt78M0ktZo-9yQ-zcaLZbow@mail.gmail.com>
         <20200515111548.GA54598@suse.com>
         <61b1f19edcc349641b5383c2ac70cbf9a15ba4bd.camel@kernel.org>
         <CAOQ4uxiWZoSj3Pjwskd_hu-ErV9096hLt13CDcW6nEEvcwDNVA@mail.gmail.com>
         <e227d42fdc91587e34bc64ac252970d39d9b4eee.camel@kernel.org>
         <CAJ4mKGbahd8CbkEauBHBX6o93jipkCVoYe9O-1rAJQJFZkqDsQ@mail.gmail.com>
         <CAOQ4uxjdu7=wXNBHZBQmtNexcG3qfu=XQov9HsRNi=os+QHAUg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-05-19 at 07:00 +0300, Amir Goldstein wrote:
> On Tue, May 19, 2020 at 1:30 AM Gregory Farnum <gfarnum@redhat.com> wrote:
> > Maybe we resolved this conversation; I can't quite tell...
> 
> I think v2 patch wraps it up...
> 
> [...]
> 

Agreed.

> > > > Questions:
> > > > 1. Does sync() result in fully purging inodes on MDS?
> > > 
> > > I don't think so, but again, that code is not trivial to follow. I do
> > > know that the MDS keeps around a "strays directory" which contains
> > > unlinked inodes that are lazily cleaned up. My suspicion is that it's
> > > satisfying lookups out of this cache as well.
> > > 
> > > Which may be fine...the MDS is not required to be POSIX compliant after
> > > all. Only the fs drivers are.
> > 
> > I don't think this is quite that simple. Yes, the MDS is certainly
> > giving back stray inodes in response to a lookup-by-ino request. But
> > that's for a specific purpose: we need to be able to give back caps on
> > unlinked-but-open files. For NFS specifically, I don't know what the
> > rules are on NFS file handles and unlinked files, but the Ceph MDS
> > won't know when files are closed everywhere, and it translates from
> > NFS fh to Ceph inode using that lookup-by-ino functionality.
> > 
> 
> There is no protocol rule that NFS server MUST return ESTALE
> for file handle of a deleted file, but there is a rule that it MAY return
> ESTALE for deleted file. For example, on server restart and traditional
> block filesystem, there is not much choice.
> 
> So returning ESTALE when file is deleted but opened on another ceph
> client is definitely allowed by the protocol standard, the question is
> whether changing the behavior will break any existing workloads...
> 

Right -- that was sort of the point of my original question about the
xfstest. The fact that ceph wasn't returning ESTALE in this situation
didn't seem to be technically _wrong_ to me, but the xfstest treated
that as a failure. It's probably best to return ESTALE since that's the
conventional behavior, but I don't think it's necessarily required for
correct operation in general.

FWIW, if we ever implement O_TMPFILE in ceph, then we may need to
revisit this code. With that, you can do a 0->1 transition on i_nlink,
which blows some of the assumptions we're making here out of the water.

> > > > 2. Is i_nlink synchronized among nodes on deferred delete?
> > > > IWO, can inode come back from the dead on client if another node
> > > > has linked it before i_nlink 0 was observed?
> > > 
> > > No, that shouldn't happen. The caps mechanism should ensure that it
> > > can't be observed by other clients until after the change.
> > > 
> > > That said, Luis' current patch doesn't ensure we have the correct caps
> > > to check the i_nlink. We may need to add that in before we can roll with
> > > this.
> > > 
> > > > 3. Can an NFS client be "migrated" from one ceph node to another
> > > > with an open but unlinked file?
> > > > 
> > > 
> > > No. Open files in ceph are generally per-client. You can't pass around a
> > > fd (or equivalent).
> > 
> > But the NFS file handles I think do work across clients, right?
> > 
> 
> Maybe they can, but that would be like NFS server restart, so
> all bets are off w.r.t open but deleted files.
> 

They do work across clients, but a file handle is just an identifier for
an inode. That's completely orthogonal to whether the file is open.

-- 
Jeff Layton <jlayton@kernel.org>

