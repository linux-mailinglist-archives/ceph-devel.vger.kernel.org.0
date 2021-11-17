Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2F64547CE
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Nov 2021 14:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbhKQNyE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 Nov 2021 08:54:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237937AbhKQNxw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 08:53:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0C4361261;
        Wed, 17 Nov 2021 13:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637157054;
        bh=MaNM4d8YLVdAqbTz+8Tw294oXvZ5Q7R+hnqLX8k6hXc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XOG5fi9vGqXfsT52L8oL0uOsKv9ulbj1gPayWFMCTgH9JDcdhrLaCT9564I5VF0gC
         NvoiZ5EYk8d2SLq+PTeEXQwXPT/m/SouR57LCZmHRbeTi0jVRNi4Mck/Nq/il+wIYH
         NftwqerMrEGpkELyHf1V5Rfl0w7QDBOBrK0MbouJbJloPcO7sRs06e8Rn9l77XTCXJ
         neJuFX6CS1P4CpB2G+54+SlN/abdi6NrTXZjFjOPBrvGnUEaYuM9Y+1Oae36io8P3z
         zhZeQHNpNzo3tXluQ5yTh5KevnFhcVmygMipEZ3ldQxVDj8tCp5wXV0Y+b5oOwxbMQ
         6ODDlynM+GVIw==
Message-ID: <e79540ddc102a2ef777bf38e505cf89f457b8121.camel@kernel.org>
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size
 doesn't change
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 17 Nov 2021 08:50:52 -0500
In-Reply-To: <62aadd46-5bed-3f51-40e0-04780ed7e97b@redhat.com>
References: <20211116092002.99439-1-xiubli@redhat.com>
         <d37b49e0048ba3cf6763b83c82ad2fd8f8f36663.camel@kernel.org>
         <672440f9-e812-e97f-1c85-0343d7e8359e@redhat.com>
         <e49bbb32e8c76e441c6d24f98774187c4e913a22.camel@kernel.org>
         <62aadd46-5bed-3f51-40e0-04780ed7e97b@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-11-17 at 21:40 +0800, Xiubo Li wrote:
> On 11/17/21 9:28 PM, Jeff Layton wrote:
> > On Wed, 2021-11-17 at 09:21 +0800, Xiubo Li wrote:
> > > On 11/17/21 4:06 AM, Jeff Layton wrote:
> > > > On Tue, 2021-11-16 at 17:20 +0800, xiubli@redhat.com wrote:
> [...]
> > > > > So when filling the inode it will truncate the pagecache by using
> > > > > truncate_sizeA again, which makes no sense and will trim the inocent
> > > > > pages.
> > > > > 
> > > > Is there a reproducer for this? It would be nice to put something in
> > > > xfstests for it if so.
> > > In xfstests' generic/075 has already testing this, but i didn't see any
> > > issue it reproduce.
> > > 
> > > I just found this strange logs when it's doing
> > > something like:
> > > 
> > > truncateA 0x10000 --> 0x2000
> > > 
> > > truncateB 0x2000   --> 0x8000
> > > 
> > > truncateC 0x8000   --> 0x6000
> > > 
> > > For the truncateC, the log says:
> > > 
> > > ceph:  truncate_size 0x2000 -> 0x6000
> > > 
> > > 
> > > The problem is that the truncateB will also do the vmtruncate by using
> > > the 0x2000 instead, the vmtruncate will not flush the dirty pages to the
> > > OSD and will just discard them from the pagecaches. Then we may lost
> > > some new updated data in case there has any write before the truncateB
> > > in range [0x2000, 0x8000).
> > > 
> > > 
> > Is that reproducible without the fscrypt size handling changes? I
> > haven't seen generic/075 fail on stock kernels.
> 
> Yeah, there is no error about this, since there has no any write between 
> truncateA and truncateB, if there has I am afraid the test will fail in 
> theory.
> 
> 

Interesting. It might be worth trying to craft a test that does that and
see if you can get it to fail on stock kernels. I'd feel better about
this if we had a reliable test for it.

> > If this is a generic bug, then we should go ahead and fix it in
> > mainline. If it's a problem only with fscrypt enabled, then let's plan
> > to roll this patch into those changes.
> > 
> I think it makes sense always to check the truncate_seq and 
> truncate_size here in kclient, or at least should we warn it in case the 
> MDS will do this again in future ?
> 
> The truncate_seq and truncate_size should always be changed at the same 
> time.
> 
> Make sense ?
> 
> 

I think so. I'll plan to do some testing with this today and will plan
to pull it into the testing branch. It would be nice to have a reliable
test for this issue though, so we can ensure it doesn't regress later.

> 
> > > 
> > > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > > ---
> > > > >    fs/ceph/inode.c | 5 +++--
> > > > >    1 file changed, 3 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > > > index 1b4ce453d397..b4f784684e64 100644
> > > > > --- a/fs/ceph/inode.c
> > > > > +++ b/fs/ceph/inode.c
> > > > > @@ -738,10 +738,11 @@ int ceph_fill_file_size(struct inode *inode, int issued,
> > > > >    			 * don't hold those caps, then we need to check whether
> > > > >    			 * the file is either opened or mmaped
> > > > >    			 */
> > > > > -			if ((issued & (CEPH_CAP_FILE_CACHE|
> > > > > +			if (ci->i_truncate_size != truncate_size &&
> > > > > +			    ((issued & (CEPH_CAP_FILE_CACHE|
> > > > >    				       CEPH_CAP_FILE_BUFFER)) ||
> > > > >    			    mapping_mapped(inode->i_mapping) ||
> > > > > -			    __ceph_is_file_opened(ci)) {
> > > > > +			    __ceph_is_file_opened(ci))) {
> > > > >    				ci->i_truncate_pending++;
> > > > >    				queue_trunc = 1;
> > > > >    			}
> 

-- 
Jeff Layton <jlayton@kernel.org>
