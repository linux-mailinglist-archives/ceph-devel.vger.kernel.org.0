Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1091CFA33
	for <lists+ceph-devel@lfdr.de>; Tue, 12 May 2020 18:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgELQLa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 12 May 2020 12:11:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:57444 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgELQLa (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 12 May 2020 12:11:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 231A5AE6F;
        Tue, 12 May 2020 16:11:31 +0000 (UTC)
Received: from localhost (webern.olymp [local])
        by webern.olymp (OpenSMTPD) with ESMTPA id 92ba15bb;
        Tue, 12 May 2020 17:11:27 +0100 (WEST)
Date:   Tue, 12 May 2020 17:11:27 +0100
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org
Subject: Re: Help understanding xfstest generic/467 failure
Message-ID: <20200512161127.GA57099@suse.com>
References: <878shx190r.fsf@suse.com>
 <ef6459452ab8156d69e2b41b35f3d388d7a3197c.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef6459452ab8156d69e2b41b35f3d388d7a3197c.camel@kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, May 12, 2020 at 11:33:13AM -0400, Jeff Layton wrote:
> On Tue, 2020-05-12 at 16:13 +0100, Luis Henriques wrote:
> > Hi Jeff,
> > 
> > I've been looking at xfstest generic/467 failure in cephfs, and I simply
> > can not decide if it's a genuine bug on ceph kernel code.  Since you've
> > recently been touching the ceph_unlink code maybe you could help me
> > understanding what's going on.
> > 
> > generic/467 runs a couple of tests using src/open_by_handle, but the one
> > failing can be summarized with the following:
> > 
> > - get a handle to /cephfs/myfile using name_to_handle_at(2)
> > - open(2) file /cephfs/myfile
> > - unlink(2) /cephfs/myfile
> > - drop caches
> > - open_by_handle_at(2) => returns -ESTALE
> > 
> > This test succeeds opening the handle with other (local) filesystems
> > (maybe I should run it with other networked filesystem such as NFS).
> > 
> > The -ESTALE is easy to trace to __fh_to_dentry, where inode->i_nlink is
> > checked against 0.  My question is: should we really be testing the
> > i_nlink here?  We dropped the name, but the file may still be there (as in
> > this case).
> > 
> > I guess I'm missing something, but hopefully you'll be able to shed some
> > light on this.  Thanks in advance for any help you may provide!
> 
> Yeah, I took a brief look at this a while back and never got back to
> looking at it again. I think cephfs's behavior is wrong here. We should
> be able to look up an open-but-unlinked file by filehandle.
> 
> That said those checks went in via commit 570df4e9c23f8, and it looks
> like it was deliberately added to __fh_to_dentry. I'm unclear as to why.

Right, I saw that commit too and that check came from the 'old' version of
ceph_lookup_inode into the 'new' version of ceph_lookup_inode and into
__fh_to_dentry.

> It may be interesting to remove the i_nlink checks and see whether it
> breaks anything?

I've done that already and a very quick test didn't show anything.  But it
may break things a very subtle ways.  I'll see if it's able to handle a
full run of xfstests.

Thanks for your hints, Jeff.  I'll see if I can progress a bit further on
this.

Cheers,
--
Luis
